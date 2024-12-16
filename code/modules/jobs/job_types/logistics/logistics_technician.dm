/datum/job/logistics_technician
	title = JOB_LOGISTICS_TECHNICIAN
	description = "Distribute supplies to the departments that ordered them, \
		collect empty crates, load and unload the supply shuttle, \
		ship bounty cubes."
	department_head = list(JOB_LOGISTICS_OFFICER)
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 2
	supervisors = "the Logistics Officer"
	selection_color = "#3A2300"
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/scp
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/logistics_technician,
			SPECIES_PLASMAMAN = /datum/outfit/job/logistics_technician/plasmaman,
		),
		"Shaft Miner" = list(
			SPECIES_HUMAN = /datum/outfit/job/miner,
			SPECIES_PLASMAMAN = /datum/outfit/job/miner/plasmaman,
		),
	)

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CAR
	departments_list = list(
		/datum/job_department/cargo,
		)

	family_heirlooms = list(/obj/item/clipboard)

	mail_goodies = list(
		/obj/item/pizzabox = 10,
		/obj/item/stack/sheet/mineral/gold = 5,
		/obj/item/stack/sheet/mineral/uranium = 4,
		/obj/item/stack/sheet/mineral/diamond = 3,
		/obj/item/gun/ballistic/rifle/boltaction = 1
	)
	rpg_title = "Merchantman"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN | JOB_CAN_BE_INTERN


/datum/outfit/job/logistics_technician
	name = JOB_LOGISTICS_TECHNICIAN
	jobtype = /datum/job/logistics_technician

	id_trim = /datum/id_trim/job/logistics_technician
	uniform = /obj/item/clothing/under/rank/cargo/tech
	belt = /obj/item/modular_computer/tablet/pda/cargo
	ears = /obj/item/radio/headset/headset_cargo
	l_hand = /obj/item/export_scanner

/datum/outfit/job/logistics_technician/plasmaman
	name = JOB_LOGISTICS_TECHNICIAN + " (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/cargo
	gloves = /obj/item/clothing/gloves/color/plasmaman/cargo
	head = /obj/item/clothing/head/helmet/space/plasmaman/cargo
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/logistics_technician/mod
	name = JOB_LOGISTICS_TECHNICIAN + " (MODsuit)"

	back = /obj/item/mod/control/pre_equipped/loader

/datum/outfit/job/miner
	name = JOB_LOGISTICS_TECHNICIAN
	jobtype = /datum/job/logistics_technician

	id_trim = /datum/id_trim/job/shaft_miner
	uniform = /obj/item/clothing/under/rank/cargo/miner
	backpack_contents = list(
		/obj/item/flashlight/seclite = 1,
		/obj/item/knife/combat/survival = 1,
		/obj/item/mining_voucher = 1,
		/obj/item/stack/marker_beacon/ten = 1,
		)
	belt = /obj/item/modular_computer/tablet/pda/shaftminer
	ears = /obj/item/radio/headset/headset_cargo/mining
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/workboots/mining
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/survival
	r_pocket = /obj/item/storage/bag/ore //causes issues if spawned in backpack

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	duffelbag = /obj/item/storage/backpack/duffelbag/explorer

	box = /obj/item/storage/box/survival/mining

/datum/outfit/job/miner/plasmaman
	name = "Shaft Miner (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/mining
	gloves = /obj/item/clothing/gloves/color/plasmaman/explorer
	head = /obj/item/clothing/head/helmet/space/plasmaman/mining
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/miner/equipped
	name = "Shaft Miner (Equipment)"

	suit = /obj/item/clothing/suit/space/nasavoid/old
	suit_store = /obj/item/tank/internals/oxygen
	backpack_contents = list(
		/obj/item/flashlight/seclite = 1,
		/obj/item/knife/combat/survival = 1,
		/obj/item/mining_voucher = 1,
		/obj/item/stack/marker_beacon/ten = 1,
		/obj/item/t_scanner/adv_mining_scanner/lesser = 1,
		)
	glasses = /obj/item/clothing/glasses/meson
	head = /obj/item/clothing/head/helmet/space/nasavoid/old
	mask = /obj/item/clothing/mask/breath
	internals_slot = ITEM_SLOT_SUITSTORE

/datum/outfit/job/miner/equipped/mod
	name = "Shaft Miner (Equipment + MODsuit)"
	back = /obj/item/mod/control/pre_equipped/mining
	suit = null
	mask = /obj/item/clothing/mask/breath
	backpack_contents = null
	box = null
