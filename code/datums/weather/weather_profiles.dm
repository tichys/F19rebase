/* <==================================================> Weather Profiles! <===================================================>
 * Weather Profiles tell the Weather Subsystem what a given round should look like, including the base conditions such as temp,
 * humidity, wind direction, severity, pressure, etc. They're picked by the Weather Subsystem at the start of a round and are
 * (if I code them well enough) blacklist/whitelist-able from certain maps.
 *
 */


 /datum/weather/profile
	name = "Weather Profile"
	desc = "A profile to be randomly selected at the start of the round, which influences weather."


	//Default environmental conditions

	/// Determines temp
	var/base_temperature = T20C // 293.15 K, 20C
	/// Determines Humidity
	var/humidity_level = 50
	/// Determines Main wind direction
	var/primary_wind_direction = NORTH
	/// The type of pressure in the profile (High, Medium, Low)
	var/pressure_pattern = null

	var/night_temp_reduction = 5.0 // How much should we reduce the temp at night?
	var/minimum_temperature = 275.15 // 2C minimum, chilly but not too bad.

	/// The weather effects that can be picked for a given profile.
	var/list/allowed_weather_effects = list()
	/// The types of smells a given profile might cause. (Ambient, probability played based on storm length)
	var/list/flavor_smells_text = list()
	/// The types of storms permitted in this profile
	var/list/allowed_storms = list()

	/// Severity, which influences severity of weather effects, damage caused by lightning, strength of wind, etc.
	var/severity = 1 //1 = Light, 2 = Moderate, 3 = Severe

	// Tag whitelist/blacklist (Ex. Here we say "Coastal", "Stormy", etc, and someone in the map config says "I don't want any "coastal" or "stormy".)

	/// Whitelist tags for storm types.
	var/weather_tag_whitelist = list()
	/// Blacklist tags for storm types
	var/weather_tag_blacklist = list()

	// Profile whitelist/blacklist (Ex. "WEATHER_PROFILE_ATLANTICSTORMFRONT")

	/// Whitelist profiles for storm types.
	var/weather_profile_whitelist = list()
	/// Blacklist profiles for storm types
	var/weather_profile_blacklist = list()

	var/datum/weather/chunking/weather_chunking = new() //Builds the weather chunking controller.

/datum/weather/profile/proc/apply_environment_settings()

	SSweather.wind_direction = primary_wind_direction

	var/list/chunk_keys = weather_chunking.get_all_turf_chunk_keys()
	for(var/key in chunk_keys)
		var/list/turfs = weather_chunking.get_turfs_in_chunks(list(key))


		for(var/turf/T in turfs)
			if(!isturf(T))
				continue

			else
				T.temperature = base_temperature




