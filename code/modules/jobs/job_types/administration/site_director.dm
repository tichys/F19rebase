/datum/job/site_director
	title = JOB_SITE_DIRECTOR
	description = "Ensure the containment and ongoing study of SCPs, safety of all staff, and \
	Foundation protocols be followed at all times. "
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the 0-5 Council"
	selection_color = "#0000E5"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/scp
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/site_director,
		),
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_STATION_MASTER

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	departments_list = list(
		/datum/job_department/command,
		/datum/job_department/company_leader
	)


	family_heirlooms = list(/obj/item/reagent_containers/food/drinks/flask/gold, /obj/item/toy/captainsaid/collector)

	mail_goodies = list(
		/obj/item/clothing/mask/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 10,
		/obj/item/toy/captainsaid/collector = 20
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Star Duke"

	voice_of_god_power = 1.4 //Command staff has authority


/datum/job/site_director/get_captaincy_announcement(mob/living/captain)
	return "[title] [captain.real_name] will be overseeing operations today."

/datum/outfit/job/site_director
	name = JOB_SITE_DIRECTOR
	jobtype = /datum/job/site_director
	allow_jumpskirt = FALSE

	id_trim = /datum/id_trim/job/site_director
	id = /obj/item/card/id/advanced/director_blank
	uniform = /obj/item/clothing/under/suit/charcoal
	backpack_contents = list(
		/obj/item/assembly/flash/handheld = 1
	)
	belt = /obj/item/modular_computer/tablet/pda/captain
	ears = /obj/item/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	chameleon_extras = list(
		/obj/item/gun/energy/e_gun,
		/obj/item/stamp/captain,
		)
	implants = list(/obj/item/implant/mindshield)
	skillchips = list(/obj/item/skillchip/disk_verifier)

	var/special_charter

/datum/outfit/job/site_director/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/list/job_changes = SSmapping.config.job_changes
	if(!length(job_changes))
		return
	var/list/captain_changes = job_changes["captain"]
	if(!length(captain_changes))
		return
	special_charter = captain_changes["special_charter"]
	if(!special_charter)
		return
	backpack_contents.Remove(/obj/item/station_charter)
	l_hand = /obj/item/station_charter/banner

/datum/outfit/job/site_director/post_equip(mob/living/carbon/human/equipped, visualsOnly)
	. = ..()
	var/obj/item/station_charter/banner/celestial_charter = equipped.held_items[LEFT_HANDS]
	if(!celestial_charter)
		return
	celestial_charter.name_type = special_charter
