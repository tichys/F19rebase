///What percentage of the crew can become heretics.
#define HERETIC_SCALING_COEFF 0.1

/datum/game_mode/heretic
	name = "Heretic"

	weight = GAMEMODE_WEIGHT_RARE
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

	antag_datum = /datum/antagonist/heretic
	antag_flag = ROLE_HERETIC

/datum/game_mode/heretic/pre_setup()
	. = ..()

	var/num_heretics = 1

	num_heretics = max(1, round(length(SSticker.ready_players) * HERETIC_SCALING_COEFF))

	for (var/i in 1 to num_heretics)
		if(possible_antags.len <= 0)
			break
		var/mob/M = pick_n_take(possible_antags)
		select_antagonist(M.mind)
