
///Takes a list of weakrefs and returns a list containing all the resolved weakrefs.
/proc/resolveWeakrefList(list/input_list)
	var/list/output_list = list()
	for(var/item in input_list)
		if(isweakref(item))
			var/datum/weakref/weakrefitem = item
			var/datum/D = weakrefitem.resolve()
			if(D)
				output_list += D
		else
			output_list += item
	return output_list
