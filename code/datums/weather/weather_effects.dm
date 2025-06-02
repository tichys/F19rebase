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
#define WEATHER_FOG /datum/weather/effect/fog

//Clothing Protection Types

#define CLOTHING_WINDPROOF 1
#define CLOTHING_LIGHTNINGPROOF 2
#define CLOTHING_FOGPROOF 4 // Next power of 2 after 2

//Clothing Protection Levels

#define PROTECTION_LIGHT 1
#define PROTECTION_MODERATE 2
#define PROTECTION_FULL 4

//Magic Number Defines

#define WIND_ALIGNMENT_TAILWIND 1
#define WIND_ALIGNMENT_HEADWIND -1

//Custom Signals

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
	var/needs_overlay_cleanup = FALSE // Set to TRUE if this effect manages its own visual overlays (I.E: Fog)

	var/global_effect_types = list(WEATHER_WINDGUST, WEATHER_LIGHTNING_STRIKE, WEATHER_FOG)

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

/datum/weather/effect/proc/cleanup_visual_overlays()
	return // Child classes that manage overlays should override this.

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
	var/list/sound_profiles = list(
		list("max_dist" = 50, "sound" = "sound/weather/lightning_strike_close.ogg", "volume" = 90),
		list("max_dist" = 100, "sound" = "sound/weather/lightning_strike_mid.ogg", "volume" = 70),
		list("max_dist" = 1000, "sound" = "sound/weather/lightning_strike_far.ogg", "volume" = 60) // Increased max_dist and volume for better audibility across large maps and Z-levels
	)

/datum/weather/effect/lightning_strike/New()
	..()

/datum/weather/effect/lightning_strike/apply_to_mobs(list/mobs_to_affect)
	if(!mobs_to_affect)
		return

	for(var/mob/living/L in mobs_to_affect)
		apply_single_mob_lightning_effect(L, CLOTHING_LIGHTNINGPROOF)

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
	if(ishuman(L))
		var/mob/living/carbon/human/human_target = L
		human_target.electrocution_animation(LIGHTNING_BOLT_ELECTROCUTION_ANIMATION_LENGTH)

/datum/weather/effect/lightning_strike/proc/process_lightning_struck_objects(list/objects_list)
	if(!objects_list)
		return

	for(var/obj/O in objects_list)
		if(O.resistance_flags & FLAMMABLE)
			ignite_object(O)
		if(istype(O, /obj/machinery))
			short_machine(O)

/datum/weather/effect/lightning_strike/apply_global_effect()

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
	if(istype(T, /turf/open/openspace)) // Do not strike open space.
		return FALSE
	// Ensure turf's Z-level is relevant for weather coverage, which implies it's a "weather active z"
	if(!(T.z in SSweather.relevant_z_levels_for_coverage))
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
	var/obj/structure/cable/C = locate(/obj/structure/cable) in T
	if(C)
		C.add_avail(rand(400000, 800000)) //Charge the cable with a random amount of power, between 400k and 800k.
		T.visible_message(span_warning("The power cable on [T] sparks and crackles with energy as the lightning strikes!"))

		if(prob(70)) //70% chance to overload and destroy the cable.
			T.visible_message(src, span_warning("The power cable violently explodes into a charred mess!"))
			new /obj/effect/decal/cleanable/burnt_wire(T)
			qdel(C) //Delete the cable, since it has exploded.
			playsound(T, 'sound/effects/explosion3.ogg', rand(30, 50), TRUE)

	var/list/objects_on_turf = list()
	for(var/atom/A in T)
		if(istype(A, /obj))
			objects_on_turf += A
	for(var/obj/O in objects_on_turf)
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

	// Lightning visual effect
	var/obj/effect/temp_visual/thunderbolt/lightning_visual = new(T)
	lightning_visual.pixel_x = rand(-16, 16) // Random offset for visual variety
	lightning_visual.pixel_y = rand(-16, 16)

	// Brief light flash at the strike location
	T.set_light(l_power = 100, l_color = "#ffffffe8", l_outer_range = 5, l_falloff_curve = 2, l_inner_range = 1) // Dynamic light for lightning flash
	addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, set_light), 0, null, null, null, FALSE), 6)

	// Add a scorch mark/burnt decal to the struck turf
	new /obj/effect/mapping_helpers/burnt_floor(T)

	// Attempt to charge power receptors on the turf
	charge_power_receptor(T)

	// Add a small chance for an explosion on the struck turf
	if(prob(15)) // 15% chance for an explosion
		explosion(T, 0, 0, 0) // Smallest possible explosion
		T.visible_message(span_warning("The ground violently explodes as lightning strikes it!"))
		message_admins(span_adminnotice("Weather Subsystem: Lightning strike caused a turf explosion at [T]!"))

	var/list/already_heard = list() //List of players who have already heard the sound, so we don't spam them.

	// Iterate through Z-levels downwards from the strike turf's Z-level
	for(var/current_z = T.z to 1 step -1) // From strike Z-level down to 1
		var/z_level_offset = T.z - current_z
		// Check for obstructions between T.z and current_z
		var/is_obstructed = FALSE
		for(var/z_check = T.z to current_z + 1 step -1) // Check turfs from T.z down to current_z + 1
			var/turf/turf_above_current = locate(T.x, T.y, z_check)
			if(turf_above_current && turf_above_current.blocks_weather) // If there's a blocking turf above, it's obstructed
				is_obstructed = TRUE
				break
		if(is_obstructed)
			continue // Skip this Z-level if obstructed

		for(var/client/C in GLOB.clients)
			var/mob/M = C.mob
			if(!M || (M in already_heard) || M.z != current_z)
				continue

			play_lightning_sound_for_mob(M, T, z_level_offset)
			already_heard += M

