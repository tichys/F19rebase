/mob/living/simple_animal/friendly/scp131
	name = "eyepod"
	desc = "A teardrop-shaped creature roughly one foot in height, with a wheel-like protrusion beneath. It stares at things with its curious unblinking eye."
	icon = 'icons/SCP/scp-131.dmi'

	icon_state = "SCP-131A"
	maxHealth = 150
	health = 150

	turns_per_move = 5
	see_in_dark = 6

	response_help_simple  = "plays with"
	response_disarm_simple = "gently nudges aside"
	response_harm_simple   = "kicks"

	see_in_dark = 7

	//Config

	///How long can 131 be seperated from its friend before becoming disinterested
	var/acceptable_seperation_time = 2 MINUTES
	///Panic visual message cooldown
	var/panic_message_cooldown = 2 SECONDS

	//Mechanical
	///Our current friend
	var/mob/living/carbon/human/friend
	///Last time we saw our friend
	var/friend_last_seen
	///ref to remove friend timer to avoid having duplicates
	var/delfriend_timer
	///Last time we sent the panic message
	var/panic_message_time

/mob/living/simple_animal/friendly/scp131/Initialize()
	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"eyepod", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_SAFE, //Obj Class
		"131", //Numerical Designation
	)

	SCP.min_time = 5 MINUTES
	return ..()

/mob/living/simple_animal/friendly/scp131/Destroy()
	. = ..()
	remove_friend()

/mob/living/simple_animal/friendly/scp131/scp131A
	name = "SCP-131-A"
	icon_state = "SCP-131A"

/mob/living/simple_animal/friendly/scp131/scp131A/Initialize()
	. = ..()
	SCP.designation = "131-A"

/mob/living/simple_animal/friendly/scp131/scp131B
	name = "SCP-131-B"
	icon_state = "SCP-131B"

/mob/living/simple_animal/friendly/scp131/scp131B/Initialize()
	. = ..()
	SCP.designation = "131-B"

// AI Stuff

/datum/say_list/scp131
	var/emote_hear = list("babbles")

/datum/ai_holder/simple_animal/passive/scp131

// Mechanics

/mob/living/simple_animal/friendly/scp131/proc/update_friend(mob/living/carbon/human/new_friend)
	if(!istype(new_friend))
		return
	if(friend)
		return
	friend = new_friend

/mob/living/simple_animal/friendly/scp131/proc/remove_friend()
	friend = null

///Allows 131 to panic when its friend is injured or when a hostile scp is in sight.
/mob/living/simple_animal/friendly/scp131/proc/panic()
	if(friend && can_see(friend))
		while(get_dist(src, friend) > 1)
			step_towards(src, friend)
		if((world.time - panic_message_time) > panic_message_cooldown)
			panic_message_time = world.time
	else
		if((world.time - panic_message_time) > panic_message_cooldown)
			emote("babbles rapidly in a panicked tone")
			panic_message_time = world.time

// Overrides

/mob/living/simple_animal/friendly/scp131/Life()
	. = ..()

	if(friend)
		if(can_see(friend))
			friend_last_seen = world.time
		else if((world.time - friend_last_seen) > acceptable_seperation_time)
			remove_friend()
			return

		if(friend.stat != CONSCIOUS)
			panic()
			if(!delfriend_timer && (friend.stat == DEAD))
				delfriend_timer = addtimer(CALLBACK(src, PROC_REF(remove_friend)), 1 MINUTE)
			return

	for(var/atom/scpInView in GLOB.SCP_list)
		if(!can_see(scpInView))
			continue
		if(scpInView.SCP.classification == SCP_SAFE)
			continue

		if((isscp173(scpInView)) && friend && can_see(friend))
			face_atom(scpInView)
			return
		else
			panic()
			return

/mob/living/simple_animal/friendly/scp131/attack_hand(mob/living/carbon/human/M)
	if(M.istate == INTENT_HARM)
		if(prob(65) && !friend)
			update_friend(M)
			face_atom(M)
			emote(pick("whirls around [M]'s legs", "nudges [M] playfully", "rolls around near [M]", "stares briefly up at [M]", "seems to follow [M]'s gaze."))
		else if(friend && (M == friend))
			emote(pick("whirls around [M]'s legs", "nudges [M] playfully", "rolls around near [M]", "stares briefly up at [M]", "seems to follow [M]'s gaze."))
		else
			to_chat(M, SPAN_NOTICE("[src] seems to ignore you."))
	else if((M.istate == INTENT_HARM) && (M == friend))
		remove_friend()
	. = ..()
