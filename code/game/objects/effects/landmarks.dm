/obj/effect/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = TURF_LAYER
	plane = GAME_PLANE
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/effect/landmark/singularity_act()
	return

/obj/effect/landmark/singularity_pull()
	return

INITIALIZE_IMMEDIATE(/obj/effect/landmark)

/obj/effect/landmark/Initialize(mapload)
	. = ..()
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/autogen_landmarks.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MOB_LAYER
	var/jobspawn_override = FALSE
	var/delete_after_roundstart = TRUE
	var/used = FALSE

/obj/effect/landmark/start/proc/after_round_start()
	if(delete_after_roundstart)
		qdel(src)

/obj/effect/landmark/start/Initialize(mapload)
	. = ..()
	GLOB.start_landmarks_list += src
	if(jobspawn_override)
		LAZYADDASSOCLIST(GLOB.jobspawn_overrides, name, src)
	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/Destroy()
	GLOB.start_landmarks_list -= src
	if(jobspawn_override)
		LAZYREMOVEASSOC(GLOB.jobspawn_overrides, name, src)
	return ..()

// START LANDMARKS FOLLOW. Don't change the names unless
// you are refactoring shitty landmark code.
/obj/effect/landmark/start/assistant
	name = JOB_ASSISTANT
	icon_state = JOB_ASSISTANT //icon_state is case sensitive. why are all of these capitalized? because fuck you that's why

/obj/effect/landmark/start/assistant/override
	jobspawn_override = TRUE
	delete_after_roundstart = FALSE

// Administration Start Landmarks

/obj/effect/landmark/start/site_director
	name = JOB_SITE_DIRECTOR
	icon_state = JOB_SITE_DIRECTOR

/obj/effect/landmark/start/human_resources_director
	name = JOB_HUMAN_RESOURCES_DIRECTOR
	icon_state = JOB_HUMAN_RESOURCES_DIRECTOR

/obj/effect/landmark/start/internal_tribunal_department_officer
	name = JOB_INTERNAL_TRIBUNAL_DEPARTMENT_OFFICER
	icon_state = JOB_INTERNAL_TRIBUNAL_DEPARTMENT_OFFICER

/obj/effect/landmark/start/ethics_committee_liaison
	name = JOB_ETHICS_COMMITTEE_LIAISON
	icon_state = JOB_ETHICS_COMMITTEE_LIAISON

/obj/effect/landmark/start/communications_director
	name = JOB_COMMUNICATIONS_DIRECTOR
	icon_state = JOB_COMMUNICATIONS_DIRECTOR

/obj/effect/landmark/start/goc_rep
	name = JOB_GOC_REP
	icon_state = JOB_GOC_REP

/obj/effect/landmark/start/goldbaker_rep
	name = JOB_GOLDBAKER_REP
	icon_state = JOB_GOLDBAKER_REP

/obj/effect/landmark/start/uiu_rep
	name = JOB_UIU_REP
	icon_state = JOB_UIU_REP


/obj/effect/landmark/start/gmcd_rep
	name = JOB_MCD_REP
	icon_state = JOB_MCD_REP

// Security Start Landmarks

/obj/effect/landmark/start/security_director
	name = JOB_SECURITY_DIRECTOR
	icon_state = JOB_SECURITY_DIRECTOR

/obj/effect/landmark/start/raisa_agent
	name = JOB_RAISA_AGENT
	icon_state = JOB_RAISA_AGENT

/obj/effect/landmark/start/investigations_agent
	name = JOB_INVESTIGATIONS_AGENT
	icon_state = JOB_INVESTIGATIONS_AGENT

// EZ Security Start Landmarks

/obj/effect/landmark/start/ez_commander
	name = JOB_EZ_COMMANDER
	icon_state = JOB_EZ_COMMANDER

/obj/effect/landmark/start/senior_ez_guard
	name = JOB_SENIOR_EZ_GUARD
	icon_state = JOB_SENIOR_EZ_GUARD

/obj/effect/landmark/start/ez_guard
	name = JOB_EZ_GUARD
	icon_state = JOB_EZ_GUARD

