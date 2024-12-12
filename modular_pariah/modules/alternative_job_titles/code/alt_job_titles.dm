/**
 * This is the file you should use to add alternate titles for each job, just
 * follow the way they're done here, it's easy enough and shouldn't take any
 * time at all to add more or add some for a job that doesn't have any.
 */


/datum/job
	/// The list of alternative job titles people can pick from, null by default.
	var/list/alt_titles = null

// Heads
/datum/job/engineering_director
	alt_titles = list(JOB_ENGINEERING_DIRECTOR)

/datum/job/medical_director
	alt_titles = list(JOB_MEDICAL_DIRECTOR)

/datum/job/security_director
	alt_titles = list(JOB_SECURITY_DIRECTOR)

// Security

/datum/job/investigations_agent
	alt_titles = list(JOB_INVESTIGATIONS_AGENT, "Forensics Specialist")

// Research

/datum/job/junior_researcher
	alt_titles = list(
		"Junior AIAD Technican",
		"Junior Xenobiologist",
		"Junior Xenobotanologist",
		"Junior Xenoarcheologist",
		"Apprentice Thaumatologist",
		"Research Assistant"
		)

/datum/job/researcher
	alt_titles = list(
		JOB_RESEARCHER,
		"AIAD Technican",
		"Xenobiologist",
		"Xenobotanologist",
		"Xenoarcheologist",
		"Thaumatologist"
		)

/datum/job/senior_researcher
	alt_titles = list(
		JOB_RESEARCHER,
		"Senior AIAD Technican",
		"Senior Xenobiologist",
		"Senior Xenobotanologist",
		"Senior Xenoarcheologist",
		"Elder Thaumatologist"
		)

// Medical

/datum/job/doctor
	alt_titles = list(JOB_MEDICAL_DOCTOR, "Physician")

/datum/job/paramedic
	alt_titles = list(JOB_PARAMEDIC)

/datum/job/chemist
	alt_titles = list(JOB_CHEMIST, "Pharmacist")

/datum/job/virologist
	alt_titles = list(JOB_VIROLOGIST, "Pathologist")

/datum/job/psychologist
	alt_titles = list(JOB_PSYCHOLOGIST)

// Engineering

/datum/job/senior_engineer
	alt_titles = list(JOB_SENIOR_ENGINEER, "Senior Maintenance Technician", "Senior Electrician", "Senior Engine Technician")

/datum/job/engineer
	alt_titles = list(JOB_ENGINEER, "Maintenance Technician", "Electrician", "Engine Technician")

/datum/job/junior_engineer
	alt_titles = list(JOB_JUNIOR_ENGINEER, "Junior Maintenance Technician", "Junior Electrician", "Junior Engine Technician")

/datum/job/atmospheric_technician
	alt_titles = list(JOB_ATMOSPHERIC_TECHNICIAN)

// Cargo
/datum/job/logistics_officer
	alt_titles = list(JOB_LOGISTICS_OFFICER)

/datum/job/logistics_technician
	alt_titles = list(JOB_LOGISTICS_TECHNICIAN, "Mailman")

// Service

/datum/job/cook
	alt_titles = list(JOB_COOK, "Chef", "Culinary Artist")

/datum/job/botanist
	alt_titles = list(JOB_BOTANIST)

/datum/job/curator
	alt_titles = list(JOB_IT_TECHNICIAN)

/datum/job/janitor
	alt_titles = list(JOB_JANITOR, "Custodian", "Sanitation Technician")

/datum/job/chaplain
	alt_titles = list(JOB_CHAPLAIN, "Horizon Initiative Shepard", "Priest", "Preacher", "Reverend", "Oracle", "Pontifex", "Magister", "High Priest", "Imam", "Rabbi", "Monk", "Counselor")
