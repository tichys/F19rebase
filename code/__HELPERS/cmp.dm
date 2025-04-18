/proc/cmp_numeric_dsc(a,b)
	return b - a

/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_text_asc(a,b)
	return sorttext(b,a)

/proc/cmp_text_dsc(a,b)
	return sorttext(a,b)

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_name_or_type_asc(atom/a, atom/b)
	var/comp_a = a.name || "[a.type]"
	var/comp_b = b.name || "[b.type]"
	return sorttext(comp_b, comp_a)

GLOBAL_VAR_INIT(cmp_field, "name")
/proc/cmp_records_asc(datum/data/record/a, datum/data/record/b)
	return sorttext(b.fields[GLOB.cmp_field], a.fields[GLOB.cmp_field])

/proc/cmp_records_dsc(datum/data/record/a, datum/data/record/b)
	return sorttext(a.fields[GLOB.cmp_field], b.fields[GLOB.cmp_field])

// Datum cmp with vars is always slower than a specialist cmp proc, use your judgement.
/proc/cmp_datum_numeric_asc(datum/a, datum/b, variable)
	return cmp_numeric_asc(a.vars[variable], b.vars[variable])

/proc/cmp_datum_numeric_dsc(datum/a, datum/b, variable)
	return cmp_numeric_dsc(a.vars[variable], b.vars[variable])

/proc/cmp_datum_text_asc(datum/a, datum/b, variable)
	return sorttext(b.vars[variable], a.vars[variable])

/proc/cmp_datum_text_dsc(datum/a, datum/b, variable)
	return sorttext(a.vars[variable], b.vars[variable])

/proc/cmp_ckey_asc(client/a, client/b)
	return sorttext(b.ckey, a.ckey)

/proc/cmp_ckey_dsc(client/a, client/b)
	return sorttext(a.ckey, b.ckey)

/proc/cmp_playtime_asc(client/a, client/b)
	return cmp_numeric_asc(a.get_exp_living(TRUE), b.get_exp_living(TRUE))

/proc/cmp_playtime_dsc(client/a, client/b)
	return cmp_numeric_asc(a.get_exp_living(TRUE), b.get_exp_living(TRUE))

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return initial(b.init_order) - initial(a.init_order) //uses initial() so it can be used on types

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/proc/cmp_filter_data_priority(list/A, list/B)
	return A["priority"] - B["priority"]

/proc/cmp_timer(datum/timedevent/a, datum/timedevent/b)
	return a.timeToRun - b.timeToRun

/proc/cmp_ruincost_priority(datum/map_template/ruin/A, datum/map_template/ruin/B)
	return initial(A.cost) - initial(B.cost)

/proc/cmp_qdel_item_time(datum/qdel_item/A, datum/qdel_item/B)
	. = B.hard_delete_time - A.hard_delete_time
	if (!.)
		. = B.destroy_time - A.destroy_time
	if (!.)
		. = B.failures - A.failures
	if (!.)
		. = B.qdels - A.qdels

/proc/cmp_generic_stat_item_time(list/A, list/B)
	. = B[STAT_ENTRY_TIME] - A[STAT_ENTRY_TIME]
	if (!.)
		. = B[STAT_ENTRY_COUNT] - A[STAT_ENTRY_COUNT]

/proc/cmp_profile_avg_time_dsc(list/A, list/B)
	return (B[PROFILE_ITEM_TIME]/(B[PROFILE_ITEM_COUNT] || 1)) - (A[PROFILE_ITEM_TIME]/(A[PROFILE_ITEM_COUNT] || 1))

/proc/cmp_profile_time_dsc(list/A, list/B)
	return B[PROFILE_ITEM_TIME] - A[PROFILE_ITEM_TIME]

/proc/cmp_profile_count_dsc(list/A, list/B)
	return B[PROFILE_ITEM_COUNT] - A[PROFILE_ITEM_COUNT]

/proc/cmp_atom_layer_asc(atom/A,atom/B)
	if(A.plane != B.plane)
		return A.plane - B.plane
	else
		return A.layer - B.layer

/proc/cmp_advdisease_resistance_asc(datum/pathogen/advance/A, datum/pathogen/advance/B)
	return A.properties[PATHOGEN_PROP_RESISTANCE] - B.properties[PATHOGEN_PROP_RESISTANCE]