/obj/effect/landmark/start/junior_ez_guard
	name = JOB_JUNIOR_EZ_GUARD
	icon_state = JOB_JUNIOR_EZ_GUARD

// LCZ Security Start Landmarks

/obj/effect/landmark/start/lcz_commander
	name = JOB_LCZ_COMMANDER
	icon_state = JOB_LCZ_COMMANDER

/obj/effect/landmark/start/senior_lcz_guard
	name = JOB_SENIOR_LCZ_GUARD
	icon_state = JOB_SENIOR_LCZ_GUARD

/obj/effect/landmark/start/lcz_guard
	name = JOB_LCZ_GUARD
	icon_state = JOB_LCZ_GUARD

/obj/effect/landmark/start/junior_lcz_guard
	name = JOB_JUNIOR_LCZ_GUARD
	icon_state = JOB_JUNIOR_LCZ_GUARD

// HCZ Security Start Landmarks

/obj/effect/landmark/start/hcz_commander
	name = JOB_HCZ_COMMANDER
	icon_state = JOB_HCZ_COMMANDER

/obj/effect/landmark/start/senior_hcz_guard
	name = JOB_SENIOR_HCZ_GUARD
	icon_state = JOB_SENIOR_HCZ_GUARD

/obj/effect/landmark/start/hcz_guard
	name = JOB_HCZ_GUARD
	icon_state = JOB_HCZ_GUARD

/obj/effect/landmark/start/junior_hcz_guard
	name = JOB_JUNIOR_HCZ_GUARD
	icon_state = JOB_JUNIOR_HCZ_GUARD

/obj/effect/landmark/start/dlcass
	name = JOB_DCLASS
	icon_state = JOB_DCLASS

// Science Start Landmarks

/obj/effect/landmark/start/research_director
	name = JOB_RESEARCH_DIRECTOR
	icon_state = JOB_RESEARCH_DIRECTOR

/obj/effect/landmark/start/assistant_research_director
	name = JOB_ASSISTANT_RESEARCH_DIRECTOR
	icon_state = JOB_ASSISTANT_RESEARCH_DIRECTOR

/obj/effect/landmark/start/senior_researcher
	name = JOB_SENIOR_RESEARCHER
	icon_state = JOB_SENIOR_RESEARCHER

/obj/effect/landmark/start/researcher
	name = JOB_RESEARCHER
	icon_state = JOB_RESEARCHER

/obj/effect/landmark/start/junior_researcher
	name = JOB_JUNIOR_RESEARCHER
	icon_state = JOB_JUNIOR_RESEARCHER

// Medical Start Landmarks

/obj/effect/landmark/start/medical_director
	name = JOB_MEDICAL_DIRECTOR
	icon_state = JOB_MEDICAL_DIRECTOR

/obj/effect/landmark/start/assistant_medical_director
	name = JOB_ASSISTANT_MEDICAL_DIRECTOR
	icon_state = JOB_ASSISTANT_MEDICAL_DIRECTOR

/obj/effect/landmark/start/medical_doctor
	name = JOB_MEDICAL_DOCTOR
	icon_state = JOB_MEDICAL_DOCTOR

/obj/effect/landmark/start/surgeon
	name = JOB_SURGEON
	icon_state = JOB_SURGEON

/obj/effect/landmark/start/paramedic
	name = JOB_PARAMEDIC
	icon_state = JOB_PARAMEDIC

/obj/effect/landmark/start/chemist
	name = JOB_CHEMIST
	icon_state = JOB_CHEMIST

/obj/effect/landmark/start/trainee_doctor
	name = JOB_TRAINEE_DOCTOR
	icon_state = JOB_TRAINEE_DOCTOR

/obj/effect/landmark/start/virologist
	name = JOB_VIROLOGIST
	icon_state = JOB_VIROLOGIST

/obj/effect/landmark/start/psychologist
	name = JOB_PSYCHOLOGIST
	icon_state = JOB_PSYCHOLOGIST

// Engineering Start Landmarks

