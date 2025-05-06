/**
 * Causes weather to occur on a z level in certain area types
 *
 * The effects of weather occur across an entire z-level.
 * Weather always occurs on different z levels at different times, regardless of weather type.
 * Can have custom durations, targets, and can automatically protect indoor areas.
 *
 */

/**
* When adding new weather, consider the following:
* - code\__DEFINES\maps.dm needs to be updated with a ZTRAIT_WEATHERNAME define, so the weather occurs on that Z.
* - code\__DEFINES\traits.dm needs to be updated with a TRAIT_WEATHERNAME_IMMUNE define, so mobs can be immune to it.
*
*/

/datum/weather
	/// name of weather
	var/name = "space wind"
	/// description of weather
	var/desc = "Heavy gusts of wind blanket the area, periodically knocking down anyone caught in the open."
	/// The message displayed in chat to foreshadow the weather's beginning
	var/telegraph_message = "<span class='warning'>The wind begins to pick up.</span>"
	/// In deciseconds, how long from the beginning of the telegraph until the weather begins
	var/telegraph_duration = 300
	/// The sound file played to everyone on an affected z-level
	var/telegraph_sound
	/// The overlay applied to all tiles on the z-level
	var/telegraph_overlay

	/// Displayed in chat once the weather begins in earnest
	var/weather_message = "<span class='userdanger'>The wind begins to blow ferociously!</span>"
	/// In deciseconds, how long the weather lasts once it begins
	var/weather_duration = 1200
	/// See above - this is the lowest possible duration
	var/weather_duration_lower = 1200
	/// See above - this is the highest possible duration
	var/weather_duration_upper = 1500
	/// Looping sound while weather is occuring
	var/weather_sound
	/// Area overlay while the weather is occuring
	var/weather_overlay
	/// Color to apply to the area while weather is occuring
	var/weather_color = null

	/// Displayed once the weather is over
	var/end_message = "<span class='danger'>The wind relents its assault.</span>"
	/// In deciseconds, how long the "wind-down" graphic will appear before vanishing entirely
	var/end_duration = 300
	/// Sound that plays while weather is ending
	var/end_sound
	/// Area overlay while weather is ending
	var/end_overlay

	/// Types of area to affect
	var/area_type = /area/space
	/// The list of z-levels that this weather is actively affecting
	var/impacted_z_levels

	/// Since it's above everything else, this is the layer used by default. TURF_LAYER is below mobs and walls if you need to use that.
	var/overlay_layer = AREA_LAYER
	/// Plane for the overlay
	var/overlay_plane = AREA_PLANE
	/// If the weather has no purpose other than looks
	var/aesthetic = FALSE
	/// Used by mobs (or movables containing mobs, such as enviro bags) to prevent them from being affected by the weather.
	var/immunity_type
	/// If this bit of weather should also draw an overlay that's uneffected by lighting onto the area
	/// Taken from weather_glow.dmi
	var/use_glow = TRUE
	/// List of all overlays to apply to our turfs
	var/list/overlay_cache

	/// The stage of the weather, from 1-4
	var/stage = END_STAGE

	/// Weight amongst other eligible weather. If zero, will never happen randomly.
	var/probability = 0
	/// The z-level trait to affect when run randomly or when not overridden.
	var/target_trait = ZTRAIT_STATION

	/// Whether a barometer can predict when the weather will happen
	var/barometer_predictable = FALSE
	/// For barometers to know when the next storm will hit
	var/next_hit_time = 0
	/// This causes the weather to only end if forced to
	var/perpetual = FALSE

	/// Mechanical Weather effects applied to this weather_type which are applied to mobs. (Wind Gust, lightning, etc)

	/// Wind direction, passed from weather profile.
	var/wind_direction = null
	/// Override to effect list in each weather type, can also be overriden in the map config.
	var/weather_effects = list()
	//The maximum number of weather effects that can be picked for a given storm.
	var/max_effects = 3

	var/datum/weather/chunking/weather_chunking = new() //Builds the weather chunking controller.