// New helper proc for playing lightning sound for a mob, considering Z-level offset
/datum/weather/effect/lightning_strike/proc/play_lightning_sound_for_mob(mob/M, turf/strike_turf, z_level_offset)
	// z_level_offset is the difference in Z-levels between the strike and the mob's Z-level.
	// 0 means same Z-level, 1 means mob is one Z-level below, etc.

	var/effective_dist = get_dist(strike_turf, M) // Horizontal distance
	effective_dist += z_level_offset * 10 // Add a penalty for vertical distance, e.g., 10 tiles per Z-level


	for(var/profile_map in sound_profiles)
		if(effective_dist <= profile_map["max_dist"])
			var/mob_turf = get_turf(M)
			if(!mob_turf) continue

			if(effective_dist <= 5) // Close: Play immediately
				playsound(mob_turf, profile_map["sound"], profile_map["volume"], TRUE)
			else // Mid/Far: Delay for realism
				var/pitch = rand(90, 110) / 100
				var/delay = effective_dist * 3 // Calculate delay based on distance
				addtimer(CALLBACK(null, PROC_REF(playsound), list(mob_turf, profile_map["sound"], profile_map["volume"], TRUE, 44100 * pitch)), delay)
			break // Found a match, stop checking profiles

/datum/weather/effect/electrified_reagents
	name = "Electrified Reagents"
	var/turf/affected_turf
	var/list/affected_mobs = list() // To prevent re-electrocution of the same mob repeatedly
	var/reagent_tick_interval = 10 // Shock every 1 second (10 deciseconds)
	var/shocks_processed = 0 // Counter for how many times process_shocks has run
	var/max_shocks = 10 // Maximum number of shocks before the effect ends as a failsafe

/datum/weather/effect/electrified_reagents/New(turf/T)
	..()
	affected_turf = T
	RegisterSignal(affected_turf, COMSIG_ATOM_ENTERED, PROC_REF(on_atom_entered))
	RegisterSignal(affected_turf, COMSIG_ATOM_EXITED, PROC_REF(on_atom_exited))

/datum/weather/effect/electrified_reagents/proc/start_effect()
	max_shocks = duration / reagent_tick_interval // Calculate max shocks based on duration and tick interval
	shocks_processed = 0 // Reset counter when effect starts
	addtimer(CALLBACK(src, PROC_REF(end_effect)), duration)
	addtimer(CALLBACK(src, PROC_REF(process_shocks)), reagent_tick_interval) // Start periodic shocking

/datum/weather/effect/electrified_reagents/proc/end_effect()
	// When the effect ends, we need to ensure any pending process_shocks timers are stopped.
	// Since process_shocks re-adds itself, we need to explicitly deltimer it.
	deltimer(CALLBACK(src, PROC_REF(process_shocks)))
	UnregisterSignal(affected_turf, COMSIG_ATOM_ENTERED)
	UnregisterSignal(affected_turf, COMSIG_ATOM_EXITED)
	qdel(src)

