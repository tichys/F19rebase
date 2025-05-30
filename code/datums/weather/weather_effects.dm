/*
* Weather Effects which can be applied to specific weather_types
* Includes things like: Wind gust, vision obscuration, damage from sources over time, knockback, etc.
* Ideally use these instead of creating new code for effects in each weather type, since these can be
* applied to all of them.
*
* There are four types of effects, but three I mainly use. Global, targets mobs, and targets objects. I
* split them up so different effects can be applied more easily to different targets. Global effects should
* usually be applied across the map, like lightning striking a random turf independent of a player, mob effects
* to mobs, objs to objs, etc. Of course there may be overlap but the system is more for convenience than absolutes.
* If you must put obj effect code in a global strike, you can, and nothing will explode.
*/

// Start of Defines - - -

//Weather Effect Defines

#define WEATHER_WINDGUST /datum/weather/effect/wind_gust
#define WEATHER_LIGHTNING_STRIKE /datum/weather/effect/lightning_strike

//Clothing Protection Types

#define CLOTHING_WINDPROOF 1
#define CLOTHING_LIGHTNINGPROOF 2

//Clothing Protection Levels

#define PROTECTION_LIGHT 1
#define PROTECTION_MODERATE 2
#define PROTECTION_FULL 4

//Magic Number Defines

#define WIND_ALIGNMENT_TAILWIND 1
#define WIND_ALIGNMENT_HEADWIND -1

//Custom Signals

///Called when an objects area moves from indoors to outdoors
#define COMSIG_OUTDOOR_ATOM_ADDED "outdoor_object_added"

///Called when an objects area moves from outdoors to indoors
#define COMSIG_OUTDOOR_ATOM_REMOVED "outdoor_object_removed"

// Chunking system Reference - now accessed via SSweather.weather_chunking

// End of Defines - - -

/datum/weather/effect
	name = "Generic weather Effect"
	var/duration = 100 //How long the effect lasts, where relevant.
	var/cooldown = 100 //Time before the effect can be reapplied.
	var/cooldown_max = 100 //Maximum cooldown time.
	var/tick_interval = 30 //Deciseconds, we have our own tick in weather fire, so we're not storm dependent.
	var/affects_areas = FALSE
	var/affects_mobs = FALSE
	var/affects_objects = FALSE
	var/severity = 1 // This effect's current severity, initialized from the global weather profile.

	var/global_effect_types = list(WEATHER_WINDGUST, WEATHER_LIGHTNING_STRIKE)

/datum/weather/effect/New()
	..()
	src.severity = SSweather.current_profile.severity

//Determines if a mob has protection (of a protection_flag type), if it does the child procs which called us will stop.
/datum/weather/effect/proc/apply_effect(mob/living/L, obj/O, protection_flag)
	var/protection_level = 0
	for (var/obj/item/clothing/equipped_item in L.contents)
		if(equipped_item.weather_protection_flags & protection_flag)
			protection_level = max(protection_level, equipped_item.weather_protection_level)

	if (protection_level == PROTECTION_FULL) {
		return TRUE
	} else if (protection_level == PROTECTION_MODERATE) {
		src.severity *= 0.5
	} else if (protection_level == PROTECTION_LIGHT) {
		src.severity *= 0.8
	}

	return FALSE

/datum/weather/effect/proc/tick()
	if(cooldown > 0)
		cooldown = max(0, cooldown - tick_interval) //Reduce cooldown by the tick interval
		return

//--- Apply to procs ---// Handles any logic that needs to be executed before handing off to actual weather effects.

/datum/weather/effect/proc/apply_to_mobs(list/mobs_to_affect)
	return // Child classes must override this to apply specific mob effects.

/datum/weather/effect/proc/apply_to_objects(list/objects_to_affect)
	return // Child classes must override this to apply specific object effects.

/datum/weather/effect/proc/apply_global_effect() //If a child (claiming to be a global effect) doesn't override, we do nothing.
	return

//--- Wind Gust Effect ---

/datum/weather/effect/wind_gust
	name = "Wind Gusts"
	cooldown_max = 70 //7 Seconds

/datum/weather/effect/wind_gust/New()
	..()
	addtimer(CALLBACK(src, PROC_REF(update_wind_direction)), rand(300, 600), TIMER_UNIQUE|TIMER_STOPPABLE) //Starting the wind direction timer

//Applying the Wind Gust effect to mobs/in view objects (Thespic)


