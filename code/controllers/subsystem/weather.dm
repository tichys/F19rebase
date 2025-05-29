#define STARTUP_STAGE 1
#define MAIN_STAGE 2
#define WIND_DOWN_STAGE 3
#define END_STAGE 4

SUBSYSTEM_DEF(weather)
	name = "Weather"
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/list/processing = list()
	var/list/eligible_zlevels = list()
	var/list/next_hit_by_zlevel = list() //Used by barometers to know when the next storm is coming

	///Referencing the current weather profile the profile system has suggested.
	var/datum/weather/profile/current_profile

	//Referencing the weather chunking system
	var/datum/weather/chunking/weather_chunking = new
	var/next_flavor_smell_time = 0
	var/flavor_smell_interval_min = 6000 // 10 minutes in deciseconds
	var/flavor_smell_interval_max = 18000 // 30 minutes in deciseconds

/datum/controller/subsystem/weather/fire()

	//Simulated threading setup for batch processing.
	var/static/mob_batch_index = 1
	var/static/obj_batch_index = 1
	var/batch_size = 10

	// Play flavor smells occasionally
	if(world.time >= next_flavor_smell_time && current_profile)
		var/list/all_smells = list()
		if(current_profile.flavor_smells_long && current_profile.flavor_smells_long.len)
			all_smells += current_profile.flavor_smells_long
		if(current_profile.flavor_smells_short && current_profile.flavor_smells_short.len)
			all_smells += current_profile.flavor_smells_short

		if(all_smells.len)
			// Set the next time for a smell opportunity
			next_flavor_smell_time = world.time + rand(flavor_smell_interval_min, flavor_smell_interval_max)
			message_admins(span_adminnotice("Weather Subsystem: Next flavor smell scheduled for [next_flavor_smell_time] (in [round((next_flavor_smell_time - world.time)/10)] seconds). Picked smell: [smell_message_raw]"))

			// Get all outdoor mobs using weather_chunking
			var/list/outdoor_mobs = list()
			for(var/key in weather_chunking.chunks)
				for(var/atom/movable/A in weather_chunking.chunks[key])
					if(ismob(A))
						outdoor_mobs += A

			// Broadcast to outdoor players with a per-player chance
			for(var/mob/player as anything in outdoor_mobs)
				// 20% chance for a player to receive a smell message
				if(prob(20)) // TD: Make this probability configurable in weather_profiles or SSweather vars.
					var/smell_message_raw = pick(all_smells)
					var/smell_message_formatted = ""

					if(smell_message_raw in current_profile.flavor_smells_long)
						smell_message_formatted = smell_message_raw // Long message is used directly
					else
						smell_message_formatted = "You catch the scent of [smell_message_raw] in the air." // Short message is formatted

					to_chat(player, span_notice(smell_message_formatted))


	// process active weather
	for(var/datum/weather/current_storm in processing)
		if(current_storm.aesthetic || current_storm.stage != MAIN_STAGE)
			continue

		// Get Candidate Lists for the current storm
		var/list/mob_canidates = weather_chunking.get_mobs_in_chunks_around_storm(current_storm)
		var/list/object_canidates = weather_chunking.get_objects_in_chunks_around_storm(current_storm)

		// Get actual lists for storage (Mobs, Obj) for the current storm
		var/list/mobs_to_affect = list()
		var/list/objects_to_affect = list()

		// Determining the mobs/objs lists here and flagging them appropriately.
		for(var/mob/living/M in mob_canidates)
			if(!M.needs_weather_update)
				continue
			mobs_to_affect += M
			M.needs_weather_update = FALSE

		for(var/obj/O in object_canidates)
			if(!O.needs_weather_update)
				continue
			objects_to_affect += O
			O.needs_weather_update = FALSE

		// We've populated our mobs and objects filtered lists, lets slice them now into batches.
		var/list/mob_slice = mobs_to_affect.Copy(mob_batch_index, mob_batch_index + batch_size)
		var/list/obj_slice = objects_to_affect.Copy(obj_batch_index, obj_batch_index + batch_size)

		//Ticking weather effects to reduce cooldown.
		//We handle evaluating if weather can act later so the subsystem is cleaner.
		for(var/datum/weather/effect/E in current_storm.weather_effects)
			if(world.time % E.tick_interval == 0)
				E.tick()

			//Global effects, once per weather effect.
			if(E.type in E.global_effect_types)
				E.apply_global_effect()

			//Applying to Mobs
			if(E.affects_mobs)
				E.apply_to_mobs(mob_slice)

			//Applying to Objects
			if(E.affects_objects)
				E.apply_to_objects(obj_slice)

	// start random weather on relevant levels
	for(var/z in eligible_zlevels)
		var/possible_weather = eligible_zlevels[z]
		var/datum/weather/our_event = pick_weight(possible_weather)
		message_admins(span_adminnotice("Weather Subsystem: Picked storm: [initial(our_event.name)] for z-level [z]"))
		run_weather(our_event, list(text2num(z)))
		eligible_zlevels -= z
		var/randTime = rand(3000, 6000)
		next_hit_by_zlevel["[z]"] = addtimer(CALLBACK(src, PROC_REF(make_eligible), z, possible_weather), randTime + initial(our_event.weather_duration_upper), TIMER_UNIQUE|TIMER_STOPPABLE) //Around 5-10 minutes between weathers

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	// Select a random weather profile for the round
	var/list/all_profiles = list()
	for(var/V in subtypesof(/datum/weather/profile))
		all_profiles += V
	message_admins(span_adminnotice("Weather Subsystem: Found [all_profiles.len] weather profiles."))
	if(all_profiles.len)
		current_profile = pick(all_profiles)
		current_profile.apply_environment_settings() // Apply environment settings from the selected profile
		message_admins("Weather Subsystem: About to log picked profile details.") //Temp for debug
		message_admins(span_adminnotice("Weather Subsystem: Picked weather profile: [current_profile.name] (Temp: [current_profile.base_temperature_type] -> [num2text(current_profile.base_temperature)]K, Pressure: [current_profile.pressure_type] -> [num2text(current_profile.current_pressure)]kPa)"))

	for(var/V in subtypesof(/datum/weather))
		var/datum/weather/W = V
		var/probability = initial(W.probability)

		// Applying map-specific probability overrides first
		var/datum/map_config/current_map_config = SSmapping.config
		var/overrides = current_map_config.weather_overrides[V]
		if((overrides && "probability") in overrides) //Do probability overrides specifically exist?
			probability = overrides["probability"]

		var/target_trait = initial(W.target_trait)

		// Filter by allowed_storms in the current profile
		if(current_profile && current_profile.allowed_storms && current_profile.allowed_storms.len)
			if(!(W.type in current_profile.allowed_storms))
				continue // Skip if this weather type is not allowed by the profile

		// any weather with a probability set may occur at random
		if (probability)
			for(var/z in SSmapping.levels_by_trait(target_trait))
				LAZYINITLIST(eligible_zlevels["[z]"])
				eligible_zlevels["[z]"][W] = probability
	return ..()

