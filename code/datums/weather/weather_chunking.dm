/* Chunk management system for weather; We essentially cache a list of atoms in an area (obj or mobs)
 * that we can then reference with a key. This is better than checking them all at once.
 * I believe Mobs/items are generally more extensive to iterate than areas.
*/

///Called when an objects area moves from indoors to outdoors
#define COMSIG_OUTDOOR_ATOM_ADDED "outdoor_object_added"

///Called when an objects area moves from outdoors to indoors
#define COMSIG_OUTDOOR_ATOM_REMOVED "outdoor_object_removed"

#define WEATHER_CHUNK_SIZE 8 //8x8 is considered a chunk. Believe it or not, the camera net system Also uses a chunking system, so ours is WEATHER_

/datum/weather/chunking
	name = "Chunk System"


	var/list/chunks = list()  /// Chunk keys and atoms contained, Ex. [4_6_1], [x_y_z]
	var/list/turf_chunks = list() // Chunk keys and exposed turfs contained.
	var/list/exposed_turfs = list() // Temporary cache used for initial registration with the chunking system.
	var/tmp/debug_message_count = 0 // Limit debug messages for chunking

//Registering/Deregistering for atoms.

/datum/weather/chunking/proc/Initialize()

	RegisterSignal(src, COMSIG_OUTDOOR_ATOM_ADDED, PROC_REF(outdoor_atom_added))
	RegisterSignal(src, COMSIG_OUTDOOR_ATOM_REMOVED, PROC_REF(outdoor_atom_removed))
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(outdoor_atom_moved))

/datum/weather/chunking/proc/outdoor_atom_added(atom/movable/A)
	if(!A) //How did it get moved here if it was anchored? I don't know.
		return

	register(A)
	A.needs_weather_update = TRUE

/datum/weather/chunking/proc/outdoor_atom_removed(atom/movable/A)
	if(!A)
		return

	unregister(A)

//Used for chunking to determine if an atom entered a new chunk.
/datum/weather/chunking/proc/outdoor_atom_moved(atom/movable/A)
	if(!A)
		return

	SSweather.weather_chunking.update_atom_location(A)

/// Actual Chunk handeling logic

/datum/weather/chunking/proc/register(atom/movable/Q)
	if(!Q) //We only want outdoor atoms and atoms that exist.
		return
	var/key = get_chunk_key(Q) //What's the key for this atoms location?
	if(!(key in src.chunks)) //If the key doesn't exist, we create the list and mark it.
		src.chunks[key] = list()
	src.chunks[key] += Q //Adding the atom to the list.

//Similar to above but removing atoms from chunks, and deleting chunks from list if empty.
/datum/weather/chunking/proc/unregister(atom/movable/Q) //Keep Q for clarity
	var/key = get_chunk_key(Q)
	if(key in src.chunks)
		src.chunks[key] -= Q
		if(!src.chunks[key])
			src.chunks[key] = null

//Keys and Coords

/datum/weather/chunking/proc/get_chunk_coords(atom/movable/Q) //Maybe misleading name, gets the chunk based on coords and chunk size.
	return list(
		floor((Q.x - 1) / WEATHER_CHUNK_SIZE),
		floor((Q.y - 1) / WEATHER_CHUNK_SIZE),
		Q.z
	)

/datum/weather/chunking/proc/get_chunk_key(atom/movable/Q) //Converts coordinates into key.
	var/list/coords = src.get_chunk_coords(Q)
	return "[coords[1]]_[coords[2]]_[coords[3]]"

//Utilities

/datum/weather/chunking/proc/update_atom_location(atom/movable/Q) //Detecting when atom moves between chunks, unregisters old, registers new.
	if(!Q)
		return

	var/key_now = get_chunk_key(Q)
	if(key_now != Q.last_weather_chunk_key)
		if(Q.last_weather_chunk_key)
			unregister(Q)
		register(Q)
		Q.last_weather_chunk_key = key_now

/datum/weather/chunking/proc/get_nearby_atoms(atom/origin, radius_in_chunks = 1) //Returns combined list of atoms in square of surrounding chunks
	var/list/center = get_chunk_coords(origin)
	var/list/results = list()

	for(var/dx = -radius_in_chunks to radius_in_chunks)
		for(var/dy = -radius_in_chunks to radius_in_chunks)
			var/x = center[1] + dx
			var/y = center[2] + dy
			var/z = center[3]
			var/key = "[x]_[y]_[z]"
			if(key in src.chunks)
				results += src.chunks[key]

	return results

// 3 by 3 grid around executed chunk, so 9 chunks total. * = chunk, x = center (also chunk)
/*

* * *
* x *
* * *

*/

/datum/weather/chunking/proc/get_mobs_in_chunks(list/chunk_keys)
	var/list/results = list()
	for(var/key in chunk_keys)
		if(key in src.chunks)
			for(var/atom/movable/Q in src.chunks[key])
				if(ismob(Q))
					results += Q

	return results


/datum/weather/chunking/proc/get_objects_in_chunks(list/chunk_keys)
	var/list/results = list()
	for(var/key in chunk_keys)
		if(key in src.chunks)
			for(var/atom/movable/Q in src.chunks[key])
				if(isobj(Q))
					results += Q

	return results

//Same as above but now we're reusing logic for Turfs.
//Weather coverage will handle init turf exposure determination, and then pass it here, chunking will handle distributing it to everyone else (Profiles, Effects, Subsystem, etc)

