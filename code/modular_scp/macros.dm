#define isscp106(A) istype(A, /mob/living/carbon/human/scp106)

#define isscp049(A) istype(A, /mob/living/carbon/human/scp049)

#define isscp343(A) istype(A, /mob/living/carbon/human/scp343)

#define isscp999(A) istype(A, /mob/living/scp999)

#define isscp131(A) istype(A, /mob/living/simple_animal/friendly/scp131)

#define isscp529(A) istype(A, /mob/living/simple_animal/cat/fluff/scp529)

#define isscp527(A) istype(A, /mob/living/carbon/human/scp527)

#define isscp173(A) istype(A, /mob/living/scp173)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define sound_to(target, sound)               to_target(target, sound)

#define isvirtualmob(A) istype(A, /mob/observer/virtual)

#define to_target(target, payload)            target << (payload)
