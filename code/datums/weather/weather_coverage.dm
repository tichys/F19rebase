/*
 * Weather Coverage Handler - This system is responsible for identifying which turfs are "exposed" to weather.
 * It primarily operates by processing vertical "columns" of turfs (unique X,Y coordinates across all Z-levels)
 * to determine the highest exposed turf in each column.
 *
 * This handler only manages the initial weather coverage calculation and passes that information to the
 * weather_chunking system, which is more efficient for real-time updates.
 */

#define UNCOVERED FALSE
#define COVERED TRUE


/datum/weather/weather_coverage

	// Referencing the weather_chunking system from the Weather subsystem.
	// This subsystem does not create its own instance.
	var/list/processing_turfs = list() // List of unique (x,y) coordinates representing vertical columns to process for weather coverage.
	var/debug_verbose_coverage_messages = FALSE // Debug flag for verbose messages
	var/max_z_level = 0 // Stores the maximum Z-level relevant to the current map
	var/list/initialized_relevant_z_levels // Stores the Z-levels relevant for weather coverage
	var/tmp/debug_message_count = 0 // Limit debug messages

/// Initialization Starts

//Registering signals, calling exposed turf calculations, and calling data pass to chunking.
/datum/weather/weather_coverage/proc/Initialize(timeofday, list/relevant_z_levels)
	message_admins(span_adminnotice("Weather Coverage Handler: Initialize called."))

	src.initialized_relevant_z_levels = relevant_z_levels // Store the relevant Z-levels

	// Determine the maximum Z-level from the relevant_z_levels
	if(relevant_z_levels && relevant_z_levels.len)
		max_z_level = max(relevant_z_levels) // Get the highest Z-level
	else
		max_z_level = world.maxz // Fallback if no relevant Z-levels (shouldn't happen for a valid map)

	message_admins("Weather Coverage Debug: relevant_z_levels = [relevant_z_levels.Join(", ")]")
	initialize_weather_coverage(relevant_z_levels)

/datum/weather/weather_coverage/proc/initialize_weather_coverage(list/relevant_z_levels)
	message_admins(span_adminnotice("Weather Coverage Handler: initialize_weather_coverage called with relevant_z_levels: [relevant_z_levels.Join(", ")]"))
	processing_turfs = list() // Explicitly re-initialize processing_turfs as a new list

	// Use the map bounds from the mapping subsystem
	var/min_x = SSmapping.map_min_x
	var/max_x = SSmapping.map_max_x
	var/min_y = SSmapping.map_min_y
	var/max_y = SSmapping.map_max_y

	message_admins(span_adminnotice("Weather Coverage Handler: Using map bounds from SSmapping: min_x=[min_x], max_x=[max_x], min_y=[min_y], max_y=[max_y]."))

	// If SSmapping didn't provide valid bounds (e.g., map loading failed or it's a default world), fallback to world dimensions
	if (max_x == 0 || max_y == 0 || min_x > max_x || min_y > max_y) // Added checks for invalid ranges
		message_admins(span_adminnotice("Weather Coverage Handler: SSmapping bounds invalid or not set. Falling back to world dimensions."))
		min_x = 1
		max_x = world.maxx
		min_y = 1
		max_y = world.maxy

	var/list/unique_column_keys_seen = new/list() // Use this to track keys already added
	var/debug_columns_added_count = 0 // New debug counter

	// Iterate within these calculated bounds for each relevant Z-level
	// This loop identifies all unique (x,y) columns that contain at least one turf
	// across all relevant Z-levels.
	for(var/z in relevant_z_levels)
		message_admins(span_adminnotice("Weather Coverage Debug: Processing Z-level: [z]")) // Added debug
		for (var/x = min_x to max_x)
			for (var/y = min_y to max_y)
				var/turf/T = locate(x, y, z)
				if (T) // Only consider existing turfs within the bounds
					var/column_key = "[x]_[y]"
					if (!(column_key in unique_column_keys_seen)) // Check if this (x,y) key has been seen across any Z-level
						unique_column_keys_seen[column_key] = TRUE // Mark as seen
						processing_turfs.Add(column_key) // Add the unique (x,y) column key as a string element to processing_turfs
						debug_columns_added_count++ // Increment debug counter
						if(debug_verbose_coverage_messages && debug_columns_added_count < 100)
							message_admins(span_adminnotice("Weather Coverage Debug: Added new unique column: [column_key]. Total unique added: [debug_columns_added_count]. processing_turfs.len now: [processing_turfs.len] (should match debug_columns_added_count)"))
							message_admins(span_adminnotice("Weather Coverage Debug: After Add - processing_turfs.len: [processing_turfs.len], debug_columns_added_count: [debug_columns_added_count]"))

	message_admins(span_adminnotice("Weather Coverage Handler: Initializing weather coverage calculation. Populated [processing_turfs.len] unique (x,y) columns for processing across all relevant Z-levels. Debug added count: [debug_columns_added_count] (should match processing_turfs.len)"))
	if(debug_verbose_coverage_messages)
		message_admins(span_adminnotice("Weather Coverage Debug: Initialized relevant Z-levels: [initialized_relevant_z_levels.Join(", ")]. Max Z-level: [max_z_level]."))
	message_admins(span_adminnotice("Weather Coverage Debug: End of initialize_weather_coverage. processing_turfs.len: [processing_turfs.len]")) // NEW DEBUG

