/**
 * This file contains all the trims associated with station jobs.
 * It also contains special prisoner trims and the miner's spare ID trim.
 */

/// ID Trims for station jobs.
/datum/id_trim/job
	trim_state = "trim_assistant"

	/// The extra access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is FALSE.
	var/list/extra_access = list()
	/// The extra wildcard_access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is FALSE.
	var/list/extra_wildcard_access = list()
	/// The base access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is TRUE.
	var/list/minimal_access = list()
	/// The base wildcard_access the card should have when CONFIG_GET(flag/jobs_have_minimal_access) is TRUE.
	var/list/minimal_wildcard_access = list()
	/// Static list. Cache of any mapping config job changes.
	var/static/list/job_changes
	/// What config entry relates to this job. Should be a lowercase job name with underscores for spaces, eg "prisoner" "research_director" "head_of_security"
	var/config_job
	/// An ID card with an access in this list can apply this trim to IDs or use it as a job template when adding access to a card. If the list is null, cannot be used as a template. Should be Head of Staff or ID Console accesses or it may do nothing.
	var/list/template_access
	/// The typepath to the job datum from the id_trim. This is converted to one of the job singletons in New().
	var/datum/job/job = /datum/job/unassigned

/datum/id_trim/job/New()
	if(ispath(job))
		job = SSjob.GetJobType(job)

	if(isnull(job_changes))
		job_changes = SSmapping.config.job_changes

	if(!length(job_changes) || !config_job)
		refresh_trim_access()
		return

	var/list/access_changes = job_changes[config_job]

	if(!length(access_changes))
		refresh_trim_access()
		return

	if(islist(access_changes["additional_access"]))
		extra_access |= access_changes["additional_access"]
	if(islist(access_changes["additional_minimal_access"]))
		minimal_access |= access_changes["additional_minimal_access"]
	if(islist(access_changes["additional_wildcard_access"]))
		extra_wildcard_access |= access_changes["additional_wildcard_access"]
	if(islist(access_changes["additional_minimal_wildcard_access"]))
		minimal_wildcard_access |= access_changes["additional_minimal_wildcard_access"]

	refresh_trim_access()

/**
 * Goes through various non-map config settings and modifies the trim's access based on this.
 *
 * Returns TRUE if the config is loaded, FALSE otherwise.
 */
/datum/id_trim/job/proc/refresh_trim_access()
	// If there's no config loaded then assume minimal access.
	if(!config)
		access = minimal_access.Copy()
		wildcard_access = minimal_wildcard_access.Copy()
		return FALSE

	// There is a config loaded. Check for the jobs_have_minimal_access flag being set.
	if(CONFIG_GET(flag/jobs_have_minimal_access))
		access = minimal_access.Copy()
		wildcard_access = minimal_wildcard_access.Copy()
	else
		access = minimal_access | extra_access
		wildcard_access = minimal_wildcard_access | extra_wildcard_access

	// If the config has global maint access set, we always want to add maint access.
	if(CONFIG_GET(flag/everyone_has_maint_access))
		access |= list(ACCESS_ENGINEERING_LVL1)

	return TRUE

/datum/id_trim/job/assistant
	assignment = "Assistant"
	trim_state = "trim_assistant"
	sechud_icon_state = SECHUD_ASSISTANT
	extra_access = list()
	minimal_access = list()
	config_job = "assistant"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5)
	job = /datum/job/assistant

/datum/id_trim/job/assistant/refresh_trim_access()
	. = ..()

	if(!.)
		return

	// Config has assistant maint access set.
	if(CONFIG_GET(flag/assistants_have_maint_access))
		access |= list(ACCESS_ENGINEERING_LVL1)

//COMMAND JOBS
/datum/id_trim/job/site_director
	assignment = JOB_SITE_DIRECTOR
	intern_alt_name = "Intern Director"
	trim_state = "adminlvl5"
	sechud_icon_state = SECHUD_SITE_DIRECTOR
	config_job = "captain"
	template_access = list(ACCESS_ADMIN_LVL5)
	job = /datum/job/site_director