//Applying the wind gust effect independent of players, mostly for objects.

/datum/weather/effect/wind_gust/apply_global_effect()
	var/datum/weather/storm/current_storm
	if(SSweather.processing.len)
		current_storm = SSweather.processing[1]
	if(!current_storm)
		return

	var/dir = pick(NORTH, SOUTH, EAST, WEST)

	var/list/outdoor_mobs = SSweather.weather_chunking.get_mobs_in_chunks_around_storm(current_storm)
	var/list/outdoor_objects = SSweather.weather_chunking.get_objects_in_chunks_around_storm(current_storm)

	process_wind_gust_mobs(outdoor_mobs, dir)
	process_wind_gust_objects(outdoor_objects, dir)

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

///Wind Gust logic for objects
/datum/weather/effect/wind_gust/proc/process_wind_gust_objects(list/objects_list, direction)
	if(!objects_list)
		return

	for(var/obj/O in objects_list)
		if(!O)
			continue

		if(O.anchored || HAS_TRAIT(O, TRAIT_NODROP))
			continue

		if(O.w_class < WEIGHT_CLASS_NORMAL)
			O.throw_at(get_step_away(O, direction), force = 3 * severity)
			O.visible_message(span_warning("The wind pushes the [O.name] away!"))

		else if((O.w_class > WEIGHT_CLASS_NORMAL) && (O.w_class < WEIGHT_CLASS_GIGANTIC))
			var/probability = 25 * severity
			if(prob(probability))
				O.throw_at(get_step_away(O, direction), force = 2 * severity)
				O.visible_message(span_warning("The intense wind displaces the [O.name]!"))

		else if(O.w_class >= WEIGHT_CLASS_GIGANTIC)
			continue

///Wind Gust logic for mobs
/datum/weather/effect/wind_gust/proc/process_wind_gust_mobs(list/mobs_list, direction)
	if(!mobs_list)
		return

	for(var/mob/living/L in mobs_list)
		if(!L)
			continue

		//Playing the sounds first, incase there's any delay.
		var/list/wind_sounds = list(
			"sound/ambience/wind_gust_light1.ogg",
			"sound/ambience/wind_gust_light2.ogg",
			"sound/ambience/wind_gust_heavy1.ogg"
		)

		var/sound_path = pick(wind_sounds)
		var/volume = rand(30, 50) //Rand volume for *Flavor*

		playsound(L, sound_path, volume)

		if(src.apply_effect(L, null, CLOTHING_WINDPROOF)) // Pass null for obj, as this is a mob effect
			continue

		//Moving the player in the wind direction gently if severity is high enough.
		if(severity > 1)
			L.forceMove(get_step(L, direction))
		if(L.mob_size < MOB_SIZE_HUMAN)
			L.throw_at(get_step_away(L, direction), force = 5 * severity)

		to_chat(L, span_warning("A strong gust of wind pushes you!"))

		//Speed boost/reduction based on wind direction
		var/wind_alignment = get_wind_alignment(L, direction)
		var/datum/movespeed_modifier/mm = 0

		switch(wind_alignment)
			if(WIND_ALIGNMENT_TAILWIND)
				mm = 0.2
			if(WIND_ALIGNMENT_HEADWIND)
				mm = -0.1

		if(mm != 0)
			L.add_movespeed_modifier(mm)
			addtimer(CALLBACK(src, /datum/weather/effect/wind_gust/proc/remove_speed, L, mm), 30)


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
	affects_objects = TRUE
	affects_mobs = TRUE

/datum/weather/effect/lightning_strike/New()
	..()

/datum/weather/effect/lightning_strike/proc/apply_single_mob_lightning_effect(mob/living/L, protection_flag)
	if(!L)
		return
	if(src.apply_effect(L, null, protection_flag)) // Pass null for obj, as this is a mob effect
		return

	L.take_damage(rand(20, 50) * severity, BURN, FIRE, 0)
	var/turf/strike_turf = get_turf(L)
	strike_turf.visible_message(span_warning("A jolt of lightning strikes [L.name]!"))
	to_chat(L, span_warning("You feel an intense shock as lightning courses through you, overhwhelming your senses!"))
	L.emote("scream")
	L.Stun(4, TRUE)
	ADD_TRAIT(L, TRAIT_BLURRY_VISION, "weather_lightning")
	addtimer(CALLBACK(L, GLOBAL_PROC_REF(___TraitRemove), L, TRAIT_BLURRY_VISION, "weather_lightning"), 3)

