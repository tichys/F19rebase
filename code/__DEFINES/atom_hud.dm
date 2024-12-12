// for secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list
// note: if you add more HUDs, even for non-human atoms, make sure to use unique numbers for the defines!
// /datum/atom_hud expects these to be unique
// these need to be strings in order to make them associative lists
/// dead, alive, sick, health status
#define HEALTH_HUD "1"
/// a simple line rounding the mob's number health
#define STATUS_HUD "2"
/// the job asigned to your ID
#define ID_HUD "3"
/// wanted, released, parroled, security status
#define WANTED_HUD "4"
/// loyality implant
#define IMPLOYAL_HUD "5"
/// chemical implant
#define IMPCHEM_HUD "6"
/// tracking implant
#define IMPTRACK_HUD "7"
/// Silicon/Mech/Circuit Status
#define DIAG_STAT_HUD "8"
/// Silicon health bar
#define DIAG_HUD "9"
/// Borg/Mech/Circutry power meter
#define DIAG_BATT_HUD "10"
/// Mech health bar
#define DIAG_MECH_HUD "11"
/// Bot HUDs
#define DIAG_BOT_HUD "12"
/// Circuit assembly health bar
#define DIAG_CIRCUIT_HUD "13"
/// Mech/Silicon tracking beacon, Circutry long range icon
#define DIAG_TRACK_HUD "14"
/// Airlock shock overlay
#define DIAG_AIRLOCK_HUD "15"
/// Bot path indicators
#define DIAG_PATH_HUD "16"
/// Gland indicators for abductors
#define GLAND_HUD "17"
#define SENTIENT_DISEASE_HUD "18"
#define AI_DETECT_HUD "19"
#define BLINK_HUD       "20" // A line representing the blink time remaining on a mob.
#define PESTILENCE_HUD  "21" // A visual indicator of the pestilence for SCP-049.

/// Displays launchpads' targeting reticle
#define DIAG_LAUNCHPAD_HUD "22"

//by default everything in the hud_list of an atom is an image
//a value in hud_list with one of these will change that behavior
#define HUD_LIST_LIST 1

//data HUD (medhud, sechud) defines
//Don't forget to update human/New() if you change these!
#define DATA_HUD_SECURITY_BASIC 1
#define DATA_HUD_SECURITY_ADVANCED 2
#define DATA_HUD_MEDICAL_BASIC 3
#define DATA_HUD_MEDICAL_ADVANCED 4
#define DATA_HUD_DIAGNOSTIC_BASIC 5
#define DATA_HUD_DIAGNOSTIC_ADVANCED 6
#define DATA_HUD_ABDUCTOR 7
#define DATA_HUD_SENTIENT_DISEASE 8
#define DATA_HUD_AI_DETECT 9

// Notification action types
#define NOTIFY_JUMP "jump"
#define NOTIFY_ATTACK "attack"
#define NOTIFY_ORBIT "orbit"

/// cooldown for being shown the images for any particular data hud
#define ADD_HUD_TO_COOLDOWN 20


// Security HUD icon_state defines

#define SECHUD_NO_ID "hudno_id"
#define SECHUD_UNKNOWN "hudunknown"
#define SECHUD_CENTCOM "hudcentcom"
#define SECHUD_SYNDICATE "hudsyndicate"

#define SECHUD_ASSISTANT "hudassistant"
#define SECHUD_BARTENDER "hudbartender"
#define SECHUD_BOTANIST "hudbotanist"
#define SECHUD_CHAPLAIN "hudchaplain"
#define SECHUD_CHIEF_ENGINEER "hudchiefengineer"
#define SECHUD_CLOWN "hudclown"
#define SECHUD_COOK "hudcook"
#define SECHUD_CURATOR "hudcurator"
#define SECHUD_GENETICIST "hudgeneticist"
#define SECHUD_JANITOR "hudjanitor"
#define SECHUD_MIME "hudmime"
#define SECHUD_PRISONER "hudprisoner"
#define SECHUD_ROBOTICIST "hudroboticist"
#define SECHUD_SECURITY_OFFICER "hudsecurityofficer"
#define SECHUD_VIROLOGIST "hudvirologist"
#define SECHUD_WARDEN "hudwarden"

