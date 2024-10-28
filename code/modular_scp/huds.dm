//Blink HUD for 173.
/proc/process_blink_hud(mob/M, mob/Alt)
	if(!can_process_hud(M))
		return

	if(isscp173(M)) //Only 173 should have a blink HUD (Also this is neccesary for maintaing the blink HUD while caged)
		var/mob/living/scp173/S = M
		var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt)
		for(var/mob/living/carbon/human/victim in dview(7, istype(S.loc, /obj/structure/scp173_cage) ? S.loc : S))
			if(victim.stat) //The unconscious cant blink, and therefore do not need to be added to the blink HUD
				continue
			P.Client.images += victim.hud_list[BLINK_HUD]

//Pestilence Hud for 049.
/proc/process_pestilence_hud(mob/M, mob/Alt)
	if(!can_process_hud(M))
		return

	if(isscp049(M) || isspecies(M, SPECIES_SCP049_1))
		var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt)
		for(var/mob/living/carbon/human/H in view(world.view, M))
			if(H.humanStageHandler.getStage("Pestilence"))
				P.Client.images += H.hud_list[PESTILENCE_HUD]
/datum/arranged_hud_process
	var/client/Client
	var/mob/Mob
	var/turf/Turf


/proc/arrange_hud_process(mob/M, mob/Alt, list/hud_list)
	if(hud_list)
		hud_list |= M
	var/datum/arranged_hud_process/P = new
	P.Client = M.client
	P.Mob = Alt ? Alt : M
	P.Turf = get_turf(P.Mob)
	return P

// SCRAMBLE gear.
/proc/process_scramble_hud(mob/M, mob/Alt)
	if(!can_process_hud(M))
		return

	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, GLOB.scramble_hud_users)
	// The only things that will have scramble hud, or so we assume
	// is SCP-096 (or, if admin shenanigans were happening, SCP-096s)
	/*
	for(var/mob/living/scp096/shylad in P.Mob.in_view(P.Turf))
		P.Client.images += new /image/hud_overlay('icons/SCP/hud_scramble.dmi', shylad, "scramble-alive")
	*/
/proc/can_process_hud(mob/M)
	if(!M)
		return 0
	if(!M.client)
		return 0
	if(M.stat != CONSCIOUS)
		return 0
	return 1

/mob/proc/in_view(turf/T) //this is kind of stupid - dark
	return view(T)
