//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : clock.S
  By   : XXX
  date : 2019-04-19
********************************************************************************************/
#include "cpu.h"
#include "pmu.h"
.text
    .global clock_init
clock_init:
        //------------------
        w = 0xf0
        [clk_con] &= w
        [clk_con].4 = 0
#if (SYS_CLK == (SRC_CLK/8))

#else
    #if (SYS_CLK == SRC_CLK)
        w = 0x3
    #elif (SYS_CLK == (SRC_CLK/2))
        w = 0x2
    #elif (SYS_CLK == (SRC_CLK/4))
        w = 0x1
    #else
        w = 0
    #endif
        [clk_con] |= w
        //-----------------------
        [clk_con].4 = 1
#endif
        ret

#define LVD_22 0
#define LVD_24 1
#define LVD_26 2
#define LVD_28 3

        .global lvd_init
lvd_init:
        w = 1 %% [lvd_con1] = w
        w = (BIT(6) | BIT(3) | BIT(2) | LVD_26)
        [lvd_con0] = w
        ret


