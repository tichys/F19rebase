/datum/job/logistics_officer
	title = JOB_LOGISTICS_OFFICER
	description = "Manage your Deckhands and Prospectors, assist with \
		economical purchasing."
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Human Resources Officer."
	selection_color = "#15381b"
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_SUPPLY
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/scp
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/logistics_officer,
			SPECIES_PLASMAMAN = /datum/outfit/job/logistics_officer/plasmaman,
		),
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_CAR

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	departments_list = list(
		/datum/job_department/cargo,
		/datum/job_department/company_leader,
	)

	family_heirlooms = list(/obj/item/stamp, /obj/item/stamp/denied)
	mail_goodies = list(
		/obj/item/circuitboard/machine/emitter = 3
	)
	rpg_title = "Steward"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/logistics_officer
	name = "Logistics Officer"
	jobtype = /datum/job/logistics_officer

	id = /obj/item/card/id/advanced/black_blank
	id_trim = /datum/id_trim/job/logistics_officer
	uniform = /obj/item/clothing/under/rank/cargo/qm
	belt = /obj/item/modular_computer/tablet/pda/quartermaster
	ears = /obj/item/radio/headset/heads/qm
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/sneakers/brown
	l_hand = /obj/item/clipboard

	chameleon_extras = /obj/item/stamp/qm

/datum/outfit/job/logistics_officer/plasmaman
	name = "Logistics Officer (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/cargo
	gloves = /obj/item/clothing/gloves/color/plasmaman/cargo
	head = /obj/item/clothing/head/helmet/space/plasmaman/cargo
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full