/// Captain gets all station accesses hardcoded in because it's the Captain.
/datum/id_trim/job/site_director/New()
	extra_access |= (SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON) + SSid_access.get_flag_access_list(ACCESS_FLAG_COMMAND))
	extra_wildcard_access |= (SSid_access.get_flag_access_list(ACCESS_FLAG_PRV_COMMAND) + SSid_access.get_flag_access_list(ACCESS_FLAG_CAPTAIN))
	minimal_access |= (SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON) + SSid_access.get_flag_access_list(ACCESS_FLAG_COMMAND))
	minimal_wildcard_access |= (SSid_access.get_flag_access_list(ACCESS_FLAG_PRV_COMMAND) + SSid_access.get_flag_access_list(ACCESS_FLAG_CAPTAIN))

	return ..()

/datum/id_trim/job/human_resources_director
	assignment = JOB_HUMAN_RESOURCES_DIRECTOR
	intern_alt_name = "Intern " + JOB_HUMAN_RESOURCES_DIRECTOR
	trim_state = "adminlvl5"
	sechud_icon_state = SECHUD_HUMAN_RESOURCES_DIRECTOR
	extra_access = list()
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_ADMIN,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ADMIN_LVL4,
		ACCESS_ADMIN_LVL5,
		ACCESS_MEDICAL,
		ACCESS_MEDICAL_LVL1,
		ACCESS_SCIENCE_LVL1,
		ACCESS_LOGISTICS,
		ACCESS_LOGISTICS_LVL1,
		ACCESS_LOGISTICS_LVL2,
		ACCESS_LOGISTICS_LVL3,
		ACCESS_LOGISTICS_LVL4,
		ACCESS_LOGISTICS_LVL5,
		ACCESS_SERVICE,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1
	)
	minimal_wildcard_access = list(ACCESS_ADMIN_LVL5)
	config_job = "head_of_personnel"
	template_access = list(ACCESS_ADMIN_LVL5)
	job = /datum/job/human_resources_director

/datum/id_trim/job/internal_tribunal_department_officer
	assignment = "Internal Tribunal Department Officer"
	trim_state = "adminlvl5"
	sechud_icon_state = SECHUD_INTERNAL_TRIBUNAL_DEPARTMENT_OFFICER
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ADMIN_LVL4,
		ACCESS_ADMIN_LVL5,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3,
		ACCESS_SECURITY_LVL4
		)
	config_job = "itdo"
	template_access = list(ACCESS_ADMIN_LVL5)
	job = /datum/job/internal_tribunal_department_officer

/datum/id_trim/job/ethics_committee_liaison
	assignment = "Ethics Committee Liaison"
	trim_state = "adminlvl5"
	sechud_icon_state = SECHUD_ETHICS_COMMITTEE_LIAISON
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ADMIN_LVL4,
		ACCESS_ADMIN_LVL5,
		ACCESS_MEDICAL,
		ACCESS_SCIENCE,
		ACCESS_SERVICE,
		ACCESS_MEDICAL_LVL1,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2
		)
	config_job = "ecl"
	template_access = list(ACCESS_ADMIN_LVL5)
	job = /datum/job/ethics_committee_liaison

/datum/id_trim/job/communications_director
	assignment = "Communications Director"
	trim_state = "adminlvl2"
	sechud_icon_state = SECHUD_COMMUNICATIONS_DIRECTOR
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_SERVICE,
		ACCESS_MEDICAL,
		ACCESS_MEDICAL_LVL1,
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3,
		ACCESS_ENGINEERING_LVL4,
		ACCESS_SCIENCE,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
		ACCESS_SCIENCE_LVL3,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1
		)
	config_job = "communications_director"
	template_access = list(ACCESS_ADMIN_LVL5)
	job = /datum/job/ethics_committee_liaison

//SECURITY JOBS


///datum/id_trim/job/warden/refresh_trim_access()
//. = ..()
//
//	if(!.)
//		return
//
//	// Config check for if sec has maint access.
//	if(CONFIG_GET(flag/security_has_maint_access))
//		access |= list(ACCESS_ENGINEERING_LVL1)

