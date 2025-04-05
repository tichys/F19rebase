/mob/living/carbon/human/scp343
	name = "strange elderly man"
	desc = "A mysterious powerful man. He looks a lot like what you would imagine god to look like."
	icon = 'icons/SCP/scp-343.dmi'
	icon_state = null

	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7

	status_flags = CANPUSH|GODMODE

	//Config

	///Cooldown for our phasing wall ability
	var/phase_cooldown = 5 SECONDS
	///How long it takes us to phase
	var/phase_time = 2 SECONDS
	///What alpha level are we when we are invisible
	var/phase_alpha = 115
	///Move speed when we are phased out
	var/phased_move_delay = 1.0

	//Mechanical

	///Cooldow tracker for our phasing wall ability
	var/phase_cooldown_track
	///Set Alpha (to know what to phase back to)
	var/set_alpha

/mob/living/carbon/human/scp343/Initialize(mapload, new_species = "SCP-343")
	. = ..()
	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"strange elderly man", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_SAFE, //Obj Class
		"343", //Numerical Designation
		SCP_PLAYABLE|SCP_ROLEPLAY
	)

	add_verb(src, /mob/living/carbon/human/scp343/verb/object_phase)

//Mechanics

/mob/living/carbon/human/scp343/verb/object_phase()
	set name = "Phase Through Object"
	set category = "SCP"
	set desc = "Phase through an object in front of you."

	if((world.time - phase_cooldown_track) < phase_cooldown)
		to_chat(src, SPAN_WARNING("You can't phase again yet."))
		return

	var/obj/target_object = null
	for(var/obj/O in get_step(src, dir))
		// Things that we will ignore
		if(!isstructure(O) && !ismachinery(O))
			continue

		if(!O.density)
			continue

		// Things that will block our phasing
		if(istype(O, /obj/machinery/shieldwall))
			to_chat(src, SPAN_WARNING("You cannot phase through [O]."))
			return

		// There can be more than one available dense object, but that doesn't matter
		target_object = O

	if(!istype(target_object))
		to_chat(src, SPAN_WARNING("There's nothing to phase through in that direction."))
		return

	var/turf/target_turf = get_step(target_object, dir)
	if(target_turf.density)
		to_chat(src, SPAN_WARNING("\The [target_turf] is preventing us from phasing in that direction."))
		return

	phase_cooldown_track = world.time

	// Mob effects
	var/old_layer = layer
	var/anim_x = 0
	var/anim_y = 0
	layer = GHOST_PLANE
	alpha = phase_alpha

	if(dir in list(NORTH, NORTHEAST, NORTHWEST))
		anim_y = 32
	if(dir in list(SOUTH, SOUTHEAST, SOUTHWEST))
		anim_y = -32
	if(dir in list(EAST, NORTHEAST, SOUTHEAST))
		anim_x = 32
	if(dir in list(WEST, NORTHWEST, SOUTHWEST))
		anim_x = -32
	animate(src, pixel_x = anim_x, pixel_y = anim_y, time = phase_time)

	if(do_after(src, phase_time, target_object))
		forceMove(get_step(src, dir))
		visible_message(SPAN_NOTICE("[src] silently phases through [target_object]"))

	layer = old_layer
	pixel_x = 0
	pixel_y = 0
	alpha = set_alpha

//TODO : Phase out obsolete proc
/mob/living/carbon/human/scp343/proc/on_update_icon()
	if(resting)
		var/matrix/M =  matrix()
		transform = M.Turn(90)
	else
		transform = null
	return
