#define ANTAG_SCP049_1 "SCP-049-1"

/datum/species/scp049_1
	name = "SCP-049-1"
	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1
	var/heal_rate = 1 // Regen.
	var/mob/living/carbon/human/target = null
	var/list/obstacles = list(
		/obj/structure/window,
		/obj/structure/closet,
		/obj/machinery/door/airlock,
		/obj/structure/table,
		/obj/structure/grille,
		/obj/structure/barricade,
		/obj/structure/railing,
		/obj/structure/girder,
		/obj/machinery/door
	)

/datum/species/scp049_1/handle_post_spawn(mob/living/carbon/human/H)
	H.istate = INTENT_HARM
	H.resting = 0
	H.stat = CONSCIOUS

	if (H.head)
		H.drop_from_inventory(H.head, get_turf(H)) //Remove helmet so headshots aren't impossible
	..()

/datum/species/scp049_1/handle_environment(mob/living/carbon/human/H)
	if (H.stat == CONSCIOUS)
		if (prob(5))
			playsound(H.loc, 'sound/hallucinations/far_noise.ogg', 15, 1)
		else if (prob(5))
			playsound(H.loc, 'sound/hallucinations/veryfar_noise.ogg', 15, 1)
		else if (prob(5))
			playsound(H.loc, 'sound/hallucinations/wail.ogg', 15, 1)

	for(var/obj/item/organ/I in H.organs)
		if (I.damage > 0)
			I.damage = max(I.damage - heal_rate, 0)


	if (H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
		H.adjustBruteLoss(-heal_rate)
		H.adjustFireLoss(-heal_rate)
		H.adjustOxyLoss(-heal_rate)
		H.adjustToxLoss(-heal_rate)
		return TRUE

	process_pestilence_hud(H)

/datum/species/scp049_1/proc/handle_npc(mob/living/carbon/human/H)
	H.resting = FALSE

	if (prob(5))
		H.custom_emote("wails!")
	else if (prob(5))
		H.custom_emote("groans!")
	if (H.resist_restraints() && prob(8))
		H.custom_emote("thrashes and writhes!")

	if (H.resting)
		walk(H, 0)
		return

	if (H.resist_restraints() || H.buckled)
		H.resist()
		return

	addtimer(CALLBACK(src, PROC_REF(handle_action), H), rand(10, 20))

/datum/species/scp049_1/proc/handle_action(mob/living/carbon/human/H)
	var/dist = 128
	for(var/mob/living/M in hearers(H, 15))
		if ((ishuman(M)) && !isspecies(M, SPECIES_SCP049_1) && !isscp049(M)) //Don't attack fellow zombies, or diona
			if (M.stat == DEAD && target)
				continue //Only eat corpses when no living (and able) targets are around
			var/D = get_dist(M, H)
			if (D <= dist * 0.5) //Must be significantly closer to change targets
				target = M //For closest target
				dist = D
				H.setClickCooldown(CLICK_CD_ATTACK*2)
	if (target)
		if (isspecies(target, SPECIES_SCP049_1))
			target = null
			return

		if (!H.Adjacent(target))
			var/turf/dir = get_step_towards(H, target)
			for(var/type in obstacles) //Break obstacles
				var/obj/obstacle = locate(type) in dir
				if (obstacle)
					H.face_atom(obstacle)
					obstacle.attack_generic(H, 10, "smashes")
					break

			step_towards(H, target.loc)
		else
			H.face_atom(target)

			if (!H.zone_selected)
				H.zone_selected = new /atom/movable/screen/zone_sel(null)
			H.zone_selected= BODY_ZONE_CHEST
			target.attack_hand(H)

		for(var/mob/living/M in hearers(H, 15))
			if (target == M) //If our target is still nearby
				return
		target = null //Target lost
/*
/datum/unarmed_attack/bite/sharp/scp049_1
	attack_verb = list("slashed", "sunk their teeth into", "bit", "mauled")
	damage = 3

/datum/unarmed_attack/bite/sharp/scp049_1/is_usable(mob/living/carbon/human/user, mob/living/carbon/human/target, zone)
	. = ..()
	if(!.)
		return FALSE
	if(isspecies(target, SPECIES_SCP049_1))
		to_chat(usr, SPAN_WARNING("They don't look very appetizing!"))
		return FALSE
	if(!target.humanStageHandler.getStage("Pestilence"))
		to_chat(usr, SPAN_WARNING("They are free from the pestilence!"))
		return FALSE
	return TRUE
*/
