//handles anything that has memetic properties and needs to keep track of affected humans. Memetics are designed to work only on humans.
/datum/component/memetic
	///List of affected humans
	var/list/affected_mobs_weakref = list()
	///Memetic bitflags to determine what should be counted as affected
	var/memetic_flags
	///Proc to run on affected humans
	var/affected_proc
	///List of sounds that count as being memetic
	var/list/memetic_sounds

/datum/component/memetic/Initialize(flags, meme_proc, memeticSounds)
	. = ..()
	memetic_flags = flags
	affected_proc = meme_proc
	memetic_sounds = memeticSounds

/datum/component/memetic/Destroy(force, silent)
	. = ..()
	LAZYCLEARLIST(affected_mobs_weakref)

/datum/component/memetic/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_SOUND_HEARD, PROC_REF(heard_memetic))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(examined_memetic))
	// RegisterSignal(parent, COMSIG_PHOTO_SHOWN_OF, PROC_REF(saw_memetic_photo))
	// RegisterSignal(parent, COMSIG_ATOM_VIEW_RESET, PROC_REF(saw_through_camera))

/datum/component/memetic/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_ATOM_SOUND_HEARD,
		COMSIG_PARENT_EXAMINE
		// COMSIG_PHOTO_SHOWN_OF,
		// COMSIG_ATOM_VIEW_RESET
	))

/datum/component/memetic/proc/check_viewers() //I dont like doing this but since theres no way for us to send a signal upon something being viewed its neccesary
	var/list/mviewers = viewers(world.view, parent)

	for(var/mob/living/carbon/human/H in mviewers)
		saw_memetic(H)

/datum/component/memetic/proc/activate_memetic_effects()
	var/list/affected_mobs = recursive_list_resolve(affected_mobs_weakref)
	if(!(memetic_flags & MPERSISTENT)) //if we arent a persistent memetic, then affected humans will be removed from effect after they no longer meet the reqs
		for(var/mob/living/carbon/human/H in affected_mobs)
			if((memetic_flags & MVISUAL) && (H in viewers(parent)) && !(H.is_blind() || HAS_TRAIT(H, TRAIT_MEMETIC_BLIND))) //potentially port human memetics as this check is not nearly as extensive
				continue
			if((memetic_flags & MAUDIBLE) && H.can_hear() && !HAS_TRAIT(H, TRAIT_MEMETIC_DEAF))
				continue
			LAZYREMOVE(affected_mobs_weakref, WEAKREF(H))

	for(var/mob/living/carbon/human/H in affected_mobs)
		if(H.stat == DEAD)
			LAZYREMOVE(affected_mobs_weakref, WEAKREF(H))
			continue
		call(parent, affected_proc)(H)

/datum/component/memetic/proc/saw_memetic(datum/source)
	var/list/mob/affected_mobs = recursive_list_resolve(affected_mobs_weakref)
	if((!ishuman(source)) || (source in affected_mobs))
		return
	var/mob/living/carbon/human/H = source
	if((memetic_flags & MVISUAL) && (H in viewers(parent)) && !(H.is_blind() || HAS_TRAIT(H, TRAIT_MEMETIC_BLIND)))
		if(memetic_flags & MSYNCED)
			LAZYOR(affected_mobs_weakref, WEAKREF(H))
		else if(H.stat != DEAD)
			call(parent, affected_proc)(H)

/datum/component/memetic/proc/heard_memetic(datum/source, mob/hearer, sound)
	SIGNAL_HANDLER
	var/list/mob/affected_mobs = recursive_list_resolve(affected_mobs_weakref)
	if((!ishuman(hearer)) || (hearer in affected_mobs))
		return
	var/soundtext
	if(istype(sound, /sound))
		var/sound/Ssound = sound
		soundtext = Ssound.file
	else
		soundtext = sound
	if(LAZYLEN(memetic_sounds) && !(soundtext in memetic_sounds))
		return
	var/mob/living/carbon/human/H = hearer
	if((memetic_flags & MAUDIBLE) && H.can_hear() && !HAS_TRAIT(H, TRAIT_MEMETIC_DEAF))
		if(memetic_flags & MSYNCED)
			LAZYOR(affected_mobs_weakref, WEAKREF(H))
		else if(H.stat != DEAD)
			call(parent, affected_proc)(H)

/datum/component/memetic/proc/examined_memetic(datum/source, mob/user, list/examine_text)
	SIGNAL_HANDLER
	var/list/mob/affected_mobs = recursive_list_resolve(affected_mobs_weakref)
	if((!ishuman(user)) || (user in affected_mobs))
		return
	var/mob/living/carbon/human/H = user
	if(!(memetic_flags & MINSPECT) || !(H in viewers(parent)) || H.is_blind() || HAS_TRAIT(user, TRAIT_MEMETIC_BLIND))
		return
	if(memetic_flags & MSYNCED)
		LAZYOR(affected_mobs_weakref, WEAKREF(H))
	else if(H.stat != DEAD)
		call(parent, affected_proc)(H)

//These will be added once we port 096, otherwise no sense to mess with it right nows

// /datum/component/memetic/proc/saw_memetic_photo(datum/source, obj/item/photo/photo_shown, mob/target)
// 	SIGNAL_HANDLER
// 	var/list/mob/affected_mobs = recursive_list_resolve(affected_mobs_weakref)
// 	if((!ishuman(target)) || (target in affected_mobs))
// 		return
// 	var/mob/living/carbon/human/H = target
// 	if(!H.can_see(visual_memetic = TRUE))
// 		return
// 	if(memetic_flags & MPHOTO)
// 		if(memetic_flags & MSYNCED)
// 			LAZYOR(affected_mobs_weakref, WEAKREF(H))
// 		else if(H.stat != DEAD)
// 			call(parent, affected_proc)(H)

// /datum/component/memetic/proc/saw_through_camera(datum/source, mob/target, obj/machinery/camera/C)
// 	SIGNAL_HANDLER
// 	var/list/mob/affected_mobs = recursive_list_resolve(affected_mobs_weakref)
// 	if(!istype(C))
// 		return
// 	if((!ishuman(target)) || (target in affected_mobs))
// 		return
// 	var/mob/living/carbon/human/H = target
// 	if(!H.can_see(visual_memetic = TRUE))
// 		return
// 	if(memetic_flags & MCAMERA)
// 		if(memetic_flags & MSYNCED)
// 			LAZYOR(affected_mobs_weakref, WEAKREF(H))
// 		else if(H.stat != DEAD)
// 			call(parent, affected_proc)(H)