/datum/weather/effect/lightning_strike/proc/process_lightning_struck_objects(list/objects_list)
	if(!objects_list)
		return

	for(var/obj/O in objects_list)
		if(O.resistance_flags & FLAMMABLE)
			ignite_object(O)
		if(istype(O, /obj/machinery))
			short_machine(O)

/datum/weather/effect/lightning_strike/apply_global_effect()

	//Presumably fairly light *TURF SELECTION* process, but can be improved later if needed.

	var/list/strike_candidates = list()
	var/list/all_exposed_turfs = SSweather.weather_chunking.get_turfs_in_chunks(SSweather.weather_chunking.get_all_turf_chunk_keys())
	if(!all_exposed_turfs || all_exposed_turfs.len == 0)
		return

	// Collect all valid strike targets
	for(var/turf/T in all_exposed_turfs)
		if(is_valid_lightning_target(T))
			strike_candidates += T

	if(strike_candidates.len == 0)
		return

	var/turf/target = pick(strike_candidates)
	strike_turf(target)

//Helpers shuttled into apply_global_effect to reduce code duplication.

/datum/weather/effect/lightning_strike/proc/ignite_object(obj/O)
	if(O.resistance_flags & FLAMMABLE)
		O.fire_act(2000, 50, get_turf(O))
		O.visible_message(span_warning("The [O] bursts into flames as lightning strikes it!"))

/datum/weather/effect/lightning_strike/proc/short_machine(obj/machinery/M)
	if(prob(30)) //30% chance we just Explode instead
		explosion(get_turf(M), 0, 0, 0)
		qdel(M)
		M.visible_message(span_warning("The [M] explodes violently as lightning strikes it!"))
	else
		M.set_machine_stat(M.machine_stat | BROKEN) //Bzzt, we shorted it out. Hope that wasn't Important!
		M.visible_message(span_warning("The [M] sparks and shorts out from the lightning strike!"))

// You can add your own criteria for validity here if for some ungodly reason being outside and not null isn't enough for you.
/datum/weather/effect/lightning_strike/proc/is_valid_lightning_target(turf/T)
	if(!T)
		return FALSE
	if(!SSweather.eligible_zlevels["[T.z]"]) // Ensure turf's Z-level is eligible for weather
		return FALSE
	// Additional checks can be added here if needed, e.g., if the turf is a specific type
	return TRUE

//Getting the objects to hit list, not actually executing the strike, that's done in the strike_turf proc.
/datum/weather/effect/lightning_strike/proc/build_multistrike_list(list/targets, percent_chance = 0, single_strike_only = FALSE)
	var/list/weighted_targets = list()
	var/highest_weight_obj = null
	var/highest_weight = 0

	for(var/obj/O in targets)
		if(!istype(O)) //Sanity check
			continue

		var/conductivity = 0
		if(istype(O, /obj/item))
			var/obj/item/I = O //Siemens Coefficient only exists on obj/item.
			conductivity = clamp(I.siemens_coefficient, 0, 1) //Negative coefficients are right out, and we don't want over 1..r 1..
		var/weight = round(conductivity * 10) //Conductivity converted into a weight value (1.0 = 10 weight)

		//Bonus weights for specific equipment/properties.

		if(istype(O, /obj/machinery))
			var/obj/machinery/M = O
			weight += (M.is_operational ? 5 : 2) //Ternary operator my beloved...

		if(istype(O, /obj/structure/fence))
			weight += 4

		if(istype(O, /obj/machinery/power/generator))
			weight += 6

		if(istype(O, /obj/structure/cable) || istype(O, /obj/item/stack/cable_coil))
			weight += 3

		if(istype(O, /obj/structure/railing) || istype(O, /obj/structure/lattice/catwalk) || istype(O, /obj/structure/overfloor_catwalk))
			weight += 2

		var/height = 1 //If the object doesn't specify a height, we assume it's 1.
		if(O.vars.Find("height")) //Checking if the object has a height var before accessing it.
			height = max(O.vars["height"] || 1, 1)
		weight += round(height * 1.5) //Height bonus, because who doesn't love a good lightning rod?

		if(weight > highest_weight)
			highest_weight = weight
			highest_weight_obj = O

		for(var/i = 1, i <= weight, i++) //Adds the object to the list multiple times depending on its weight (Conductivity)
			weighted_targets += O

	if(!weighted_targets.len) //If no objects with conductivity > 0, we just pick a random target from original list.
		if(!targets.len) // If original targets list is also empty, return an empty list
			message_admins(span_adminnotice("Weather System: build_multistrike_list: Both weighted_targets and original targets list are empty. This should not usually happen!"))
			return list()
		return list(pick(targets)) // Ensure a list is always returned

	//Single Strike argument: If for some reason you just want to hit that One Fucking Bird.
	if(single_strike_only)
		return pick(weighted_targets)

	var/list/objects_struck = list()
	var/list/unique_targets = list()

	//Building unique targets, so we don't get duplicates from the weighting.
	for(var/obj/O in weighted_targets)
		if(O && !(O in unique_targets))
			unique_targets += O

	//Rolling for each unique conductive object, to see if it will get struck.
	for(var/obj/O in unique_targets)
		if(prob(percent_chance))
			objects_struck += O

	//If nothing passes the roll, just strike the highest weighted one.
	if(!objects_struck.len && highest_weight_obj)
		objects_struck += highest_weight_obj

	return objects_struck //If we DO have conductive objects, we pick from our weighted list instead.