/datum/weather/effect/electrified_reagents/proc/process_shocks()
	shocks_processed++ // Increment the counter

	if(!affected_turf || !affected_turf.reagents || affected_turf.reagents.total_volume == 0 || shocks_processed >= max_shocks)
		end_effect() // No reagents left, or max shocks reached, end the effect
		return

	for(var/mob/living/L in affected_turf.contents)
		if(L.loc == affected_turf) // Ensure mob is directly on the turf
			L.electrocute_act(rand(5, 15) * severity, L, 0.2) // Weaker shock for continuous effect
			L.visible_message(span_warning("The electrified reagents on [affected_turf] shock [L.name]!"))
			to_chat(L, span_warning("You feel a continuous jolt from the electrified reagents!"))
			L.Stun(1, TRUE)
			ADD_TRAIT(L, TRAIT_BLURRY_VISION, "weather_lightning_liquid_continuous")
			addtimer(CALLBACK(L, GLOBAL_PROC_REF(___TraitRemove), L, TRAIT_BLURRY_VISION, "weather_lightning_liquid_continuous"), reagent_tick_interval)

	// Re-add the timer for the next shock
	addtimer(CALLBACK(src, PROC_REF(process_shocks)), reagent_tick_interval)

/datum/weather/effect/electrified_reagents/proc/on_atom_entered(atom/source, atom/movable/arrived, atom/old_loc, list/old_locs)
	if(istype(arrived, /mob/living/))
		var/mob/living/L = arrived
		if(L.loc == affected_turf && !(L in affected_mobs)) // Ensure mob is on the turf and not already affected
			affected_mobs += L // Add to affected list to be shocked by process_shocks

/datum/weather/effect/electrified_reagents/proc/on_atom_exited(atom/source, atom/movable/gone, direction)
	if(istype(gone, /mob/living/))
		var/mob/living/L = gone
		if(L in affected_mobs)
			affected_mobs -= L // Remove from affected list when mob leaves the turf

/*--- Fog Effect ---
	  _
	 / \
	/ _ \
   | (_) |
   \ ___ /
	 `-'
*/

/datum/weather/effect/fog
	name = "Dense Fog"
	desc = "A thick, swirling fog that reduces visibility."
	affects_areas = TRUE // This effect now manages area overlays
	affects_mobs = TRUE
	tick_interval = 10 // Every 1 second
	cooldown_max = 0 // Continuous effect, no cooldown
	needs_overlay_cleanup = TRUE // This effect manages its own visual overlays
	var/list/active_visual_overlays = list() // To store the overlays created by this effect

/datum/weather/effect/fog/apply_global_effect()
	var/datum/weather/current_storm
	if(SSweather.processing.len)
		current_storm = SSweather.processing[1] // Get the current active storm
	if(!current_storm || !current_storm.impacted_z_levels || !current_storm.impacted_z_levels.len)
		cleanup_visual_overlays() // If no storm or no impacted levels, clean up
		return

	// Only apply overlays if they haven't been applied yet for this storm
	if(!active_visual_overlays.len)
		var/icon/fog_icon = 'icons/obj/watercloset.dmi'
		var/icon_state_name = "mist"
		var/overlay_color = "#A0A0A0" // Light grey

		for(var/z_level in current_storm.impacted_z_levels)
			var/list/z_chunk_keys = SSweather.weather_chunking.get_all_turf_chunk_keys_on_z(z_level)
			if(!z_chunk_keys || !z_chunk_keys.len)
				continue

			var/list/exposed_turfs_on_z = SSweather.weather_chunking.get_turfs_in_chunks(z_chunk_keys)
			for(var/turf/T in exposed_turfs_on_z)
				if(!isturf(T))
					continue

				var/mutable_appearance/fog_overlay = mutable_appearance(fog_icon, icon_state_name, AREA_LAYER, ABOVE_LIGHTING_PLANE, 100)
				fog_overlay.color = overlay_color
				T.overlays += fog_overlay
				active_visual_overlays += fog_overlay // Store reference to remove later

