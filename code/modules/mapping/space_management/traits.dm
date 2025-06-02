/// Look up levels[z].traits[trait]
/datum/controller/subsystem/mapping/proc/level_trait(z, trait)
	if (!isnum(z) || z < 1)
		return null
	if (z_list)
		if (z > z_list.len)
			stack_trace("Unmanaged z-level [z]! maxz = [world.maxz], z_list.len = [z_list.len]")
			return FALSE
		var/datum/space_level/S = get_level(z)
		return S.traits[trait]
	else
		var/list/default = DEFAULT_MAP_TRAITS
		if (z > default.len)
			stack_trace("Unmanaged z-level [z]! maxz = [world.maxz], default.len = [default.len]")
			return FALSE
		return default[z][DL_TRAITS][trait]

/// Check if levels[z] has any of the specified traits
/datum/controller/subsystem/mapping/proc/level_has_any_trait(z, list/traits)
	for (var/I in traits)
		if (level_trait(z, I))
			return TRUE
	return FALSE

/// Check if levels[z] has all of the specified traits
/datum/controller/subsystem/mapping/proc/level_has_all_traits(z, list/traits)
	for (var/I in traits)
		if (!level_trait(z, I))
			return FALSE
	return TRUE

/// Get a list of all z which have the specified trait
/datum/controller/subsystem/mapping/proc/levels_by_trait(trait)
	. = list()
	if (SSweather.weather_coverage_handler.debug_verbose_coverage_messages)
		message_admins(span_adminnotice("SSmapping.levels_by_trait called for trait: [trait]"))
	var/list/_z_list = z_list
	if (SSweather.weather_coverage_handler.debug_verbose_coverage_messages)
		message_admins(span_adminnotice("SSmapping.levels_by_trait: z_list.len = [_z_list ? _z_list.len : "NULL"]"))
	for(var/A in _z_list)
		var/datum/space_level/S = A
		if (S.traits[trait])
			. += S.z_value
	var/list/found_levels = .
	if (SSweather.weather_coverage_handler.debug_verbose_coverage_messages)
		message_admins(span_adminnotice("SSmapping.levels_by_trait: Returning [found_levels.len] levels: [found_levels.Join(", ")]"))

/// Get a list of all z which have any of the specified traits
/datum/controller/subsystem/mapping/proc/levels_by_any_trait(list/traits)
	. = list()
	var/list/_z_list = z_list
	for(var/A in _z_list)
		var/datum/space_level/S = A
		for (var/trait in traits)
			if (S.traits[trait])
				. += S.z_value
				break

/// Prefer not to use this one too often
/datum/controller/subsystem/mapping/proc/get_station_center()
	var/station_z = levels_by_trait(ZTRAIT_STATION)[1]
	return locate(round(world.maxx * 0.5, 1), round(world.maxy * 0.5, 1), station_z)
