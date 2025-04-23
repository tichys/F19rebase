/mob/living/carbon/human/scp049
	name = "\improper plague doctor"
	desc = "A mysterious plague doctor."
	icon = 'icons/SCP/scp-049.dmi'

	//Config

	/// Emote cooldown
	var/emote_cooldown = 5 SECONDS
	/// Base regen
	var/base_regen = 0.05
	/// How much our regen does each instance of SCP-049-1 add
	var/regen_multiply = 1.5
	/// Heal cooldown
	var/heal_cooldown = 2 SECONDS
	/// How much time should pass without interactions to be able to get up and leave
	var/patience_limit = 15 MINUTES

	// Mechanical

	/// Amount of zombies we achieved so far
	var/cured_count = 0
	/// The area we spawned in
	var/area/home_area = null
	/// Emote cooldown tracker
	COOLDOWN_DECLARE(emote)
	/// Heal cooldown tracker
	COOLDOWN_DECLARE(heal)
	///our breach timer, if it ever hits zero we breach
	var/breach_timer

/mob/living/carbon/human/scp049/Initialize(mapload)
	. = ..()

	set_species(/datum/species/scp049) //if ever setting species, species MUST be set BEFORE creating the SCP datum, otherwise the names will not work as the head will get regenerated
	gender = MALE //human init randomizes gender

	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"\improper plague doctor", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_EUCLID, //Obj Class
		"049", //Numerical Designation
		SCP_PLAYABLE|SCP_ROLEPLAY
	)

	SCP.min_time = 10 MINUTES
	SCP.min_playercount = 15 //mostly a RP scp, cant escape as soon as they spawn in

	add_verb(src, list(
		/mob/living/carbon/human/scp049/verb/Greetings,
		/mob/living/carbon/human/scp049/verb/YetAnotherVictim,
		/mob/living/carbon/human/scp049/verb/YouAreNotDoctor,
		/mob/living/carbon/human/scp049/verb/SenseDiseaseInYou,
		/mob/living/carbon/human/scp049/verb/HereToCureYou,
	))

	home_area = get_area(src)

	RegisterSignal(src, COMSIG_MOVABLE_HEAR, PROC_REF(onHear))
	RegisterSignal(src, COMSIG_MOB_LOGIN, PROC_REF(announceJoin))
	RegisterSignal(home_area, COMSIG_AREA_ENTERED, PROC_REF(handleContainment))
	RegisterSignal(home_area, COMSIG_AREA_EXITED, PROC_REF(handleEscape))

	// grant_language(LANGUAGE_PLAGUESPEAK_GLOBAL)

	var/datum/atom_hud/data/human/pestilence/pHud = GLOB.huds[DATA_HUD_PESTILENCE]
	pHud.show_to(src)

/mob/living/carbon/human/scp049/Destroy()
	QDEL_NULL(SCP)
	UnregisterSignal(src, list(COMSIG_MOVABLE_HEAR, COMSIG_MOB_LOGIN))
	UnregisterSignal(home_area, list(COMSIG_AREA_ENTERED, COMSIG_AREA_EXITED))
	return ..()

//Mechanics

/mob/living/carbon/human/scp049/proc/AttackVoiceLine() //for when we're up to no good!
	var/voiceline = list('sound/scp/scp049/SCP049_1.ogg','sound/scp/scp049/SCP049_2.ogg','sound/scp/scp049/SCP049_3.ogg','sound/scp/scp049/SCP049_4.ogg','sound/scp/scp049/SCP049_5.ogg')
	playsound(src, pick(voiceline), 30)

/mob/living/carbon/human/scp049/proc/announceJoin()
	SIGNAL_HANDLER
	priority_announce("Motion sensors triggered in the containment chamber of SCP-049, on-site security personnel are to investigate the issue.", "Motion Sensors", "SCP-049 Potentially Active", ANNOUNCER_SCP049LOGIN)
	resetBreachTimer()

	//breach related stuff below