/datum/weather/chunking/proc/register_exposed_turf(turf/T)
	if (!T || !T.z)
		return

	var/key = get_turf_chunk_key(T)
	if (!(key in src.turf_chunks))
		src.turf_chunks[key] = list() // Initialize as a list if new chunk key

	var/list/turfs_in_chunk = src.turf_chunks[key]
	if (!(T in turfs_in_chunk)) // Only add if not already present
		turfs_in_chunk += T
	else
		if(debug_message_count < 100)
			message_admins(span_adminnotice("Weather Chunking Debug: Turf ([T.x],[T.y],[T.z]) already in chunk [key]. No change."))

/datum/weather/chunking/proc/unregister_exposed_turf(turf/T)
	var/key = get_turf_chunk_key(T)

	if (key in src.turf_chunks)
		var/list/turfs_in_chunk = src.turf_chunks[key]
		if (T in turfs_in_chunk)
			turfs_in_chunk -= T
			if(debug_message_count < 100 && SSweather.weather_coverage_handler.debug_verbose_coverage_messages)
				message_admins(span_adminnotice("Weather Chunking Debug: Turf ([T.x],[T.y],[T.z]) removed from chunk [key]. Turfs in chunk: [turfs_in_chunk.len]"))
			if (!turfs_in_chunk.len) // If the list becomes empty, remove the chunk key
				src.turf_chunks.Remove(key)
				if(debug_message_count < 100 && SSweather.weather_coverage_handler.debug_verbose_coverage_messages)
					message_admins(span_adminnotice("Weather Chunking Debug: Chunk key [key] removed (empty). turf_chunks.len now: [length(src.turf_chunks)]"))
		else
			if(debug_message_count < 100 && SSweather.weather_coverage_handler.debug_verbose_coverage_messages)
				message_admins(span_adminnotice("Weather Chunking Debug: Turf ([T.x],[T.y],[T.z]) not found in chunk [key]. No change."))
	else
		if(debug_message_count < 100 && SSweather.weather_coverage_handler.debug_verbose_coverage_messages)
			message_admins(span_adminnotice("Weather Chunking Debug: Chunk key [key] not found. No turf to unregister."))

/datum/weather/chunking/proc/get_turf_chunk_coords(turf/T)
	return list(
		floor((T.x - 1) / WEATHER_CHUNK_SIZE),
		floor((T.y - 1) / WEATHER_CHUNK_SIZE),
		T.z
		)

/datum/weather/chunking/proc/get_turf_chunk_key(turf/T)
	var/list/coords = src.get_turf_chunk_coords(T)
	return "[coords[1]]_[coords[2]]_[coords[3]]"


/datum/weather/chunking/proc/get_turfs_in_chunks(list/chunk_keys)
	var/list/results = list()
	for (var/key in chunk_keys)
		if (key in src.turf_chunks)
			var/list/turfs_in_chunk = src.turf_chunks[key]
			if (istype(turfs_in_chunk, /list)) // Ensure it's a list
				results += turfs_in_chunk
			else if (istype(turfs_in_chunk, /turf)) // Handle old format if any remain
				results += turfs_in_chunk
	return results

/datum/weather/chunking/proc/get_all_turf_chunk_keys()
	. = list()
	for (var/key in src.turf_chunks)
		. += key

/datum/weather/chunking/proc/get_all_turf_chunk_keys_on_z(z_level)
	. = list()
	for (var/key in src.turf_chunks)
		var/list/coords = splittext(key, "_")
		if (coords.len == 3 && text2num(coords[3]) == z_level)
			. += key

/datum/weather/chunking/proc/get_impacted_chunk_keys(datum/weather/storm)
	. = list()
	if(!storm || !storm.impacted_z_levels || !islist(storm.impacted_z_levels) || !length(storm.impacted_z_levels) || !istype(storm.center_turf, /turf))
		return

	// Iterate through all impacted Z-levels specified by the storm
	for(var/current_z in storm.impacted_z_levels)
		// Ensure current_z is a valid number
		if(!isnum(current_z))
			continue

		if(storm.radius_in_chunks == -1) // All-encompassing horizontally for this Z-level
			var/list/z_chunk_keys = get_all_turf_chunk_keys_on_z(current_z)
			for(var/key in z_chunk_keys)
				// No need to check area_type, as turf_chunks already contains only exposed turfs
				. |= key

		else if(storm.radius_in_chunks > 0) // Radius-based horizontally for this Z-level
			var/list/center_chunk_coords = get_turf_chunk_coords(storm.center_turf)
			var/center_x = center_chunk_coords[1]
			var/center_y = center_chunk_coords[2]

			for(var/dx = -storm.radius_in_chunks to storm.radius_in_chunks)
				for(var/dy = -storm.radius_in_chunks to storm.radius_in_chunks)
					var/x = center_x + dx
					var/y = center_y + dy
					var/key = "[x]_[y]_[current_z]"
					if(key in src.turf_chunks) // Check if this chunk actually exists and has exposed turfs
						// No need to check area_type, as turf_chunks already contains only exposed turfs
						. |= key

/datum/weather/chunking/proc/get_mobs_in_chunks_around_storm(datum/weather/storm)
	var/list/impacted_keys = get_impacted_chunk_keys(storm)
	return get_mobs_in_chunks(impacted_keys)

/datum/weather/chunking/proc/get_objects_in_chunks_around_storm(datum/weather/storm)
	var/list/impacted_keys = get_impacted_chunk_keys(storm)
	return get_objects_in_chunks(impacted_keys)