/datum/id_trim/job/security_director
	assignment = JOB_SECURITY_DIRECTOR
	intern_alt_name = "Intern " + JOB_SECURITY_DIRECTOR
	trim_state = "securitylvl5"
	sechud_icon_state = SECHUD_SECURITY_DIRECTOR
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ADMIN_LVL4,
		ACCESS_MEDICAL_LVL1,
		ACCESS_SCIENCE_LVL1,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_LOGISTICS_LVL1,
		ACCESS_SERVICE,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3,
		ACCESS_SECURITY_LVL4,
		ACCESS_SECURITY_LVL5
		)
	config_job = "security_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5)
	job = /datum/job/security_director

/datum/id_trim/job/raisa_agent
	assignment = JOB_RAISA_AGENT
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_RAISA
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ADMIN_LVL4,
		ACCESS_SCIENCE,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
		ACCESS_SCIENCE_LVL3,
		ACCESS_SERVICE,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3
		)
	config_job = "raisa_agent"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/raisa_agent

/datum/id_trim/job/investigations_agent
	assignment = "Investigations Agent"
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_DETECTIVE
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_MEDICAL,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3
		)
	config_job = "investigations_agent"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/investigations_agent

//EZ
/datum/id_trim/job/junior_ez_guard
	assignment = "Junior EZ Guard"
	trim_state = "securitylvl2"
	sechud_icon_state = SECHUD_EZ_JUNIOR_GUARD
	extra_access = list(ACCESS_MEDICAL_LVL1, ACCESS_SCIENCE_LVL1, ACCESS_ENGINEERING_LVL1)
	minimal_access = list(
		ACCESS_LOGISTICS_LVL1,
		ACCESS_SERVICE,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2
		)
	config_job = "junior_ez"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/junior_ez_guard

/datum/id_trim/job/ez_guard
	assignment = "EZ Guard"
	trim_state = "securitylvl2"
	sechud_icon_state = SECHUD_EZ_GUARD
	extra_access = list(ACCESS_SECURITY_LVL3)
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_MEDICAL_LVL1,
		ACCESS_SCIENCE_LVL1,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_LOGISTICS_LVL1,
		ACCESS_SERVICE,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2
		)
	config_job = "ez_guard"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/ez_guard

/datum/id_trim/job/senior_ez_guard
	assignment = "Senior EZ Guard"
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_EZ_SENIOR_GUARD
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_LOGISTICS_LVL1,
		ACCESS_LOGISTICS_LVL2,
		ACCESS_SERVICE,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3
		)
	config_job = "senior_ez"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/senior_ez_guard

/datum/id_trim/job/ez_commander
	assignment = "EZ Commander"
	trim_state = "securitylvl4"
	sechud_icon_state = SECHUD_EZ_ZONE_COMMANDER
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ADMIN_LVL4,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
		ACCESS_SCIENCE_LVL3,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3,
		ACCESS_LOGISTICS_LVL1,
		ACCESS_LOGISTICS_LVL2,
		ACCESS_SERVICE,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3,
		ACCESS_SECURITY_LVL4
		)
	config_job = "ez_commander"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL5)
	job = /datum/job/ez_commander

//LCZ
/datum/id_trim/job/junior_lcz_guard
	assignment = "Junior LCZ Guard"
	trim_state = "securitylvl2"
	sechud_icon_state = SECHUD_LCZ_JUNIOR_GUARD
	extra_access = list(ACCESS_SECURITY_LVL3)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SECURITY_LVL1, ACCESS_SECURITY_LVL2)
	config_job = "junior_lcz"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/junior_lcz_guard

/datum/id_trim/job/lcz_guard
	assignment = "LCZ Guard"
	trim_state = "securitylvl2"
	sechud_icon_state = SECHUD_LCZ_GUARD
	extra_access = list(ACCESS_SECURITY_LVL3)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SECURITY_LVL1, ACCESS_SECURITY_LVL2)
	config_job = "lcz_guard"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/lcz_guard

/datum/id_trim/job/senior_lcz_guard
	assignment = "Senior LCZ Guard"
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_LCZ_SENIOR_GUARD
	extra_access = list()
	minimal_access = list(ACCESS_SECURITY, ACCESS_SECURITY_LVL1, ACCESS_SECURITY_LVL2, ACCESS_SECURITY_LVL3)
	config_job = "senior_lcz"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/senior_lcz_guard

