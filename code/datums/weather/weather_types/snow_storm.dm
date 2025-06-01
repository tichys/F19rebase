/datum/weather/weather_types/snow_storm
	name = "snow storm"
	desc = "Harsh snowstorms roam the topside of this arctic planet, burying any area unfortunate enough to be in its path."
	probability = 90

	telegraph_message = "<span class='warning'>Drifting particles of snow begin to dust the surrounding area..</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_snow"

	weather_message = "<span class='userdanger'><i>Harsh winds pick up as dense snow begins to fall from the sky! Seek shelter!</i></span>"
	weather_overlay = "snow_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1500

	end_duration = 100
	end_message = "<span class='boldannounce'>The snowfall dies down, it should be safe to go outside again.</span>"

	target_trait = ZTRAIT_PLANETARY_ENVIRONMENT

	immunity_type = TRAIT_SNOWSTORM_IMMUNE

	barometer_predictable = TRUE
	use_glow = FALSE

/datum/weather/snow_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(5,15))

// since snowstorm is on a station z level, add extra checks to not annoy everyone
/datum/weather/snow_storm/can_get_alert(mob/player)
	if(!..())
		return FALSE

	if(!is_station_level(player.z))
		return TRUE  // bypass checks

	if(isobserver(player))
		return TRUE

	if(HAS_TRAIT(player, TRAIT_DETECT_STORM))
		return TRUE

	if(istype(get_area(player), /area/mine))
		return TRUE

	var/list/impacted_chunk_keys = SSweather.weather_chunking.get_impacted_chunk_keys(src)
	var/list/impacted_turfs = SSweather.weather_chunking.get_turfs_in_chunks(impacted_chunk_keys)

	for(var/turf/snow_turf in impacted_turfs)
		if(locate(snow_turf) in view(player))
			return TRUE

	return FALSE