/datum/weather/weather_coverage/proc/process_next_turf_batch(batch_size)
	message_admins(span_adminnotice("Weather Coverage Debug: Start of process_next_turf_batch. processing_turfs.len: [processing_turfs.len]")) // NEW DEBUG
	if(!processing_turfs.len)
		return FALSE // No more columns to process

	var/columns_processed_in_batch = 0
	for(var/i = 1 to batch_size)
		if(!processing_turfs.len)
			break

		var/column_key_string = processing_turfs[1]
		// Workaround for unexpected list.Cut(1) behavior: manually reconstructing the list
		var/list/temp_list = list()
		for(var/j = 2 to processing_turfs.len) //Var j avoids nested duplicate loop.
			temp_list.Add(processing_turfs[j])
		processing_turfs = temp_list
		if(debug_verbose_coverage_messages)
			message_admins(span_adminnotice("Weather Coverage Debug: After manual removal. processing_turfs.len: [processing_turfs.len]")) // NEW DEBUG

		if (!istext(column_key_string)) // Handle invalid column key (should be a string)
			if(debug_verbose_coverage_messages)
				message_admins(span_adminnotice("Weather Coverage Handler: Skipping invalid column key (not a string): [column_key_string]."))
			columns_processed_in_batch++
			continue

		var/list/coords = splittext(column_key_string, "_")
		if (coords.len != 2) // Handle invalid format (e.g., "x_y")
			if(debug_verbose_coverage_messages)
				message_admins(span_adminnotice("Weather Coverage Handler: Skipping invalid column key format: [column_key_string]."))
			columns_processed_in_batch++
			continue

		var/column_x = text2num(coords[1])
		var/column_y = text2num(coords[2])

		if (!isnum(column_x) || !isnum(column_y)) // Handle non-numeric coordinates after parsing
			if(debug_verbose_coverage_messages)
				message_admins(span_adminnotice("Weather Coverage Handler: Skipping non-numeric column coordinates: [column_key_string]."))
			columns_processed_in_batch++
			continue

		// Scan from top to bottom in this (x, y) column, limited by the highest relevant Z-level.
		for (var/z = max_z_level, z >= 1, z--) // Loop down to z=1, using max_z_level
			var/turf/current_turf = locate(column_x, column_y, z)

			if (!current_turf) // No turf at this Z-level
				// If we're at the highest relevant Z-level and there's no turf, then the turf below it might be exposed.
				if(z == max_z_level) // If the very top is empty, the turf below it might be exposed
					if (z - 1 >= 1) // Ensure z-1 is a valid Z-level
						var/turf/turf_to_expose = locate(column_x, column_y, z - 1)
						if(turf_to_expose) // Ensure it exists
							if(turf_to_expose.z in initialized_relevant_z_levels) // Only expose if the Z-level is relevant
								set_exposed(turf_to_expose, TRUE)
								if(debug_verbose_coverage_messages)
									message_admins(span_adminnotice("Weather Coverage: Exposed turf [turf_to_expose.loc] due to empty space at max_z_level."))
				continue // Always continue to the next lower Z-level, let the main logic handle subsequent turfs

			// If we are at the highest Z-level and this turf exists, it is exposed.
			// Or if the turf above it does not block weather, this turf is exposed.
			var/turf/turf_above = locate(current_turf.x, current_turf.y, current_turf.z + 1)
			if(debug_verbose_coverage_messages && debug_message_count < 100)
				message_admins(span_adminnotice("Weather Coverage Debug: Evaluating Turf [current_turf.loc] (Type: [current_turf.type], Z: [current_turf.z]). Turf above: [turf_above ? turf_above.loc : "None"] (Type: [turf_above ? turf_above.type : "N/A"], Blocks Weather: [turf_above ? turf_above.blocks_weather : "N/A"]). Z relevant: [current_turf.z in initialized_relevant_z_levels]. Exposed Candidate: [(!turf_above || !turf_above.blocks_weather)]."))
				debug_message_count++ // Increment counter
			if ((!turf_above || !turf_above.blocks_weather) && (current_turf.z in initialized_relevant_z_levels)) // Only expose if the Z-level is relevant
				set_exposed(current_turf, TRUE)
				if(debug_verbose_coverage_messages)
					message_admins(span_adminnotice("Weather Coverage: Exposed turf [current_turf.loc] because it's at the top or turf above does not block weather."))
				// If this turf blocks weather, then everything below it is covered.
				// So we can break the loop for this column.
				if (current_turf.blocks_weather)
					if(debug_verbose_coverage_messages)
						message_admins(span_adminnotice("Weather Coverage Debug: Breaking column scan for ([column_x],[column_y]) at [current_turf.loc] because it blocks weather."))
					break
				// If this turf does NOT block weather, continue scanning downwards.
				continue

			// If we reach here, current_turf exists, and the turf above it exists and blocks weather.
			// This means current_turf is covered. Everything below it is also covered. So, break.
			if(debug_verbose_coverage_messages)
				message_admins(span_adminnotice("Weather Coverage Debug: Breaking column scan for ([column_x],[column_y]) at [current_turf.loc] because turf above ([turf_above.loc]) blocks weather."))
			break

		columns_processed_in_batch++

	if(debug_verbose_coverage_messages)
		message_admins(span_adminnotice("Weather Coverage Handler: Processed [columns_processed_in_batch] columns. [processing_turfs.len] remaining."))

	return processing_turfs.len > 0 // Return TRUE if there are more columns to process

