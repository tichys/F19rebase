var/decl/appearance_manager/appearance_manager = new()

/decl/appearance_manager
	var/list/appearances_
	var/list/appearance_handlers_

/decl/appearance_manager/New()
	..()
	appearances_ = list()
	appearance_handlers_ = list()
	for(var/entry in subtypesof(/decl/appearance_handler))
		appearance_handlers_[entry] += new entry()

/decl/appearance_manager/proc/get_appearance_handler(handler_type)
	return appearance_handlers_[handler_type]

/decl/appearance_manager/proc/add_appearance(mob/viewer, datum/appearance_data/ad)
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		pq = new/PriorityQueue(GLOBAL_PROC_REF(cmp_appearance_data))
		appearances_[viewer] = pq
		RegisterSignal(viewer, COMSIG_MOB_LOGIN, TYPE_PROC_REF(/decl/appearance_manager, apply_appearance_images))
		RegisterSignal(viewer, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/decl/appearance_manager, remove_appearances))
	pq.Enqueue(ad)
	reset_appearance_images(viewer)

/decl/appearance_manager/proc/remove_appearance(mob/viewer, datum/appearance_data/ad, refresh_images)
	var/PriorityQueue/pq = appearances_[viewer]
	pq.Remove(ad)
	if(viewer.client)
		viewer.client.images -= ad.images
	if(!pq.Length())
		UnregisterSignal(viewer, COMSIG_MOB_LOGIN)
		UnregisterSignal(viewer, COMSIG_PARENT_QDELETING)
		appearances_ -= viewer

/decl/appearance_manager/proc/remove_appearances(mob/viewer)
	var/PriorityQueue/pq = appearances_[viewer]
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		ad.RemoveViewer(viewer, FALSE)
	appearances_[viewer] -= viewer

/decl/appearance_manager/proc/reset_appearance_images(mob/viewer)
	clear_appearance_images(viewer)
	apply_appearance_images(viewer)

/decl/appearance_manager/proc/clear_appearance_images(mob/viewer)
	if(!viewer.client)
		return
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		return
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		viewer.client.images -= ad.images

/decl/appearance_manager/proc/apply_appearance_images(mob/viewer)
	if(!viewer.client)
		return
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		return
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		viewer.client.images |= ad.images


/datum/appearance_data
	var/priority
	var/list/images
	var/list/viewers

/datum/appearance_data/New(images, viewers, priority)
	..()
	src.priority = priority
	src.images = images
	src.viewers = list()
	for(var/viewer in viewers)
		AddViewer(viewer, FALSE)

/datum/appearance_data/Destroy()
	for(var/viewer in viewers)
		RemoveViewer(viewer)
	src.images = null
	src.viewers = null
	. = ..()

/datum/appearance_data/proc/AddViewer(mob/viewer, check_if_viewer = TRUE)
	if(check_if_viewer && (viewer in viewers))
		return FALSE
	if(!istype(viewer))
		return FALSE
	viewers |= viewer
	appearance_manager.add_appearance(viewer, src)
	return TRUE

/datum/appearance_data/proc/RemoveViewer(mob/viewer, refresh_images = TRUE)
	if(!(viewer in viewers))
		return FALSE
	viewers -= viewer
	appearance_manager.remove_appearance(viewer, src, refresh_images)
	return TRUE


/decl/appearance_handler
	var/priority = 15
	var/list/appearance_sources

/decl/appearance_handler/New()
	..()
	appearance_sources = list()

/decl/appearance_handler/proc/AddAltAppearance(source, list/images, list/viewers = list())
	if(source in appearance_sources)
		return FALSE
	appearance_sources[source] = new/datum/appearance_data(images, viewers, priority)
	RegisterSignal(source, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/decl/appearance_handler, RemoveAltAppearance))

/decl/appearance_handler/proc/RemoveAltAppearance(source)
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		UnregisterSignal(source, COMSIG_PARENT_QDELETING)
		appearance_sources -= source
		qdel(ad)

/decl/appearance_handler/proc/DisplayAltAppearanceTo(source, viewer)
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		ad.AddViewer(viewer)

/decl/appearance_handler/proc/DisplayAllAltAppearancesTo(viewer)
	for(var/entry in appearance_sources)
		DisplayAltAppearanceTo(entry, viewer)