/datum/controller/subsystem/weather/proc/update_z_level(datum/space_level/level)
	var/z = level.z_value
	for(var/datum/weather/weather as anything in subtypesof(/datum/weather))
		var/probability = initial(weather.probability)
		var/target_trait = initial(weather.target_trait)
		if(probability && level.traits[target_trait])
			LAZYINITLIST(eligible_zlevels["[z]"])
			eligible_zlevels["[z]"][weather] = probability

/datum/controller/subsystem/weather/proc/run_weather(datum/weather/weather_datum_type, z_levels_param, skip_telegraph)
	var/list/actual_z_levels = z_levels_param // Declare a typed local variable to ensure correct type inference

	if (istext(weather_datum_type))
		for (var/V in subtypesof(/datum/weather))
			var/datum/weather/W = V
			if (initial(W.name) == weather_datum_type)
				weather_datum_type = V
				break
	if (!ispath(weather_datum_type, /datum/weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")

	if (isnull(actual_z_levels))
		actual_z_levels = SSmapping.levels_by_trait(initial(weather_datum_type.target_trait))
		if (isnull(actual_z_levels))
			actual_z_levels = list()
	else if (isnum(actual_z_levels))
		actual_z_levels = list(actual_z_levels)
	else if (!islist(actual_z_levels))
		CRASH("run_weather called with invalid z_levels: [actual_z_levels || "null"]")

	var/turf/storm_center_turf
	if(actual_z_levels.len)
		// Sort actual_z_levels in descending order to prioritize higher Z-levels
		var/list/sorted_z_levels = list()
		for(var/z_level in actual_z_levels)
			var/inserted = FALSE
			for(var/i = 1, i <= sorted_z_levels.len, i++)
				if(z_level > sorted_z_levels[i])
					sorted_z_levels.Insert(i, z_level)
					inserted = TRUE
					break
			if(!inserted)
				sorted_z_levels += z_level

		// Find a suitable center turf on the highest impacted z-level first.
		for(var/z_level in sorted_z_levels)
			var/list/candidate_turfs = list()
			// Iterate all turfs to find suitable ones on the current z_level
			for(var/turf/T in world.contents)
				if(T.z == z_level)
					var/area/A = get_area(T)
					// Only check if it's outdoors
					if(A.outdoors)
						candidate_turfs += T
			if(candidate_turfs.len)
				storm_center_turf = pick(candidate_turfs) // Pick a random suitable turf from the highest Z-level
				break // Found a center, no need to check lower z-levels

	//A storm is Born!
	var/datum/weather/W = new weather_datum_type(actual_z_levels, storm_center_turf)

	W.telegraph(skip_telegraph)

/datum/controller/subsystem/weather/proc/make_eligible(z, possible_weather)
	eligible_zlevels[z] = possible_weather
	next_hit_by_zlevel["[z]"] = null

/datum/controller/subsystem/weather/proc/get_weather(z, area/active_area)
	var/datum/weather/A
	for(var/V in processing)
		var/datum/weather/W = V
		if((z in W.impacted_z_levels) && W.area_type == active_area.type)
			A = W
			break
	return A
