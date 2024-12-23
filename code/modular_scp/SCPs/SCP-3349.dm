// ACTIVITY

/mob/living/carbon/human/proc/handle_3349(mob/living/carbon/H)
	var/obj/item/organ/heart/heart = H.getorganslot(ORGAN_SLOT_HEART)
	if(stat == DEAD)
		heart.SCP.Destroy()
		UnregisterSignal(src, COMSIG_CARBON_LIFE)
	else
		if(heart.SCP.designation == "3349-1")
			if(prob(0.75))		// about 2-5 minutes after starting, it ends.
				heart.SCP.Destroy()
				to_chat(src, SPAN_INFO("The euphoric sensation ends."))
			/* For sanity system later
			if(prob(20))
				adjustSanityLoss(-1)	// the sensation is comforting
			*/
			if(prob(10))
				stamina.adjust(-1)		// little harder to run though
		else
			if(prob(0.1))	// takes a good 20-30 minutes on average, probably
				heart.SCP = new /datum/scp(
					src, // Ref to actual SCP atom
					"", //Name (Should not be the scp desg, more like what it can be described as to viewers)
					SCP_KETER, //Obj Class
					"3349-1" //Numerical Designation
				)
				to_chat(src, SPAN_INFO("You feel a sudden euphoric sensation!"))

// SETUP

GLOBAL_VAR(scp3349_precedent)
GLOBAL_VAR(scp3349_fake_precedent)

/proc/initialize_scp3349_precedents()

	// common medicines
	var/list/reagents = list(
		/datum/reagent/medicine/inaprovaline,
		/datum/reagent/medicine/kelotane,
		/datum/reagent/medicine/dylovene,
		/datum/reagent/medicine/dexalin
	)

	GLOB.scp3349_precedent = pick_n_take(reagents)
	GLOB.scp3349_fake_precedent = pick_n_take(reagents)

// PAPER

/obj/item/paper/scp3349_ekg
	color = COLOR_OFF_WHITE