/datum/weather/New(z_levels)
	..()
	impacted_z_levels = z_levels

	/*
	* Applying map-specific overrides to things like descs, probabilities, durations, etc.
	* Can be extended if you'd like to add more overrides, just update the map Json and this code.
	*
	*/

	var/datum/map_config/current_map_config = SSmapping.config
	var/overrides = current_map_config.weather_overrides[type]
	if(overrides) //It's possible
		if("desc" in overrides)
			desc = overrides["desc"]
		if("probability" in overrides)
			probability = overrides["probability"]
		if("telegraph_duration" in overrides)
			telegraph_duration = overrides["telegraph_duration"]
		if("weather_duration_lower" in overrides)
			weather_duration_lower = overrides["weather_duration_lower"]
		if("weather_duration_upper" in overrides)
			weather_duration_upper = overrides["weather_duration_upper"]
		if("end_duration" in overrides)
			end_duration = overrides["end_duration"]
		if("telegraph_message" in overrides)
			telegraph_message = overrides["telegraph_message"]
		if("weather_message" in overrides)
			weather_message = overrides["weather_message"]
		if("end_message" in overrides)
			end_message = overrides["end_message"]
		if("perpetual" in overrides)
			perpetual = overrides["perpetual"]
		if("barometer_predictable" in overrides)
			barometer_predictable = overrides["barometer_predictable"]
		if("area_type" in overrides)
			area_type = overrides["area_type"]
		if("protect_indoors" in overrides)
			protect_indoors = overrides["protect_indoors"]
		if("aesthetic" in overrides)
			aesthetic = overrides["aesthetic"]



/**
 * Telegraphs the beginning of the weather on the impacted z levels
 *
 * Sends sounds and details to mobs in the area
 * Calculates duration and hit areas, and makes a callback for the actual weather to start
 *
 */
/datum/weather/proc/telegraph(get_to_the_good_part)
	if(stage == STARTUP_STAGE)
		return

	SEND_GLOBAL_SIGNAL(COMSIG_WEATHER_TELEGRAPH(type))
	stage = STARTUP_STAGE

	weather_duration = rand(weather_duration_lower, weather_duration_upper)
	SSweather.processing |= src
	update_turf_overlays()

	if(get_to_the_good_part)
		start()
	else
		send_alert(telegraph_message, telegraph_sound)
		addtimer(CALLBACK(src, PROC_REF(start)), telegraph_duration)

/**
 * Starts the actual weather and effects from it
 *
 * Updates area overlays and sends sounds and messages to mobs to notify them
 * Begins dealing effects from weather to mobs in the area
 *
 */
/datum/weather/proc/start()
	if(stage >= MAIN_STAGE)
		return

	SEND_GLOBAL_SIGNAL(COMSIG_WEATHER_START(type))

	stage = MAIN_STAGE
	update_turf_overlays()

	weather_effects = select_weather_effects()

	send_alert(weather_message, weather_sound)
	if(!perpetual)
		addtimer(CALLBACK(src, PROC_REF(wind_down)), weather_duration)

/**
 * Weather enters the winding down phase, stops effects
 *
 * Updates areas to be in the winding down phase
 * Sends sounds and messages to mobs to notify them
 *
 */
/datum/weather/proc/wind_down()
	if(stage >= WIND_DOWN_STAGE)
		return

	SEND_GLOBAL_SIGNAL(COMSIG_WEATHER_WINDDOWN(type))
	stage = WIND_DOWN_STAGE

	update_turf_overlays()

	send_alert(end_message, end_sound)
	addtimer(CALLBACK(src, PROC_REF(end)), end_duration)

/**
 * Fully ends the weather
 *
 * Effects no longer occur and area overlays are removed
 * Removes weather from processing completely
 *
 */
/datum/weather/proc/end()
	if(stage == END_STAGE)
		return

	SEND_GLOBAL_SIGNAL(COMSIG_WEATHER_END(type))
	stage = END_STAGE

	SSweather.processing -= src
	update_turf_overlays()

/datum/weather/proc/send_alert(alert_msg, alert_sfx)
	for(var/z_level in impacted_z_levels)
		for(var/mob/player as anything in SSmobs.clients_by_zlevel[z_level])
			if(!can_get_alert(player))
				continue

			if(telegraph_message)
				to_chat(player, alert_msg)

			if(telegraph_sound)
				SEND_SOUND(player, sound(alert_sfx))

// the checks for if a mob should recieve alerts, returns TRUE if can
/datum/weather/proc/can_get_alert(mob/player)
	var/turf/mob_turf = get_turf(player)
	return !isnull(mob_turf)

/**
 * Returns TRUE if the living mob can be affected by the weather
 *
 */