/datum/id_trim/job/lcz_commander
	assignment = "LCZ Commander"
	trim_state = "securitylvl4"
	sechud_icon_state = SECHUD_LCZ_ZONE_COMMANDER
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3,
		ACCESS_SECURITY_LVL4
		)
	config_job = "lcz_commander"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL5)
	job = /datum/job/lcz_commander

//HCZ
/datum/id_trim/job/junior_hcz_guard
	assignment = "Junior HCZ Guard"
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_HCZ_JUNIOR_GUARD
	extra_access = list()
	minimal_access = list(ACCESS_SECURITY, ACCESS_SECURITY_LVL1, ACCESS_SECURITY_LVL2, ACCESS_SECURITY_LVL3)
	config_job = "junior_hcz"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/junior_hcz_guard

/datum/id_trim/job/hcz_guard
	assignment = "HCZ Guard"
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_HCZ_GUARD
	extra_access = list()
	minimal_access = list(ACCESS_SECURITY, ACCESS_SECURITY_LVL1, ACCESS_SECURITY_LVL2, ACCESS_SECURITY_LVL3)
	config_job = "hcz_guard"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/hcz_guard

/datum/id_trim/job/senior_hcz_guard
	assignment = "Senior HCZ Guard"
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_HCZ_SENIOR_GUARD
	extra_access = list()
	minimal_access = list(ACCESS_SECURITY, ACCESS_SECURITY_LVL1, ACCESS_SECURITY_LVL2, ACCESS_SECURITY_LVL3)
	config_job = "senior_hcz"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/senior_hcz_guard

/datum/id_trim/job/hcz_commander
	assignment = "HCZ Commander"
	trim_state = "securitylvl4"
	sechud_icon_state = SECHUD_HCZ_ZONE_COMMANDER
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_SECURITY,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3,
		ACCESS_SECURITY_LVL4
		)
	config_job = "hcz_commander"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL5)
	job = /datum/job/hcz_commander

//RESEARCH JOBS

/datum/id_trim/job/research_director
	assignment = "Research Director"
	intern_alt_name = "Intern Research"
	trim_state = "trim_researchdirector"
	sechud_icon_state = SECHUD_RESEARCH_DIRECTOR
	extra_access = list()
	extra_wildcard_access = list()
	minimal_access = list(
		ACCESS_ADMIN,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ADMIN_LVL4,
		ACCESS_SCIENCE,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
		ACCESS_SCIENCE_LVL3,
		ACCESS_SCIENCE_LVL4,
		ACCESS_SCIENCE_LVL5,
		ACCESS_MEDICAL,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2
	)
	minimal_wildcard_access = list(ACCESS_SCIENCE_LVL5)
	config_job = "research_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5)
	job = /datum/job/research_director

/datum/id_trim/job/junior_researcher
	assignment = JOB_JUNIOR_RESEARCHER
	trim_state = "sciencelvl1"
	sechud_icon_state = SECHUD_JUNIOR_RESEARCHER
	extra_access = list()
	minimal_access = list(ACCESS_SCIENCE, ACCESS_SCIENCE_LVL1, ACCESS_SCIENCE_LVL2)
	config_job = "junior_researcher"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SCIENCE_LVL4, ACCESS_SCIENCE_LVL5)
	job = /datum/job/junior_researcher

/datum/id_trim/job/researcher
	assignment = JOB_RESEARCHER
	trim_state = "sciencelvl2"
	sechud_icon_state = SECHUD_RESEARCHER
	extra_access = list(ACCESS_SCIENCE_LVL3)
	minimal_access = list(ACCESS_MEDICAL_LVL1, ACCESS_SCIENCE, ACCESS_SCIENCE_LVL1, ACCESS_SCIENCE_LVL2)
	config_job = "researcher"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SCIENCE_LVL4, ACCESS_SCIENCE_LVL5)
	job = /datum/job/researcher