///Charging something on a turf
/datum/weather/effect/lightning_strike/proc/charge_power_receptor(turf/T)
	var/obj/structure/cable/C = locate(/obj/structure/cable) in T.contents
	if(C)
		C.add_avail(rand(400000, 800000)) //Charge the cable with a random amount of power, between 400k and 800k.
		T.visible_message(span_warning("The power cable on [T] sparks and crackles with energy as the lightning strikes!"))

		if(prob(70)) //70% chance to overload and destroy the cable.
			T.visible_message(src, span_warning("The power cable violently explodes into a charred mess!"))
			new /obj/effect/decal/cleanable/burnt_wire(T)
			qdel(C) //Delete the cable, since it has exploded.
			playsound(T, 'sound/effects/explosion3.ogg', rand(30, 50), TRUE)

	for(var/obj/O in T.contents)
		if(O == C)
			continue //We already handeled cables

	//Shamelessly "Inspired" from inducer code.

		if(istype(O, /obj/item/stock_parts/cell))
			var/obj/item/stock_parts/cell/cell_obj = O
			if(cell_obj.charge < cell_obj.maxcharge)
				var/to_transfer = rand(10000, 30000)
				cell_obj.give(to_transfer)
				cell_obj.update_appearance()
				T.visible_message(span_notice("A power cell on [T] crackles with energy from the lightning!"))

		else if(hascall(O, "get_cell"))
			var/obj/item/stock_parts/cell/cell_obj = call(O, "get_cell")()
			if(cell_obj && cell_obj.charge < cell_obj.maxcharge)
				var/to_transfer = rand(10000, 30000)
				cell_obj.give(to_transfer)
				cell_obj.update_appearance()
				O.update_appearance()
				T.visible_message(span_notice("[O] briefly surges with power from the lightning strike!"))

/* Strike turf handles all the messy logistics of hitting things on and around a turf, while the others
 * (apply_effect and apply_global_effect) handle specific cases like lightning targeting mobs for some reason,
 *  and passing arguments to the strike_turf proc itself.
 */