/obj/effect/landmark/start/engineering_director
	name = JOB_ENGINEERING_DIRECTOR
	icon_state = JOB_ENGINEERING_DIRECTOR

/obj/effect/landmark/start/assistant_engineering_director
	name = JOB_ASSISTANT_ENGINEERING_DIRECTOR
	icon_state = JOB_ASSISTANT_ENGINEERING_DIRECTOR

/obj/effect/landmark/start/containment_engineer
	name = JOB_CONTAINMENT_ENGINEER
	icon_state = JOB_CONTAINMENT_ENGINEER

/obj/effect/landmark/start/it_technician
	name = JOB_IT_TECHNICIAN
	icon_state = JOB_IT_TECHNICIAN

/obj/effect/landmark/start/senior_engineer
	name = JOB_SENIOR_ENGINEER
	icon_state = JOB_SENIOR_ENGINEER

/obj/effect/landmark/start/engineer
	name = JOB_ENGINEER
	icon_state = JOB_ENGINEER

/obj/effect/landmark/start/junior_engineer
	name = JOB_JUNIOR_ENGINEER
	icon_state = JOB_JUNIOR_ENGINEER

/obj/effect/landmark/start/atmospheric_technician
	name = JOB_ATMOSPHERIC_TECHNICIAN
	icon_state = JOB_ATMOSPHERIC_TECHNICIAN

// Logistics Start Landmarks

/obj/effect/landmark/start/logistics_officer
	name = JOB_LOGISTICS_OFFICER
	icon_state = JOB_LOGISTICS_OFFICER

/obj/effect/landmark/start/logistics_technician
	name = JOB_LOGISTICS_TECHNICIAN
	icon_state = JOB_LOGISTICS_TECHNICIAN

// Service Start Landmarks

/obj/effect/landmark/start/botanist
	name = JOB_BOTANIST
	icon_state = JOB_BOTANIST

/obj/effect/landmark/start/cook
	name = JOB_COOK
	icon_state = JOB_COOK

/obj/effect/landmark/start/janitor
	name = JOB_JANITOR
	icon_state = JOB_JANITOR

/obj/effect/landmark/start/clown
	name = JOB_CLOWN
	icon_state = JOB_CLOWN

/obj/effect/landmark/start/chaplain
	name = JOB_CHAPLAIN
	icon_state = JOB_CHAPLAIN

// Silicon Start Landmarks

/obj/effect/landmark/start/cyborg
	name = JOB_CYBORG
	icon_state = JOB_CYBORG

/obj/effect/landmark/start/ai
	name = JOB_AI
	icon_state = JOB_AI
	delete_after_roundstart = FALSE
	var/primary_ai = TRUE
	var/latejoin_active = TRUE

/obj/effect/landmark/start/ai/after_round_start()
	if(latejoin_active && !used)
		new /obj/structure/ai_core/latejoin_inactive(loc)
	return ..()

/obj/effect/landmark/start/ai/secondary
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "ai_spawn"
	primary_ai = FALSE
	latejoin_active = FALSE

//Antagonist spawns

/obj/effect/landmark/start/wizard
	name = "wizard"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "wiznerd_spawn"

/obj/effect/landmark/start/wizard/Initialize(mapload)
	..()
	GLOB.wizardstart += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/nukeop
	name = "nukeop"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_spawn"

/obj/effect/landmark/start/nukeop/Initialize(mapload)
	..()
	GLOB.nukeop_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/nukeop_leader
	name = "nukeop leader"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_leader_spawn"

/obj/effect/landmark/start/nukeop_leader/Initialize(mapload)
	..()
	GLOB.nukeop_leader_start += loc
	return INITIALIZE_HINT_QDEL

// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/effect/landmark/start/new_player)

/obj/effect/landmark/start/new_player
	name = "New Player"

/obj/effect/landmark/start/new_player/Initialize(mapload)
	..()
	GLOB.newplayer_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/Initialize(mapload)
	..()
	SSjob.latejoin_trackers += loc
	return INITIALIZE_HINT_QDEL

