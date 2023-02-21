//*INDENT-OFF*
#ifndef __DETECT_H__
#define __DETECT_H__

#include "io.h"
#if HALL_EN
#define hall_detect_api()   CALL hall_detect
#else
#define hall_detect_api()
#endif

#endif


