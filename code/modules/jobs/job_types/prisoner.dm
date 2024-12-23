/datum/job/dclass
	title = JOB_DCLASS
	description = "Keep yourself occupied in permabrig."
	department_head = list("The Security Team")
	faction = FACTION_STATION
	total_positions = 0
	spawn_positions = 2
	selection_color = "#bd630a"
	exp_granted_type = EXP_TYPE_CREW
	paycheck = PAYCHECK_ZERO //This doesnt actually do anything since prisoners have no department

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/prisoner,
			SPECIES_PLASMAMAN = /datum/outfit/job/prisoner/plasmaman,
		),
	)

	department_for_prefs = /datum/job_department/security

	exclusive_mail_goodies = TRUE
	mail_goodies = list (
		/obj/effect/spawner/random/contraband/prison = 1
	)

	family_heirlooms = list(/obj/item/pen/blue)
	rpg_title = "Defeated Miniboss"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/prisoner
	name = "Prisoner"
	jobtype = /datum/job/dclass

	id = /obj/item/card/id/advanced/prisoner
	id_trim = /datum/id_trim/job/prisoner
	uniform = /obj/item/clothing/under/rank/prisoner
	belt = null
	ears = null
	shoes = /obj/item/clothing/shoes/sneakers/orange

/datum/outfit/job/prisoner/plasmaman
	name = "Prisoner (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/prisoner
	gloves = /obj/item/clothing/gloves/color/plasmaman/black
	head = /obj/item/clothing/head/helmet/space/plasmaman/prisoner
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/prisoner/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(1)) // D BOYYYYSSSSS
		head = /obj/item/clothing/head/beanie/black/dboy

/datum/outfit/job/prisoner/post_equip(mob/living/carbon/human/new_prisoner, visualsOnly)
	. = ..()
	if(!length(SSpersistence.prison_tattoos_to_use) || visualsOnly)
		return
	var/obj/item/bodypart/tatted_limb = pick(new_prisoner.bodyparts)
	var/list/tattoo = pick(SSpersistence.prison_tattoos_to_use)
	tatted_limb.AddComponent(/datum/component/tattoo, tattoo["story"])
	SSpersistence.prison_tattoos_to_use -= tattoo
