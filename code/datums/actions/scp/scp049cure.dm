/datum/action/scp049cure
	name = "Cure"
	desc = "Purge the pestilence."
	button_icon = 'icons/obj/surgery.dmi'
	button_icon_state = "retractor"

	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_HANDS_BLOCKED

	///Are we currently curing?
	var/cure_in_progress = FALSE
	///How long it takes to perform a cure surgery
	var/curetime = 10 SECONDS

/datum/action/scp049cure/IsAvailable(feedback)
	. = ..()
	if(cure_in_progress)
		if(feedback)
			to_chat(owner, span_warning("You are already curing someone!"))
		return FALSE

/datum/action/scp049cure/Trigger(trigger_flags)
	if(!..())
		return FALSE

	var/obj/item/hand_item/grab/G = owner.get_active_held_item()
	if(!isgrab(G))
		return FALSE
	var/mob/living/carbon/human/target = G.affecting
	if(!istype(target))
		return FALSE

	if((NOZOMBIE in target.dna.species.species_traits) || !HAS_TRAIT(target, TRAIT_PESTILENCE))
		return FALSE

	if(!istype(owner, /mob/living/carbon/human/scp049))
		Remove(owner)
		QDEL_NULL(src) //this shouldent happen but sanity check
		return FALSE

	owner.visible_message(span_warning("\The [owner] begins to perfom some kind of surgery on [target]!"),span_notice("You begin to work to cure [target] of the Pestilence."))
	if(!do_after(owner, target, curetime))
		owner.balloon_alert(owner, "Curing interrupted!")
		return FALSE

	owner.visible_message(span_danger("\The [owner] finishes up their procedure on [target]!"), span_boldnicegreen("You cure [target] of the Pestilence, it makes you feel good."))

	new /obj/effect/decal/cleanable/blood/splatter(get_turf(owner))
	playsound(target, 'sound/effects/splat.ogg', 20, 1)

	target.visible_message(span_bolddanger("The lifeless corpse of [target] begins to convulse violently!"))
	REMOVE_TRAIT(target, TRAIT_PESTILENCE, list("Attacked SCP-049", "badmin", "Random Pestilence"))

	target.adjust_timed_status_effect(30 SECONDS, /datum/status_effect/jitter)

	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human/scp049, FinishPlagueDoctorCure), target), 15 SECONDS)
