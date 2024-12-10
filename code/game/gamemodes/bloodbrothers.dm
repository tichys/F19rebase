///What percentage of the crew can become bros :flooshed:.
#define BROTHER_SCALING_COEFF 0.15
//The minimum amount of people in a blood brothers team. Set this below 2 and you're stupid.
#define BROTHER_MINIMUM_TEAM_SIZE 2

/datum/game_mode/brothers
	name = "Blood Brothers"

	weight = GAMEMODE_WEIGHT_RARE
	required_enemies = BROTHER_MINIMUM_TEAM_SIZE

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

	antag_datum = /datum/antagonist/brother
	antag_flag = ROLE_BROTHER

	var/list/datum/team/brother_team/pre_brother_teams = list()

/datum/game_mode/brothers/pre_setup()
	. = ..()

	var/num_teams = max(1, round((length(SSticker.ready_players) * BROTHER_SCALING_COEFF) / BROTHER_MINIMUM_TEAM_SIZE))

	for(var/j in 1 to num_teams)
		if(length(possible_antags) < BROTHER_MINIMUM_TEAM_SIZE) //This shouldn't ever happen but, just in case
			break

		var/datum/team/brother_team/team = new
		// 10% chance to add 1 more member
		var/team_size = prob(10) ? min(BROTHER_MINIMUM_TEAM_SIZE + 1, possible_antags) : BROTHER_MINIMUM_TEAM_SIZE

		for(var/k in 1 to team_size)
			var/mob/bro = pick_n_take(possible_antags)
			team.add_member(bro.mind)
			select_antagonist(bro.mind)

		pre_brother_teams += team

/datum/game_mode/brothers/setup_antags()
	for(var/datum/team/brother_team/team in pre_brother_teams)
		team.pick_meeting_area()
		team.forge_brother_objectives()
		team.update_name()

	return ..()

/datum/game_mode/brothers/give_antag_datums()
	for(var/datum/team/brother_team/team in pre_brother_teams)
		for(var/datum/mind/M in team.members)
			M.add_antag_datum(/datum/antagonist/brother, team)
