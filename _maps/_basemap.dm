#include "map_files\generic\CentCom.dmm"
#include "map_files\site404\site404.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\debug\runtimestation.dmm"
		#include "map_files\debug\multiz.dmm"
		#include "map_files\site404\site404.dmm"

		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