/datum/weather/effect/fog/apply_to_mobs(list/mobs_to_affect)
	// Fog is a continuous effect, so we don't use the cooldown for application frequency
	// The tick_interval handles how often this proc is called by the subsystem.

	for(var/mob/living/L in mobs_to_affect)
		if(!L || !can_weather_act(L)) // Check if mob is valid and exposed
			continue

		if(apply_effect(L, null, CLOTHING_FOGPROOF)) // Check for fog protection
			continue

		// Apply vision impairment based on severity
		var/vision_trait_duration = 3 // Short duration, reapplied every tick_interval
		switch(severity)
			if(1) // Light fog
				ADD_TRAIT(L, TRAIT_BLURRY_VISION, "weather_fog_light")
				addtimer(CALLBACK(L, GLOBAL_PROC_REF(___TraitRemove), L, TRAIT_BLURRY_VISION, "weather_fog_light"), vision_trait_duration)
				to_chat(L, span_notice("The fog makes it hard to see clearly."))
			if(2) // Moderate fog
				ADD_TRAIT(L, TRAIT_BLURRY_VISION, "weather_fog_moderate")
				addtimer(CALLBACK(L, GLOBAL_PROC_REF(___TraitRemove), L, TRAIT_BLURRY_VISION, "weather_fog_moderate"), vision_trait_duration)
				to_chat(L, span_warning("The dense fog significantly reduces your visibility."))
			if(3) // Severe fog
				ADD_TRAIT(L, TRAIT_BLURRY_VISION, "weather_fog_severe")
				addtimer(CALLBACK(L, GLOBAL_PROC_REF(___TraitRemove), L, TRAIT_BLURRY_VISION, "weather_fog_severe"), vision_trait_duration)
				to_chat(L, span_userdanger("You can barely see through the oppressive fog!"))

/datum/weather/effect/fog/cleanup_visual_overlays()
	// Get the current storm to access impacted_z_levels for cleanup
	var/datum/weather/current_storm
	if(SSweather.processing.len)
		current_storm = SSweather.processing[1]

	if(!current_storm || !current_storm.impacted_z_levels || !current_storm.impacted_z_levels.len)
		// If no storm or no impacted levels, try to clean up from all known chunks
		var/list/all_chunk_keys = SSweather.weather_chunking.get_all_turf_chunk_keys()
		for(var/key in all_chunk_keys)
			var/list/turfs = SSweather.weather_chunking.get_turfs_in_chunks(list(key))
			for(var/turf/T in turfs)
				if(!isturf(T))
					continue
				T.overlays -= active_visual_overlays
	else
		for(var/z_level in current_storm.impacted_z_levels)
			var/list/z_chunk_keys = SSweather.weather_chunking.get_all_turf_chunk_keys_on_z(z_level)
			if(!z_chunk_keys || !z_chunk_keys.len)
				continue

			var/list/exposed_turfs_on_z = SSweather.weather_chunking.get_turfs_in_chunks(z_chunk_keys)
			for(var/turf/T in exposed_turfs_on_z)
				if(!isturf(T))
					continue
				T.overlays -= active_visual_overlays
	active_visual_overlays.Cut() // Clear the list


/// --- Admin Utilities --- For both testing/debugging and the... Other Things... admins get up to..

/client/proc/toggle_weather_debug_admin_verbs()
	set name = "Toggle Weather Debug Admin Verbs"
	set category = "Debug"
	set desc = "Toggles the visibility of weather debug admin verbs."

	if(!check_rights(R_DEBUG))
		return

	if(src.weather_debug_verbs_enabled)
		remove_verb(src, GLOB.admin_verbs_debug_weather)
		src.weather_debug_verbs_enabled = FALSE
		to_chat(src, span_interface("Weather debug verbs are now hidden."), confidential = TRUE)
	else
		add_verb(src, GLOB.admin_verbs_debug_weather)
		src.weather_debug_verbs_enabled = TRUE
		to_chat(src, span_interface("Weather debug verbs are now visible."), confidential = TRUE)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Weather Debug Verbs")