/datum/weather/effect/lightning_strike/proc/strike_turf(turf/T)
	if(!T) //How did we get here without a turf?
		return

	//Lightning flash logic goes here.
	T.set_light(l_power = 100, l_color = "#FFFFFF") // Brief bright white flash at the strike location
	addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, set_light), 0, null, null, null, FALSE), 10) // Turn off light after 10 deciseconds
	// I hate addtimer so Unspeakably much, why are you making me do this???

	var/list/sound_profiles = list(
		list("max_dist" = 10, "sound" = "sound/weather/lightning_strike_close.ogg", "volume" = 70),
		list("max_dist" = 50, "sound" = "sound/weather/lightning_strike_mid.ogg", "volume" = 50),
		list("max_dist" = 80, "sound" = "sound/weather/lightning_strike_far.ogg", "volume" = 30)
	)

	var/list/already_heard = list() //List of players who have already heard the sound, so we don't spam them.

	for(var/client/C in GLOB.clients)
		var/mob/M = C.mob
		if(!M || (M in already_heard)) // Ignore clientless mobs or mobs who already heard it.
			continue

		var/hearing_range = get_dist(T, M)

		for(var/profile_map in sound_profiles)
			if(hearing_range <= profile_map["max_dist"])
				var/strike_turf = get_turf(M)

				if(hearing_range <= 5)
					//Close: Lets play the sound immediately
					playsound(strike_turf, profile_map["sound"], profile_map["volume"], TRUE)
				else
					//Mid/Far, lets delay for realism
					var/pitch = rand(90, 110) / 100 // .9 to 1.1 pitch variation
					var/delay = hearing_range * 3 // Calculate delay based on distance (3 deciseconds per tile)
					addtimer(CALLBACK(null, PROC_REF(playsound), list(get_turf(M), profile_map["sound"], profile_map["volume"], TRUE, 44100 * pitch)), delay) // "Cause Light travels faster than sound!"

				already_heard += M //Add the mob to the already heard list.
				break //break out of the loop, since we found a match.

	//Affecting randomly struck mobs on a picked turf.
	for(var/mob/living/L in T.contents)
		apply_single_mob_lightning_effect(L, CLOTHING_LIGHTNINGPROOF)

	// Getting all nearby atoms from surrounding chunks
	var/list/nearby_atoms = SSweather.weather_chunking.get_nearby_atoms(T, 1)

	var/list/nearby_objs = list()
	for(var/atom/A in nearby_atoms)
		if(istype(A, /obj))
			nearby_objs += A

	// NEW LOGIC: If no objects found via chunking, fallback to all objects on the turf and adjacent turfs
	if(!nearby_objs.len)
		message_admins(span_adminnotice("DEBUG: strike_turf: No objects found via chunking. Falling back to direct turf contents for lightning strike."))
		for(var/atom/A in T.contents)
			if(istype(A, /obj) && !(A in nearby_objs))
				nearby_objs += A
		for(var/direction in list(NORTH, SOUTH, EAST, WEST)) // Get adjacent turfs in cardinal directions
			var/turf/adjacent_turf = get_step(T, direction)
			if(!adjacent_turf)
				continue
			for(var/atom/A in adjacent_turf.contents)
				if(istype(A, /obj) && !(A in nearby_objs))
					nearby_objs += A

	message_admins(span_adminnotice("DEBUG: nearby_atoms count: [nearby_atoms.len]. nearby_objs count (after fallback): [nearby_objs.len]."))

	var/list/targets_to_strike = build_multistrike_list(nearby_objs, 50) //We have the nearby objs, lets check to see if any of them are conductive/high, etc.

	if(targets_to_strike && targets_to_strike.len)
		process_lightning_struck_objects(targets_to_strike)

	if(prob(40 + (severity * 10))) //40% chance the strike produces a *Gentle* impact, ideally knocking things/equipment around.
		explosion(T, light_impact_range = 3, flame_range = 1, flash_range = 2)


/// --- Admin Utilities --- For both testing/debugging and the... Other Things... admins get up to..

GLOBAL_LIST_INIT(weather_debug_verbs, list(
	// These verbs are hidden by default and shown by toggle_weather_debug_verbs
	/client/proc/lightning_strike_test,
	/client/proc/toggle_weather_coverage_debug_messages,
	/client/proc/debug_all_weather_effects
))
GLOBAL_PROTECT(weather_debug_verbs)

/client/proc/toggle_weather_debug_verbs()
	set category = "Debug"
	set name = "Toggle Weather Debug Verbs"
	set desc = "Toggles the visibility of weather-related debug verbs."

	if(!check_rights(R_DEBUG))
		return

	if(verbs.Find(/client/proc/lightning_strike_test)) // Check if any weather verb is currently visible
		remove_verb(src, GLOB.weather_debug_verbs)
		to_chat(usr, span_interface("Weather debug verbs hidden."))
	else
		add_verb(src, GLOB.weather_debug_verbs)
		to_chat(usr, span_interface("Weather debug verbs shown."))

/client/proc/debug_all_weather_effects()
	set name = "Enable All Weather Effects"
	set category = "Debug"
	set desc = "Enables all known weather effects regardless of the active weather profile."

	if(!check_rights(R_DEBUG))
		return

	if(!SSweather)
		to_chat(usr, span_warning("Weather subsystem not found."), confidential = TRUE)
		return

	// Clear existing weather effects
	for(var/datum/weather/current_storm in SSweather.processing)
		qdel(current_storm)
	SSweather.processing.Cut()

	var/list/enabled_effects = list()
	for(var/effect_type in subtypesof(/datum/weather/effect))
		var/datum/weather/effect/new_effect = new effect_type()
		SSweather.processing += new_effect
		enabled_effects += new_effect.name

	to_chat(usr, span_notice("All weather effects enabled: [enabled_effects.Join(", ")]"), confidential = TRUE)
	log_admin("[key_name(usr)] enabled all weather effects: [enabled_effects.Join(", ")]")
	message_admins("[key_name_admin(usr)] enabled all weather effects: [enabled_effects.Join(", ")]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Enable All Weather Effects")