/datum/id_trim/job/senior_researcher
	assignment = JOB_SENIOR_RESEARCHER
	trim_state = "sciencelvl3"
	sechud_icon_state = SECHUD_SENIOR_RESEARCHER
	extra_access = list()
	minimal_access = list(ACCESS_MEDICAL_LVL1, ACCESS_SCIENCE, ACCESS_SCIENCE_LVL1, ACCESS_SCIENCE_LVL2, ACCESS_SCIENCE_LVL3)
	config_job = "senior_researcher"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SCIENCE_LVL4, ACCESS_SCIENCE_LVL5)
	job = /datum/job/senior_researcher

/datum/id_trim/job/assistant_research_director
	assignment = JOB_ASSISTANT_RESEARCH_DIRECTOR
	trim_state = "sciencelvl4"
	sechud_icon_state = SECHUD_ASSISTANT_RESEARCH_DIRECTOR
	extra_access = list()
	minimal_access = list(ACCESS_MEDICAL_LVL1, ACCESS_SCIENCE, ACCESS_SCIENCE_LVL1, ACCESS_SCIENCE_LVL2, ACCESS_SCIENCE_LVL3)
	config_job = "senior_researcher"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SCIENCE_LVL4, ACCESS_SCIENCE_LVL5)
	job = /datum/job/senior_researcher

// MEDICAL JOBS

/datum/id_trim/job/medical_director
	assignment = JOB_MEDICAL_DIRECTOR
	trim_state = "adminlvl4"
	sechud_icon_state = SECHUD_MEDICAL_DIRECTOR
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ADMIN_LVL4,
		ACCESS_SCIENCE,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
		ACCESS_SCIENCE_LVL3,
		ACCESS_MEDICAL,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_MEDICAL_LVL4,
		ACCESS_MEDICAL_LVL5
		)
	minimal_wildcard_access = list(ACCESS_MEDICAL_LVL5)
	config_job = "medical_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5)
	job = /datum/job/medical_director

/datum/id_trim/job/assistant_medical_director
	assignment = JOB_ASSISTANT_MEDICAL_DIRECTOR
	trim_state = "adminlvl3"
	sechud_icon_state = SECHUD_MEDICAL_DIRECTOR
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
		ACCESS_MEDICAL,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_MEDICAL_LVL4
		)
	minimal_wildcard_access = list(ACCESS_MEDICAL_LVL5)
	config_job = "medical_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5)
	job = /datum/job/medical_director

/datum/id_trim/job/trainee_doctor
	assignment = JOB_TRAINEE_DOCTOR
	trim_state = "base"
	sechud_icon_state = SECHUD_TRAINEE_DOCTOR
	extra_access = list()
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_LVL1, ACCESS_MEDICAL_LVL2)
	config_job = "trainee_doctor"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_MEDICAL_LVL4, ACCESS_MEDICAL_LVL5)
	job = /datum/job/trainee_doctor

/datum/id_trim/job/medical_doctor
	assignment = JOB_MEDICAL_DOCTOR
	trim_state = "sciencelvl1"
	sechud_icon_state = SECHUD_MEDICAL_DOCTOR
	extra_access = list(ACCESS_MEDICAL_LVL3)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_LVL1, ACCESS_MEDICAL_LVL2, ACCESS_SCIENCE_LVL1)
	config_job = "medical_doctor"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_MEDICAL_LVL4, ACCESS_MEDICAL_LVL5)
	job = /datum/job/medical_doctor

/datum/id_trim/job/paramedic
	assignment = JOB_PARAMEDIC
	trim_state = "sciencelvl1"
	sechud_icon_state = SECHUD_PARAMEDIC
	extra_access = list(ACCESS_MEDICAL_LVL3)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_LVL1, ACCESS_MEDICAL_LVL2, ACCESS_SCIENCE_LVL1)
	config_job = "paramedc"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_MEDICAL_LVL4, ACCESS_MEDICAL_LVL5)
	job = /datum/job/paramedic

/datum/id_trim/job/chemist
	assignment = JOB_CHEMIST
	trim_state = "sciencelvl1"
	sechud_icon_state = SECHUD_CHEMIST
	extra_access = list()
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_LVL1, ACCESS_MEDICAL_LVL2, ACCESS_MEDICAL_LVL3, ACCESS_SCIENCE_LVL1)
	config_job = "chemist"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_MEDICAL_LVL4, ACCESS_MEDICAL_LVL5)
	job = /datum/job/chemist

