/// Called on `/atom/set_opacity` (/atom, old_opacity, new_opacity)
#define COMSIG_SET_OPACITY "set_opacity"

/atom/proc/SetName(new_name)
	var/old_name = name
	if(old_name != new_name)
		name = new_name

		//TODO: de-shitcodify
		if(has_extension(src, /datum/extension/labels))
			var/datum/extension/labels/L = get_extension(src, /datum/extension/labels)
			name = L.AppendLabelsToName(name)

/atom/movable/proc/dropInto(atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return forceMove(null)

/atom/proc/onDropInto(atom/movable/AM)
	return // If onDropInto returns null, then dropInto will forceMove AM into us.

/atom/movable/onDropInto(atom/movable/AM)
	return loc // If onDropInto returns something, then dropInto will attempt to drop AM there.
