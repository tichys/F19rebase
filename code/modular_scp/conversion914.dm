/*
* Proc used by SCP-914 to modify/convert the item
* Return value will be placed in the output section of the machine
* If you don't return valid atom - nothing will be returned
* If return value isn't src - the original item will be deleted
**************************************************************************
* Rough - Destroys or otherwise mutilates the object beyond repair.
* Coarse - Dismantles/Deconstructs/Disassembles the object without damage.
* 1:1 - Returns a similar object, either in material or other properties.
* Fine - Simply upgrades the object or returns a better one.
* Very Fine - Returns something with improved anomalous properties.
*/
/atom/movable/proc/Conversion914(mode = MODE_ONE_TO_ONE, mob/user = usr)
	switch(mode)
		if(MODE_ROUGH)
			return null
		if(MODE_COARSE)
			return (prob(50) ? null : src)
	return src