/datum/id_trim/job/surgeon
	assignment = JOB_SURGEON
	trim_state = "sciencelvl1"
	sechud_icon_state = SECHUD_SURGEON
	extra_access = list()
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_LVL1, ACCESS_MEDICAL_LVL2, ACCESS_MEDICAL_LVL3, ACCESS_SCIENCE_LVL1)
	config_job = "surgeon"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_MEDICAL_LVL4, ACCESS_MEDICAL_LVL5)
	job = /datum/job/surgeon

/datum/id_trim/job/psychologist
	assignment = JOB_PSYCHOLOGIST
	trim_state = "sciencelvl2"
	sechud_icon_state = SECHUD_PSYCHOLOGIST
	extra_access = list()
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_LVL1, ACCESS_MEDICAL_LVL2, ACCESS_SCIENCE_LVL1, ACCESS_SCIENCE_LVL2)
	config_job = "psychologist"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_MEDICAL_LVL4, ACCESS_MEDICAL_LVL5)
	job = /datum/job/psychologist

/datum/id_trim/job/virologist
	assignment = JOB_VIROLOGIST
	trim_state = "sciencelvl1"
	sechud_icon_state = SECHUD_VIROLOGIST
	extra_access = list()
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MEDICAL_LVL1, ACCESS_MEDICAL_LVL2, ACCESS_MEDICAL_LVL3, ACCESS_SCIENCE_LVL1, ACCESS_SCIENCE_LVL2)
	config_job = "virologist"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_MEDICAL_LVL4, ACCESS_MEDICAL_LVL5)
	job = /datum/job/virologist

// ENGINEERING JOBS

/datum/id_trim/job/engineering_director
	assignment = JOB_ENGINEERING_DIRECTOR
	trim_state = "adminlvl4"
	sechud_icon_state = SECHUD_ENGINEERING_DIRECTOR
	extra_access = list()
	minimal_access = list(ACCESS_ADMIN_LVL1, ACCESS_ADMIN_LVL2, ACCESS_ADMIN_LVL3, ACCESS_ADMIN_LVL4, ACCESS_ENGINEERING, ACCESS_ENGINEERING_LVL1, ACCESS_ENGINEERING_LVL2, ACCESS_ENGINEERING_LVL3, ACCESS_ENGINEERING_LVL4, ACCESS_ENGINEERING_LVL5, ACCESS_SECURITY_LVL1, ACCESS_SCIENCE_LVL1, ACCESS_LOGISTICS_LVL1)
	config_job = "engineering_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5)
	job = /datum/job/engineering_director

/datum/id_trim/job/assistant_engineering_director
	assignment = JOB_ASSISTANT_ENGINEERING_DIRECTOR
	trim_state = "adminlvl3"
	sechud_icon_state = SECHUD_ENGINEERING_DIRECTOR
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3,
		ACCESS_ENGINEERING_LVL4,
		ACCESS_SCIENCE_LVL1,
		ACCESS_LOGISTICS_LVL1
	)
	config_job = "assistant_engineering_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5)
	job = /datum/job/assistant_engineering_director

/datum/id_trim/job/containment_engineer
	assignment = JOB_ASSISTANT_ENGINEERING_DIRECTOR
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_ENGINEERING_DIRECTOR
	extra_access = list()
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3,
		ACCESS_SCIENCE_LVL1
	)
	config_job = "engineering_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_ENGINEERING_LVL4, ACCESS_ENGINEERING_LVL5)
	job = /datum/job/containment_engineer

/datum/id_trim/job/it_technician
	assignment = JOB_IT_TECHNICIAN
	trim_state = "securitylvl3"
	sechud_icon_state = SECHUD_ENGINEERING_DIRECTOR
	extra_access = list()
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3,
		ACCESS_SCIENCE_LVL1
	)
	config_job = "engineering_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_ENGINEERING_LVL4, ACCESS_ENGINEERING_LVL5)
	job = /datum/job/it_technician

