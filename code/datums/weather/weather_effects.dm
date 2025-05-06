/*
* Weather Effects which can be applied to specific weather_types
* Includes things like: Wind gust, vision obscuration, damage from sources over time, knockback, etc.
* Ideally use these instead of creating new code for effects in each weather type, since these can be
* applied to all of them.
*/

// Start of Defines - - -

//Weather Effect Defines

#define WEATHER_WINDGUST /datum/weather/effect/wind_gust
#define WEATHER_LIGHTNING_STRIKE /datum/weather/effect/lightning_strike

//Clothing Protection Types

#define CLOTHING_WINDPROOF 1
#define CLOTHING_LIGHTNINGPROOF

//Clothing Protection Levels

#define PROTECTION_LIGHT 1
#define PROTECTION_MODERATE 2
#define PROTECTION_FULL 3

//Magic Number Defines

#define WIND_ALIGNMENT_TAILWIND 1
#define WIND_ALIGNMENT_HEADWIND -1

//Custom Signals

///Called when an objects area moves from indoors to outdoors
#define COMSIG_OUTDOOR_ATOM_ADDED "outdoor_object_added"

///Called when an objects area moves from outdoors to indoors
#define COMSIG_OUTDOOR_ATOM_REMOVED "outdoor_object_removed"

// End of Defines - - -

/datum/weather/effect
	name = "Generic weather Effect"
	var/duration = 100 //How long the effect lasts, where relevant.
	var/cooldown = 100 //Time before the effect can be reapplied.
	var/cooldown_max = 100 //Maximum cooldown time.
	var/tick_interval = 30 //Deciseconds, we have our own tick in weather fire, so we're not storm dependent.

/datum/weather/effect/New()
	..()
	RegisterSignal(COMSIG_OUTDOOR_ATOM_ADDED, /datum/weather/effect/proc/outdoor_atom_added)
	RegisterSignal(COMSIG_OUTDOOR_ATOM_REMOVED, /datum/weather/effect/proc/outdoor_atom_removed)
	RegisterSignal(COMSIG_MOVABLE_MOVED, /datum/weather/effect/proc/outdoor_atom_moved)

/datum/weather/effect/proc/outdoor_atom_added(atom/movable/A)
	if(!A || A.anchored) //How did it get moved here if it was anchored? I don't know.
		return

	weather_chunking.register(A)
	needs_weather_update = TRUE

/datum/weather/effect/proc/outdoor_object_removed(atom/movable/A)
	if(!A)
		return

	weather_chunking.unregister(A)

//Used for chunking to determine if an atom entered a new chunk.
/datum/weather/effect/proc/outdoor_object_moved(atom/movable/A)
	if(!A)
		return

	weather_chunking.update_atom_location

/datum/weather/effect/proc/apply_effect(mob/living/L, protection_flag)
	var/protection_level = 0
	for (var/obj/item/clothing/equipped_item in L.contents)
		if(equipped_item.weather_protection_flags & protection_flag)
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

//Applying the Wind Gust effect to mobs/in view objects (Thespic)