/proc/cmp_quirk_asc(datum/quirk/A, datum/quirk/B)
	var/a_sign = SIGN(initial(A.quirk_genre) * -1)
	var/b_sign = SIGN(initial(B.quirk_genre) * -1)

	var/a_name = initial(A.name)
	var/b_name = initial(B.name)

	if(a_sign != b_sign)
		return a_sign - b_sign
	else
		return sorttext(b_name, a_name)

/proc/cmp_job_display_asc(datum/job/A, datum/job/B)
	return GLOB.job_display_order.Find(A.type) - GLOB.job_display_order.Find(B.type)

/proc/cmp_department_display_asc(datum/job_department/A, datum/job_department/B)
	return A.display_order - B.display_order

/proc/cmp_reagents_asc(datum/reagent/a, datum/reagent/b)
	return sorttext(initial(b.name),initial(a.name))

/proc/cmp_typepaths_asc(A, B)
	return sorttext("[B]","[A]")

/proc/cmp_pdaname_asc(obj/item/modular_computer/A, obj/item/modular_computer/B)
	return sorttext(B?.saved_identification, A?.saved_identification)

/proc/cmp_pdajob_asc(obj/item/modular_computer/A, obj/item/modular_computer/B)
	return sorttext(B?.saved_job, A?.saved_job)

/proc/cmp_num_string_asc(A, B)
	return text2num(A) - text2num(B)

/proc/cmp_mob_realname_dsc(mob/A,mob/B)
	return sorttext(A.real_name,B.real_name)

/// Orders bodyparts by their body_part value, ascending.
/proc/cmp_bodypart_by_body_part_asc(obj/item/bodypart/limb_one, obj/item/bodypart/limb_two)
	return limb_one.body_part - limb_two.body_part

/// Orders bodyparts by how they should be shown to players in a UI
/proc/cmp_bodyparts_display_order(obj/item/bodypart/limb_one, obj/item/bodypart/limb_two)
	var/static/list/parts = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	return parts.Find(limb_one.body_zone) - parts.Find(limb_two.body_zone)

/// Orders by integrated circuit weight
/proc/cmp_port_order_asc(datum/port/compare1, datum/port/compare2)
	return compare1.order - compare2.order

/// Orders by uplink category weight
/proc/cmp_uplink_category_desc(datum/uplink_category/compare1, datum/uplink_category/compare2)
	return initial(compare2.weight) - initial(compare1.weight)

/**
 * Sorts crafting recipe requirements before the crafting recipe is inserted into GLOB.crafting_recipes
 *
 * Prioritises [/datum/reagent] to ensure reagent requirements are always processed first when crafting.
 * This prevents any reagent_containers from being consumed before the reagents they contain, which can
 * lead to runtimes and item duplication when it happens.
 */
/proc/cmp_crafting_req_priority(A, B)
	var/lhs
	var/rhs

	lhs = ispath(A, /datum/reagent) ? 0 : 1
	rhs = ispath(B, /datum/reagent) ? 0 : 1

	return lhs - rhs

/// Orders heretic knowledge by priority
/proc/cmp_heretic_knowledge(datum/heretic_knowledge/knowledge_a, datum/heretic_knowledge/knowledge_b)
	return initial(knowledge_b.priority) - initial(knowledge_a.priority)

///Orders R-UST fusion by priority
/proc/cmp_fusion_reaction_des(datum/fusion_reaction/A, datum/fusion_reaction/B)
	return B.priority - A.priority

/// Sort by plane, then by layer. Approximately BYOND rendering order.
/proc/cmp_zm_render_order(atom/A, atom/B)
	return (B.plane - A.plane) || (B.layer - A.layer)

/// Sort modules by priority
/proc/cmp_pref_modules(datum/preference_group/A, datum/preference_group/B)
	return B.priority - A.priority

/proc/cmp_pref_name(datum/preference/A, datum/preference/B)
	return sorttext(B.explanation, A.explanation)

/proc/cmp_loadout_name(datum/loadout_item/A, datum/loadout_item/B)
	return sorttext(B.name, A.name)

/// Orders designs by name
/proc/cmp_design_name(datum/design/A, datum/design/B)
	return sorttext(B.name, A.name)

/// Orders lists by the size of lists in their contents
/proc/cmp_list_length(list/A, list/B)
	return length(A) - length(B)

/// Orders codex entries by name alphabetically
/proc/cmp_codex_name(datum/codex_entry/a, datum/codex_entry/b)
	return sorttext(b.name, a.name)