/datum/id_trim/job/comms_programmer
	assignment = JOB_COMMS_PROGRAMMER
	trim_state = "sciencelvl3"
	sechud_icon_state = SECHUD_ENGINEERING_DIRECTOR
	extra_access = list()
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3,
		ACCESS_SCIENCE,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
	)
	config_job = "engineering_director"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_ENGINEERING_LVL4, ACCESS_ENGINEERING_LVL5)
	job = /datum/job/comms_programmer

/datum/id_trim/job/junior_engineer
	assignment = JOB_JUNIOR_ENGINEER
	trim_state = "base"
	sechud_icon_state = SECHUD_JUNIOR_ENGINEER
	extra_access = list()
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3,
	)
	config_job = "junior_engineer"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_ENGINEERING_LVL4, ACCESS_ENGINEERING_LVL5)
	job = /datum/job/engineer

/datum/id_trim/job/engineer
	assignment = JOB_ENGINEER
	trim_state = "base"
	sechud_icon_state = SECHUD_ENGINEER
	extra_access = list()
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3
	)
	config_job = "engineer"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_ENGINEERING_LVL4, ACCESS_ENGINEERING_LVL5)
	job = /datum/job/engineer

/datum/id_trim/job/senior_engineer
	assignment = JOB_SENIOR_ENGINEER
	trim_state = "base"
	sechud_icon_state = SECHUD_SENIOR_ENGINEER
	extra_access = list()
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3
		)
	config_job = "senior_engineer"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_ENGINEERING_LVL4, ACCESS_ENGINEERING_LVL5)
	job = /datum/job/senior_engineer

/datum/id_trim/job/atmospheric_technician
	assignment = JOB_ATMOSPHERIC_TECHNICIAN
	trim_state = "base"
	sechud_icon_state = SECHUD_ATMOSPHERIC_TECHNICIAN
	extra_access = list()
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ENGINEERING_LVL2,
		ACCESS_ENGINEERING_LVL3
		)
	config_job = "engineer"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_ENGINEERING_LVL4, ACCESS_ENGINEERING_LVL5)
	job = /datum/job/atmospheric_technician

// LOGISTICS JOBS

/datum/id_trim/job/logistics_officer
	assignment = JOB_LOGISTICS_OFFICER
	trim_state = "adminlvl3"
	sechud_icon_state = SECHUD_LOGISTICS_OFFICER
	extra_access = list()
	minimal_access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_LOGISTICS,
		ACCESS_LOGISTICS_LVL1,
		ACCESS_LOGISTICS_LVL2,
		ACCESS_LOGISTICS_LVL3,
		ACCESS_LOGISTICS_LVL4,
		ACCESS_LOGISTICS_LVL5,
		ACCESS_SECURITY_LVL1
	)
	config_job = "logistics_officer"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5)
	job = /datum/job/logistics_officer

/datum/id_trim/job/logistics_technician
	assignment = JOB_LOGISTICS_TECHNICIAN
	trim_state = "base"
	sechud_icon_state = SECHUD_LOGISTICS_TECHNICIAN
	extra_access = list()
	minimal_access = list(
		ACCESS_LOGISTICS,
		ACCESS_LOGISTICS_LVL1,
		ACCESS_LOGISTICS_LVL2,
		ACCESS_LOGISTICS_LVL3
	)
	config_job = "logistics_technician"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_LOGISTICS_LVL5)
	job = /datum/job/logistics_technician

/datum/id_trim/job/shaft_miner
	assignment = JOB_PROSPECTOR
	trim_state = "base"
	sechud_icon_state = SECHUD_SHAFT_MINER
	extra_access = list()
	minimal_access = list(
		ACCESS_LOGISTICS,
		ACCESS_LOGISTICS_LVL1,
		ACCESS_LOGISTICS_LVL2,
		ACCESS_LOGISTICS_LVL3,
		ACCESS_LOGISTICS_LVL4
	)
	config_job = "shaft_miner"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_LOGISTICS_LVL5)
	job = /datum/job/shaft_miner

/// ID card obtained from the mining Disney dollar points vending machine.
/datum/id_trim/job/shaft_miner/spare
	extra_access = list()
	minimal_access = list(ACCESS_LOGISTICS_LVL2, ACCESS_MECH_MINING, ACCESS_LOGISTICS_LVL1, ACCESS_LOGISTICS_LVL3, ACCESS_LOGISTICS_LVL3)
	template_access = null

