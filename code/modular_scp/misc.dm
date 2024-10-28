/mob/proc/setClickCooldown(timeout)
	next_move = max(world.time + (timeout * next_move_modifier), next_move)

/datum/species/proc/handle_post_spawn(mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	populate_features()


/mob/proc/format_emote(emoter = null, message = null)
	var/pretext
	var/subtext
	var/nametext
	var/end_char
	var/start_char
	var/name_anchor
	var/anchor_char = get_prefix_key(/decl/prefix/visible_emote)

	if(!message || !emoter)
		return

	message = html_decode(message)

	name_anchor = findtext(message, anchor_char)
	if(name_anchor > 0) // User supplied emote with visible_emote token (default ^)
		pretext = copytext(message, 1, name_anchor)
		subtext = copytext(message, name_anchor + 1, length(message) + 1)
	else
		// No token. Just the emote as usual.
		subtext = message

	// Oh shit, we got this far! Let's see... did the user attempt to use more than one token?
	if(findtext(subtext, anchor_char))
		// abort abort!
		to_chat(emoter, SPAN_WARNING("You may use only one \"[anchor_char]\" symbol in your emote."))
		return

	if(pretext)
		// Add a space at the end if we didn't already supply one.
		end_char = copytext(pretext, length(pretext), length(pretext) + 1)
		if(end_char != " ")
			pretext += " "

	// Grab the last character of the emote message.
	end_char = copytext(subtext, length(subtext), length(subtext) + 1)
	if(!(end_char in list(".", "?", "!", "\"", "-", "~"))) // gotta include ~ for all you fucking weebs
		// No punctuation supplied. Tack a period on the end.
		subtext += "."

	// Add a space to the subtext, unless it begins with an apostrophe or comma.
	if(subtext != ".")
		// First, let's get rid of any existing space, to account for sloppy emoters ("X, ^ , Y")
		subtext = trim_left(subtext)
		start_char = copytext(subtext, 1, 2)
		if(start_char != "," && start_char != "'")
			subtext = " " + subtext

	pretext = capitalize(html_encode(pretext))
	nametext = html_encode(nametext)
	subtext = html_encode(subtext)
	// Store the player's name in a nice bold, naturalement
	nametext = "<B>[emoter]</B>"
	return pretext + nametext + subtext

/mob/proc/custom_emote(message = null)

	if((usr && stat))
		to_chat(src, "You are unable to emote.")
		return

	var/input
	if(!message)
		input = sanitize(input(src,"Choose an emote to display.") as text|null)
	else
		input = message

	if(input)
		message = format_emote(src, message)
	else
		return
	message = parsemarkdown_basic_step1(message)
	if (message)
		log_emote("[name]/[key] : [message]")

/mob/proc/drop_from_inventory(obj/item/W, atom/target = null)
	if(W)
		remove_from_mob(W, target)
		if(!(W?.loc)) return 1 // self destroying objects (tk, grabs)
		update_icons()
		return 1
	return 0

//Attemps to remove an object on a mob.
/mob/proc/remove_from_mob(obj/O, atom/target)
	if(!O) // Nothing to remove, so we succeed.
		return 1
	src.dropItemToGround(O)
	if (src.client)
		src.client.screen -= O
	O.reset_plane_and_layer()
	O.screen_loc = null
	if(istype(O, /obj/item))
		var/obj/item/I = O
		if(target)
			I.forceMove(target)
		else
			I.dropInto(loc)
		I.dropped(src)
	return 1

/mob/proc/get_prefix_key(prefix_type)


// Open everything and then kill APC
/area/proc/full_breach()
	for(var/obj/machinery/door/temp_door in src)
		if(istype(temp_door, /obj/machinery/door/poddoor))
			var/obj/machinery/door/poddoor/BD = temp_door
			INVOKE_ASYNC(BD, TYPE_PROC_REF(/obj/machinery/door/poddoor, open))
			continue
		temp_door.open(TRUE) // Forced
	for(var/obj/machinery/power/apc/temp_apc in src)
		temp_apc.energy_fail(30 SECONDS)


/proc/is_dark(turf/T, darkness_threshold = 0.03)
	if(T.get_lumcount() <= darkness_threshold)
		return TRUE
	return FALSE


/*
	List generation helpers
*/

/proc/get_turfs_in_range(turf/center, range, list/predicates)
	. = list()

	if (!istype(center))
		return

	for (var/turf/T in trange(range, center))
		if (!predicates || all_predicates_true(list(T), predicates))
			. += T

/proc/pick_turf_in_range(turf/center, range, list/turf_predicates)
	var/list/turfs = get_turfs_in_range(center, range, turf_predicates)
	if (length(turfs))
		return pick(turfs)
