/datum/job/goi_rep
	title = "Group of Interest Representative"
	description = "As the GOC Representative, your task is to assess the facility and generally \
	advocate for hardline approaches in regards to anomalies and their containment, or destruction. "
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the leaders of your respective group of interest."
	selection_color = "#131E41"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/goc,
		/datum/employer/goldbaker,
		/datum/employer/uiu,
		/datum/employer/mcd,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/goc_rep,
		),
		JOB_GOLDBAKER_REP = list(
			SPECIES_HUMAN = /datum/outfit/job/goldbaker_rep,
		),
		JOB_UIU_REP = list(
			SPECIES_HUMAN = /datum/outfit/job/uiu_rep,
		),
		JOB_MCD_REP = list(
			SPECIES_HUMAN = /datum/outfit/job/mcd_rep,
		),
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_STATION_MASTER

	departments_list = list(
		/datum/job_department/command,
	)


	family_heirlooms = list()

	mail_goodies = list(
		/obj/item/clothing/mask/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 10,
		/obj/item/toy/captainsaid/collector = 20
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Star Duke"

	voice_of_god_power = 1.4 //Command staff has authority

// GOC Rep Outfit

/datum/outfit/job/goc_rep
	name = JOB_GOC_REP
	jobtype = /datum/job/goi_rep
	allow_jumpskirt = FALSE

	id = /obj/item/card/id/advanced/black_blank
	id_trim = /datum/id_trim/job/goc_rep
	uniform = /obj/item/clothing/under/suit/charcoal
	backpack_contents = list(
		/obj/item/assembly/flash/handheld = 1
	)
	belt = /obj/item/modular_computer/tablet/pda
	ears = /obj/item/radio/headset/headset_com
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

// Goldbaker Rep Outfit

/datum/outfit/job/goldbaker_rep
	name = JOB_GOLDBAKER_REP
	jobtype = /datum/job/goi_rep
	allow_jumpskirt = FALSE

	id = /obj/item/card/id/advanced/black_blank
	id_trim = /datum/id_trim/job/goldbaker_rep
	uniform = /obj/item/clothing/under/suit/beige
	backpack_contents = list(
		/obj/item/folder/yellow = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 1,
		/obj/item/knife/bloodletter = 1
	)
	belt = /obj/item/modular_computer/tablet/pda
	ears = /obj/item/radio/headset/heads/cmo
	head = /obj/item/clothing/head/flatcap
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

// UIU Rep Outfit

/datum/outfit/job/uiu_rep
	name = JOB_UIU_REP
	jobtype = /datum/job/goi_rep
	allow_jumpskirt = FALSE

	id_trim = /datum/id_trim/job/uiu_rep
	uniform = /obj/item/clothing/under/rank/security/detective
	suit = /obj/item/clothing/suit/irs
	belt = /obj/item/modular_computer/tablet/pda/detective
	ears = /obj/item/radio/headset/heads/hos
	gloves = /obj/item/clothing/gloves/forensic
	neck = /obj/item/clothing/neck/tie/detective
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/toy/crayon/white
	r_pocket = /obj/item/storage/fancy/cigarettes/dromedaryco

	l_hand = /obj/item/storage/briefcase/crimekit

	chameleon_extras = list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/gun/ballistic/revolver/detective,
		)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

// MCD Rep Outfit

/datum/outfit/job/mcd_rep
	name = JOB_MCD_REP
	jobtype = /datum/job/goi_rep
	allow_jumpskirt = FALSE

	id = /obj/item/card/id/advanced/black_blank
	id_trim = /datum/id_trim/job/mcd_rep
	uniform = /obj/item/clothing/under/suit/tuxedo
	backpack_contents = list(
		/obj/item/gun/ballistic/revolver/golden = 1,
		/obj/item/ammo_box/a357 = 1,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 1
	)
	belt = /obj/item/modular_computer/tablet/pda
	ears = /obj/item/radio/headset/headset_com
	head = /obj/item/clothing/head/that
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag
