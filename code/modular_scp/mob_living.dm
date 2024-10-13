/mob/living/carbon/human
	var/visual_insulation = V_INSL_NONE		// How much your eyes are insulated, I.E how blinded you are. Different from tint in that insulation does not always mean your view is physically obstructed.
	var/audible_insulation = A_INSL_NONE	// How much your ears are insulated, I.E how deafened you are.

	//Blink related vars
	var/blink_total					//The total amount of blink time a human is given
	var/blink_current				//The current amount of blink time a human has, when this reaches zero the human blinks
	var/is_blinking	= FALSE			//Whether blinking is enabled for a human
	var/list/blink_causers = list()	//What is causing the human to blink
	var/atom/movable/screen/fov/fov = null//The screen object because I can't figure out how the hell TG does their screen objects so I'm just using legacy code.
	var/atom/movable/screen/fov/fov_mask/fov_mask
	var/usefov = 1
	///Stage Handler (so we dont have a billion vars for scps)
	var/datum/stageHandler/humanStageHandler = new /datum/stageHandler()

/mob/proc/is_invisible_to(mob/viewer)
	return (!alpha || !mouse_opacity || viewer.see_invisible < invisibility)

/*
  PLANE MASTERS
*/

/atom/movable/screen/plane_master
	appearance_flags = PLANE_MASTER
	screen_loc = "CENTER"
	globalscreen = 1

/atom/movable/screen/plane_master/ghost_master
	plane = OBSERVER_PLANE

/atom/movable/screen/plane_master/ghost_dummy
	// this avoids a bug which means plane masters which have nothing to control get angry and mess with the other plane masters out of spite
	alpha = 0
	appearance_flags = 0
	plane = OBSERVER_PLANE

GLOBAL_LIST_INIT(ghost_master, list(
	new /atom/movable/screen/plane_master/ghost_master(),
	new /atom/movable/screen/plane_master/ghost_dummy()
))

/atom/movable/screen/plane_master/effects_planemaster
	appearance_flags = PLANE_MASTER | KEEP_TOGETHER
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/effects_planemaster/openspace/Initialize()
	. = ..()
	add_filter("openspace_blur", 0, list(type = "blur", size = 0.6))

/atom/movable/screen/plane_master/vision_cone_target
	name = "vision cone master"
	plane = HIDDEN_PLANE
	render_target = "vision_cone_target"

/atom/movable/screen/plane_master/vision_cone/primary/Initialize() //Things to hide
	. = ..()
	add_filter("vision_cone", 50, list(type="alpha", render_source="vision_cone_target", flags=MASK_INVERSE))

/atom/movable/screen/plane_master/vision_cone/inverted/Initialize() //Things to show in hidden section
	. = ..()
	add_filter("inverted_vision_cone", 50, list(type="alpha", render_source="vision_cone_target"))

/mob/living/carbon/human/InitializePlanes()
	..()
	var/atom/movable/screen/plane_master/vision_cone_target/VC = new
	var/atom/movable/screen/plane_master/vision_cone/primary/mob = new
	var/atom/movable/screen/plane_master/vision_cone/inverted/sounds = new


	//define what planes the masters dictate.
	mob.plane = MOB_PLANE
	sounds.plane = INSIDE_VISION_CONE_PLANE

	client.screen += VC
	client.screen += mob
	client.screen += sounds
