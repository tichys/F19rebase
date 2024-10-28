
// Similar to above but we also follow into nullspace
/atom/movable/proc/move_to_turf_or_null(atom/movable/am, old_loc, new_loc)
	var/turf/T = get_turf(new_loc)
	if(T != loc)
		forceMove(T)

/mob/living/carbon/human/proc/can_touch_bare_skin(mob/living/carbon/human/target)
	var/covered_parts = target.check_obscured_slots()
	switch(zone_selected)
		if(BODY_ZONE_PRECISE_R_FOOT)
			if(covered_parts & FOOT_RIGHT)
				return FALSE
		if(BODY_ZONE_PRECISE_L_FOOT)
			if(covered_parts & FOOT_LEFT)
				return FALSE
		if(BODY_ZONE_R_LEG)
			if(covered_parts & LEG_RIGHT)
				return FALSE
		if(BODY_ZONE_L_LEG)
			if(covered_parts & LEG_LEFT)
				return FALSE
		if(BODY_ZONE_PRECISE_GROIN)
			if(covered_parts & GROIN)
				return FALSE
		if(BODY_ZONE_CHEST)
			if(covered_parts & CHEST)
				return FALSE
		if(BODY_ZONE_PRECISE_R_HAND)
			if(covered_parts & HAND_RIGHT)
				return FALSE
		if(BODY_ZONE_PRECISE_L_HAND)
			if(covered_parts & HAND_LEFT)
				return FALSE
		if(BODY_ZONE_R_ARM)
			if(covered_parts & ARM_RIGHT)
				return FALSE
		if(BODY_ZONE_L_ARM)
			if(covered_parts & ARM_LEFT)
				return FALSE
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH)
			if(covered_parts & HEAD)
				return FALSE
	return TRUE

/proc/isfloor(turf/T)
	return (istype(T, /turf/open/floor))
