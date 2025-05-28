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

/datum/controller/subsystem/weather/fire()

	//Get Candidate Lists (From weather chunking system) to filter through.
	//Chunking does the heavy lifting, we just clean up whatever it gives us.
	var/list/mob_canidates = list()
	var/list/object_canidates = list()
	var/datum/weather/our_event

	if(processing.len) // Check if there's at least one active storm
		our_event = processing[1] // Use the first active storm as the "single current active storm"
		mob_canidates += weather_chunking.get_mobs_in_chunks_around_storm(our_event) //TD: Impacted chunks takes from weather coverage subsystem otherwise what was this all for???
		object_canidates += weather_chunking.get_objects_in_chunks_around_storm(our_event)

	//Simulated threading setup for batch processing.
	var/static/mob_batch_index = 1
	var/static/obj_batch_index = 1
	var/batch_size = 10

	//Get actual lists for storage (Mobs, Obj, Area)
	var/list/mobs_to_affect = list()
	var/list/objects_to_affect = list()

	//Determining the mobs/objs lists here and flagging them appropriately.
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


	//We've populated our mobs and objects filtered lists, lets slice them now into batches.
	var/list/mob_slice = mobs_to_affect.Copy(mob_batch_index, mob_batch_index + batch_size)
	var/list/obj_slice = objects_to_affect.Copy(obj_batch_index, obj_batch_index + batch_size)

	// process active weather
	for(var/datum/weather/current_storm in processing)
		if(current_storm.aesthetic || current_storm.stage != MAIN_STAGE)
			continue

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
		our_event = pick_weight(possible_weather)
		run_weather(our_event, list(text2num(z)))
		eligible_zlevels -= z
		var/randTime = rand(3000, 6000)
		next_hit_by_zlevel["[z]"] = addtimer(CALLBACK(src, PROC_REF(make_eligible), z, possible_weather), randTime + initial(our_event.weather_duration_upper), TIMER_UNIQUE|TIMER_STOPPABLE) //Around 5-10 minutes between weathers

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	for(var/V in subtypesof(/datum/weather))
		var/datum/weather/W = V
		var/probability = initial(W.probability)

		// Applying map-specific probability overrides first
		var/datum/map_config/current_map_config = SSmapping.config
		var/overrides = current_map_config.weather_overrides[V]
		if((overrides && "probability") in overrides) //Do probability overrides specifically exist?
			probability = overrides["probability"]

		var/target_trait = initial(W.target_trait)

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