#define SECHUD_SITE_DIRECTOR "hudsitedirector"
#define SECHUD_HUMAN_RESOURCES_DIRECTOR "hudhumanresources"
#define SECHUD_INTERNAL_TRIBUNAL_DEPARTMENT_OFFICER "huditdo"
#define SECHUD_ETHICS_COMMITTEE_LIAISON "hudecl"
#define SECHUD_GOI_REP "hudgoi"
#define SECHUD_COMMUNICATIONS_DIRECTOR "hudcommsofficer"

#define SECHUD_LCZ_ZONE_COMMANDER "hudlczcommander"
#define SECHUD_LCZ_SENIOR_GUARD "hudlczsarge"
#define SECHUD_LCZ_GUARD "hudlczsenior"
#define SECHUD_LCZ_JUNIOR_GUARD "hudlczguard"

#define SECHUD_HCZ_ZONE_COMMANDER "hudhczcommander"
#define SECHUD_HCZ_SENIOR_GUARD "hudhczsarge"
#define SECHUD_HCZ_GUARD "hudhczsenior"
#define SECHUD_HCZ_JUNIOR_GUARD "hudhczguard"

#define SECHUD_EZ_ZONE_COMMANDER "hudezcommander"
#define SECHUD_EZ_SENIOR_GUARD "hudezsarge"
#define SECHUD_EZ_GUARD "hudezsenior"
#define SECHUD_EZ_JUNIOR_GUARD "hudezguard"

#define SECHUD_SECURITY_DIRECTOR "hudguardcommander"
#define SECHUD_RAISA "hudraisa"
#define SECHUD_DETECTIVE "huddetective"

#define SECHUD_RESEARCH_DIRECTOR "hudresearchdirector_gold"
#define SECHUD_ASSISTANT_RESEARCH_DIRECTOR "hudassistantresearchdirector"
#define SECHUD_SENIOR_RESEARCHER "hudseniorresearcher"
#define SECHUD_RESEARCHER "hudscientist"
#define SECHUD_JUNIOR_RESEARCHER "hudresearchassistant"

#define SECHUD_MEDICAL_DIRECTOR "hudchiefmedicalofficer_gold"
#define SECHUD_ASSISTANT_MEDICAL_DIRECTOR "hudassistantmedicalofficer"
#define SECHUD_MEDICAL_DOCTOR "hudmedicaldoctor"
#define SECHUD_SURGEON "hudsurgeon"
#define SECHUD_CHEMIST "hudchemist"
#define SECHUD_PARAMEDIC "hudparamedic"
#define SECHUD_PSYCHOLOGIST "hudpsychologist"
#define SECHUD_TRAINEE_DOCTOR "hudmedicalassistant"

#define SECHUD_ENGINEERING_DIRECTOR "hudchiefengineer_gold"
#define SECHUD_ASSISTANT_ENGINEERING_DIRECTOR "hudassistantengineer"
#define SECHUD_CONTAINMENT_ENGINEER "hudcontainmentengineer"
#define SECHUD_COMMS_PROGRAMMER "hudcommsprogrammer"
#define SECHUD_IT_TECHNICIAN "hudittech"
#define SECHUD_ATMOSPHERIC_TECHNICIAN "hudatmospherictechnician"
#define SECHUD_SENIOR_ENGINEER "hudseniorengineer"
#define SECHUD_ENGINEER "hudstationengineer"
#define SECHUD_JUNIOR_ENGINEER "hudengineeringcontractor"

#define SECHUD_LOGISTICS_OFFICER "hudquartermaster"
#define SECHUD_LOGISTICS_TECHNICIAN "hudcargotechnician"
#define SECHUD_SHAFT_MINER "hudshaftminer"

#define SECHUD_CHEF "hudchef"

#define SECHUD_DEATH_COMMANDO "huddeathcommando"

#define SECHUD_EMERGENCY_RESPONSE_TEAM_COMMANDER "hudemergencyresponseteamcommander"
#define SECHUD_SECURITY_RESPONSE_OFFICER "hudsecurityresponseofficer"
#define SECHUD_ENGINEERING_RESPONSE_OFFICER "hudengineeringresponseofficer"
#define SECHUD_MEDICAL_RESPONSE_OFFICER "hudmedicalresponseofficer"
#define SECHUD_RELIGIOUS_RESPONSE_OFFICER "hudreligiousresponseofficer"
#define SECHUD_JANITORIAL_RESPONSE_OFFICER "hudjanitorialresponseofficer"
#define SECHUD_ENTERTAINMENT_RESPONSE_OFFICER "hudentertainmentresponseofficer"
