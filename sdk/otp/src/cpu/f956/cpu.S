//*INDENT-OFF*
#ifndef __CPU_S__
#define __CPU_S__
#include "cpu.h"
#include "uart.h"


#if 0//UT_DEBUG_EN

#define cpu_deg_char        put_char
#define cpu_deg_char_n      put_char_n
#define cpu_deg_u8          put_u8
#define cpu_deg_u8_n        put_u8_n
#else

#define cpu_deg_char(...)
#define cpu_deg_char_n(...)
#define cpu_deg_u8(...)
#define cpu_deg_u8_n(...)
#endif

    .global f_indr0_inc
f_indr0_inc:
        [indp0] = w
        [indp_con].1 = 0 %% [indp_con].0 = 1
        ret
    .global f_indr1_inc
f_indr1_inc:
        [indp1] = w
        [indp_con].3 = 0 %% [indp_con].2 = 1
        ret

    .global __set_ea_ret
__set_ea_ret:
        set_ea
        ret
#endif


