/*
	These defines are specific to the atom/flags_1 bitmask
*/
#define ALL (~0) //For convenience.
#define NONE 0

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

/* Directions */
///All the cardinal direction bitflags.
#define ALL_CARDINALS (NORTH|SOUTH|EAST|WEST)

// for /datum/var/datum_flags
#define DF_USE_TAG (1<<0)
#define DF_VAR_EDITED (1<<1)
#define DF_ISPROCESSING (1<<2)

//FLAGS BITMASK
// scroll down before changing the numbers on these

/// Is this object currently processing in the atmos object list?
#define ATMOS_IS_PROCESSING_1 (1<<0)
/// conducts electricity (metal etc.)
#define CONDUCT_1 (1<<1)
/// For machines and structures that should not break into parts, eg, holodeck stuff
#define NODECONSTRUCT_1 (1<<2)
/// item has priority to check when entering or leaving
#define ON_BORDER_1 (1<<3)
///Whether or not this atom shows screentips when hovered over
#define NO_SCREENTIPS_1 (1<<4)
/// Prevent clicking things below it on the same turf eg. doors/ fulltile windows
#define PREVENT_CLICK_UNDER_1 (1<<5)
///specifies that this atom is a hologram that isnt real
#define HOLOGRAM_1 (1<<6)
/// was this spawned by an admin? used for stat tracking stuff.
#define ADMIN_SPAWNED_1 (1<<7)
/// should not get harmed if this gets caught by an explosion?
#define PREVENT_CONTENTS_EXPLOSION_1 (1<<8)
/// Should this object be paintable with very dark colors?
#define ALLOW_DARK_PAINTS_1 (1<<9)
/// Should this object be unpaintable?
#define UNPAINTABLE_1 (1<<10)
/// Is the thing currently spinning?
#define IS_SPINNING_1 (1<<11)
#define SUPERMATTER_IGNORES_1 (1<<12)
/// If a turf can be made dirty at roundstart. This is also used in areas.
#define CAN_BE_DIRTY_1 (1<<13)
/// Should we use the initial icon for display? Mostly used by overlay only objects
#define HTML_USE_INITAL_ICON_1 (1<<14)
/// Can players recolor this in-game via vendors (and maybe more if support is added)?
#define IS_PLAYER_COLORABLE_1 (1<<15)
/// Whether or not this atom has contextual screentips when hovered OVER
#define HAS_CONTEXTUAL_SCREENTIPS_1 (1<<16)
// Whether or not this atom is storing contents for a disassociated storage object
#define HAS_DISASSOCIATED_STORAGE_1 (1<<17)
// Atom has similar priority to border objects when doing Bump() calculations.
#define BUMP_PRIORITY_1 (1<<18)
/// If this atom has experienced a decal element "init finished" sourced appearance update
/// We use this to ensure stacked decals don't double up appearance updates for no rasin
/// Flag as an optimization, don't make this a trait without profiling
/// Yes I know this is a stupid flag, no you can't take him from me ~LemonInTheDark
#define DECAL_INIT_UPDATE_EXPERIENCED_1 (1<<19)

//OH YEAH BABY FLAGS_2 HERE WE GO
///Plasma Contamination
#define CONTAMINATED_2 (1<<0)
///Uses atom temperature. Opt-in.
#define ATMOS_SENSITIVE_2 (1<<1)

// Update flags for [/atom/proc/update_appearance]
/// Update the atom's name
#define UPDATE_NAME (1<<0)
/// Update the atom's desc
#define UPDATE_DESC (1<<1)
/// Update the atom's icon state
#define UPDATE_ICON_STATE (1<<2)
/// Update the atom's overlays
#define UPDATE_OVERLAYS (1<<3)
/// Update the atom's greyscaling
#define UPDATE_GREYSCALE (1<<4)
/// Update the atom's smoothing. (More accurately, queue it for an update)
#define UPDATE_SMOOTHING (1<<5)
/// Update the atom's icon
#define UPDATE_ICON (UPDATE_ICON_STATE|UPDATE_OVERLAYS)

/// If the thing can reflect light (lasers/energy)
#define RICOCHET_SHINY (1<<0)
/// If the thing can reflect matter (bullets/bomb shrapnel)
#define RICOCHET_HARD (1<<1)

//TURF FLAGS
/// If a turf cant be jaunted through.
#define NOJAUNT (1<<0)
#define UNUSED_RESERVATION_TURF (1<<1)
/// Blocks lava rivers being generated on the turf.
#define NO_LAVA_GEN (1<<3)
/// Blocks ruins spawning on the turf.
#define NO_RUINS (1<<4)
/// Blocks this turf from being rusted
#define NO_RUST (1<<5)
/// Is this turf is "solid". Space and lava aren't for instance
#define IS_SOLID (1<<6)