/client/proc/debug_all_weather_effects()
	set name = "Enable All Weather Effects"
	set category = "Weather Debugging"
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
	set category = "Weather Debugging"
	set name = "Test Lightning Strike"
	set desc = "Manually triggers a lightning strike at a random eligible turf, or near the user."

	if(!check_rights(R_DEBUG))
		return

	if(!SSweather)
		to_chat(usr, span_warning("Weather subsystem not found."), confidential = TRUE)
		return

	if(!SSweather.initial_coverage_processing_complete)
		to_chat(usr, span_warning("Weather system is still initializing turf coverage. Please wait a moment and try again."), confidential = TRUE)
		message_admins(span_adminnotice("DEBUG: lightning_strike_test verb called by [usr.key] but weather coverage not complete."))
		return

	message_admins(span_adminnotice("DEBUG: lightning_strike_test verb called by [usr.key]"))
	to_chat(usr, "DEBUG: Manually triggering lightning strike.")

	var/datum/weather/effect/lightning_strike/L = new
	var/turf/target_turf = null
	var/force_near_user = input("Force strike near your current location?", "Lightning Strike Target") as null|anything in list("Yes", "No")

	to_chat(usr, "DEBUG: Turf Chunks Keys: [length(SSweather.weather_chunking.get_all_turf_chunk_keys())]")
	var/list/all_exposed_turfs = SSweather.weather_chunking.get_turfs_in_chunks(SSweather.weather_chunking.get_all_turf_chunk_keys())
	var/list/eligible_strike_candidates = list()

	if(force_near_user == "Yes")
		target_turf = get_turf(usr)
		if(!L.is_valid_lightning_target(target_turf))
			to_chat(usr, span_warning("Your current turf is not a valid lightning target. Falling back to random eligible turf."))
			target_turf = null // Reset to null to allow random selection below

	if(!target_turf) // If not forced near user, or user's turf was invalid
		if(all_exposed_turfs.len > 0)
			for(var/turf/T in all_exposed_turfs)
				if(L.is_valid_lightning_target(T))
					eligible_strike_candidates += T

		if(eligible_strike_candidates.len > 0)
			target_turf = pick(eligible_strike_candidates)
		else
			target_turf = get_turf(usr) // Fallback to user's turf if no eligible turfs found at all

	if(target_turf)
		L.strike_turf(target_turf)
		to_chat(usr, "Lightning strike triggered at [target_turf].")
		message_admins(span_adminnotice("DEBUG: Lightning strike triggered by [usr.key] at [target_turf] ([target_turf.x],[target_turf.y],[target_turf.z]). <A HREF='?_src_=holder;_authorize=1;admin_jump_to=[target_turf.x],[target_turf.y],[target_turf.z]'>Jump to</A>"))
	else
		to_chat(usr, "Could not determine a valid turf to strike.")
		message_admins(span_adminnotice("DEBUG: Could not determine a valid turf to strike for lightning strike test."))

	qdel(L)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Test Lightning Strike")

/datum/weather/effect/lightning_strike/proc/electrocute_in_liquid(turf/T)
	if(!T)
		return

	if(T.reagents && T.reagents.total_volume > 0)
		var/list/turf_contents = list()
		for(var/atom/A in T)
			if(istype(A, /mob/living))
				turf_contents += A
		for(var/mob/living/L in turf_contents)
			if(L.loc == T) // Ensure mob is directly on the turf
				// Apply electrocution effect to mob
				L.electrocute_act(rand(10, 30) * severity, L, 0.5) // Electrocute with some damage and a chance to stun
				L.visible_message(span_warning("A jolt of lightning strikes the spilled reagents around [L.name], electrocuting them and the liquid!"))
				to_chat(L, span_warning("You feel an intense shock as the spilled reagents around you become electrified!"))
				L.Stun(2, TRUE)
				ADD_TRAIT(L, TRAIT_BLURRY_VISION, "weather_lightning_liquid")
				addtimer(CALLBACK(L, GLOBAL_PROC_REF(___TraitRemove), L, TRAIT_BLURRY_VISION, "weather_lightning_liquid"), 2)

		// Electrocute the reagents themselves (e.g., evaporate some of it, or cause a visual effect)
		T.visible_message(span_warning("The spilled reagents on [T] crackle with electricity!"))
		if(prob(25)) // 25% chance to remove some of the reagents
			T.reagents.remove_all(0.25, relative = TRUE) // Remove 25% of the total volume proportionally

		// Apply a lasting electric effect to the reagents
		var/datum/weather/effect/electrified_reagents/E = new(T)
		E.duration = rand(300, 600) // Lasts 30 to 60 seconds
		E.severity = src.severity // Inherit severity from the lightning strike
		E.start_effect()
