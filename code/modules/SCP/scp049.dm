/mob/living/carbon/human/scp049
	name = "plague doctor"
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
	///Cure action datum
	var/datum/action/scp049cure/cureaction

/mob/living/carbon/human/scp049/Initialize(mapload)
	. = ..()

	set_species(/datum/species/scp049) //if ever setting species, species MUST be set BEFORE creating the SCP datum, otherwise the names will not work as the head will get regenerated
	gender = MALE //human init randomizes gender

	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"plague doctor", //Name (Should not be the scp desg, more like what it can be described as to viewers)
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
	RegisterSignal(src, list(COMSIG_LIVING_START_GRAB, COMSIG_LIVING_NO_LONGER_GRABBING), PROC_REF(handleCureGrab))

	// grant_language(LANGUAGE_PLAGUESPEAK_GLOBAL)

	var/datum/atom_hud/data/human/pestilence/pHud = GLOB.huds[DATA_HUD_PESTILENCE]
	pHud.show_to(src)

	cureaction = new
	cureaction.link_to(src)

/mob/living/carbon/human/scp049/Destroy()
	QDEL_NULL(SCP)
	UnregisterSignal(src, list(COMSIG_MOVABLE_HEAR, COMSIG_MOB_LOGIN, COMSIG_LIVING_START_GRAB))
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

	// Cure procs

/mob/living/carbon/human/scp049/proc/handleCureGrab(datum/source, atom/movable/pulled, obj/item/hand_item/grab/grab)
	SIGNAL_HANDLER
	if(grab && istype(grab.current_grab, /datum/grab/normal/aggressive) && pulled && ishuman(pulled) && HAS_TRAIT(pulled, TRAIT_PESTILENCE))
		var/mob/living/carbon/human/H = pulled
		if(H.stat == DEAD && !(NOZOMBIE in H.dna.species.species_traits))
			cureaction.Grant(src)
			return
	cureaction.Remove(src)

/mob/living/carbon/human/scp049/proc/FinishPlagueDoctorCure(mob/living/carbon/human/target)
	if(QDELETED(target))
		return

	if(is_species(target, /datum/species/zombie/scp049_1))
		return

	target.visible_message(span_danger("\The [target]'s skin decays before your very eyes!"))
	target.set_species(/datum/species/zombie/scp049_1)

	//Fully heal the zombie's damage the first time they rise
	target.setToxLoss(0, 0)
	target.setOxyLoss(0, 0)
	target.heal_overall_damage(INFINITY, INFINITY, null, TRUE)
	target.stamina.adjust(INFINITY)

	if(!target.revive())
		return
	target.grab_ghost()

	to_chat(target, span_danger("You feel the last of your mind drift away... You must follow the one who cured you of your wretched disease."))
	log_admin("[key_name(target)] has transformed into an instance of 049-1!")
	playsound(get_turf(target), 'sound/hallucinations/wail.ogg', 25, 1)

//Overrides

/mob/living/carbon/human/scp049/Life()
	. = ..()
	//Regen (The more zombies we have the more we heal)
	if(COOLDOWN_FINISHED(src, heal) && getBruteLoss())
		var/heal_amount = -max((base_regen + (cured_count * regen_multiply)), base_regen)
		adjustBruteLoss(heal_amount)
		COOLDOWN_START(src, heal, heal_cooldown)

/mob/living/carbon/human/scp049/UnarmedAttack(atom/target as mob)
	if(!istype(target) || !combat_mode || !ishuman(target))
		return ..()

	var/mob/living/carbon/human/H = target

	if(is_species(H, /datum/species/scp049) || is_species(H, /datum/species/zombie))
		return ..()

	if(H.stat == DEAD)
		return ..()

	if(!HAS_TRAIT(H, TRAIT_PESTILENCE))
		to_chat(src, span_notice("They are not infected with the Pestilence."))
		return ..()

	if(H.SCP)
		to_chat(src, span_warning("This thing... it isnt normal... you cannot cure it."))
		return ..()

	var/body_parts_covered
	for(var/i in body_zone2cover_flags(zone_selected))
		body_parts_covered |= i

	if(!(H.get_all_covered_flags() & body_parts_covered))
		visible_message(span_bolddanger("[src] reaches towards [H]!"))
		AttackVoiceLine()
		H.death(cause_of_death = "Killed by SCP-[SCP.designation], and may be potentially cured...")
		return

	to_chat(src, span_warning("\The [H]'s [parse_zone(zone_selected)] is covered! You must make contact with bare skin to kill!"))

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

/mob/living/carbon/human/scp049/attack_hand(mob/living/carbon/human/M, modifiers)
	. = ..()
	if(M.combat_mode && M != src)
		ADD_TRAIT(M, TRAIT_PESTILENCE, "Attacked SCP-049")

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

