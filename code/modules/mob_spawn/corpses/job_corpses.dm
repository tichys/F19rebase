
//jobs from ss13 but DEAD.

/obj/effect/mob_spawn/corpse/human/logistics_technician
	name = "Logistics Technican"
	outfit = /datum/outfit/job/logistics_technician
	icon_state = "corpsecargotech"

/obj/effect/mob_spawn/corpse/human/cook
	name = "Cook"
	outfit = /datum/outfit/job/cook
	icon_state = "corpsecook"

/obj/effect/mob_spawn/corpse/human/medical_doctor
	name = "Doctor"
	outfit = /datum/outfit/job/medical_doctor
	icon_state = "corpsedoctor"

/obj/effect/mob_spawn/corpse/human/engineer
	name = "Engineer"
	outfit = /datum/outfit/job/engineer
	icon_state = "corpseengineer"

/obj/effect/mob_spawn/corpse/human/engineer/mod
	outfit = /datum/outfit/job/engineer/mod

/obj/effect/mob_spawn/corpse/human/clown
	name = JOB_CLOWN
	outfit = /datum/outfit/job/clown
	icon_state = "corpseclown"

/obj/effect/mob_spawn/corpse/human/miner
	name = JOB_LOGISTICS_TECHNICIAN
	outfit = /datum/outfit/job/miner
	icon_state = "corpseminer"

/obj/effect/mob_spawn/corpse/human/miner/mod
	outfit = /datum/outfit/job/miner/equipped/mod

/obj/effect/mob_spawn/corpse/human/miner/explorer
	outfit = /datum/outfit/job/miner/equipped

/obj/effect/mob_spawn/corpse/human/plasmaman
	mob_species = /datum/species/plasmaman
	outfit = /datum/outfit/plasmaman

/obj/effect/mob_spawn/corpse/human/assistant
	name = JOB_ASSISTANT
	outfit = /datum/outfit/job/assistant
	icon_state = "corpsegreytider"

/obj/effect/mob_spawn/corpse/human/assistant/beesease_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.ForceContractDisease(new /datum/disease/beesease)

/obj/effect/mob_spawn/corpse/human/assistant/brainrot_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.ForceContractDisease(new /datum/disease/brainrot)

/obj/effect/mob_spawn/corpse/human/assistant/spanishflu_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.ForceContractDisease(new /datum/disease/fluspanish)
