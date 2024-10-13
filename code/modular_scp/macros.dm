#define isscp106(A) istype(A, /mob/living/carbon/human/scp106)

#define isscp049(A) istype(A, /mob/living/carbon/human/scp049)

#define isscp343(A) istype(A, /mob/living/carbon/human/scp343)

#define isscp999(A) istype(A, /mob/living/scp999)

#define isscp131(A) istype(A, /mob/living/simple_animal/friendly/scp131)

#define isscp529(A) istype(A, /mob/living/simple_animal/cat/fluff/scp529)

#define isscp527(A) istype(A, /mob/living/carbon/human/scp527)

#define isscp173(A) istype(A, /mob/living/scp173)


/proc/isspecies(A, B)
	if(!iscarbon(A))
		return FALSE
	var/mob/living/carbon/C = A
	return C.species?.name == B
