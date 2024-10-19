/mob/living/proc/do_possession(mob/observer/possessor)

	if(!(istype(possessor) && possessor.ckey))
		return 0

	if(src.ckey || src.client)
		to_chat(possessor, SPAN_WARNING("\The [src] already has a player."))
		return 0

	//message_staff(SPAN_CLASS("adminnotice","[key_name_admin(possessor)] has taken control of \the [src]."))
	log_admin("[key_name(possessor)] took control of \the [src].")
	src.ckey = possessor.ckey
	qdel(possessor)

	/* too spooky for us
	if(round_is_spooky(6)) // Six or more active cultists.
		to_chat(src, SPAN_NOTICE("You reach out with tendrils of ectoplasm and invade the mind of \the [src]..."))
		to_chat(src, "<b>You have assumed direct control of \the [src].</b>")
		to_chat(src, SPAN_NOTICE("Due to the spookiness of the round, you have taken control of the poor animal as an invading, possessing spirit - roleplay accordingly."))
		src.universal_speak = TRUE
		src.universal_understand = TRUE
		//src.cultify() // Maybe another time.
		return
	*/
	to_chat(src, "<b>You are now \the [src]!</b>")
	return 1
