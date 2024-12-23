/**
 * This is the file you should use to add alternate titles for each job, just
 * follow the way they're done here, it's easy enough and shouldn't take any
 * time at all to add more or add some for a job that doesn't have any.
 */


/datum/job
	/// The list of alternative job titles people can pick from, null by default.
	var/list/alt_titles = null

// Heads
/datum/job/security_director
	alt_titles = list(JOB_SECURITY_DIRECTOR, "Guard Commander")

/datum/job/goi_rep
	alt_titles = list(
		JOB_GOC_REP,
		JOB_GOLDBAKER_REP,
		JOB_UIU_REP,
		JOB_MCD_REP
	)

// Security

/datum/job/investigations_agent
	alt_titles = list(
		JOB_INVESTIGATIONS_AGENT,
		"Forensics Specialist"
	)

// Research

/datum/job/junior_researcher
	alt_titles = list(
		"Junior AIAD Technican",
		"Junior Cryptozoologist",
		"Junior Xenobiologist",
		"Junior Xenoentomologist",
		"Junior Xenobotanologist",
		"Junior Xenoarcheologist",
		"Apprentice Thaumatologist",
		"Apprentice Alchemist",
		"Research Assistant"
		)

/datum/job/researcher
	alt_titles = list(
		JOB_RESEARCHER,
		"AIAD Technican",
		"Cryptozoologist",
		"Xenobiologist",
		"Xenoentomologist",
		"Xenobotanologist",
		"Xenoarcheologist",
		"Alchemist",
		"Thaumatologist"
		)

/datum/job/senior_researcher
	alt_titles = list(
		JOB_RESEARCHER,
		"Senior AIAD Technican",
		"Senior Cryptozoologist",
		"Senior Xenobiologist",
		"Senior Xenoentomologist",
		"Senior Xenobotanologist",
		"Senior Xenoarcheologist",
		"Elder Alchemist",
		"Elder Thaumatologist"
		)

// Medical

/datum/job/doctor
	alt_titles = list(JOB_MEDICAL_DOCTOR, "Physician")

/datum/job/paramedic
	alt_titles = list(JOB_PARAMEDIC, "Emergency Medical Technician")

/datum/job/chemist
	alt_titles = list(JOB_CHEMIST, "Pharmacist")

/datum/job/virologist
	alt_titles = list(JOB_VIROLOGIST, "Pathologist")

/datum/job/psychologist
	alt_titles = list(JOB_PSYCHOLOGIST, "Therapist")

// Engineering

/datum/job/senior_engineer
	alt_titles = list(JOB_SENIOR_ENGINEER, "Senior Maintenance Technician", "Senior Electrician", "Senior Engine Technician")

/datum/job/engineer
	alt_titles = list(JOB_ENGINEER, "Maintenance Technician", "Electrician", "Engine Technician")

/datum/job/junior_engineer
	alt_titles = list(JOB_JUNIOR_ENGINEER, "Junior Maintenance Technician", "Junior Electrician", "Junior Engine Technician")

// Cargo
/datum/job/logistics_officer
	alt_titles = list(JOB_LOGISTICS_OFFICER, "Quartermaster")

// Service

/datum/job/cook
	alt_titles = list(JOB_COOK, "Chef", "Culinary Artist")

/datum/job/botanist
	alt_titles = list(JOB_BOTANIST, "Hydroponicist")

/datum/job/curator
	alt_titles = list(JOB_IT_TECHNICIAN, "Archivist")

/datum/job/janitor
	alt_titles = list(JOB_JANITOR, "Custodian", "Sanitation Technician")

/datum/job/chaplain
	alt_titles = list(JOB_CHAPLAIN, "Horizon Initiative Shepard", "Priest", "Preacher", "Reverend", "Oracle", "Pontifex", "Magister", "High Priest", "Imam", "Rabbi", "Monk", "Counselor")
