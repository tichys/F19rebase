/obj/item/clothing/mask/cigarette/scp013
	name = "'Blue Lady' cigarette"
	desc = "The words 'Blue Lady' are written on this deftly-rolled cigarette in blue ink."

	smoketime = 24 HOURS //dont want this going out before anyone undergoing the effects is finished

	//Config
	///Our callback messages to the affected individual that happen from time to time
	var/list/blmessages = list(
		"I miss her...",
		"Where did she go...",
		"You spot a glimpse of her in a nearby reflection...",
		"I know her I just can't remember...",
		"I love her... Where did she go?"
	)
	//Mechanical

	///Humans who have smoked 013, helps us prevent it from extinguishing if someone is still undergoing the effects
	var/list/affected_weakref

/obj/item/clothing/mask/cigarette/scp013/Initialize()
	. = ..()
	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"'Blue Lady' cigarette", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_SAFE, //Obj Class
		"013", //Numerical Designation
	)

	LAZYINITLIST(affected_weakref)

//Mechanics

/obj/item/clothing/mask/cigarette/scp013/proc/effect(mob/living/carbon/human/H)
	if(!lit)
		return
	if(H.humanStageHandler.createStage("BlueLady"))
		update_013_status(H)
		LAZYOR(affected_weakref,WEAKREF(H))

/obj/item/clothing/mask/cigarette/scp013/proc/update_013_status(mob/living/carbon/human/H)
	H.humanStageHandler.adjustStage("BlueLady", 1)
	switch(H.humanStageHandler.getStage("BlueLady"))
		if(1)
			to_chat(H, span_boldnotice("You can't remember what you did this morning, or the day before..."))
			addtimer(CALLBACK(src, PROC_REF(update_013_status), H), 2 MINUTES)
		if(2)
			to_chat(H, span_boldnotice("You remember now, you were looking in the mirror as you painted your lips blue."))
			addtimer(CALLBACK(src, PROC_REF(update_013_status), H), 1 MINUTES)
			H.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/one_person, "bluelady", get_bluelady_image(H), H)
		if(3)
			to_chat(H, span_boldnotice("Briefly, she fades from your mind. You miss her already."))
			addtimer(CALLBACK(src, PROC_REF(update_013_status), H), 2 MINUTE)
			H.remove_alt_appearance("bluelady")
		if(4)
			to_chat(H, span_boldnotice("You put the blue dress on, that's all you can recall. How did you get here?"))
			addtimer(CALLBACK(src, PROC_REF(update_013_status), H), 3 MINUTE)
			H.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/one_person, "bluelady", get_bluelady_image(H), H)
		if(5)
			to_chat(H, span_boldnotice("Who were you? You try to remember in more detail..."))
			addtimer(CALLBACK(src, PROC_REF(update_013_status), H), 1 MINUTE)
		if(6)
			to_chat(H, span_boldnotice("I can't live without her..."))
			addtimer(CALLBACK(src, PROC_REF(update_013_status), H), 55 SECONDS)
		if(7)
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, bluelady_message), blmessages), 10 SECONDS)
			LAZYREMOVE(affected_weakref, WEAKREF(H))
			if(!LAZYLEN(affected_weakref))
				put_out(H)

/obj/item/clothing/mask/cigarette/scp013/proc/get_bluelady_image(mob/living/carbon/human/H)
	var/image/I = image('icons/mob/human_parts_greyscale.dmi', H, "human_chest_f")
	I.override = 1
	I.add_overlay(image('icons/mob/human_parts_greyscale.dmi', H, "human_r_arm"))
	I.add_overlay(image('icons/mob/human_parts_greyscale.dmi', H, "human_l_arm"))
	I.add_overlay(image('icons/mob/human_parts_greyscale.dmi', H, "human_r_hand"))
	I.add_overlay(image('icons/mob/human_parts_greyscale.dmi', H, "human_l_hand"))
	I.add_overlay(image('icons/mob/human_parts_greyscale.dmi', H, "human_r_leg"))
	I.add_overlay(image('icons/mob/human_parts_greyscale.dmi', H, "human_l_leg"))
	I.add_overlay(image('icons/scp/scp-013-overlay.dmi', H, "bl_head"))

	var/image/hair = image('icons/mob/hair.dmi', icon_state = "hair_emofringe")
	hair.color = "#15120e"
	I.add_overlay(hair)
	I.add_overlay(image('icons/scp/scp-013-overlay.dmi', icon_state = "lady_in_blue_u"))
	I.add_overlay(image('icons/scp/scp-013-overlay.dmi', icon_state = "blue_heels"))

	return I

//Overrides

/obj/item/clothing/mask/cigarette/scp013/light(flavor_text = null)
	. = ..()
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/H = loc
	if(H.get_slot_by_item(src) != ITEM_SLOT_MASK)
		return
	effect(H)

/obj/item/clothing/mask/cigarette/scp013/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_MASK || !ishuman(user))
		return
	effect(user)

/obj/item/clothing/mask/cigarette/use_reagents(mob/living/carbon/user, drag)
	reagents.add_reagent_list(list_reagents) //infinite smoking chems
	return ..()

/obj/item/clothing/mask/cigarette/put_out(mob/user, done_early = FALSE)
	if(done_early)
		if(user)
			to_chat(user, span_notice("You cant bring yourself to put it out..."))
		return
	return ..()

//Human mechanics

/mob/living/carbon/human/proc/bluelady_message(blmessages) //This is needed since once the cigarette goes out it is no longer an instance of 013 (and callbacks dont work)
	if(!humanStageHandler.getStage("BlueLady")) //shouldent happen, but if admins do some fuckery with stages mid game then this will account for it
		return
	if(prob(15))
		to_chat(src, span_boldnotice(pick(blmessages)))
	addtimer(CALLBACK(src, PROC_REF(bluelady_message), blmessages), 45 SECONDS)

//Cigarrete Pack

/obj/item/storage/fancy/cigarettes/bluelady
	name = "Pack of 'Blue Lady' cigarettes"
	icon_state = "bl"
	base_icon_state = "bl"
	desc = "A packet of six Blue Lady cigarettes. The SCP logo is stamped on the paper."

	spawn_type = /obj/item/clothing/mask/cigarette/scp013
