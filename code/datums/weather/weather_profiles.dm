/* <==================================================> Weather Profiles! <===================================================>
 * Weather Profiles tell the Weather Subsystem what a given round should look like, including the base conditions such as temp,
 * wind direction, severity, pressure, etc. They're picked by the Weather Subsystem at the start of a round and are
 * (if I code them well enough) blacklist/whitelist-able from certain maps. Instead of having multiple storm "types", we'll just
 * pretend to have many with different profiles that don't interact Too Much with the subsystem controller.
 *
 * If a profile picks a storm that doesn't support a included weather effect , it will be ignored.
 *
 */



/datum/weather/profile
	name = "Weather Profile"
	desc = "A profile to be randomly selected at the start of the round, which influences weather."


	/// Default environmental conditions


	/// Determines Main wind direction
	var/primary_wind_direction = NORTH

	var/night_temp_reduction = 5.0 // How much should we reduce the temp at night?
	var/minimum_temperature = 275.15 // 2C minimum, chilly but not too bad.

	/// The weather effects that can be picked for a given profile.
	var/list/allowed_weather_effects = list()
	/// The types of smell flavortexts a given profile might cause. (Ex. "You catch the scent of drying seaweed on the wind")
	var/list/flavor_smells_long = list()
	/// The short smells a given profile might cause (Ex. "dry earth", "salt brine", hooked into "You catch the scent of [thing] in the air.")
	var/list/flavor_smells_short = list()
	/// The types of storms permitted in this profile
	var/list/allowed_storms = list()


	//For convienence in assignments
	#define LOW_PRESSURE "LOW_PRESSURE"
	#define MEDIUM_PRESSURE "MEDIUM_PRESSURE"
	#define HIGH_PRESSURE "HIGH_PRESSURE"

	#define TEMP_LOW "LOW_TEMP"
	#define TEMP_MEDIUM "MEDIUM_TEMP"
	#define TEMP_HIGH "HIGH_TEMP"

	/// The type of pressure in the profile (High, Medium, Low)
	var/list/pressure_pattern = list(
		"LOW_PRESSURE" = list(98.7, 99.5, 100.3),
		"MEDIUM_PRESSURE" = list(101.3, 100.8, 100.7),
		"HIGH_PRESSURE" = list(102.3, 103.1, 103.8)
	)

	var/pressure_type = MEDIUM_PRESSURE //If not set, we assume pressure is normal.
	var/current_pressure // Initialized in New()

	/// Defines temperature ranges for different temperature types, if not overridden by base_temperature
	var/list/temperature_ranges = list(
		"LOW_TEMP" = list(263.15, 273.15), // -10C to 0C
		"MEDIUM_TEMP" = list(283.15, 293.15), // 10C to 20C
		"HIGH_TEMP" = list(303.15, 313.15) // 30C to 40C
	)


	/// Determines temp (single value for this profile, or a string key for temperature_ranges)
	var/base_temperature_type = TEMP_MEDIUM // Default to medium temperature range
	var/base_temperature // Initialized in New()

	/// Severity, which influences severity of weather effects, damage caused by lightning, strength of wind, etc.
	var/severity = 1 //1 = Light, 2 = Moderate, 3 = Severe

	// Tag whitelist/blacklist (Ex. Here we say "Coastal", "Stormy", etc, and someone in the map config says "I don't want any "coastal" or "stormy".)

	/// Whitelist tags for storm types.
	var/list/weather_tag_whitelist = list()
	/// Blacklist tags for storm types
	var/list/weather_tag_blacklist = list()

	// Profile whitelist/blacklist (Ex. "WEATHER_PROFILE_ATLANTICSTORMFRONT")

	/// Whitelist profiles for storm types.
	var/list/weather_profile_whitelist = list()
	/// Blacklist profiles for storm types
	var/list/weather_profile_blacklist = list()

/datum/weather/profile/New()
	. = ..()
	// Pick a random pressure value from the range defined by pressure_type
	if(pressure_pattern && pressure_pattern[pressure_type] && length(pressure_pattern[pressure_type]) == 3) // Ensure it's a min, mid, max list
		current_pressure = rand(pressure_pattern[pressure_type][1], pressure_pattern[pressure_type][3])
	else
		current_pressure = pick(pressure_pattern[MEDIUM_PRESSURE]) // Fallback to picking from default medium range

	// Pick a random temperature value from the range defined by base_temperature_type
	if(temperature_ranges && temperature_ranges[base_temperature_type] && length(temperature_ranges[base_temperature_type]) == 2)
		base_temperature = rand(temperature_ranges[base_temperature_type][1], temperature_ranges[base_temperature_type][2])
	else if(isnum(base_temperature_type)) // If base_temperature_type was set directly as a number
		base_temperature = base_temperature_type
	else
		base_temperature = T20C // Fallback to default if not specified or invalid