/mob/living/carbon/human/scp049/proc/onHear(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	if((hearing_args[HEARING_SPEAKER] == src) || (get_area(src) != home_area))
		return
	resetBreachTimer()

/mob/living/carbon/human/scp049/proc/handleContainment(datum/source, atom/movable/arrived, area/old_area)
	SIGNAL_HANDLER
	if(src == arrived)
		resetBreachTimer()

/mob/living/carbon/human/scp049/proc/handleEscape(datum/source, atom/movable/gone, direction)
	SIGNAL_HANDLER
	if(src == gone)
		if(!breach_timer)
			return
		deltimer(breach_timer)
		breach_timer = null

/mob/living/carbon/human/scp049/proc/resetBreachTimer()
	if(breach_timer)
		deltimer(breach_timer)
		breach_timer = null
	breach_timer = addtimer(CALLBACK(src, PROC_REF(breach)), patience_limit, TIMER_STOPPABLE)

/mob/living/carbon/human/scp049/proc/breach()
	if(client)
		priority_announce("Critical failure in containment systems in the containment chamber of SCP-049, on-site security personnel are to investigate immediately.", "Critical Containment Failure", "SCP-049 Containment Failure")
		home_area.breach()
	breach_timer = null

//Overrides

/mob/living/carbon/human/scp049/Life()
	. = ..()
	//Regen (The more zombies we have the more we heal)
	if(COOLDOWN_FINISHED(src, heal) && getBruteLoss())
		var/heal_amount = -max((base_regen + (cured_count * regen_multiply)), base_regen)
		adjustBruteLoss(heal_amount)
		COOLDOWN_START(src, heal, heal_cooldown)

// /mob/living/carbon/human/scp049/UnarmedAttack(atom/target as obj|mob)
// 	if(!istype(target))
// 		return

// 	if(istype(target, /obj/machinery/door))
// 		setClickCooldown(CLICK_CD_ATTACK)
// 		OpenDoor(target)
// 		return

// 	if(!ishuman(target) || isscp049(target))
// 		return ..()

// 	var/mob/living/carbon/human/H = target

// 	if(isspecies(H, SPECIES_SCP049_1))
// 		return ..()

// 	if(!H.humanStageHandler.getStage("Pestilence"))
// 		to_chat(src, span_danger("They are not infected with the Pestilence."))
// 		return

// 	if(H.SCP)
// 		to_chat(src, span_warning("This thing... it isnt normal... you cannot cure it."))
// 		return

// 	setClickCooldown(CLICK_CD_ATTACK)

// 	switch(a_intent)
// 		if(I_HELP)
// 			to_chat(src, SPAN_NOTICE("You refrain from curing as your intent is set to help."))
// 			return ..()
// 		if(I_HURT)
// 			if(H.stat == DEAD)
// 				to_chat(src, SPAN_NOTICE("They are ready for your cure."))
// 			else if(can_touch_bare_skin(H))
// 				visible_message(span_danger(SPAN_ITALIC("[src] reaches towards [H]!")))
// 				AttackVoiceLine()
// 				H.death(deathmessage = "suddenly becomes very still...", show_dead_message = "You have been killed by SCP-[SCP.designation]. Be patient as you may yet be cured...")
// 			else
// 				// Crowd control tool!
// 				if(anger_timer >= anger_timer_max * 0.75)
// 					visible_message(span_danger(SPAN_ITALIC("[src] reaches towards [H], making them stumble!")))
// 					H.Weaken(10)
// 					return
// 				visible_message(span_warning(SPAN_ITALIC("[src] reaches towards [H], but nothing happens...")))
// 				to_chat(src, span_warning("\The target's [zone_sel.selecting] is covered. You must make contact with bare skin to kill!"))
// 			return
// 	return ..()

// /mob/living/carbon/human/scp049/attack_hand(mob/living/carbon/human/M)
// 	if(isspecies(M, SPECIES_SCP049_1))
// 		to_chat(M, span_danger(SPAN_BOLD("Do not attack your master!")))
// 		return

// 	if(M.a_intent != I_HELP && M != src)
// 		M.humanStageHandler.setStage("Pestilence", 1)
// 		anger_timer = min(anger_timer + 2, anger_timer_max)

// 	return ..()

/mob/living/carbon/human/scp049/update_body_parts(update_limb_data) //dont need to draw limbs since we have our own icon
	update_wound_overlays()
	remove_overlay(BODYPARTS_LAYER)

/mob/living/carbon/human/scp049/bullet_act(obj/projectile/P)
	. = ..()
	if(ishuman(P.firer) && P.damage && !P.nodamage && (P.firer != src))
		ADD_TRAIT(P.firer, TRAIT_PESTILENCE, "Attacked SCP-049")

/mob/living/carbon/human/scp049/attackby(obj/item/W, mob/user, params)
	. = ..()
	if((W.force > 0) && ishuman(user) && (user != src))
		ADD_TRAIT(user, TRAIT_PESTILENCE, "Attacked SCP-049")

/mob/living/carbon/human/scp049/examinate(atom/A)
	. = ..()
	if(ishuman(A) && HAS_TRAIT(A, TRAIT_PESTILENCE))
		var/pest_message = pick("They reek of the disease.", "They need to be cured.", "The disease is strong in them.", "You sense the pestilence in them.")
		to_chat(src, "[span_bolddanger(pest_message)]")

// Emotes

/mob/living/carbon/human/scp049/verb/Greetings()
	set category = "SCP-049"
	set name = "Greetings"

	if(COOLDOWN_FINISHED(src, emote))
		playsound(src, 'sound/scp/scp049/SCP049_1.ogg', 30)
		COOLDOWN_START(src, emote, emote_cooldown)
		return

	to_chat(src, span_warning("You cannot do a special emote so soon after having just done one!"))

/mob/living/carbon/human/scp049/verb/YetAnotherVictim()
	set category = "SCP-049"
	set name = "Yet another victim"

	if(COOLDOWN_FINISHED(src, emote))
		playsound(src, 'sound/scp/scp049/SCP049_2.ogg', 30)
		COOLDOWN_START(src, emote, emote_cooldown)
		return

	to_chat(src, span_warning("You cannot do a special emote so soon after having just done one!"))

/mob/living/carbon/human/scp049/verb/YouAreNotDoctor()
	set category = "SCP-049"
	set name = "You are not a doctor"

	if(COOLDOWN_FINISHED(src, emote))
		playsound(src, 'sound/scp/scp049/SCP049_3.ogg', 30)
		COOLDOWN_START(src, emote, emote_cooldown)
		return

	to_chat(src, span_warning("You cannot do a special emote so soon after having just done one!"))

/mob/living/carbon/human/scp049/verb/SenseDiseaseInYou()
	set category = "SCP-049"
	set name = "I sense the disease in you"

	if(COOLDOWN_FINISHED(src, emote))
		playsound(src, 'sound/scp/scp049/SCP049_4.ogg', 30)
		COOLDOWN_START(src, emote, emote_cooldown)
		return

	to_chat(src, span_warning("You cannot do a special emote so soon after having just done one!"))

/mob/living/carbon/human/scp049/verb/HereToCureYou()
	set category = "SCP-049"
	set name = "I'm here to cure you"

	if(COOLDOWN_FINISHED(src, emote))
		playsound(src, 'sound/scp/scp049/SCP049_5.ogg', 30)
		COOLDOWN_START(src, emote, emote_cooldown)
		return

	to_chat(src, span_warning("You cannot do a special emote so soon after having just done one!"))

// Cure procs

// /mob/living/carbon/human/scp049/proc/PlagueDoctorCure(mob/living/carbon/human/target)
// 	if(!(target.species.name in GLOB.zombie_species) || !target.humanStageHandler.getStage("Pestilence"))
// 		return

// 	if(isspecies(target, SPECIES_DIONA) || isspecies(target, SPECIES_SCP049_1) || target.isSynthetic())
// 		return

// 	if(target.mind)
// 		if(target.mind.special_role == ANTAG_SCP049_1)
// 			return
// 		target.mind.special_role = ANTAG_SCP049_1

// 	var/turf/T = get_turf(target)
// 	new /obj/effect/decal/cleanable/blood(T)
// 	playsound(T, 'sounds/effects/splat.ogg', 20, 1)
// 	cured_count++

// 	target.SCP = new /datum/scp(
// 		target, // Ref to actual SCP atom
// 		"plague zombie", //Name (Should not be the scp desg, more like what it can be described as to viewers)
// 		SCP_EUCLID, //Obj Class
// 		"049-[cured_count]", //Numerical Designation
// 		SCP_PLAYABLE
// 	)

// 	target.visible_message(span_bolddanger("The lifeless corpse of [target] begins to convulse violently!"))
// 	target.humanStageHandler.setStage("Pestilence", 0)

// 	target.adjust_jitter(30 SECONDS)
// 	target.adjustBruteLoss(100)

// 	addtimer(CALLBACK(src, PROC_REF(FinishPlagueDoctorCure), target), 15 SECONDS)

// /mob/living/carbon/human/scp049/proc/FinishPlagueDoctorCure(mob/living/carbon/human/target)
// 	if(QDELETED(target))
// 		return

// 	if(isspecies(target, SPECIES_SCP049_1))
// 		return

// 	target.revive()
// 	target.ChangeToHusk()
// 	target.visible_message(\
// 		span_danger("\The [target]'s skin decays before your very eyes!"), \
// 		span_danger("You feel the last of your mind drift away... You must follow the one who cured you of your wretched disease."))
// 	log_admin("[key_name(target)] has transformed into an instance of 049-1!")

// 	target.Weaken(4)

// 	target.species = all_species[SPECIES_SCP049_1]
// 	target.species.handle_post_spawn(target)

// 	playsound(get_turf(target), 'sounds/hallucinations/wail.ogg', 25, 1)
