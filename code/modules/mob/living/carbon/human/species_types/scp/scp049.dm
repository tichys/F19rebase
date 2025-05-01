/datum/species/scp049
	name = "\improper ???"
	id = SPECIES_SCP049
	default_color = "#d5d5c9"
	species_traits = list(NOEYESPRITES, NO_UNDERWEAR)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_XRAY_VISION,
		TRAIT_NOBREATH,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_NOHUNGER,
		TRAIT_TOXIMMUNE,
		TRAIT_NODISMEMBER
	)
	skinned_type = /obj/item/stack/sheet/animalhide/human
	sexes = FALSE
	job_outfit_type = SPECIES_SCP049
	changesource_flags = MIRROR_BADMIN //Changesource flags need to be set for something otherwise tests fail

	speedmod = -0.25

	brutemod = 0.5
	burnmod = 1.5
	coldmod = 0.5
	stunmod = 0.5
	siemens_coeff = 0.5

	special_step_sounds = list('sound/effects/footstep/heavy1.ogg', 'sound/effects/footstep/heavy2.ogg')

/datum/species/scp049/check_roundstart_eligible()
	return FALSE

/datum/species/scp049/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	C.update_body()

/datum/species/zombie/scp049_1
	name = "\improper SCP-049-1 Instance"
	id = SPECIES_SCP049_1

	armor = 20
	speedmod = 1.6

	inherent_traits = list( //Had to remove advanced tool user
		TRAIT_CAN_STRIP,
		TRAIT_NOMETABOLISM,
		TRAIT_NOHUNGER,
		TRAIT_TOXIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RADIMMUNE,
		TRAIT_EASYDISMEMBER,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOBREATH,
		TRAIT_NODEATH,
		TRAIT_FAKEDEATH,
		TRAIT_NOCLONELOSS,
		TRAIT_STUNRESISTANCE,
		TRAIT_DISCOORDINATED_TOOL_USER,
		TRAIT_CLUMSY
	)

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision/zombie,
		ORGAN_SLOT_EARS =  /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
	)

	/// The rate the zombies regenerate at
	var/heal_rate = 0.5
	/// The cooldown before the zombie can start regenerating
	COOLDOWN_DECLARE(regen_cooldown)

/datum/species/zombie/scp049_1/check_roundstart_eligible()
	return FALSE

/datum/species/zombie/scp049_1/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_AFTER_APPLY_DAMAGE, PROC_REF(on_take_damage))
	RegisterSignal(C, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(block049Attack))
	RegisterSignal(C, COMSIG_PARENT_QDELETING, PROC_REF(handleOwnerDel))

	C.SCP = new /datum/scp(
		C, // Ref to actual SCP atom
		null, //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_EUCLID, //Obj Class
		"049-1", //Numerical Designation
		SCP_PLAYABLE | SCP_NO_NAME_REPLACE
	)

/datum/species/zombie/scp049_1/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, list(COMSIG_MOB_AFTER_APPLY_DAMAGE, COMSIG_LIVING_UNARMED_ATTACK, COMSIG_PARENT_QDELETING))
	QDEL_NULL(C.SCP)

/datum/species/zombie/scp049_1/proc/on_take_damage(datum/source, damage_dealt, damagetype, def_zone, blocked, sharpness, attack_direction, attacking_item)
	SIGNAL_HANDLER
	if(damage_dealt)
		COOLDOWN_START(src, regen_cooldown, 6 SECONDS)

/datum/species/zombie/scp049_1/proc/handleOwnerDel(datum/source)
	SIGNAL_HANDLER
	if(!istype(source, /atom))
		return //sanity check
	var/atom/A = source
	QDEL_NULL(A.SCP)

/datum/species/zombie/scp049_1/spec_life(mob/living/carbon/C, delta_time, times_fired)
	. = ..()
	if(COOLDOWN_FINISHED(src, regen_cooldown))
		var/heal_amt = heal_rate
		if(C.stat == UNCONSCIOUS)
			heal_amt *= 2
		C.heal_overall_damage(heal_amt * delta_time, heal_amt * delta_time)
		C.adjustToxLoss(-heal_amt * delta_time)
	if(!(C.stat == UNCONSCIOUS) && DT_PROB(2, delta_time))
		playsound(C, pick(spooks), 50, TRUE, 10)

/datum/species/zombie/scp049_1/proc/block049Attack(mob/living/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER
	if(ishuman(target) && is_species(target, /datum/species/scp049))
		to_chat(source, span_boldwarning("Do not attack your master!"))
		return COMPONENT_CANCEL_ATTACK_CHAIN
