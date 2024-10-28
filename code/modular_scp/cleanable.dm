/obj/effect/decal/cleanable/blood/gibs/red

/obj/effect/decal/cleanable/mucus
	name = "mucus"
	desc = "Disgusting mucus."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "mucus"
	var/dry = FALSE

/obj/effect/decal/cleanable/mucus/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(set_dry)), DRYING_TIME * 2)

/obj/effect/decal/cleanable/mucus/proc/set_dry()
	dry = TRUE