////////////////Area flags\\\\\\\\\\\\\\
/// If it's a valid territory for cult summoning or the CRAB-17 phone to spawn
#define VALID_TERRITORY (1<<0)
/// If blobs can spawn there and if it counts towards their score.
#define BLOBS_ALLOWED (1<<1)
/// If mining tunnel generation is allowed in this area
#define CAVES_ALLOWED (1<<2)
/// If flora are allowed to spawn in this area randomly through tunnel generation
#define FLORA_ALLOWED (1<<3)
/// If mobs can be spawned by natural random generation
#define MOB_SPAWN_ALLOWED (1<<4)
/// Are you forbidden from teleporting to the area? (centcom, mobs, wizard, hand teleporter)
#define NOTELEPORT (1<<5)
/// Hides area from player Teleport function.
#define HIDDEN_AREA (1<<6)
/// If false, loading multiple maps with this area type will create multiple instances.
#define UNIQUE_AREA (1<<7)
/// If people are allowed to suicide in it. Mostly for OOC stuff like minigames
#define BLOCK_SUICIDE (1<<8)
/// Can the Xenobio management console transverse this area by default?
#define XENOBIOLOGY_COMPATIBLE (1<<9)
/// If Abductors are unable to teleport in with their observation console
#define ABDUCTOR_PROOF (1<<10)
/// If an area should be hidden from power consoles, power/atmosphere alerts, etc.
#define NO_ALERTS (1<<11)
/// If blood cultists can draw runes or build structures on this AREA.
#define CULT_PERMITTED (1<<12)
///Whther this area is iluminated by starlight
#define AREA_USES_STARLIGHT (1<<13)
/// If engravings are persistent in this area
#define PERSISTENT_ENGRAVINGS (1<<14)
/// Display this area's name to mobs upon entering the area.
#define SHOW_NAME (1<<15)

/*
	These defines are used specifically with the atom/pass_flags bitmask
	the atom/checkpass() proc uses them (tables will call movable atom checkpass(PASSTABLE) for example)
*/
//flags for pass_flags
#define PASSTABLE (1<<0)
#define PASSGLASS (1<<1)
#define PASSGRILLE (1<<2)
#define PASSBLOB (1<<3)
#define PASSMOB (1<<4)
#define PASSCLOSEDTURF (1<<5)
/// Let thrown things past us. **ONLY MEANINGFUL ON pass_flags_self!**
#define LETPASSTHROW (1<<6)
#define PASSMACHINE (1<<7)
#define PASSSTRUCTURE (1<<8)
#define PASSFLAPS (1<<9)
#define PASSDOORS (1<<10)
#define PASSVEHICLE (1<<11)
#define PASSITEM (1<<12)
/// Do not intercept click attempts during Adjacent() checks. See [turf/proc/ClickCross].
#define LETPASSCLICKS (1<<13)
/// Pass through flock objects and mobs
#define PASSFLOCK (1<<14)

//Movement Types
#define GROUND (1<<0)
#define FLYING (1<<1)
#define VENTCRAWLING (1<<2)
#define FLOATING (1<<3)
/// When moving, will Cross() everything, but won't stop or Bump() anything.
#define PHASING (1<<4)

//Fire and Acid stuff, for resistance_flags
#define LAVA_PROOF (1<<0)
/// 100% immune to fire damage (but not necessarily to lava or heat)
#define FIRE_PROOF (1<<1)
#define FLAMMABLE (1<<2)
#define ON_FIRE (1<<3)
/// acid can't even appear on it, let alone melt it.
#define UNACIDABLE (1<<4)
/// acid stuck on it doesn't melt it.
#define ACID_PROOF (1<<5)
/// doesn't take damage
#define INDESTRUCTIBLE (1<<6)
/// can't be frozen
#define FREEZE_PROOF (1<<7)

//tesla_zap
#define ZAP_MACHINE_EXPLOSIVE (1<<0)
#define ZAP_ALLOW_DUPLICATES (1<<1)
#define ZAP_OBJ_DAMAGE (1<<2)
#define ZAP_MOB_DAMAGE (1<<3)
#define ZAP_MOB_STUN (1<<4)
#define ZAP_GENERATES_POWER (1<<5)
/// Zaps with this flag will generate less power through tesla coils
#define ZAP_LOW_POWER_GEN (1<<6)
#define ZAP_NO_COOLDOWN (1<<7)

#define ZAP_DEFAULT_FLAGS ZAP_MOB_STUN | ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_NO_COOLDOWN
#define ZAP_ENERGYBALL_FLAGS ((ZAP_DEFAULT_FLAGS) &~ ZAP_NO_COOLDOWN)
#define ZAP_FUSION_FLAGS ZAP_OBJ_DAMAGE | ZAP_MOB_DAMAGE | ZAP_MOB_STUN
#define ZAP_SUPERMATTER_FLAGS ZAP_GENERATES_POWER

