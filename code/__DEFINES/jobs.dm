#define JOB_AVAILABLE 0
#define JOB_UNAVAILABLE_GENERIC 1
#define JOB_UNAVAILABLE_BANNED 2
#define JOB_UNAVAILABLE_PLAYTIME 3
#define JOB_UNAVAILABLE_ACCOUNTAGE 4
#define JOB_UNAVAILABLE_SLOTFULL 5
/// Job unavailable due to incompatibility with an antag role.
#define JOB_UNAVAILABLE_ANTAG_INCOMPAT 6

#define DEFAULT_RELIGION "Christianity"
#define DEFAULT_DEITY "Space Jesus"
#define DEFAULT_BIBLE "Default Bible Name"
#define DEFAULT_BIBLE_REPLACE(religion) "The Holy Book of [religion]"

#define JOB_DISPLAY_ORDER_DEFAULT 100


/**
 * =======================
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * WARNING WARNING WARNING
 * =======================
 * These names are used as keys in many locations in the database
 * you cannot change them trivially without breaking job bans and
 * role time tracking, if you do this and get it wrong you will die
 * and it will hurt the entire time
 */

//No department

#define JOB_ASSISTANT "Civilian"
#define JOB_DCLASS "D-Class"

//Command

#define JOB_SITE_DIRECTOR "Site Director"
#define JOB_HUMAN_RESOURCES_DIRECTOR "Human Resources Director"
#define JOB_INTERNAL_TRIBUNAL_DEPARTMENT_OFFICER "Internal Tribunal Department Officer"
#define JOB_ETHICS_COMMITTEE_LIAISON "Ethics Committee Liaison"
#define JOB_COMMUNICATIONS_DIRECTOR "Communications Director"

#define JOB_GOC_REP "Global Occult Coalition Representative"
#define JOB_GOLDBAKER_REP "Goldbaker-Reinz Corporate Representative"
#define JOB_MCD_REP "Marshal, Carter & Dark Corporate Representative"
#define JOB_UIU_REP "Unusual Incidents Unit Representative"

//Silicon

#define JOB_AI "AIC"
#define JOB_CYBORG "Cyborg"
#define JOB_PERSONAL_AI "Personal AIC"

//Security

#define JOB_SECURITY_DIRECTOR "Security Director"

#define JOB_EZ_COMMANDER "EZ Commander"
#define JOB_SENIOR_EZ_GUARD "Senior Guard"
#define JOB_EZ_GUARD "EZ Guard"
#define JOB_JUNIOR_EZ_GUARD "Junior Guard"

#define JOB_RAISA_AGENT "RAISA Agent"
#define JOB_INVESTIGATIONS_AGENT "Investigations Agent"

#define JOB_LCZ_COMMANDER "LCZ Commander"
#define JOB_SENIOR_LCZ_GUARD "Senior LCZ Guard"
#define JOB_LCZ_GUARD "LCZ Guard"
#define JOB_JUNIOR_LCZ_GUARD "Junior LCZ Guard"

#define JOB_HCZ_COMMANDER "HCZ Commander"
#define JOB_SENIOR_HCZ_GUARD "Senior HCZ Guard"
#define JOB_HCZ_GUARD "HCZ Guard"
#define JOB_JUNIOR_HCZ_GUARD "Junior HCZ Guard"

//Researcher
#define JOB_RESEARCH_DIRECTOR "Research Director"
#define JOB_ASSISTANT_RESEARCH_DIRECTOR "Assistant Research Director"
#define JOB_SENIOR_RESEARCHER "Senior Researcher"
#define JOB_RESEARCHER "Researcher"
#define JOB_JUNIOR_RESEARCHER "Junior Researcher"

//Medical
#define JOB_MEDICAL_DIRECTOR "Medical Director"
#define JOB_ASSISTANT_MEDICAL_DIRECTOR "Assistant Medical Director"
#define JOB_MEDICAL_DOCTOR "Medical Doctor"
#define JOB_SURGEON "Surgeon"
#define JOB_PARAMEDIC "Paramedic"
#define JOB_CHEMIST "Chemist"
#define JOB_TRAINEE_DOCTOR "Medical Resident"
#define JOB_VIROLOGIST "Virologist"
#define JOB_PSYCHOLOGIST "Psychologist"

//Engineering
#define JOB_ENGINEERING_DIRECTOR "Engineering Director"
#define JOB_ASSISTANT_ENGINEERING_DIRECTOR "Assistant Engineering Director"
#define JOB_CONTAINMENT_ENGINEER "Containment Engineer"
#define JOB_IT_TECHNICIAN "IT Technician"
#define JOB_COMMS_PROGRAMMER "Communications Programmer"
#define JOB_SENIOR_ENGINEER "Senior Engineer"
#define JOB_ENGINEER "Engineer"
#define JOB_JUNIOR_ENGINEER "Junior Engineer"
#define JOB_ATMOSPHERIC_TECHNICIAN "Atmospheric Technician"

