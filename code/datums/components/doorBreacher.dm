/*
* 	This component allows living mobs to force open doors in a more arcadey way rather than just destroying the door.
*/
/datum/component/doorBreacher
	/// Door force open cooldown
	var/doorCooldown
	/// Door cooldown tracker
	COOLDOWN_DECLARE(door_cooldown_track)
	/// Doors we are allowed to open, assoc list (door type = time to open). If a door type isint present, but its parent type is, the parent type will be referenced. Because of typing and this being processed in order, you should always put subtypes before parent types.
	var/list/doorList
	/// Blacklist for doors we cannot open under any condition, should be an assoc list where (door type = true)
	var/list/blackList
	/// Time added on if welded
	var/weldedTime
	/// Time added on if bolted
	var/lockedTime
	/// Time added if secured (only for airlock doors) (time is added per level of security)
	var/secureTime
	/// Do we require the door to be broken to force? If just true or false, will be true or false for all doors. If a list where doortype = TRUE or FALSE, requirement will be per door
	var/reqBroken
	/// Do we avoid sending msg's about the door breaking?
	var/silent
	/// Are we currently handeling a door?
	var/inProgress
	/// Should we only do one door at a time?
	var/oneAtATime

/datum/component/doorBreacher/Initialize(_doorCooldown, _doorList, _weldedTime, _lockedTime, _secureTime, _blackList = list(), _reqBroken = FALSE, _oneAtATime = TRUE, _silent = FALSE)
	if(!isliving(parent))
		CRASH("Attempted to initilize doorBreacher component on an non-living entity!")
	doorCooldown = _doorCooldown
	doorList = _doorList
	weldedTime = _weldedTime
	lockedTime = _lockedTime
	secureTime = _secureTime
	reqBroken = _reqBroken
	oneAtATime = _oneAtATime
	silent = _silent
	blackList = _blackList

/datum/component/doorBreacher/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(handleDoor))

/datum/component/doorBreacher/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_LIVING_UNARMED_ATTACK)

/datum/component/doorBreacher/proc/handleDoor(mob/living/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER
	if(!istype(target, /obj/machinery/door))
		return
	if(!target.density)
		return
	if(!proximity)
		return
	if(inProgress && oneAtATime)
		return
	var/obj/machinery/door/D = target
	if(D.allowed(source))
		return

	INVOKE_ASYNC(src, PROC_REF(forceDoor), source, target)

/datum/component/doorBreacher/proc/forceDoor(mob/living/source, obj/machinery/door/doorTarget)
	var/baseTime = -1
	for(var/curDoorType in doorList)
		if(!istype(doorTarget, curDoorType))
			continue
		baseTime = doorList[curDoorType]
		break

	if(baseTime == -1 || is_type_in_list(doorTarget, blackList))
		return

	if(!islist(reqBroken) && reqBroken && doorTarget.is_operational)
		to_chat(source, span_warning("The door must be inoperable for you to force it!"))
		return

	if(islist(reqBroken))
		var/list/reqBrokenList = reqBroken
		for(var/curDoorType in reqBrokenList)
			if(!istype(doorTarget, curDoorType))
				continue
			if(reqBrokenList[curDoorType] && doorTarget.is_operational)
				to_chat(source, span_warning("The door must be inoperable for you to force it!"))
				return
			break

	if(!COOLDOWN_FINISHED(src, door_cooldown_track))
		to_chat(source, span_warning("You cannot force a door again so soon!"))
		return

	inProgress = TRUE

	var/mob/living/parentLiving = parent;
	if(!istype(parentLiving))
		CRASH("DoorBreacher component has a non-living parent!")

	if(istype(doorTarget, /obj/machinery/door/airlock) && secureTime)
		var/obj/machinery/door/airlock/airlockTarget = doorTarget
		while(airlockTarget.is_secure())
			if(!silent)
				parentLiving.visible_message(span_danger("\The [parent] starts slicing through the security shielding on \the [airlockTarget]!"), span_notice("You start to slice through a level of the security shielding on \the [airlockTarget]."))
			if(!do_after(parent, airlockTarget, secureTime))
				inProgress = FALSE
				return
			if(!silent)
				parentLiving.visible_message(span_danger("\The [parent] slices through the security shielding on \the [airlockTarget]!"), span_notice("You slice through a level of the security shielding on \the [airlockTarget]."))
			airlockTarget.security_level--
			airlockTarget.spark_system.start()

	if(doorTarget.welded)
		if(!silent)
			parentLiving.visible_message(span_danger("\The [parent] begins to rip through the welding on \the [doorTarget]!"), span_notice("You begin to remove the welding on \the [doorTarget]."))
		if(weldedTime && !do_after(parent, doorTarget, weldedTime))
			inProgress = FALSE
			return
		if(!silent)
			parentLiving.visible_message(span_danger("\The [parent] rips through the welding on \the [doorTarget]!"), span_notice("You remove the welding on \the [doorTarget]."))
		doorTarget.welded = FALSE
		doorTarget.update_overlays()

	if(doorTarget.locked)
		if(!silent)
			parentLiving.visible_message(span_danger("\The [parent] begins to force the bolts on \the [doorTarget]!"), span_notice("You begin to force the bolts on \the [doorTarget]."))
		if(lockedTime && !do_after(parent, doorTarget, lockedTime))
			inProgress = FALSE
			return
		if(!silent)
			parentLiving.visible_message(span_danger("\The [parent] forces the bolts on \the [doorTarget]!"), span_notice("You force the bolts on \the [doorTarget]."))
		doorTarget.unlock()

	if(!silent)
		parentLiving.visible_message(span_danger("\The [parent] begins to force open \the [doorTarget]!"), span_notice("You begin to force open \the [doorTarget]."))

	if(baseTime && !do_after(parent, doorTarget, baseTime))
		inProgress = FALSE
		return
	if(istype(doorTarget, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlockTarget = doorTarget
		airlockTarget.open(2)
	else
		doorTarget.open()

	if(!(doorTarget.machine_stat & BROKEN))
		doorTarget.take_damage((1 - doorTarget.integrity_failure) * doorTarget.max_integrity, 0, BRUTE, 0, 0) //guaranteed to break the door properly, as just calling atom_break might lead to werid behavior

	if(!silent)
		parentLiving.visible_message(span_danger("\The [parent] forces open \the [doorTarget]!"), span_notice("You force open \the [doorTarget]."))

	inProgress = FALSE

	COOLDOWN_START(src, door_cooldown_track, doorCooldown)
