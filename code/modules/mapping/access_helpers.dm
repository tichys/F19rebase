/obj/effect/mapping_helpers/airlock/access
	layer = DOOR_HELPER_LAYER
	icon_state = "access_helper"

// These are mutually exclusive; can't have req_any and req_all
/obj/effect/mapping_helpers/airlock/access/any/payload(obj/machinery/door/airlock/airlock)
	if(airlock.req_access_txt == "0")
		var/list/access_list = get_access()
		// Overwrite if there is no access set, otherwise add onto existing access
		if(airlock.req_one_access_txt == "0")
			airlock.req_one_access_txt = access_list.Join(";")
		else
			airlock.req_one_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_one_access, but req_access was already set!")

/obj/effect/mapping_helpers/airlock/access/all/payload(obj/machinery/door/airlock/airlock)
	if(airlock.req_one_access_txt == "0")
		var/list/access_list = get_access()
		if(airlock.req_access_txt == "0")
			airlock.req_access_txt = access_list.Join(";")
		else
			airlock.req_access_txt += ";[access_list.Join(";")]"
	else
		log_mapping("[src] at [AREACOORD(src)] tried to set req_access, but req_one_access was already set!")

/obj/effect/mapping_helpers/airlock/access/proc/get_access()
	var/list/access = list()
	return access

// -------------------- Req Any (Only requires ONE of the given accesses to open)

// -------------------- Security Access Helpers

/obj/effect/mapping_helpers/airlock/access/any/security
	icon_state = "access_helper_sec"

/obj/effect/mapping_helpers/airlock/access/any/security/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/security/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/security/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/security/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/security/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL5
	return access_list

// -------------------- Administration Access Helpers

/obj/effect/mapping_helpers/airlock/access/any/admin
	icon_state = "access_helper_com"

/obj/effect/mapping_helpers/airlock/access/any/admin/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL5
	return access_list

// -------------------- Science Access Helpers

/obj/effect/mapping_helpers/airlock/access/any/science
	icon_state = "access_helper_sci"

/obj/effect/mapping_helpers/airlock/access/any/science/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/science/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/science/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/science/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/science/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL5
	return access_list

// -------------------- Medical Access Helpers

/obj/effect/mapping_helpers/airlock/access/any/medical
	icon_state = "access_helper_med"

/obj/effect/mapping_helpers/airlock/access/any/medical/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/medical/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/medical/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/medical/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/medical/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL5
	return access_list

// -------------------- Engineering access helpers

/obj/effect/mapping_helpers/airlock/access/any/engineering
	icon_state = "access_helper_eng"

/obj/effect/mapping_helpers/airlock/access/any/engineering/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/engineering/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/engineering/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/engineering/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/engineering/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL5
	return access_list

// -------------------- Service access helpers

/obj/effect/mapping_helpers/airlock/access/any/service
	icon_state = "access_helper_serv"

/obj/effect/mapping_helpers/airlock/access/any/service/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SERVICE
	return access_list

// -------------------- Logistics Access Helpers

/obj/effect/mapping_helpers/airlock/access/any/logistics
	icon_state = "access_helper_sup"

/obj/effect/mapping_helpers/airlock/access/any/logistics/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/logistics/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/logistics/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/logistics/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/logistics/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL5
	return access_list

// -------------------- Syndicate access helpers

/obj/effect/mapping_helpers/airlock/access/any/syndicate
	icon_state = "access_helper_syn"

/obj/effect/mapping_helpers/airlock/access/any/syndicate/general/get_access()
	var/list/access_list = ..()
	access_list += list(ACCESS_SYNDICATE)
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/syndicate/leader/get_access()
	var/list/access_list = ..()
	access_list += list(ACCESS_SYNDICATE_LEADER)
	return access_list

// -------------------- Away access helpers
/obj/effect/mapping_helpers/airlock/access/any/away
	icon_state = "access_helper_awy"

/obj/effect/mapping_helpers/airlock/access/any/away/general/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERAL
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/command/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_COMMAND
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/security/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_SEC
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/engineering/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_ENGINE
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/medical/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_MED
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/supply/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_SUPPLY
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/science/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_SCIENCE
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/maintenance/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_MAINT
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/generic1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERIC1
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/generic2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERIC2
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/generic3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERIC3
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/away/generic4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERIC4
	return access_list

