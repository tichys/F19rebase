/datum/plant/rainbow_bunch
	species = "rainbowbunch"
	name = "Polychromatic Flower"

	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_dead = "rainbowbunch-dead"
	icon_harvest = "rainbowbunch-harvest"
	growthstages = 4

	seed_path = /obj/item/seeds/rainbow_bunch
	product_path = /obj/item/food/grown/rainbow_flower
	base_harvest_yield = 3

	innate_genes = list(/datum/plant_gene/product_trait/preserved)

/obj/item/seeds/rainbow_bunch
	name = "pack of rainbow bunch seeds"
	desc = "A pack of seeds that'll grow into a beautiful bush of various colored flowers."
	icon_state = "seed-rainbowbunch"

	plant_type = /datum/plant/rainbow_bunch

/obj/item/food/grown/rainbow_flower
	plant_datum = /datum/plant/rainbow_bunch
	name = "rainbow flower"
	desc = "A beautiful flower capable of being used for most dyeing processes."
	icon_state = "map_flower"
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 3
	attack_verb_continuous = list("pompfs")
	attack_verb_simple = list("pompf")
	greyscale_config = /datum/greyscale_config/flower_simple
	greyscale_config_worn = /datum/greyscale_config/flower_simple_worn

/obj/item/food/grown/rainbow_flower/Initialize(mapload)
	. = ..()
	if(greyscale_colors)
		return

	var/flower_color = rand(1,8)
	switch(flower_color)
		if(1)
			set_greyscale("#c50b0b")
			reagents.add_reagent(/datum/reagent/colorful_reagent/powder/red, 3)
			dye_color = DYE_RED
			desc += " This one is in a bright red color."
		if(2)
			set_greyscale("#f76f07")
			reagents.add_reagent(/datum/reagent/colorful_reagent/powder/orange, 3)
			dye_color = DYE_ORANGE
			desc += " This one is in a citrus orange color."
		if(3)
			set_greyscale("#d8ce13")
			reagents.add_reagent(/datum/reagent/colorful_reagent/powder/yellow, 3)
			dye_color = DYE_YELLOW
			desc += " This one is in a bright yellow color."
		if(4)
			set_greyscale("#a0da23")
			reagents.add_reagent(/datum/reagent/colorful_reagent/powder/green, 3)
			dye_color = DYE_GREEN
			desc += " This one is in a grassy green color."
		if(5)
			set_greyscale("#0862c1")
			reagents.add_reagent(/datum/reagent/colorful_reagent/powder/blue, 3)
			dye_color = DYE_BLUE
			desc += " This one is in a soothing blue color."
		if(6)
			set_greyscale("#ad00cc")
			reagents.add_reagent(/datum/reagent/colorful_reagent/powder/purple, 3)
			dye_color = DYE_PURPLE
			desc += " This one is in a vibrant purple color."
		if(7)
			set_greyscale("#161616")
			reagents.add_reagent(/datum/reagent/colorful_reagent/powder/black, 3)
			dye_color = DYE_BLACK
			desc += " This one is in a midnight black color."
		if(8)
			set_greyscale("#FFFFFF")
			reagents.add_reagent(/datum/reagent/colorful_reagent/powder/white, 3)
			dye_color = DYE_WHITE
			desc += " This one is in a pure white color."
