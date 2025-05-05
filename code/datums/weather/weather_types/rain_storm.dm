/datum/weather/rain_storm
	name = "rain"
	desc = "Cold raindrops pour down from the sky, soaking everything they touch in a thin layer of water. "
	probability = 90

	telegraph_message = "<span class='warning'>Dark clouds poke through the sky as drops of rain begin to sprinkle down from above..</span>"
	telegraph_duration = 200
	telegraph_overlay = "light_rain"

	weather_message = "<span class='userdanger'><i>The wind picks up as a slow drizzle begins to turn into a downpour!</i></span>"
	weather_overlay = "rain_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1500

	end_duration = 100
	end_message = "<span class='boldannounce'>The downpour dies down, the smell of rainwater lingering in the air.</span>"

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_RAINSTORM

	immunity_type = TRAIT_RAINSTORM_IMMUNE

	barometer_predictable = TRUE
	use_glow = FALSE
	weather_effect = list(WEATHER_WINDGUST)
	allowed_weather_effects = list(
		WEATHER_WINDGUST = 5,
		WEATHER_LIGHTNING_STRIKE = 2
	)

/datum/weather/rain_storm/weather_act(mob/living/L)
	..()

/datum/weather/rain_storm/can_get_alert

/datum/weather/rain_storm/start()
	. = ..()

	//Unique alerts for old people and SD's
	for(mob/living/L in GLOB.player_list)
		if(!L.isdead && L.ishuman && L.age > 60)
			to_chat(L, span_warning("You feel an ache in your knee...a storm is coming..</span>"))
			//Probably not my most efficient use of iterating a list, but.. it IS funny.
		else if((is_captain_job(L.mind.assigned_role)) && (if(!get_area(L).outdoors)))
			to_chat(L, span_warning("A storm is brewing out on the horizon..</span>"))