// SERVICE JOBS

/datum/id_trim/job/clown
	assignment = "Clown"
	trim_state = "trim_clown"
	sechud_icon_state = SECHUD_CLOWN
	extra_access = list()
	minimal_access = list(ACCESS_SERVICE, ACCESS_SERVICE)
	config_job = "clown"
	template_access = list(ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5)
	job = /datum/job/clown

/datum/id_trim/job/mime
	assignment = JOB_CLOWN
	trim_state = "base"
	sechud_icon_state = SECHUD_MIME
	extra_access = list()
	minimal_access = list(ACCESS_SERVICE)
	config_job = "mime"
	template_access = list(ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5)
	job = /datum/job/clown

/datum/id_trim/job/bartender
	assignment = JOB_BARTENDER
	trim_state = "base"
	sechud_icon_state = SECHUD_BARTENDER
	extra_access = list()
	minimal_access = list(ACCESS_SERVICE)
	config_job = "bartender"
	template_access = list(ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5)
	job = /datum/job/bartender

/datum/id_trim/job/cook
	assignment = JOB_COOK
	trim_state = "base"
	sechud_icon_state = SECHUD_COOK
	extra_access = list()
	minimal_access = list(ACCESS_SERVICE)
	config_job = "cook"
	template_access = list(ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5)
	job = /datum/job/cook

/datum/id_trim/job/cook/chef
	assignment = JOB_COOK
	sechud_icon_state = SECHUD_CHEF

/datum/id_trim/job/botanist
	assignment = JOB_BOTANIST
	trim_state = "base"
	sechud_icon_state = SECHUD_BOTANIST
	extra_access = list()
	minimal_access = list(ACCESS_SERVICE)
	config_job = "botanist"
	template_access = list(ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5)
	job = /datum/job/botanist

/datum/id_trim/job/chaplain
	assignment = JOB_CHAPLAIN
	trim_state = "base"
	sechud_icon_state = SECHUD_CHAPLAIN
	extra_access = list()
	minimal_access = list(ACCESS_SERVICE)
	config_job = "chaplain"
	template_access = list(ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5)
	job = /datum/job/chaplain

/datum/id_trim/job/janitor
	assignment = JOB_JANITOR
	trim_state = "base"
	sechud_icon_state = SECHUD_JANITOR
	extra_access = list()
	minimal_access = list(ACCESS_SERVICE, ACCESS_ENGINEERING_LVL1, ACCESS_MEDICAL_LVL1)
	config_job = "janitor"
	template_access = list(ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5)
	job = /datum/job/janitor

/datum/id_trim/job/prisoner
	assignment = "Prisoner"
	trim_state = "trim_prisoner"
	sechud_icon_state = SECHUD_PRISONER
	config_job = "prisoner"
	template_access = list(ACCESS_ADMIN_LVL5, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL5, ACCESS_ADMIN_LVL5)
	job = /datum/job/dclass

/datum/id_trim/job/prisoner
	assignment = "Prisoner"
	trim_state = "trim_prisoner"
	sechud_icon_state = SECHUD_PRISONER
	config_job = "prisoner"
	template_access = list(ACCESS_ADMIN_LVL4, ACCESS_ADMIN_LVL5, ACCESS_SECURITY_LVL4, ACCESS_SECURITY_LVL5)
	job = /datum/job/dclass

/datum/id_trim/job/prisoner/one
	trim_state = "trim_prisoner_1"
	template_access = null

/datum/id_trim/job/prisoner/two
	trim_state = "trim_prisoner_2"
	template_access = null

/datum/id_trim/job/prisoner/three
	trim_state = "trim_prisoner_3"
	template_access = null

/datum/id_trim/job/prisoner/four
	trim_state = "trim_prisoner_4"
	template_access = null

/datum/id_trim/job/prisoner/five
	trim_state = "trim_prisoner_5"
	template_access = null

/datum/id_trim/job/prisoner/six
	trim_state = "trim_prisoner_6"
	template_access = null

/datum/id_trim/job/prisoner/seven
	trim_state = "trim_prisoner_7"
	template_access = null