/// Convert a power value to mob damage
#define TESLA_MOB_DAMAGE_COEFF 600
#define TESLA_POWER_TO_MOB_DAMAGE(power) floor(power / TESLA_MOB_DAMAGE_COEFF)
/// Convert a desired damage value into the required power amount
#define TESLA_MOB_DAMAGE_TO_POWER(desired_damage) floor(desired_damage * TESLA_MOB_DAMAGE_COEFF)

//EMP protection
#define EMP_PROTECT_SELF (1<<0)
#define EMP_PROTECT_CONTENTS (1<<1)
#define EMP_PROTECT_WIRES (1<<2)

//Mob mobility var flags
/// can move
#define MOBILITY_MOVE (1<<0)
/// can, and is, standing up
#define MOBILITY_STAND (1<<1)
/// can pickup items
#define MOBILITY_PICKUP (1<<2)
/// can hold and use items
#define MOBILITY_USE (1<<3)
/// can use interfaces like machinery
#define MOBILITY_UI (1<<4)
/// can use storage item
#define MOBILITY_STORAGE (1<<5)
/// can pull things
#define MOBILITY_PULL (1<<6)
/// can rest
#define MOBILITY_REST (1<<7)
/// can lie down
#define MOBILITY_LIEDOWN (1<<8)

#define MOBILITY_FLAGS_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_PICKUP | MOBILITY_USE | MOBILITY_UI | MOBILITY_STORAGE | MOBILITY_PULL)
#define MOBILITY_FLAGS_CARBON_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_PICKUP | MOBILITY_USE | MOBILITY_UI | MOBILITY_STORAGE | MOBILITY_PULL | MOBILITY_REST | MOBILITY_LIEDOWN)
#define MOBILITY_FLAGS_REST_CAPABLE_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_PICKUP | MOBILITY_USE | MOBILITY_UI | MOBILITY_STORAGE | MOBILITY_PULL | MOBILITY_REST | MOBILITY_LIEDOWN)

//alternate appearance flags
#define AA_TARGET_SEE_APPEARANCE (1<<0)
#define AA_MATCH_TARGET_OVERLAYS (1<<1)

#define KEEP_TOGETHER_ORIGINAL "keep_together_original"

//setter for KEEP_TOGETHER to allow for multiple sources to set and unset it
#define ADD_KEEP_TOGETHER(x, source)\
	if ((x.appearance_flags & KEEP_TOGETHER) && !HAS_TRAIT(x, TRAIT_KEEP_TOGETHER)) ADD_TRAIT(x, TRAIT_KEEP_TOGETHER, KEEP_TOGETHER_ORIGINAL); \
	ADD_TRAIT(x, TRAIT_KEEP_TOGETHER, source);\
	x.appearance_flags |= KEEP_TOGETHER

#define REMOVE_KEEP_TOGETHER(x, source)\
	REMOVE_TRAIT(x, TRAIT_KEEP_TOGETHER, source);\
	if(HAS_TRAIT_FROM_ONLY(x, TRAIT_KEEP_TOGETHER, KEEP_TOGETHER_ORIGINAL))\
		REMOVE_TRAIT(x, TRAIT_KEEP_TOGETHER, KEEP_TOGETHER_ORIGINAL);\
	else if(!HAS_TRAIT(x, TRAIT_KEEP_TOGETHER))\
		x.appearance_flags &= ~KEEP_TOGETHER

//religious_tool flags
#define RELIGION_TOOL_INVOKE (1<<0)
#define RELIGION_TOOL_SACRIFICE (1<<1)
#define RELIGION_TOOL_SECTSELECT (1<<2)

// ---- Skillchip incompatability flags ---- //
// These flags control which skill chips are compatible with eachother.
// By default, skillchips are incompatible with themselves and multiple of the same istype() cannot be implanted together. Set this flag to disable that check.
#define SKILLCHIP_ALLOWS_MULTIPLE (1<<0)
// This skillchip is incompatible with other skillchips from the incompatible_category list.
#define SKILLCHIP_RESTRICTED_CATEGORIES (1<<1)

//dir macros
///Returns true if the dir is diagonal, false otherwise
#define ISDIAGONALDIR(d) (d&(d-1))
///True if the dir is north or south, false therwise
#define NSCOMPONENT(d)   (d&(NORTH|SOUTH))
///True if the dir is east/west, false otherwise
#define EWCOMPONENT(d)   (d&(EAST|WEST))
///Flips the dir for north/south directions
#define NSDIRFLIP(d)     (d^(NORTH|SOUTH))
///Flips the dir for east/west directions
#define EWDIRFLIP(d)     (d^(EAST|WEST))
///Turns the dir by 180 degrees
#define DIRFLIP(d)       turn(d, 180)

#define MAX_BITFIELD_SIZE 24

