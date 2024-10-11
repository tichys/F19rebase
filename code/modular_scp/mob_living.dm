/mob/living/carbon/human
	//Blink related vars
	var/blink_total					//The total amount of blink time a human is given
	var/blink_current				//The current amount of blink time a human has, when this reaches zero the human blinks
	var/is_blinking	= FALSE			//Whether blinking is enabled for a human
	var/list/blink_causers = list()	//What is causing the human to blink
