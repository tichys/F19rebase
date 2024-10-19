GLOBAL_LIST_EMPTY(SCP_list)

GLOBAL_LIST_EMPTY(scramble_hud_users)     // List of all entities using SCRAMBLE gear

#define gender2text(gender) capitalize(gender)

#define isscp106(A) istype(A, /mob/living/carbon/human/scp106)

#define isscp049(A) istype(A, /mob/living/carbon/human/scp049)

#define isscp343(A) istype(A, /mob/living/carbon/human/scp343)

#define isscp999(A) istype(A, /mob/living/scp999)

#define isscp131(A) istype(A, /mob/living/simple_animal/friendly/scp131)

#define isscp529(A) istype(A, /mob/living/simple_animal/cat/fluff/scp529)

#define isscp527(A) istype(A, /mob/living/carbon/human/scp527)

#define isscp173(A) istype(A, /mob/living/scp173)


#define isghost(A) istype(A, /mob/dead/observer)


/// sent every carbon Life()
#define COMSIG_CARBON_LIFE "carbon_life"

/// Called on `/atom/movable/Move` and `/atom/movable/proc/forceMove` (/atom/movable, /atom, /atom)
#define COMSIG_MOVED "moved"
