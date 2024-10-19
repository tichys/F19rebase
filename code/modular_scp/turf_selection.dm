/decl/turf_selection/proc/get_turfs(atom/origin, range)
	return list()

/decl/turf_selection/line/get_turfs(atom/origin, range)
	. = list()
	var/center = get_turf(origin)
	if(!center)
		return
	for(var/i = 0 to range)
		center = get_step(center, origin.dir)
		if(!center) // Reached the end of the world most likely
			return
		. += center

/decl/turf_selection/square/get_turfs(atom/origin, range)
	. = list()
	var/center = get_turf(origin)
	if(!center)
		return
	for(var/turf/T in trange(range, center))
		. += T

/proc/trange(rad = 0, turf/centre = null) //alternative to range (ONLY processes turfs and thus less intensive)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)
