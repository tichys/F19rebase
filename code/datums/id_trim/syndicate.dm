/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/syndicom
	assignment = "Syndicate Overlord"
	trim_state = "trim_syndicate"
	sechud_icon_state = SECHUD_SYNDICATE
	access = list(ACCESS_SYNDICATE)

/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/syndicom/crew
	assignment = "Syndicate Operative"
	access = list(ACCESS_SYNDICATE, ACCESS_SCIENCE_LVL2)

/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/syndicom/captain
	assignment = "Syndicate Ship Captain"
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER, ACCESS_SCIENCE_LVL2)

/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/battlecruiser
	assignment = "Syndicate Battlecruiser Crew"
	trim_state = "trim_syndicate"
	access = list(ACCESS_SYNDICATE)

/// Trim for Syndicate mobs, outfits and corpses.
/datum/id_trim/battlecruiser/captain
	assignment = "Syndicate Battlecruiser Captain"
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon
	assignment = "Unknown"
	access = list(ACCESS_SYNDICATE, ACCESS_ENGINEERING_LVL1)

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon/operative
	assignment = "Syndicate Operative"
	trim_state = "trim_syndicate"

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon/operative/clown
	assignment = "Syndicate Entertainment Operative"

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon/operative/clown_leader
	assignment = "Syndicate Entertainment Operative Leader"
	access = list(ACCESS_ENGINEERING_LVL1, ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)

/// Trim for Chameleon ID cards. Many outfits, nuke ops and some corpses hold Chameleon ID cards.
/datum/id_trim/chameleon/operative/nuke_leader
	assignment = "Syndicate Operative Leader"
	access = list(ACCESS_ENGINEERING_LVL1, ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
