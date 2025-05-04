/*
* Weather Effects which can be applied to specific weather_types
* Includes things like: Wind gust, vision obscuration, damage from sources over time, knockback, etc.
* Ideally use these instead of creating new code for effects in each weather type, since these can be
* applied to all of them.
*/

/datum/weather/effect
	var/name = "Generic weather Effect"
	var/severity = 1 //1 = Light, 2 = Moderate, 3 = Severe
	var/duration = 100 //How long the effect lasts, where relevant.
	var/cooldown = 100 //Time before the effect can be reapplied.
	var/cooldown_max = 100 //Maximum cooldown time.
	var/tick_interval = 30 //Deciseconds, we have our own tick in weather fire, so we're not storm dependent.

/datum/weather/effect/proc/apply_effect(mob/living/L, protection_flag)
	var/protection_level = 0
    for (var/obj/item/clothing/equipped_item in L.contents)
        if (equipped_item.slot && (equipped_item.weather_protection_flags & protection_flag))
            protection_level = max(protection_level, equipped_item.weather_protection_level)

    if (protection_level == PROTECTION_FULL) {
        return TRUE
    } else if (protection_level == PROTECTION_MODERATE) {
        severity *= 0.5
    } else if (protection_level == PROTECTION_LIGHT) {
        severity *= 0.8
    }

    return FALSE

/datum/weather/effect/proc/tick()
	if(cooldown > 0)
		cooldown = max(0, cooldown - tick_interval) //Reduce cooldown by the tick interval
		return


//--- Wind Gust Effect ---

/datum/weather/effect/wind_gust
	name = "Wind Gusts"
	cooldown_max = 70 //7 Seconds

/datum/weather/effect/wind_gust/New()
	..()
	addtimer(CALLBACK(src, PROC_REF(update_wind_direction)), rand(300, 600), TIMER_UNIQUE|TIMER_STOPPABLE) //Starting the wind direction timer

/datum/weather/effect/wind_gust/proc/apply_effect(mob/living/L, direction)
	//Unironically the rare occasion where calling parent proc *actually* passes an argument, wow. ..()
	if(..(L, CLOTHING_WINDPROOF))
		return //If the player has full protection, don't apply the effect, otherwise continue.

		var/turf/location = get_turf(L)
		var/direction = direction

		var/list/wind_sounds = list(
			"sound/ambience/wind_gust_light1.ogg",
			"sound/ambience/wind_gust_light2.ogg",
			"sound/ambience/wind_gust_heavy1.ogg"
		)

		var/sound_path = pick(wind_sounds)
		var/volume = rand(30, 50) //Rand volume for *Flavor*

		playsound(L, sound_path, volume)

		L.forceMove(get_step(L, direction))
		if(L.Weight < 60 || L.mob_size < MOB_SIZE_NORMAL) //Small and Tiny mobs
			L.throw_at(get_step_away(L, direction), force = 5 * severity) // Comically strong wind if you are Tiny.

		to_chat(L, "<span class='warning'>A strong gust of wind pushes you!</span>")

		//Speed boost/reduction based on wind direction
		var/wind_alignment = get_wind_alignment(L, direction)
		var/datum/movespeed_modifier/mm = 0 //I ran out of variable names, okay??

		switch(wind_alignment)
			if(1) //Wind at back
				mm = 0.2 // 20% boost
			if(-1) //Wind in face
				mm = -0.1 // 10% reduction

		if(speed_modifier != 0)
			L.add_movespeed_modifier(mm)
			//Revert the speed change after 3 seconds, we don't want it to be too beneficial or too crippling.
			addtimer(CALLBACK(src, .proc/revert_pmove, L, mm), 30)

	//Object Interactions
	for(var/obj/nearby_object in range(location, 1))
		if(nearby_object.anchored) //Wind gusts can't move anchored objects
			continue

		var/obj/item/I = nearby_object
		if(istype(I, /obj/item))
			if(I.flags & NODROP) //We don't want to accidentally move items that are not supposed to be moved.
				continue

		if(nearby_object.weight < WEIGHT_CLASS_NORMAL) //Weight class small/tiny for objects.
			nearby_object.throw_at(get_step_away(nearby_object, direction), force = 3 * severity)
			to_chat(L, "<span class='warning'>The wind pushes the [nearby_object.name] away!</span>")
		else if((nearby_object.weight > WEIGHT_CLASS_NORMAL) && (nearby_object.weight < WEIGHT_CLASS_GIGANTIC)) //Normal to Huge, ignoring Gigantic
			var/probability = 25 * severity //Adjust probability of moving larger objects based on severity.
			if(prob(probability))
				nearby_object.throw_at(get_step_away(nearby_object, direction), force = 2 * severity)
				to_chat(L, "<span class='warning'>The intense wind displaces the [nearby_object.name]!</span>")


/datum/weather/effect/wind_gust/proc/update_wind_direction()
	if(prob(75))
		primary_wind_direction = pick(NORTH, SOUTH, EAST, WEST) //Since there's only one storm active at a time (?), it's probably okay to keep this attached to all storms.

/datum/weather/effect/wind_gust/proc/get_wind_alignment(mob/living/L, primary_wind_direction)
	var/player_facing = L.facing
	var/wind_dir = wind_direction

	if(wind_dir == NORTH)
		return 1 //Wind at back
	else if(wind_dir == turn(player_facing, 180))
		return -1 //Wind at front
	else
		return 0 //Wind at an angle

/datum/weather/effect/wind_gust/proc/revert_wmove(mob/living/L, speed_modifier)
	if(L && !L.destroyed)
		L.add_movespeed_modifier(-mm)

//Weather Effect Defines

#define WEATHER_WINDGUST /datum/weather/effect/wind_gust

//Clothing Protection Types

#define CLOTHING_WINDPROOF 1

//Clothing Protection Levels

#define PROTECTION_NONE 0
#define PROTECTION_LIGHT 1
#define PROTECTION_MODERATE 2
#define PROTECTION_FULL 3