//space carps, magicarps, lone ops, slaughter demons, possibly revenants spawn here
/obj/effect/landmark/carpspawn
	name = "carpspawn"
	icon_state = "carp_spawn"

//spawn for mice and other maint pests
/obj/effect/landmark/pestspawn
	name = "pestspawn"
	icon_state = "pest_spawn"
	layer = MOB_LAYER //needs to display above catwalks

//observer start
/obj/effect/landmark/observer_start
	name = "Observer-Start"
	icon_state = "observer_start"

//xenos, morphs and nightmares spawn here
/obj/effect/landmark/xeno_spawn
	name = "xeno_spawn"
	icon_state = "xeno_spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload)
	..()
	GLOB.xeno_spawn += loc
	return INITIALIZE_HINT_QDEL

//objects with the stationloving component (nuke disk) respawn here.
//also blobs that have their spawn forcemoved (running out of time when picking their spawn spot) and santa
/obj/effect/landmark/blobstart
	name = "blobstart"
	icon_state = "blob_start"

/obj/effect/landmark/blobstart/Initialize(mapload)
	..()
	GLOB.blobstart += loc
	return INITIALIZE_HINT_QDEL

//spawns sec equipment lockers depending on the number of sec officers
/obj/effect/landmark/secequipment
	name = "secequipment"
	icon_state = "secequipment"

/obj/effect/landmark/secequipment/Initialize(mapload)
	..()
	GLOB.secequipment += loc
	return INITIALIZE_HINT_QDEL

//players that get put in admin jail show up here
/obj/effect/landmark/prisonwarp
	name = "prisonwarp"
	icon_state = "prisonwarp"

/obj/effect/landmark/prisonwarp/Initialize(mapload)
	..()
	GLOB.prisonwarp += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/ert_spawn
	name = "Emergencyresponseteam"
	icon_state = "ert_spawn"

/obj/effect/landmark/ert_spawn/Initialize(mapload)
	..()
	GLOB.emergencyresponseteamspawn += loc
	return INITIALIZE_HINT_QDEL

//ninja energy nets teleport victims here
/obj/effect/landmark/holding_facility
	name = "Holding Facility"
	icon_state = "holding_facility"

/obj/effect/landmark/holding_facility/Initialize(mapload)
	..()
	GLOB.holdingfacility += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/observe
	name = "tdomeobserve"
	icon_state = "tdome_observer"

/obj/effect/landmark/thunderdome/observe/Initialize(mapload)
	..()
	GLOB.tdomeobserve += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/one
	name = "tdome1"
	icon_state = "tdome_t1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload)
	..()
	GLOB.tdome1 += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/two
	name = "tdome2"
	icon_state = "tdome_t2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload)
	..()
	GLOB.tdome2 += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/admin
	name = "tdomeadmin"
	icon_state = "tdome_admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload)
	..()
	GLOB.tdomeadmin += loc
	return INITIALIZE_HINT_QDEL

//generic event spawns
/obj/effect/landmark/event_spawn
	name = "generic event spawn"
	icon_state = "generic_event"
	layer = OBJ_LAYER


/obj/effect/landmark/event_spawn/Initialize(mapload)
	. = ..()
	GLOB.generic_event_spawns += src

/obj/effect/landmark/event_spawn/Destroy()
	GLOB.generic_event_spawns -= src
	return ..()

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/Initialize(mapload, my_ruin_template)
	. = ..()
	name = "ruin_[GLOB.ruin_landmarks.len + 1]"
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()

// handled in portals.dm, id connected to one-way portal
/obj/effect/landmark/portal_exit
	name = "portal exit"
	icon_state = "portal_exit"
	var/id

/// Marks the bottom left of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_bottom_left
	name = "unit test zone bottom left"

/// Marks the top right of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_top_right
	name = "unit test zone top right"

//Landmark that creates destinations for the navigate verb to path to
/obj/effect/landmark/navigate_destination
	name = "navigate verb destination"
	icon_state = "navigate"
	layer = OBJ_LAYER
	var/location