/datum/weather/proc/can_weather_act(mob/living/mob_to_check)
	var/turf/mob_turf = get_turf(mob_to_check)

	if(!mob_turf)
		return

	if(!(mob_turf.z in impacted_z_levels))
		return

	if((immunity_type && HAS_TRAIT(mob_to_check, immunity_type)) || HAS_TRAIT(mob_to_check, TRAIT_WEATHER_IMMUNE))
		return

	var/atom/loc_to_check = mob_to_check.loc
	while(loc_to_check != mob_turf)
		if((immunity_type && HAS_TRAIT(loc_to_check, immunity_type)) || HAS_TRAIT(loc_to_check, TRAIT_WEATHER_IMMUNE))
			return
		loc_to_check = loc_to_check.loc

	if(!(get_area(mob_to_check) in impacted_areas))
		return

	return TRUE

/**
 * Affects the mob, object, or area with whatever the weather does.
 *
 */
/datum/weather/proc/weather_act(mob/living/L, /obj/O, /area/A)
	for(var/datum/weather/effect/E in weather_effects)
		if(!istype(E, /datum/weather/effect)) //Sanity Check? AlmonD Water.
			break

		//Skip effects if cooling down.
		if(E.cooldown > 0)
			break

		//Handling mob-specific effects
		if(L)
			E.apply_effect(L)

		//Handling object-specific effects
		if(O)
			E.apply_effect(O)

		//Handling area-specific effects
		if(A)
			E.apply_effect(A)

/**
 * Updates the overlays on impacted areas
 *
 */
/datum/weather/proc/update_turf_overlays()
	var/list/new_overlay_cache = generate_overlay_cache()

	var/list/chunk_keys = weather_chunking.get_all_turf_chunk_keys()

	for(var/key in chunk_keys)
		var/list/turfs = weather_chunking.get_turfs_in_chunks(list(key))
		for(var/turf/T in turfs)
			if(!isturf(T))
				continue

			//Clearing old overlays
			if(length(overlay_cache))
				T.overlays -= overlay_cache

			//Adding new overlays
			if(length(new_overlay_cache))
				T.overlays += new_overlay-cache

	overlay_cache = new_overlay_cache

/// Returns a list of visual offset -> overlays to use
/datum/weather/proc/generate_overlay_cache()
	// We're ending, so no overlays at all
	if(stage == END_STAGE)
		return list()

	var/weather_state = ""
	switch(stage)
		if(STARTUP_STAGE)
			weather_state = telegraph_overlay
		if(MAIN_STAGE)
			weather_state = weather_overlay
		if(WIND_DOWN_STAGE)
			weather_state = end_overlay

	var/list/gen_overlay_cache = list()
	if(use_glow)
		var/mutable_appearance/glow_image = mutable_appearance('icons/effects/glow_weather.dmi', weather_state, overlay_layer, ABOVE_LIGHTING_PLANE, 100)
		glow_image.color = weather_color
		gen_overlay_cache += glow_image

	var/mutable_appearance/weather_image = mutable_appearance('icons/effects/weather_effects.dmi', weather_state, overlay_layer, plane = overlay_plane)
	weather_image.color = weather_color
	gen_overlay_cache += weather_image

	return gen_overlay_cache

/**
 * Selects random weather effects from the allowed list at the beginning of the storm.
 *
 */

/datum/weather/proc/select_weather_effects()
	var/num_effects = 3 //Arbitrary

	if(weather_effects) //If we have a list of effects (from map config or otherwise), don't bother picking randomly.
		return weather_effects
	else
		var/list/selected_effects = list()
		var/total_weight = 0

		for(var/effect in allowed_weather_effects)
			total_weight += allowed_weather_effects[effect] //Adding each effects weight to the total weight.

		if(max_effects)
			num_effects = rand(1, max_effects) //If we have a max effects number, use that.
		else
			num_effects = rand(1, 5) //At least 1, at most 5.

		while(num_effects > 0 && total_weight > 0) //Continue selecting until we hit the max effects, or no more weight.
			var/random_weight = rand(1, total_weight)
			var/current_weight = 0

			for(var/effect in allowed_weather_effects)
				current_weight += allowed_weather_effects[effect]
				if(random_weight <= current_weight)
					selected_effects += effect ///362-365, choose and remove the effect from the list, along with its weight.
					total_weight -= allowed_weather_effects[effect]
					allowed_weather_effects.Remove(effect)
					num_effects--
					break

		return selected_effects
