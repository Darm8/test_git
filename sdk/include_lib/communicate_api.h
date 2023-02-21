#ifndef __COMMUNICATE_API_H__
#define __COMMUNICATE_API_H__

#include "cpu.h"

#define CMD_POWER_LVL_OPEN          0x06
#define CMD_POWER_LVL_CLOSE         0x07

#define ola_ear_inquire()      \
        w = CMD_POWER_LVL_OPEN %% [tr0] = w

#define ola_ear0_inquire()      \
        ola_ear_inquire() %% \
        call ear0_inquire

#define ola_ear1_inquire()      \
        ola_ear_inquire() %% \
        call ear1_inquire


#define chg_para_faild              [TR3].7 = 0
#define chg_para_success            [TR3].7 = 1


#endif

