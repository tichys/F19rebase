///What percentage of the crew can become traitors.
#define TRAITOR_SCALING_COEFF 0.15

/datum/game_mode/traitor
	name = "Traitor"

	weight = GAMEMODE_WEIGHT_COMMON
	restricted_jobs = list(JOB_CYBORG, JOB_AI)
	protected_jobs = list(
		JOB_SITE_DIRECTOR,
		JOB_HUMAN_RESOURCES_DIRECTOR,
		JOB_SECURITY_DIRECTOR,
		JOB_ENGINEERING_DIRECTOR,
		JOB_MEDICAL_DIRECTOR,
		JOB_EZ_COMMANDER,
		JOB_SENIOR_EZ_GUARD,
		JOB_EZ_GUARD,
		JOB_JUNIOR_EZ_GUARD,
		JOB_RAISA_AGENT,
		JOB_LCZ_COMMANDER,
		JOB_SENIOR_LCZ_GUARD,
		JOB_LCZ_GUARD,
		JOB_JUNIOR_LCZ_GUARD,
		JOB_HCZ_COMMANDER,
		JOB_SENIOR_HCZ_GUARD,
		JOB_HCZ_GUARD,
		JOB_JUNIOR_HCZ_GUARD
	)

	antag_datum = /datum/antagonist/traitor
	antag_flag = ROLE_TRAITOR

/datum/game_mode/traitor/pre_setup()
	. = ..()

	var/num_traitors = 1

	num_traitors = max(1, round(length(SSticker.ready_players) * TRAITOR_SCALING_COEFF))

	for (var/i in 1 to num_traitors)
		if(possible_antags.len <= 0)
			break
		var/mob/M = pick_n_take(possible_antags)
		select_antagonist(M.mind)