/client/proc/lightning_strike_test()
	set category = "Debug"
	set name = "Test Lightning Strike"
	set desc = "Triggers a lightning strike at a selected turf."

	message_admins(span_adminnotice("DEBUG: lightning_strike_test verb called by [usr.key]"))
	to_chat(usr, "DEBUG: Initiating lightning strike test.")

	var/datum/weather/effect/lightning_strike/L = new // Instantiate once
	var/turf/target_turf = null // Initialize to null, as there's no input

	// Always attempt random strike first
	to_chat(usr, span_debug("Attempting to find a random exposed turf for lightning strike."))
	message_admins(span_adminnotice("DEBUG: Attempting to find a random exposed turf for lightning strike."))

	var/list/all_exposed_turfs = SSweather.weather_chunking.get_turfs_in_chunks(SSweather.weather_chunking.get_all_turf_chunk_keys())

	var/list/eligible_strike_candidates = list()
	if(all_exposed_turfs.len > 0)
		for(var/turf/T in all_exposed_turfs)
			if(L.is_valid_lightning_target(T)) // Use the existing validity check
				eligible_strike_candidates += T

	if(eligible_strike_candidates.len > 0)
		to_chat(usr, span_debug("Found [eligible_strike_candidates.len] eligible strike candidates."))
		message_admins(span_adminnotice("DEBUG: Found [eligible_strike_candidates.len] eligible strike candidates."))
		target_turf = pick(eligible_strike_candidates)
		to_chat(usr, "Striking a random eligible turf: [target_turf].")
		message_admins(span_adminnotice("DEBUG: Random eligible turf selected: [target_turf]."))
	else
		target_turf = get_turf(usr) // Fallback to user's turf if no eligible turfs found
		to_chat(usr, "No eligible exposed turfs found. Striking your current turf: [target_turf]. Note: This turf may not be eligible for weather effects.")
		message_admins(span_adminnotice("DEBUG: No eligible exposed turfs found. Striking user's turf: [target_turf]."))

	if(target_turf)
		var/list/eligible_z_keys = list()
		if(SSweather.eligible_zlevels)
			for(var/z_key in SSweather.eligible_zlevels)
				eligible_z_keys += z_key
		var/joined_keys = eligible_z_keys.len ? eligible_z_keys.Join(", ") : "None"
		message_admins(span_adminnotice("DEBUG: Target turf Z-level: [target_turf.z]. Eligible Z-levels: [joined_keys]. Is target Z-level eligible? [SSweather.eligible_zlevels["[target_turf.z]"] ? "TRUE" : "FALSE"]."))

		// --- Start of new logic to ensure objects for testing build_multistrike_list ---
		var/list/test_nearby_atoms = SSweather.weather_chunking.get_nearby_atoms(target_turf, 1)
		var/list/test_nearby_objs = list()
		for(var/atom/A in test_nearby_atoms)
			if(istype(A, /obj))
				test_nearby_objs += A

		var/obj/dummy_obj_for_test
		if(!test_nearby_objs.len)
			// If no objects are found, spawn a temporary dummy object for the test
			dummy_obj_for_test = new /obj/item/stack/sheet/iron(target_turf) // Use a common, simple object
			message_admins(span_adminnotice("DEBUG: Spawning dummy object [dummy_obj_for_test] at [target_turf] for lightning strike test."))
		// --- End of new logic ---

		L.strike_turf(target_turf)

		// --- Clean up dummy object after strike ---
		if(dummy_obj_for_test)
			qdel(dummy_obj_for_test)
			message_admins(span_adminnotice("DEBUG: Deleting dummy object [dummy_obj_for_test] after lightning strike test."))
		// --- End of clean up ---

		to_chat(usr, "Lightning strike initiated at [target_turf].")
		message_admins(span_adminnotice("DEBUG: Lightning strike initiated at [target_turf]."))
	else
		to_chat(usr, "Could not determine a valid turf to strike.")
		message_admins(span_adminnotice("DEBUG: Could not determine a valid turf to strike."))

	qdel(L) // Clean up the datum after the strike
