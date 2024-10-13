/atom/movable/screen/fov
	icon = 'icons/mob/hide.dmi'
	icon_state = "combat"
	screen_loc = "1,1"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = VISION_CONE_PLANE
	var/view

/atom/movable/screen/fov/New(loc, size)
	..()
	update_size(size)

/atom/movable/screen/fov/proc/update_size(size)
	if(view == size)
		return
	view = size

	// Unfortunately, our vision cone icon is from the southwest of screen.
	// This causes us to have to translate it (not just scale) unlike other fullscreen overlays.
	var/list/actual_size = getviewsize(size)
	var/x_translation = (actual_size[1] - 15) * world.icon_size / 2
	var/y_translation = (actual_size[2] - 15) * world.icon_size / 2
	transform = matrix(actual_size[1] / 15, 0, x_translation, 0, actual_size[2] / 15, y_translation)

/atom/movable/screen/fov/fov_mask
	icon = 'icons/mob/hide.dmi'
	icon_state = "combat_mask_alt"
	screen_loc = "1,1"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	//plane = HIDDEN_PLANE
