/datum/daycycle

	/// Unique string ID used to register a level with a daycycle.
	var/daycycle_id
	/// How long is a full day and night cycle?
	var/cycle_duration = 1 HOUR
	/// How far are we into the current cycle?
	var/time_in_cycle = 0
	/// What world.time did we last update? Used to calculate time progression between ticks.
	var/last_update = 0
	/// What z-levels are affected by this daycycle? Used for mass updating ambience.
	var/list/levels_affected = list()
	/// What period of day are we sitting in as of our last update?
	var/datum/daycycle_period/current_period
	/// Mappings of colour and power to % progression points throughout the cycle.
	/// Each entry must be arranged in order of earliest to latest.
	/// Null values on periods use the general level ambience instead.
	var/list/cycle_periods = list(
		new /datum/daycycle_period/sunrise,
		new /datum/daycycle_period/daytime,
		new /datum/daycycle_period/sunset,
		new /datum/daycycle_period/night
	)

/datum/daycycle/New(_cycle_id)
	daycycle_id = _cycle_id
	last_update = world.time
	current_period = cycle_periods[1]
	transition_daylight() // pre-populate our values.

/datum/daycycle/proc/add_level(level_z)
	levels_affected |= level_z

	update_level_ambience(level_z)

/datum/daycycle/proc/remove_level(level_z)
	levels_affected -= level_z

	update_level_ambience(level_z)

/datum/daycycle/proc/transition_daylight()

	time_in_cycle = (time_in_cycle + (world.time - last_update)) % cycle_duration
	last_update = world.time

	var/datum/daycycle_period/last_period = current_period
	var/progression_percentage = time_in_cycle / cycle_duration
	for(var/datum/daycycle_period/period in cycle_periods)
		if(progression_percentage <= period.period)
			current_period = period
			break

	. = (current_period.color != last_period.color || current_period.power != last_period.power)
	if(current_period != last_period && current_period.announcement)
		for(var/mob/player in GLOB.player_list)
			var/turf/T = get_turf(player)
			var/area/A = get_area(T)
			if(T && (T.z in levels_affected) && (A.outdoors))
				to_chat(player, span_notice((current_period.announcement)))

/datum/daycycle/proc/tick()
	if(transition_daylight())
		for(var/level_z in levels_affected)
			update_level_ambience(level_z)

/datum/daycycle/proc/update_level_ambience(z)
	for(var/x = 1 to world.maxx)
		for(var/y = 1 to world.maxy)
			var/turf/T = locate(x, y, z)
			var/area/A = get_area(T)
			if(T && A.outdoors) //I tried to just do get_area(T).outdoors like *every other time*, but for some UNGODLY reason this one is PICKY.
				T.update_ambient_light()