/obj/effect/landmark/navigate_destination/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/navigate_destination/LateInitialize()
	. = ..()
	if(!location)
		var/obj/machinery/door/airlock/A = locate(/obj/machinery/door/airlock) in loc
		location = A ? format_text(A.name) : get_area_name(src, format_text = TRUE)

	GLOB.navigate_destinations[loc] = location

	qdel(src)

//Command
/obj/effect/landmark/navigate_destination/bridge
	location = "Bridge"

/obj/effect/landmark/navigate_destination/hop
	location = "Head of Personnel's Office"

/obj/effect/landmark/navigate_destination/vault
	location = "Vault"

/obj/effect/landmark/navigate_destination/teleporter
	location = "Teleporter"

/obj/effect/landmark/navigate_destination/gateway
	location = "Gateway"

/obj/effect/landmark/navigate_destination/eva
	location = "EVA Storage"

/obj/effect/landmark/navigate_destination/aiupload
	location = "AI Upload"

/obj/effect/landmark/navigate_destination/minisat_access_ai
	location = "AI MiniSat Access"

/obj/effect/landmark/navigate_destination/minisat_access_tcomms
	location = "Telecomms MiniSat Access"

/obj/effect/landmark/navigate_destination/minisat_access_tcomms_ai
	location = "AI and Telecomms MiniSat Access"

/obj/effect/landmark/navigate_destination/tcomms
	location = "Telecommunications"

//Departments
/obj/effect/landmark/navigate_destination/sec
	location = "Security"

/obj/effect/landmark/navigate_destination/det
	location = "Private Investigator's Office"

/obj/effect/landmark/navigate_destination/research
	location = "Research"

/obj/effect/landmark/navigate_destination/engineering
	location = "Engineering"

/obj/effect/landmark/navigate_destination/techstorage
	location = "Technical Storage"

/obj/effect/landmark/navigate_destination/atmos
	location = "Atmospherics"

/obj/effect/landmark/navigate_destination/med
	location = "Medical"

/obj/effect/landmark/navigate_destination/chemfactory
	location = "Chemistry Factory"

/obj/effect/landmark/navigate_destination/cargo
	location = "Cargo"

//Common areas
/obj/effect/landmark/navigate_destination/bar
	location = "Bar"

/obj/effect/landmark/navigate_destination/dorms
	location = "Dormitories"

/obj/effect/landmark/navigate_destination/court
	location = "Courtroom"

/obj/effect/landmark/navigate_destination/tools
	location = "Tool Storage"

/obj/effect/landmark/navigate_destination/library
	location = "Library"

/obj/effect/landmark/navigate_destination/chapel
	location = "Chapel"

/obj/effect/landmark/navigate_destination/minisat_access_chapel_library
	location = "Chapel and Library MiniSat Access"

//Service
/obj/effect/landmark/navigate_destination/kitchen
	location = "Kitchen"

/obj/effect/landmark/navigate_destination/hydro
	location = "Hydroponics"

/obj/effect/landmark/navigate_destination/janitor
	location = "Janitor's Closet"

/obj/effect/landmark/navigate_destination/lawyer
	location = "Lawyer's Office"

//Shuttle docks
/obj/effect/landmark/navigate_destination/dockarrival
	location = "Arrival Shuttle Dock"

/obj/effect/landmark/navigate_destination/dockesc
	location = "Escape Shuttle Dock"

/obj/effect/landmark/navigate_destination/dockescpod
	location = "Escape Pod Dock"

/obj/effect/landmark/navigate_destination/dockescpod1
	location = "Escape Pod 1 Dock"

/obj/effect/landmark/navigate_destination/dockescpod2
	location = "Escape Pod 2 Dock"

/obj/effect/landmark/navigate_destination/dockescpod3
	location = "Escape Pod 3 Dock"

/obj/effect/landmark/navigate_destination/dockescpod4
	location = "Escape Pod 4 Dock"

/obj/effect/landmark/navigate_destination/dockaux
	location = "Auxiliary Dock"

//Maint
/obj/effect/landmark/navigate_destination/incinerator
	location = "Incinerator"

/obj/effect/landmark/navigate_destination/disposals
	location = "Disposals"
