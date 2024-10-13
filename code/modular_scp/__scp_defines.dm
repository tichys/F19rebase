/atom/var/datum/scp/SCP //For SCP's

// Classifcations

#define SCP_SAFE		"Safe"
#define SCP_EUCLID		"Euclid"
#define SCP_KETER 		"Keter"
#define SCP_THAUMIEL	"Thaumiel"
#define SCP_NEUTRALIZED "Neutralized"

// SCP 914 defines
#define MODE_ROUGH "Rough"
#define MODE_COARSE "Coarse"
#define MODE_ONE_TO_ONE "1:1"
#define MODE_FINE "Fine"
#define MODE_VERY_FINE "Very Fine"

//Meta bitflags

///Is the SCP playable?
#define SCP_PLAYABLE 		(1<<0)
///Is it a roleplay oriented SCP?
#define SCP_ROLEPLAY		(1<<1)
///Does the scp have memetic properties?
#define SCP_MEMETIC			(1<<2)
///Is this SCP disabled and should be prevented from spawning?
#define SCP_DISABLED (1<<3)

//Memetic bitflags

///Do memetics take affect when the atom is seen?
#define MVISUAL				(1<<0)
///Do memetics take affect when the atom is heard?
#define MAUDIBLE			(1<<1)
///Do memetics take affect when the atom is inspected?
#define MINSPECT			(1<<2)
///Should memetics take affect through cameras?
#define MCAMERA				(1<<3)
///Should memetics take affect through photos?
#define MPHOTO				(1<<4)
///Is the individual still affected after they no longer meet the memetic requirements? Only use if the MSYNCED flag is used.
#define MPERSISTENT			(1<<5)
///Is the scp memetic effect synced? If this flag is enabled the memetic comp's active_memetic_effect() must be called to enact the memetic effect.
#define MSYNCED				(1<<6)

//Memetic insulation defines
//Audio insulation
#define A_INSL_NONE 		0
#define A_INSL_IMPERFECT 	1
#define A_INSL_PERFECT 		2
//Visual insulation
#define V_INSL_NONE 		0
#define V_INSL_IMPERFECT 	1
#define V_INSL_PERFECT 		2


/// Called in '/mob/verb/examinate' on examined atom (/mob/examinee)
#define COMSIG_ATOM_EXAMINED "atomExamined"

/// Called in '/mob/living/say' on the mob who heard speech (/mob/living/speaker, message)
#define COMSIG_MOB_HEARD_SPEECH "mobHeardSpeech"
/// Called in '/mob/living/say' on the mob who heard the whisper (/mob/living/speaker, list(message)). Message is passed in a list so that back-editing is possible.
#define COMSIG_MOB_HEARD_WHISPER "mobHeardWhisper"
/// Called in 'mob/on_hear_say' on the mob who heard whatever message (/mob/hearer, message)
#define COMSIG_MOB_HEAR "mob_hear"


/*
*	Photos
*/

/// Called in '/obj/item/device/camera/proc/captureimage' on the atom taken a picture of (/obj/item/device/camera, mob/living/user)
#define COMSIG_PHOTO_TAKEN_OF "photoTakenOf"
/// Called in '/obj/item/photo/proc/show' on the atom that the photo was shown of (/obj/item/photo, mob/user)
#define COMSIG_PHOTO_SHOWN_OF "photoShownOf"

/*
*	Sound
*/

/// Called in '/mob/proc/playsound_local' on the atom that the sound originated from (/mob/hearer, sound)
#define COMSIG_OBJECT_SOUND_HEARD "atomHeard"
/// Called in '/datum/sound_token/proc/PrivUpdateListener' on the atom that the sound originated from (/mob/hearer, sound)
#define COMSIG_OBJECT_SOUND_HEARD_LOOPING "atomHeardLooping"

/*
*	Eye
*/

/// Called in '/mob/proc/reset_view' on every atom in view of new eyeobj (/mob/viewer, /atom/new_view)
#define COMSIG_ATOM_VIEW_RESET "atomViewReset"

#define set_temp_blindness(duration) set_timed_status_effect(duration, /datum/status_effect/temporary_blindness)
#define set_temp_blindness_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/temporary_blindness, TRUE)

#define MOB_FACTION_NEUTRAL "neutral"

#define EXTENSION_FLAG_NONE 0
#define EXTENSION_FLAG_IMMEDIATE 1          // Instantly instantiates, instead of doing it lazily.
//#define EXTENSION_FLAG_MULTIPLE_INSTANCES 2 // Allows multiple instances per base type. To be implemented
