#define REVOLUTION_SCALING_COEFF 0.1
///The absolute cap of headrevs.
#define REVOLUTION_MAX_HEADREVS 3

/datum/game_mode/revolution
	name = "Revolution"

	weight = GAMEMODE_WEIGHT_EPIC
	min_pop = 25

	//Atleast 1 of any head.
	required_jobs = list(
		list(JOB_SITE_DIRECTOR = 1),
		list(JOB_HUMAN_RESOURCES_DIRECTOR = 1),
		list(JOB_SECURITY_DIRECTOR = 1),
		list(JOB_ENGINEERING_DIRECTOR = 1),
		list(JOB_MEDICAL_DIRECTOR = 1),
		list(JOB_RESEARCH_DIRECTOR = 1)
	)

	restricted_jobs = list(
		JOB_AI,
		JOB_CYBORG,
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

	antag_flag = ROLE_REV_HEAD
	antag_datum = /datum/antagonist/rev/head

	var/datum/team/revolution/revolution
	var/round_winner

/datum/game_mode/revolution/pre_setup()
	. = ..()
	var/num_revs = clamp(round(length(SSticker.ready_players) * REVOLUTION_SCALING_COEFF), 1, REVOLUTION_MAX_HEADREVS)

	for(var/i = 1 to num_revs)
		if(possible_antags.len <= 0)
			break
		var/mob/M = pick_n_take(possible_antags)
		select_antagonist(M.mind)

/datum/game_mode/revolution/setup_antags()
	revolution = new()
	. = ..()

	revolution.update_objectives()
	revolution.update_heads()
	SSshuttle.registerHostileEnvironment(revolution)

/datum/game_mode/revolution/give_antag_datums()
	for(var/datum/mind/M in antagonists)
		if(!check_eligible(M))
			antagonists -= M
			log_game("Revolution: discarded [M.name] from head revolutionary due to ineligibility.")
			continue

		var/datum/antagonist/rev/head/new_head = new antag_datum()
		new_head.give_flash = TRUE
		new_head.remove_clumsy = TRUE
		M.add_antag_datum(new_head,revolution)

/// Checks for revhead loss conditions and other antag datums.
/datum/game_mode/revolution/proc/check_eligible(datum/mind/M)
	var/turf/T = get_turf(M.current)
	if(!considered_afk(M) && considered_alive(M) && is_station_level(T.z) && !M.antag_datums?.len && !HAS_TRAIT(M, TRAIT_MINDSHIELD))
		return TRUE
	return FALSE

/datum/game_mode/revolution/process(delta_time)
	round_winner = revolution.check_completion()
	if(round_winner)
		datum_flags &= ~DF_ISPROCESSING

/datum/game_mode/revolution/check_finished()
	. = ..()
	if(.)
		return
	return !!round_winner

/datum/game_mode/revolution/set_round_result()
	. = ..()
	revolution.round_result(round_winner)
