/datum/job/junior_hcz_guard
	title = JOB_JUNIOR_HCZ_GUARD
	description = "Maintain the security of Keter anomalies held in the HCZ."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list(JOB_SECURITY_DIRECTOR)
	faction = FACTION_STATION
	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the Security Director."
	selection_color = "#602f1c"
	minimal_player_age = 7
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/scp,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/junior_hcz_guard,
			SPECIES_PLASMAMAN = /datum/outfit/job/junior_hcz_guard/plasmaman,
		),
	)

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	departments_list = list(
		/datum/job_department/security,
		)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/clothing/mask/whistle = 5,
		/obj/item/melee/baton/security/boomerang/loaded = 1
	)
	rpg_title = "Guard"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/outfit/job/junior_hcz_guard
	name = "Junior HCZGuard"
	jobtype = /datum/job/junior_hcz_guard

	id_trim = /datum/id_trim/job/junior_hcz_guard
	uniform = /obj/item/clothing/under/rank/security/officer
	suit = /obj/item/clothing/suit/armor/vest/sec
	suit_store = /obj/item/gun/energy/disabler
	backpack_contents = list(
		/obj/item/storage/evidencebag = 1,
		)
	belt = /obj/item/modular_computer/tablet/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec

	box = /obj/item/storage/box/survival/security
	chameleon_extras = list(
		/obj/item/clothing/glasses/hud/security/sunglasses,
		/obj/item/clothing/head/helmet,
		/obj/item/gun/energy/disabler,
		)
		//The helmet is necessary because /obj/item/clothing/head/helmet/sec is overwritten in the chameleon list by the standard helmet, which has the same name and icon state
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/junior_hcz_guard/plasmaman
	name = "Junior HCZ Guard (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/security
	gloves = /obj/item/clothing/gloves/color/plasmaman/black
	head = /obj/item/clothing/head/helmet/space/plasmaman/security
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/junior_hcz_guard/mod
	name = "Junior HCZ Guard (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/security
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null

// HCZ Guard

/datum/job/hcz_guard
	title = JOB_HCZ_GUARD
	description = "Maintain the security of Keter anomalies held in the HCZ."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list(JOB_SECURITY_DIRECTOR)
	faction = FACTION_STATION
	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the Security Director."
	selection_color = "#602f1c"
	minimal_player_age = 7
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/scp,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/hcz_guard,
			SPECIES_PLASMAMAN = /datum/outfit/job/hcz_guard/plasmaman,
		),
	)

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	departments_list = list(
		/datum/job_department/security,
		)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/clothing/mask/whistle = 5,
		/obj/item/melee/baton/security/boomerang/loaded = 1
	)
	rpg_title = "Guard"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/outfit/job/hcz_guard
	name = "HCZ Guard"
	jobtype = /datum/job/hcz_guard

	id_trim = /datum/id_trim/job/hcz_guard
	uniform = /obj/item/clothing/under/rank/security/officer
	suit = /obj/item/clothing/suit/armor/vest/sec
	suit_store = /obj/item/gun/energy/disabler
	backpack_contents = list(
		/obj/item/storage/evidencebag = 1,
		)
	belt = /obj/item/modular_computer/tablet/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec

	box = /obj/item/storage/box/survival/security
	chameleon_extras = list(
		/obj/item/clothing/glasses/hud/security/sunglasses,
		/obj/item/clothing/head/helmet,
		/obj/item/gun/energy/disabler,
		)
		//The helmet is necessary because /obj/item/clothing/head/helmet/sec is overwritten in the chameleon list by the standard helmet, which has the same name and icon state
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/hcz_guard/plasmaman
	name = "HCZ Guard (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/security
	gloves = /obj/item/clothing/gloves/color/plasmaman/black
	head = /obj/item/clothing/head/helmet/space/plasmaman/security
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/hcz_guard/mod
	name = "HCZ Guard (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/security
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null

// Senior HCZ Guard