/// 33554431 (2^24 - 1) is the maximum value our bitflags can reach.
#define MAX_BITFLAG_DIGITS 8

// timed_action_flags parameter for `/proc/do_after_mob`, `/proc/do_mob` and `/proc/do_after`
/// Can do the action even if mob moves location
#define DO_IGNORE_USER_LOC_CHANGE (1<<0)
/// Can do the action even if the target moves location
#define DO_IGNORE_TARGET_LOC_CHANGE (1<<1)
/// Can do the action even if the item is no longer being held
#define DO_IGNORE_HELD_ITEM (1<<2)
/// Can do the action even if the mob is incapacitated (ex. handcuffed)
#define DO_IGNORE_INCAPACITATED (1<<3)
/// Used to prevent important slowdowns from being abused by drugs like kronkaine
#define DO_IGNORE_SLOWDOWNS (1<<4)
/// Used to prevent rotation by the user.
#define DO_RESTRICT_USER_DIR_CHANGE (1<<5)
/// If the user has their next_move value changed (usually by clicking), fail.
#define DO_RESTRICT_CLICKING (1<<6)
/// Shown to all mobs not just the user
#define DO_PUBLIC (1<<7)



// Spacevine-related flags
/// Is the spacevine / flower bud heat resistant
#define SPACEVINE_HEAT_RESISTANT (1 << 0)
/// Is the spacevine / flower bud cold resistant
#define SPACEVINE_COLD_RESISTANT (1 << 1)

// Z-level flags, used by ZAS and Z-Mimic.

#define Z_ATMOS_IN_UP      (1 << 0)	//! Allows air to flow IN from higher Z levels
#define Z_ATMOS_IN_DOWN    (1 << 1)	//! Allows air to flow IN from lower z levels
#define Z_ATMOS_OUT_UP     (1 << 2)	//! Allows air to flow OUT to higher Z levels
#define Z_ATMOS_OUT_DOWN   (1 << 3)	//! Allows air to flow OUT to LOWER z levels

#define Z_MIMIC_BELOW      (1 << 4)	//! Should this turf mimic the below turf?
#define Z_MIMIC_OVERWRITE  (1 << 5)	//! If this turf is mimicking, overwrite its appearance instead of using a mimic object. This is faster, but means the turf cannot have its own appearance.
#define Z_MIMIC_NO_AO      (1 << 6)	//! Bypass turf AO and only apply Z-AO. You probably want this on visually-empty z-turfs (like openspace).
#define Z_MIMIC_NO_OCCLUDE (1 << 7)	//! If we're a non-OVERWRITE z-turf, allow clickthrough of this turf.
#define Z_MIMIC_BASETURF   (1 << 8)	//! Fake-copy baseturf instead of below turf.

GLOBAL_LIST_INIT(z_defines, list(
	"Z_ATMOS_IN_UP",
	"Z_ATMOS_IN_DOWN",
	"Z_ATMOS_OUT_UP",
	"Z_ATMOS_OUT_DOWN",

	"Z_MIMIC_BELOW",
	"Z_MIMIC_OVERWRITE",
	"Z_MIMIC_NO_AO",
	"Z_MIMIC_NO_OCCLUDE",
	"Z_MIMIC_BASETURF"
))

// Z-Mimic movable flags. This is not prefixed with ZM_* to avoid confusion with other codebases that use that prefix for the above flags.

#define ZMM_IGNORE          (1 << 0)	//! Do not copy this movable. Atoms with INVISIBILITY_ABSTRACT implicitly do not copy.
#define ZMM_MANGLE_PLANES   (1 << 1)	//! Check this movable's overlays/underlays for explicit plane use and mangle for compatibility with Z-Mimic. If you're using emissive overlays, you probably should be using this flag. Expensive, only use if necessary.
#define ZMM_LOOKAHEAD       (1 << 2)	//! Look one turf ahead and one turf back when considering z-turfs that might be seeing this atom. Respects dir. Cheap, but not free.
#define ZMM_LOOKBESIDE      (1 << 3)	//! Look one turf to the left and right when considering z-turfs that might be seeing this atom. Respects dir. Cheap, but not free.
#define ZMM_NO_CACHE_ROOT   (1 << 4)	//! When performing mangling, do not cache the root (depth=0) appearance. Set this on mangled types that change appearance frequently.

// convenience flags

// This is intended for use on dev-defined openspace turfs, don't put _OVERWRITE in here unless you feel like having people ask why their zturfs are empty
#define Z_MIMIC_DEFAULTS (Z_MIMIC_BELOW)	//! Common defaults for zturfs.
#define ZMM_WIDE_LOAD (ZMM_LOOKAHEAD | ZMM_LOOKBESIDE)	//! Atom is big and needs to scan one extra turf in both X and Y. This only extends the range by one turf. Cheap, but not free.