/datum/weather/effect/wind_gust/proc/apply_gust_effect(mob/living/L, direction)
	if(src.apply_effect(L, CLOTHING_WINDPROOF)) //We take different arguments than apply_effect, so it's not our parent, and we need to call it manually.
		return //If the player has full protection, don't apply the effect, otherwise continue.

	//Playing the sounds first, incase there's any delay.
	var/list/wind_sounds = list(
		"sound/ambience/wind_gust_light1.ogg",
		"sound/ambience/wind_gust_light2.ogg",
		"sound/ambience/wind_gust_heavy1.ogg"
	)

	var/sound_path = pick(wind_sounds)
	var/volume = rand(30, 50) //Rand volume for *Flavor*

	playsound(L, sound_path, volume)

	//Moving the player in the wind direction gently if severity is high enough.
	if(severity > 1)
		L.forceMove(get_step(L, direction))
	if(L.mob_size < MOB_SIZE_HUMAN) //Small and Tiny mobs || I'd like to also check weight preference set by players, but I don't know the var for that.
		L.throw_at(get_step_away(L, direction), force = 5 * severity) // Comically strong wind if you are Tiny.

	to_chat(L, span_warning("A strong gust of wind pushes you!"))

	//Speed boost/reduction based on wind direction
	var/wind_alignment = get_wind_alignment(L, direction)
	var/datum/movespeed_modifier/mm = 0 //I ran out of variable names, okay??

	switch(wind_alignment)
		if(WIND_ALIGNMENT_TAILWIND) //Wind at back
			mm = 0.2 // 20% boost
		if(WIND_ALIGNMENT_HEADWIND) //Wind in face
			mm = -0.1 // 10% reduction

	if(mm != 0)
		L.add_movespeed_modifier(mm)
		//Revert the speed change after 3 seconds, we don't want it to be too beneficial or too crippling.
		addtimer(CALLBACK(src, /datum/weather/effect/wind_gust/proc/remove_speed, L, mm), 30)

	//Object Interactions
	var/turf/location = get_turf(L)
	for(var/obj/nearby_object in range(location, 1))
		if(nearby_object.anchored) //Wind gusts can't move anchored objects
			continue

		var/obj/item/I = nearby_object
		if(istype(I, /obj/item))
			if(HAS_TRAIT(I, TRAIT_NODROP)) //We don't want to accidentally move items that are not supposed to be moved.
				continue

		if(nearby_object.w_class < WEIGHT_CLASS_NORMAL) //Weight class small/tiny for objects.
			nearby_object.throw_at(get_step_away(nearby_object, direction), force = 3 * severity)
			to_chat(L, span_warning("The wind pushes the [nearby_object.name] away!"))

		else if((nearby_object.w_class > WEIGHT_CLASS_NORMAL) && (nearby_object.w_class < WEIGHT_CLASS_GIGANTIC)) //Normal to Huge, ignoring Gigantic
			var/probability = 25 * severity //Adjust probability of moving larger objects based on severity.
			if(prob(probability))
				nearby_object.throw_at(get_step_away(nearby_object, direction), force = 2 * severity)
				to_chat(L, span_warning("The intense wind displaces the [nearby_object.name]!"))

//Applying the wind gust effect independent of players, mostly for objects.

/datum/weather/effect/wind_gust/proc/apply_global_effect()
	for(var/obj/O in GLOB.outdoor_weather_objects)
		if(!O)
			continue

		if(O.anchored || HAS_TRAIT(O, TRAIT_NODROP)) //No moving anchored objects/yucky nodrop items.
			continue

		if(O.w_class < WEIGHT_CLASS_NORMAL) //Weight class determinations same as before, see player dependent object interactions for clarification.
			O.throw_at(get_step_away(O, dir), force = 3 * severity)
			to-chat(O, span_warning("The wind pushes the [O.name] away!"))

		else if((O.w_class > WEIGHT_CLASS_NORMAL) && (O.w_class < WEIGHT_CLASS_GIGANTIC))
			var/probability = 25 * severity
			if(prob(probability))
				O.throw_at(get_step_away(O, dir), force = 2 * severity)
				to_chat(O, span_warning("The intense wind displaces the [O.name]!"))

			else if(O.w_class >= WEIGHT_CLASS_GIGANTIC) //Gigantic objects unaffected by gusts.
				continue

//25% chance per weather_act to switch the wind direction.
/datum/weather/effect/wind_gust/proc/update_wind_direction()
	if(prob(75))
		wind_direction = pick(NORTH, SOUTH, EAST, WEST) //Since there's only one storm active at a time (?), it's probably okay to keep this attached to all storms.

/datum/weather/effect/wind_gust/proc/get_wind_alignment(mob/living/L, wind_direction)
	var/player_facing = L.dir
	var/wind_dir = wind_direction

	if(wind_dir == player_facing)
		return 1 //Wind at back
	else if(wind_dir == turn(player_facing, 180))
		return -1 //Wind at front
	else
		return 0 //Wind at an angle

// Helper to remove wind speed modifier after a few seconds.
/datum/weather/effect/wind_gust/proc/remove_speed(mob/living/L, datum/movespeed_modifier/mm)
	L.remove_movespeed_modifier(mm)


/*--- Lightning Strike Effect --- Rumble Rumble Crash!

    ___(                        )
   (                          _)
  (_                       __))
    ((                _____)
      (_________)----'
         _/  /
        /  _/
      _/  /
     / __/
   _/ /
  /__/
 //
/'

*/

