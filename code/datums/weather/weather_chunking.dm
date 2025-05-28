/* Chunk management system for weather; We essentially cache a list of atoms in an area (obj or mobs)
 * that we can then reference with a key. This is better than checking them all at once.
 * I believe Mobs/items are generally more extensive to iterate than areas.
*/

#define WEATHER_CHUNK_SIZE 8 //8x8 is considered a chunk. Believe it or not, the camera net system Also uses a chunking system, so ours is WEATHER_

/datum/weather/chunking
	name = "Chunk System"


	var/list/chunks = list()  /// Chunk keys and atoms contained, Ex. [4_6_1], [x_y_z]
	var/list/turf_chunks = list() // Chunk keys and exposed turfs contained.

//Registering/Deregistering

/datum/weather/chunking/proc/register(atom/movable/Q)
	var/area/A = get_area(Q)
	if(!Q || !A.outdoors) //We only want outdoor atoms and atoms that exist.
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
		round(Q.x / WEATHER_CHUNK_SIZE),
		round(Q.y / WEATHER_CHUNK_SIZE),
		Q.z
	)

/datum/weather/chunking/proc/get_chunk_key(atom/movable/Q) //Converts coordinates into key.
	var/list/coords = src.get_chunk_coords(Q)
	return "[coords[1]]_[coords[2]]_[coords[3]]"

//Utilities

/datum/weather/chunking/proc/update_atom_location(atom/movable/Q) //Detecting when atom moves between chunks, unregisters old, registers new.
	var/area/A = get_area(Q)
	if(!Q || !A.outdoors)
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
	var/area/A = get_area(T)
	if (!T || !T.z || !T.blocks_weather || !A.outdoors)
		return

	var/key = get_turf_chunk_key(T)
	if (!(key in src.turf_chunks))
		src.turf_chunks[key] = list()
	src.turf_chunks[key] += T

/datum/weather/chunking/proc/unregister_exposed_turf(turf/T)
	var/key = get_turf_chunk_key(T)
	if (key in src.turf_chunks)
		src.turf_chunks[key] -= T
		if (!src.turf_chunks[key])
			src.turf_chunks[key] = null

/datum/weather/chunking/proc/get_turf_chunk_coords(turf/T)
	return list(
		round(T.x / WEATHER_CHUNK_SIZE),
		round(T.y / WEATHER_CHUNK_SIZE),
		T.z
		)

/datum/weather/chunking/proc/get_turf_chunk_key(turf/T)
	var/list/coords = src.get_turf_chunk_coords(T)
	return "[coords[1]]_[coords[2]]_[coords[3]]"


/datum/weather/chunking/proc/get_turfs_in_chunks(list/chunk_keys)
	var/list/results = list()
	for (var/key in chunk_keys)
		if (key in src.turf_chunks)
			results += src.turf_chunks[key]
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
	if(!storm || !storm.impacted_z_levels || !islist(storm.impacted_z_levels) || !(storm.impacted_z_levels:list).len || !istype(storm.center_turf, /turf))
		return

	var/start_z = (storm.center_turf:turf).z

	// Iterate from the storm's center Z-level downwards to 1
	for(var/current_z = start_z to 1 step -1)
		// Only consider this Z-level if it's one of the storm's eligible impacted_z_levels
		if(!(current_z in storm.impacted_z_levels))
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

	return

/datum/weather/chunking/proc/get_mobs_in_chunks_around_storm(datum/weather/storm)
	var/list/impacted_keys = get_impacted_chunk_keys(storm)
	return get_mobs_in_chunks(impacted_keys)

/datum/weather/chunking/proc/get_objects_in_chunks_around_storm(datum/weather/storm)
	var/list/impacted_keys = get_impacted_chunk_keys(storm)
	return get_objects_in_chunks(impacted_keys)
