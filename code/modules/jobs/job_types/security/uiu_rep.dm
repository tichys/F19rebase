/datum/job/uiu_rep
	title = JOB_UIU_REP
	description = "Communicate with your respective Group of Interest and maintain diplomatic relations with the Foundation while also pursuing your group's interests."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Federal Bureau of Investigation"
	selection_color = "#490A0D"
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_SECURITY
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/uiu
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/uiu_rep,
		),
	)

	paycheck = PAYCHECK_COMMAND

	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	departments_list = list(
		/datum/job_department/command,
	)


	family_heirlooms = list(/obj/item/reagent_containers/food/drinks/bottle/whiskey)


	mail_goodies = list(
		/obj/item/storage/fancy/cigarettes = 25,
		/obj/item/ammo_box/c38 = 25,
		/obj/item/ammo_box/c38/dumdum = 5,
		/obj/item/ammo_box/c38/hotshot = 5,
		/obj/item/ammo_box/c38/iceblox = 5,
		/obj/item/ammo_box/c38/match = 5,
		/obj/item/ammo_box/c38/trac = 5,
	)

	rpg_title = "Thiefcatcher"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/outfit/job/uiu_rep
	name = JOB_UIU_REP
	jobtype = /datum/job/uiu_rep
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