/datum/weather/effect/lightning_strike
	name = "Lightning Strikes"
	cooldown = 700 // At least 70 seconds between strikes by default

/datum/weather/effect/lightning_strike/New()
	..()
	build_lightning_target_list()

/datum/weather/effect/lightning_strike/proc/apply_effect(mob/living/L, protection_flag) //Same as parent for now, change later if I need more arguments.
	if(..(L, CLOTHING_LIGHTNINGPROOF))
		return

	if(strike_mode == STRIKE_GLOBAL)
		if(turfs.len == 0)
			strike_mode = STRIKE_NEAR_PLAYER //We failed to find a global target, so we pick an area near a player argument instead.
		else
			target_turf = pick(turfs)


	else if(strike_mode == STRIKE_NEAR_PLAYER)
		for(var/mob/living/player in GLOB.player_list)
			if(isturf(player.loc))

/datum/weather/effect/lightning_strike/proc/global_apply_effect()

	//Presumably fairly light *TURF SELECTION* process, but can be improved later if needed.
	//Does a global outdoor turf list exist? Should I just cache this in a bigger global list?

	var/list/turfs = list()
	var/max_attempts = 20 //If we fail to find a target in 10 attempts, we pack it up and go home.

	if(!turfs || turfs.len < 10) //If there's no turfs to strike (or less than 10), we need to find some, else lets just use the one's we have.
		for(var/i = 1 to max_attempts)
			if(turfs.len >= 10) //Stop when we hit the 10 turf cap.
				break

			var/turf/T = locate(rand(1, world.maxx), rand(1, world.maxy), rand(1, world.maxz))
			if(T.outdoors && !istype(T, /turf/open/openspace)) //We don't want lightning to strike the "Sky" or indoor areas.
				turfs += T //Adding the turf to the list of possible targets.

		if(turfs.len == 0)
			return //No valid turfs to strike, somehow, so we give up.

		var/turf/target_turf = pick(turfs)

		strike_turf(target_turf) //KRA-BOOM!



//Helpers shuttled into apply_effect and apply_global_effect to reduce code duplication.

/datum/weather/effect/lightning_strike/proc/ignite_object(obj/O)
	if(O.resistance_flags & FLAMMABLE)
		O.ignite() //Proc for igniting, whatever that is..
		visible_message(src, span_warning("The [O] bursts into flames as lightning strikes it!"))

/datum/weather/effect/lightning_strike/proc/short_machine(obj/machine/M)
	if(prob(30)) //30% chance we just Explode instead
		M.explode() //Explode proc, whatever that is.
		visible_message(src, span_warning("The [M] explodes violently as lightning strikes it!"))
	else
		M.short_circuit()
		visible_message(src, span_warning("The [M] sparks and shorts out from the lightning strike!"))

//Getting the list, not actually executing the strike, that's done in the apply_effect proc.
/datum/weather/effect/lightning_strike/proc/strike_conductive_objects(list/targets)
	var/list/conductive_objects = list()
	for(var/obj/O in targets)
		var/conductivity = clamp(O.siemens_coefficient, 0, 1) //Negative coefficients are right out, and we don't want over 1..

		var/weight = round(conductivity * 10) //Conductivity converted into a weight value (1.0 = 10 weight)

		for(var/i = 1, i <= weight, i++) //Adds the object to the list multiple times depending on its weight (Conductivity)
			weighted_targets += O

	if(!weighted_targets.len) //If no objects with conductivity > 0, we just pick a random target from original list.
		return pick(targets)

	return pick(weighted_targets) //If we DO have conductive objects, we pick from our weighted list instead.