/datum/weather/profile/proc/apply_environment_settings()
	// TD: Implement how primary_wind_direction from the profile should influence the environment globally.

	var/is_night = FALSE // TD: Implement proper check for night/day based on world.timeofday or similar.
	// Example: if(world.timeofday >= NIGHT_START_TIME || world.timeofday < DAY_START_TIME) is_night = TRUE

	var/list/chunk_keys = SSweather.weather_chunking.get_all_turf_chunk_keys()
	for(var/key in chunk_keys)
		var/list/turfs_in_chunk = SSweather.weather_chunking.get_turfs_in_chunks(list(key))
		for(var/turf/T in turfs_in_chunk)
			if(!isturf(T))
				continue

			else
				var/selected_temp = base_temperature // Use the pre-calculated base_temperature

				// Apply night temperature reduction
				if(is_night)
					selected_temp = max(minimum_temperature, selected_temp - night_temp_reduction)

				T.temperature = selected_temp


/// --- Nautical Weather Profiles ---

#define ATLANTIC_STORMFRONT /datum/weather/profile/atlanticstormfront

/datum/weather/profile/atlanticstormfront
	name = "Atlantic Storm Front"
	desc = "A brewing Atlantic system with strong winds and shifting pressure. Common in the colder months."
	base_temperature_type = TEMP_LOW
	pressure_type = LOW_PRESSURE
	night_temp_reduction = 8.0
	minimum_temperature = 268.15 // -5C
	allowed_weather_effects = list(WEATHER_LIGHTNING_STRIKE = 10, WEATHER_WINDGUST = 10)
	allowed_storms = list(/datum/weather/weather_types/rain_storm, /datum/weather/weather_types/snow_storm)
	weather_tag_whitelist = list("coastal", "stormy")

	flavor_smells_short = list("salt air", "ocean spray", "seaweed", "briny wind", "stormy sea")
	flavor_smells_long = list(
		"The air smells faintly of salt and wet stone.",
		"A briny, ocean breeze rolls in.",
		"The faint tang of saltwater fills your nostrils.",
		"The smell of wet steel lingers in the air.."
	)

/datum/weather/profile/atlanticstormfront/apply_environment_settings()
	..()
	//We can't put non-constants in the define, so we'll do it here.
	primary_wind_direction = pick(NORTH, NORTHWEST)

#define FOGGY_BANKS /datum/weather/profile/foggybank

/datum/weather/profile/foggybank
	name = "Foggy Bank Drifts"
	desc = "A dense fog creeping over the ocean, bringing high humidity and obscuring vision."
	base_temperature_type = TEMP_MEDIUM
	primary_wind_direction = EAST
	pressure_type = MEDIUM_PRESSURE
	night_temp_reduction = 3.0
	minimum_temperature = 280.15 // 7C
	allowed_weather_effects = list(WEATHER_LIGHTNING_STRIKE = 10, WEATHER_WINDGUST = 10, WEATHER_FOG = 10)
	allowed_storms = list(/datum/weather/weather_types/rain_storm, /datum/weather/weather_types/snow_storm)
	weather_tag_whitelist = list("coastal", "foggy")
	flavor_smells_short = list("salt air", "oil fumes", "wet rust", "damp concrete", "wet grease")
	flavor_smells_long = list(
		"A thick, salty fog hangs in the air, tinged with the scent of cold brine..",
		"You smell oil fumes mingling with the sea mist.",
		"The fog carries the faint aroma of grease, fuel, and chilled sea air.",
		"A slick ocean breeze rolls through, heavy with moisture and the smell of old machinery."
	)

#define GALE_SURGES /datum/weather/profile/gale_surge

/datum/weather/profile/gale_surge
	name = "Gale Surges"
	desc = "Brutal winds and freezing temps from the north. Cold exposure is a legitimate danger."
	base_temperature_type = TEMP_LOW
	primary_wind_direction = NORTH
	pressure_type = LOW_PRESSURE
	night_temp_reduction = 10.0
	minimum_temperature = 261 //-12C
	allowed_weather_effects = list(WEATHER_LIGHTNING_STRIKE = 10, WEATHER_WINDGUST = 10)
	allowed_storms = list(/datum/weather/weather_types/rain_storm, /datum/weather/weather_types/snow_storm)
	weather_tag_whitelist = list("windy", "cold", "freezing")
	flavor_smells_short = list("frostbitten steel", "cold ozone", "dry salt", "windburn", "crackling static")
	flavor_smells_long = list(
		"The biting wind carries a sterile, metallic scent - like frostbitten steel.",
		"You catch the faint smell of ozone and distant ice.",
		"A dry wind whips through, carrying nothing but chill and windburn..",
		"The cold air burns your nostrils, drowning out the scent of the sea."
	)