/// Initialization Ends


/// Utilities for Turf Creation/Destruction
/datum/weather/weather_coverage/proc/on_turf_created(turf/T)
	if(!T || !T.z) return

	var/turf/below = locate(T.x, T.y, T.z - 1)

	if(!below)
		return

	if(T.blocks_weather)
		// Turf now blocks weather; below is no longer exposed
		set_exposed(below, FALSE) //Set_exposed marks the turf as covered.

/datum/weather/weather_coverage/proc/on_turf_destroyed(turf/T)
	if(!T || !T.z)
		return

	if(!T.blocks_weather)
		// Turf that was destroyed didn't block weather, so no point in checking, since fundementally nothing should change.
		return

	//Check the turf below the destroyed turf
	var/turf/below = locate(T.x, T.y, T.z - 1)
	if(below) //If the turf below exists, go through the next step of validations
		update_turf_exposure(below)

/datum/weather/weather_coverage/proc/update_turf_exposure(turf/T)
	if(!T)
		return

	// Turf that blocked weather is now gone; below might be exposed
	var/turf/above = locate(T.x, T.y, T.z + 1)
	var/is_exposed = (!above || !above.blocks_weather);

	set_exposed(T, is_exposed);

//Sets the turf as covered or uncovered, and flags it for a weather update.
/datum/weather/weather_coverage/proc/set_exposed(turf/T, is_exposed)
	if(!T)
		return

	if(is_exposed)
		if(T.cover_cache != UNCOVERED)
			T.cover_cache = UNCOVERED
			SSweather.weather_chunking.exposed_turfs |= T
			SSweather.weather_chunking.register_exposed_turf(T)
			T.needs_weather_update = TRUE
			if(debug_verbose_coverage_messages && debug_message_count < 100)
				message_admins(span_adminnotice("Weather Coverage Debug: set_exposed called for [T.loc] as TRUE. Number of exposed turfs in chunking system: [SSweather.weather_chunking.turf_chunks.len]"))
				debug_message_count++
	else
		if(T.cover_cache != COVERED)
			T.cover_cache = COVERED
			SSweather.weather_chunking.exposed_turfs -= T // This line still uses exposed_turfs, but it's a temporary cache, so it's fine.
			SSweather.weather_chunking.unregister_exposed_turf(T)
			T.needs_weather_update = TRUE
			if(debug_verbose_coverage_messages)
				message_admins(span_adminnotice("Weather Coverage: Turf [T.loc] became covered. Number of exposed turfs in chunking system: [SSweather.weather_chunking.turf_chunks.len]"))



/datum/weather/weather_coverage/proc/finalize_exposed_turf_registration()
	if(!SSweather.weather_chunking)
		return
	message_admins(span_adminnotice("Weather Coverage: Initial weather coverage calculation complete. Found [length(SSweather.weather_chunking.get_turfs_in_chunks(SSweather.weather_chunking.get_all_turf_chunk_keys()))] exposed turfs on map."))