///Charging something on a turf
/datum/weather/effect/lightning_strike/proc/charge_power_receptor(turf/T)
	var/obj/structure/cable/C = locate(/obj/structure/cable) in T.contents
	if(C)
		C.charge(rand(400000, 800000)) //Charge the cable with a random amount of power, between 400k and 800k.
		visible_message(src, span_warning("The power cable on [T] sparks and crackles with energy as the lightning strikes!"))

		if(prob(70)) //70% chance to overload and destroy the cable.
			visible_message(src, span_warning("The power cable violently explodes into a charred mess!"))
			new /obj/effect/decal/cleanable/burnt_wire(T)
			qdel(C) //Delete the cable, since it has exploded.
			playsound(T, 'sound/effects/explosion3.ogg', rand(30, 50), TRUE)

	for(var/obj/O in T.contents)
		if(O == C)
			continue //We already handeled cables

	//Shamelessly "Inspired" from inducer code.

		if(istype(O, /obj/item/stock_parts/cell))
			var/obj/item/stock_parts/cell/C = O
			if(C.charge < C.maxcharge)
				var/to_transfer = rand(10000, 30000)
				var/transferred = C.give(to_transfer)
				C.update_appearance()
				visible_message(src, span_notice("A power cell on [T] crackles with energy from the lightning!"))

		else if(hascall(O, "get_cell"))
			var/obj/item/stock_parts/cell/C = call(O, "get_cell")()
			if(C && C.charge < C.maxcharge)
				var/to_transfer = rand(10000, 30000)
				var/transferred = C.give(to_transfer)
				C.update_appearance()
				O.update_appearance()
				visible_message(src, span_notice("[O] briefly surges with power from the lightning strike!"))



/* Strike turf handles all the messy logistics of hitting things on and around a turf, while the others
 * (apply_effect and apply_global_effect) handle specific cases like lightning targeting mobs for some reason,
 *  and passing arguments to the strike_turf proc itself.
 */
/datum/weather/effect/lightning_strike/proc/strike_turf(turf/T)
	if(!T) //How did we get here without a turf?
		return

	//Lightning flash logic goes here.



	//Lightning flash logic done.

	var/list/sound_profiles = list(
		list("max_dist" = 10, "sound" = "sound/weather/lightning_strike_close.ogg", "volume" = 70),
		list("max_dist" = 50, "sound" = "sound/weather/lightning_strike_mid.ogg", "volume" = 50),
		list("max_dist" = 80, "sound" = "sound/weather/lightning_strike_far.ogg", "volume" = 30)
	)

	var/sound_path = pick(lightning_sounds)

	var/list/already_heard = list() //List of players who have already heard the sound, so we don't spam them.

	for(var/mob/living/L in GLOB.player_list)
		if(!L.client || L in already_heard) //Ignore clientless mobs, and players who already heard it.
			continue

		var/hearing_range = get_dist(T, L)

		for(var/profile_map in sound_profiles)
			if(hearing_range <= profile_map["max_dist"])
				var/sound_path = pick(profile_map["sound"])
				var/strike_turf = get_turf(L)

				if(hearing_range <= 5)
					//Close: Lets play the sound immediately
					playsound(strike_turf, sound_path, profile_map["volume"], TRUE)
				else
					//Mid/Far, lets delay for realism
					var/pitch = rand(90, 110) / 100 // .9 to 1.1 pitch variation
					addtimer(CALLBACK(proc=/proc/playsound, args=list(get_turf(L), profile_map["sound"], profile_map["volume"], TRUE, pitch)), delay) // "Cause Light travels faster than sound!"

				already_heard += L //Add the player to the already heard list.
				break //break out of the loop, since we found a match.

	//Affecting randomly struck mobs on a picked turf (Not to be mistaken with Targeted mobs in player dependent apply_effect)
	for(var/mob/living/L in T.contents)
		L.take_damage(rand(20, 50) * severity, BURN, FIRE, 0) //This can get out of hand quickly if the severity increases.
		visible_message(src, span_warning("A jolt of lightning strikes [L.name]!"))
		to_chat(L, span_warning("You feel an intense shock as lightning courses through you, overhwhelming your senses!"))
		L.emote("scream")
		L.Stun(4, TRUE) //You just got hit by lightning, shake it off..
		L.blur_eyes(3)
		addtimer(CALLBACK(proc=L.set_bluriness, args=list(0)), 3) // Unblur eyes after 3 seconds

	for(var/obj/O in T.contents)
		if(O.resistance_flags & FLAMMABLE)
			ignite_object(O)
		if(istype(O, /obj/machinery))
			short_machine(O)

	if(prob(40 + (severity * 10))) //40% chance the strike produces a *Gentle* impact, ideally knocking things/equipment around.
		explosion(T, light_impact_range = 3, flame_range = 1, flash_range = 2)
