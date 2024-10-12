/mob/living/carbon/human
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
