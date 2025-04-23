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