// -------------------- Admin access helpers
/obj/effect/mapping_helpers/airlock/access/any/admin
	icon_state = "access_helper_adm"

/obj/effect/mapping_helpers/airlock/access/any/admin/general/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_GENERAL
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/thunderdome/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_THUNDER
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/medical/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_MEDICAL
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/living/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_LIVING
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/storage/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_STORAGE
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/teleporter/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_TELEPORTER
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/captain/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_CAPTAIN
	return access_list

/obj/effect/mapping_helpers/airlock/access/any/admin/bar/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_CAPTAIN
	return access_list

// -------------------- Req All (Requires ALL of the given accesses to open)

// -------------------- Security Access Helpers

/obj/effect/mapping_helpers/airlock/access/all/security
	icon_state = "access_helper_sec"

/obj/effect/mapping_helpers/airlock/access/all/security/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/security/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/security/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/security/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/security/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SECURITY_LVL5
	return access_list

// -------------------- Administration Access Helpers

/obj/effect/mapping_helpers/airlock/access/all/admin
	icon_state = "access_helper_com"

/obj/effect/mapping_helpers/airlock/access/all/admin/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ADMIN_LVL5
	return access_list

// -------------------- Science Access Helpers

/obj/effect/mapping_helpers/airlock/access/all/science
	icon_state = "access_helper_sci"

/obj/effect/mapping_helpers/airlock/access/all/science/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/science/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/science/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/science/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/science/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SCIENCE_LVL5
	return access_list

// -------------------- Medical Access Helpers

/obj/effect/mapping_helpers/airlock/access/all/medical
	icon_state = "access_helper_med"

/obj/effect/mapping_helpers/airlock/access/all/medical/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/medical/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/medical/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/medical/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/medical/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_MEDICAL_LVL5
	return access_list

// -------------------- Engineering access helpers

/obj/effect/mapping_helpers/airlock/access/all/engineering
	icon_state = "access_helper_eng"

/obj/effect/mapping_helpers/airlock/access/all/engineering/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/engineering/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/engineering/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/engineering/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/engineering/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_ENGINEERING_LVL5
	return access_list

// -------------------- Service access helpers

/obj/effect/mapping_helpers/airlock/access/all/service
	icon_state = "access_helper_serv"

/obj/effect/mapping_helpers/airlock/access/all/service/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SERVICE
	return access_list

// -------------------- Logistics Access Helpers

/obj/effect/mapping_helpers/airlock/access/all/logistics
	icon_state = "access_helper_sup"

/obj/effect/mapping_helpers/airlock/access/all/logistics/level1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL1
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/logistics/level2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL2
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/logistics/level3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL3
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/logistics/level4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL4
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/logistics/level5/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_LOGISTICS_LVL5
	return access_list


// -------------------- Syndicate access helpers
/obj/effect/mapping_helpers/airlock/access/all/syndicate
	icon_state = "access_helper_syn"

/obj/effect/mapping_helpers/airlock/access/all/syndicate/general/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SYNDICATE
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/syndicate/leader/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_SYNDICATE_LEADER
	return access_list

// -------------------- Away access helpers
/obj/effect/mapping_helpers/airlock/access/any/away
	icon_state = "access_helper_awy"

/obj/effect/mapping_helpers/airlock/access/all/away/general/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERAL
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/command/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_COMMAND
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/security/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_SEC
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/engineering/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_ENGINE
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/medical/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_MED
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/supply/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_SUPPLY
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/science/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_SCIENCE
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/maintenance/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_MAINT
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/generic1/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERIC1
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/generic2/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERIC2
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/generic3/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERIC3
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/away/generic4/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_AWAY_GENERIC4
	return access_list

// -------------------- Admin access helpers
/obj/effect/mapping_helpers/airlock/access/all/admin
	icon_state = "access_helper_adm"

/obj/effect/mapping_helpers/airlock/access/all/admin/general/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_GENERAL
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/thunderdome/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_THUNDER
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/medical/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_MEDICAL
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/living/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_LIVING
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/storage/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_STORAGE
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/teleporter/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_TELEPORTER
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/captain/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_CAPTAIN
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/admin/bar/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_CENT_BAR
	return access_list