#define DIESEL_RAIN /datum/weather/profile/dieselrain

/datum/weather/profile/dieselrain
	name = "Diesel Rain"
	desc = "Thick rain and industrial smells mix during this unusual low-pressure event."
	base_temperature_type = TEMP_MEDIUM
	pressure_type = LOW_PRESSURE
	allowed_weather_effects = list(WEATHER_LIGHTNING_STRIKE = 10, WEATHER_WINDGUST = 10)
	allowed_storms = list(/datum/weather/weather_types/rain_storm, /datum/weather/weather_types/snow_storm)
	weather_tag_whitelist = list("rain", "storm", "industrial")
	flavor_smells_short = list("diesel", "ozone", "burnt plastic", "wet steel", "hot asphalt")
	flavor_smells_long = list(
		"Acrid diesel fumes linger in the rain-heavy air.",
		"You smell ozone and something vaguely electric carried on the storm wind.",
		"The air reeks of oil and storm-churned grime.",
		"The slick scent of fuel mixes with the chemical tang of industrial runoff."
	)

/datum/weather/profile/dieselrain/apply_environment_settings()
	..()
	//We can't put non-constants in the define, so we'll do it here.
	primary_wind_direction = pick(WEST, NORTHWEST)

/// --- General Weather Profiles ---

#define HEAT_HAZE /datum/weather/profile/heathaze

/datum/weather/profile/heathaze
	name = "Heat Haze"
	desc = "A rare warm spell causes sweltering conditions in the area.."
	base_temperature_type = TEMP_HIGH
	pressure_type = HIGH_PRESSURE
	night_temp_reduction = 2.0
	minimum_temperature = 290.15 //17C
	allowed_weather_effects = list(WEATHER_LIGHTNING_STRIKE = 10, WEATHER_WINDGUST = 10)
	allowed_storms = list(/datum/weather/weather_types/rain_storm, /datum/weather/weather_types/snow_storm) // Allow the generic weather type (targets ZTRAIT_STATION by default)
	flavor_smells_short = list("dry earth", "hot air", "something burning")
	flavor_smells_long = list(
		"You catch the acrid scent of something distant.. maybe burning.",
		"The wind smells dry and sour, like old rust baking in the sun.",
		"The breeze is thick with radiated dust and baked minerals.",
		"A wave of hot, dry air carriest the faint tang of heated metal."
	)

/datum/weather/profile/heathaze/apply_environment_settings()
	..()
	//We can't put non-constants in the define, so we'll do it here.
	primary_wind_direction = pick(SOUTH, SOUTHEAST)

#define CLEAR_SKIES /datum/weather/profile/clearskies

/datum/weather/profile/clearskies
	name = "Clear Skies (Test Profile)"
	desc = "A rare and pleasant weather pattern that brings clear skies and calm conditions. Modified for testing lightning."
	base_temperature_type = TEMP_MEDIUM
	primary_wind_direction = SOUTHWEST
	pressure_type = HIGH_PRESSURE
	allowed_weather_effects = list(WEATHER_LIGHTNING_STRIKE = 10, WEATHER_WINDGUST = 10)
	allowed_storms = list(/datum/weather/weather_types/rain_storm, /datum/weather/weather_types/snow_storm) // Allow the generic weather type (targets ZTRAIT_STATION by default)
	flavor_smells_short = list("fresh air", "sun-warmed air", "a gentle light scent")
	flavor_smells_long = list(
		"The air smells clear and crisp, like a spring morning.",
		"The wind is light, bringing only the faintest smells.",
		"The breeze carries the scent of fresh air, and a hint of distant greenery."
	)

#define MONSOON /datum/weather/profile/equatorialmonsoon

/datum/weather/profile/equatorialmonsoon
	name = "Equatorial Monsoon"
	desc = "Relentless rain with thick, humid air and high storm chances"
	base_temperature_type = TEMP_HIGH
	primary_wind_direction = SOUTH
	pressure_type = LOW_PRESSURE
	allowed_weather_effects = list(WEATHER_LIGHTNING_STRIKE = 10, WEATHER_WINDGUST = 10, WEATHER_FOG = 10)
	allowed_storms = list(/datum/weather/weather_types/rain_storm, /datum/weather/weather_types/snow_storm)