//Logistics
#define JOB_LOGISTICS_OFFICER "Logistics Officer"
#define JOB_LOGISTICS_TECHNICIAN "Logistics Technician"

//Service
#define JOB_BOTANIST "Botanist"
#define JOB_COOK "Cook"
#define JOB_JANITOR "Janitor"
#define JOB_CLOWN "Morale Officer"
#define JOB_CHAPLAIN "Chaplain"

//ERTs
#define JOB_ERT_DEATHSQUAD "Death Commando"
#define JOB_ERT_COMMANDER "Emergency Response Team Commander"
#define JOB_ERT_OFFICER "Security Response Officer"
#define JOB_ERT_ENGINEER "Engineering Response Officer"
#define JOB_ERT_MEDICAL_DOCTOR "Medical Response Officer"
#define JOB_ERT_CHAPLAIN "Religious Response Officer"
#define JOB_ERT_JANITOR "Janitorial Response Officer"
#define JOB_ERT_CLOWN "Entertainment Response Officer"

//CentCom
#define JOB_CENTCOM "Central Command"
#define JOB_CENTCOM_OFFICIAL "CentCom Official"
#define JOB_CENTCOM_ADMIRAL "Admiral"
#define JOB_CENTCOM_COMMANDER "CentCom Commander"
#define JOB_CENTCOM_VIP "VIP Guest"
#define JOB_CENTCOM_BARTENDER "CentCom Bartender"
#define JOB_CENTCOM_CUSTODIAN "Custodian"
#define JOB_CENTCOM_THUNDERDOME_OVERSEER "Thunderdome Overseer"
#define JOB_CENTCOM_MEDICAL_DOCTOR "Medical Officer"
#define JOB_CENTCOM_RESEARCH_OFFICER "Research Officer"
#define JOB_CENTCOM_SPECIAL_OFFICER "Special Ops Officer"
#define JOB_CENTCOM_PRIVATE_SECURITY "Private Security Force"

#define DEPARTMENT_UNASSIGNED "No department assigned"

#define DEPARTMENT_BITFLAG_SECURITY (1<<0)
#define DEPARTMENT_SECURITY "Foundation Security"
#define DEPARTMENT_BITFLAG_MANAGEMENT (1<<1)
#define DEPARTMENT_MANAGEMENT "Foundation Administration"
#define DEPARTMENT_BITFLAG_SERVICE (1<<2)
#define DEPARTMENT_SERVICE "Foundation Service"
#define DEPARTMENT_BITFLAG_CARGO (1<<3)
#define DEPARTMENT_CARGO "Foundation Logistics"
#define DEPARTMENT_BITFLAG_ENGINEERING (1<<4)
#define DEPARTMENT_ENGINEERING "Foundation Engineering"
#define DEPARTMENT_BITFLAG_SCIENCE (1<<5)
#define DEPARTMENT_SCIENCE "Foundation Research"
#define DEPARTMENT_BITFLAG_MEDICAL (1<<6)
#define DEPARTMENT_MEDICAL "Foundation Medical"
#define DEPARTMENT_BITFLAG_SILICON (1<<7)
#define DEPARTMENT_SILICON "Artifical Intelligence Applications"
#define DEPARTMENT_BITFLAG_ASSISTANT (1<<8)
#define DEPARTMENT_ASSISTANT "Civilian"
#define DEPARTMENT_BITFLAG_CAPTAIN (1<<9)
#define DEPARTMENT_CAPTAIN "Site Director"
#define DEPARTMENT_BITFLAG_COMPANY_LEADER (1<<10)
#define DEPARTMENT_COMPANY_LEADER "Company Leader"

/* Job datum job_flags */
/// Whether the mob is announced on arrival.
#define JOB_ANNOUNCE_ARRIVAL (1<<0)
/// Whether the mob is added to the crew manifest.
#define JOB_CREW_MANIFEST (1<<1)
/// Whether the mob is equipped through SSjob.EquipRank() on spawn.
#define JOB_EQUIP_RANK (1<<2)
/// Whether the job is considered a regular crew member of the station. Equipment such as AI and cyborgs not included.
#define JOB_CREW_MEMBER (1<<3)
/// Whether this job can be joined through the new_player menu.
#define JOB_NEW_PLAYER_JOINABLE (1<<4)
/// Reopens this position if we lose the player at roundstart.
#define JOB_REOPEN_ON_ROUNDSTART_LOSS (1<<5)
/// If the player with this job can have quirks assigned to him or not. Relevant for new player joinable jobs and roundstart antags.
#define JOB_ASSIGN_QUIRKS (1<<6)
/// Whether this job can be an intern.
#define JOB_CAN_BE_INTERN (1<<7)

#define FACTION_NONE "None"
#define FACTION_STATION "Site"