/datum/job/senior_hcz_guard
	title = JOB_SENIOR_HCZ_GUARD
	description = "Maintain the security of Keter anomalies held in the HCZ."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list(JOB_SECURITY_DIRECTOR)
	faction = FACTION_STATION
	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the Security Director."
	selection_color = "#602f1c"
	minimal_player_age = 7
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/scp,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/senior_hcz_guard,
			SPECIES_PLASMAMAN = /datum/outfit/job/senior_hcz_guard/plasmaman,
		),
	)

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	departments_list = list(
		/datum/job_department/security,
		)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/clothing/mask/whistle = 5,
		/obj/item/melee/baton/security/boomerang/loaded = 1
	)
	rpg_title = "Guard"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/outfit/job/senior_hcz_guard
	name = "Senior HCZ Guard"
	jobtype = /datum/job/senior_hcz_guard

	id_trim = /datum/id_trim/job/senior_hcz_guard
	uniform = /obj/item/clothing/under/rank/security/officer
	suit = /obj/item/clothing/suit/armor/vest/sec
	suit_store = /obj/item/gun/energy/disabler
	backpack_contents = list(
		/obj/item/storage/evidencebag = 1,
		)
	belt = /obj/item/modular_computer/tablet/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec

	box = /obj/item/storage/box/survival/security
	chameleon_extras = list(
		/obj/item/clothing/glasses/hud/security/sunglasses,
		/obj/item/clothing/head/helmet,
		/obj/item/gun/energy/disabler,
		)
		//The helmet is necessary because /obj/item/clothing/head/helmet/sec is overwritten in the chameleon list by the standard helmet, which has the same name and icon state
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/senior_hcz_guard/plasmaman
	name = "Senior HCZ Guard (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/security
	gloves = /obj/item/clothing/gloves/color/plasmaman/black
	head = /obj/item/clothing/head/helmet/space/plasmaman/security
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/senior_hcz_guard/mod
	name = "Senior HCZ Guard (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/security
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null

// HCZ Commander

/datum/job/hcz_commander
	title = JOB_HCZ_COMMANDER
	description = "Maintain the security of Keter anomalies held in the HCZ."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list(JOB_SECURITY_DIRECTOR)
	faction = FACTION_STATION
	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the Security Director."
	selection_color = "#602f1c"
	minimal_player_age = 7
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/scp,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/hcz_commander,
			SPECIES_PLASMAMAN = /datum/outfit/job/hcz_commander/plasmaman,
		),
	)

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	departments_list = list(
		/datum/job_department/security,
		)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/clothing/mask/whistle = 5,
		/obj/item/melee/baton/security/boomerang/loaded = 1
	)
	rpg_title = "Guard"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/outfit/job/hcz_commander
	name = "HCZ Commander"
	jobtype = /datum/job/hcz_commander

	id_trim = /datum/id_trim/job/hcz_commander
	uniform = /obj/item/clothing/under/rank/security/officer
	suit = /obj/item/clothing/suit/armor/vest/sec
	suit_store = /obj/item/gun/energy/disabler
	backpack_contents = list(
		/obj/item/storage/evidencebag = 1,
		)
	belt = /obj/item/modular_computer/tablet/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec

	box = /obj/item/storage/box/survival/security
	chameleon_extras = list(
		/obj/item/clothing/glasses/hud/security/sunglasses,
		/obj/item/clothing/head/helmet,
		/obj/item/gun/energy/disabler,
		)
		//The helmet is necessary because /obj/item/clothing/head/helmet/sec is overwritten in the chameleon list by the standard helmet, which has the same name and icon state
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/hcz_commander/plasmaman
	name = "HCZ Commander (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/security
	gloves = /obj/item/clothing/gloves/color/plasmaman/black
	head = /obj/item/clothing/head/helmet/space/plasmaman/security
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/hcz_commander/mod
	name = "HCZ Commander (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/security
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null
