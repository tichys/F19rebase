// Helper procs for building detailed log lines
/datum/proc/get_log_info_line()
	return "[src] ([type]) ([REF(src)])"

/area/get_log_info_line()
	return "[..()] ([isnum(z) ? "[x],[y],[z]" : "0,0,0"])"

/turf/get_log_info_line()
	return "[..()] ([x],[y],[z]) ([loc ? loc.type : "NULL"])"

/atom/movable/get_log_info_line()
	var/turf/t = get_turf(src)
	return "[..()] ([t ? t : "NULL"]) ([t ? "[t.x],[t.y],[t.z]" : "0,0,0"]) ([t ? t.type : "NULL"])"

/mob/get_log_info_line()
	return ckey ? "[..()] ([ckey])" : ..()

/proc/log_info_line(datum/d)
	if(isnull(d))
		return "*null*"
	if(islist(d))
		var/list/L = list()
		for(var/e in d)
			// Indexing on numbers just gives us the same number again in the best case and causes an index out of bounds runtime in the worst
			var/v = isnum(e) ? null : d[e]
			L += "[log_info_line(e)][v ? " - [log_info_line(v)]" : ""]"
		return "\[[jointext(L, ", ")]\]" // We format the string ourselves, rather than use json_encode(), because it becomes difficult to read recursively escaped "
	if(!istype(d))
		return json_encode(d)
	return d.get_log_info_line()
