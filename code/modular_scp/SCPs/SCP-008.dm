/datum/reagent/scp008
	name = "008 Prions"
	description = "An oily substance which slowly churns of its own accord."
	taste_description = "decaying blood"
	color = "#540000"
	taste_mult = 5
	/* WE dont need this do we?
	metabolism = REM
	overdose = 200
	hidden_from_codex = TRUE
	heating_products = null
	heating_point = null
	should_admin_log = TRUE
	*/

	var/list/zombie_messages = list(
	"stage1" = list(
		"You feel uncomfortably warm.",
		"You feel rather feverish.",
		"Your throat is extremely dry...",
		"Your muscles cramp...",
		"You feel dizzy.",
		"You feel slightly fatigued.",
		"You feel light-headed."
	),
	"stage2" = list(
		"You feel something under your skin!",
		"Mucus runs down the back of your throat",
		"Your muscles burn.",
		"Your skin itches.",
		"Your bones ache.",
		"Sweat runs down the side of your neck.",
		"Your heart races."
	),
	"stage3" = list(
		"Your head feels like it's splitting open!",
		"Your skin is peeling away!",
		"Your body stings all over!",
		"It feels like your insides are squirming!",
		"You're in agony!"
	)
)

/datum/reagent/scp008/affect_blood(mob/living/carbon/M, alien, removed)
	if (!ishuman(M))
		return
	var/mob/living/carbon/human/H = M

	if (!(H.species.name in GLOB.zombie_species) || isspecies(H, SPECIES_DIONA) || H.isSynthetic())
		remove_self(volume)
		return
	var/true_dose = H.chem_doses[type] + volume

	if(!M.SCP)
		var/SCP008_instance_count = 1
		for(var/mob/living/carbon/human/instance in GLOB.SCP_list)
			if(isspecies(instance, SPECIES_ZOMBIE))
				SCP008_instance_count++

		M.SCP = new /datum/scp(
		M, // Ref to actual SCP atom
		"", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_EUCLID, //Obj Class
		"008-[SCP008_instance_count]", //Numerical Designation
		SCP_PLAYABLE
	)

	if (true_dose >= 30)
		if (M.getBrainLoss() > 140)
			H.zombify()
		if (prob(1))
			to_chat(M, SPAN_WARNING("<font style='font-size:[rand(1,2)]'>[pick(zombie_messages["stage1"])]</font>"))

	if (true_dose >= 60)
		M.bodytemperature += 7.5
		if (prob(3))
			to_chat(M, SPAN_WARNING("<font style='font-size:2'>[pick(zombie_messages["stage1"])]</font>"))
		if (M.getBrainLoss() < 20)
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1, 2))

	if (true_dose >= 90)
		M.hallucinating(50, min(true_dose / 2, 50))
		if (M.getBrainLoss() < 75)
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1, 2))
		if (prob(0.5))
			H.shake_animation()
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(12, 24))
		if (prob(5))
			to_chat(M, SPAN_DANGER("<font style='font-size:[rand(2,3)]'>[pick(zombie_messages["stage2"])]</font>"))
		M.bodytemperature += 9

	if (true_dose >= 110)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
		M.adjust_dizzy(10 SECONDS)
		if (prob(8))
			to_chat(M, SPAN_DANGER("<font style='font-size:[rand(3,4)]'>[pick(zombie_messages["stage3"])]</font>"))

	if (true_dose >= 135)
		if (prob(3))
			H.zombify()

	M.reagents.add_reagent(/datum/reagent/scp008, rand(1.5, 3.5))

/datum/reagent/scp008/affect_touch(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed * 0.5)


/mob/living/carbon/human/proc/zombify()
	if (!isspecies(src, SPECIES_ZOMBIE))
		return

	var/turf/T = get_turf(src)
	new /obj/effect/decal/cleanable/vomit(T)
	playsound(T, 'sounds/effects/splat.ogg', 20, 1)

	addtimer(CALLBACK(src, PROC_REF(transform_zombie)), 20)

/mob/living/carbon/human/proc/transform_zombie()
	adjust_jitter(30 SECONDS)
	adjustBruteLoss(100)
	sleep(150)

	if (QDELETED(src))
		return

	if (isspecies(src, SPECIES_ZOMBIE)) //Check again otherwise Consume can run this twice at once
		return

	ChangeToHusk()
	visible_message(SPAN_DANGER("\The [src]'s skin decays before your very eyes!"), SPAN_DANGER("Your entire body is ripe with pain as it is consumed down to flesh and bones. You ... hunger. Not only for flesh, but to spread this gift. Use Abilities -> Consume to infect and feed upon your prey."))
	log_admin("[key_name(src)] has transformed into a zombie!")

	Stun(4)
	set_dizzy(0)

	resuscitate()
	set_stat(CONSCIOUS)


	species = all_species[SPECIES_ZOMBIE]
	species.handle_post_spawn(src)

	var/turf/T = get_turf(src)
