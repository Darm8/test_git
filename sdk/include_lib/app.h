//*INDENT-OFF*
#ifndef __APP_H__
#define __APP_H__

#include "io.h"
#define LOW_POWER_MODE   2

#define mode_jmp(curr,next) \
        w = curr %% \
        dw_is_equ_skip([a_sys_mode]) \
        GOTO next

//123456451418547u1
#if HALL_EN
#define OPEN_LID_MODE    0
#define CLOSE_LID_MODE   1

#define sys_mode_api() \
        if(a_bit_hall_online == 1) skip        %%\
        GOTO __sys_goto_close_lid_mode         %%\
    __sys_goto_open_lid_mode:                  %%\
        w = OPEN_LID_MODE %% [a_sys_mode] = w  %%\
        ret                                    %%\
    __sys_goto_close_lid_mode:                 %%\
        if (b_vbat_lowpower == 0) skip         %%\
        goto __sys_goto_lowpower_mode          %%\
        w = CLOSE_LID_MODE %% [a_sys_mode] = w %%\
        ret                                    %%\
    __sys_goto_lowpower_mode:                  %%\
        w = LOW_POWER_MODE %% [a_sys_mode] = w

#define main_mode_loop()                                 \
    __case_open_lid_mode:                                %%\
        mode_jmp(OPEN_LID_MODE, __case_close_lid_mode)   %%\
        call open_lid_app                                %%\
        goto __case_common_mode                          %%\
    __case_close_lid_mode:                               %%\
        mode_jmp(CLOSE_LID_MODE, __case_low_power_mode)  %%\
        call close_lid_app                               %%\
        goto __case_common_mode

#else
#define NO_HALL_MODE     1

#define sys_mode_api() \
        if (b_vbat_lowpower == 0) skip         %%\
        goto __sys_goto_lowpower_mode          %%\
        w = NO_HALL_MODE %% [a_sys_mode] = w %%\
        ret                                    %%\
    __sys_goto_lowpower_mode:                  %%\
        w = LOW_POWER_MODE %% [a_sys_mode] = w


#define main_mode_loop()                                 \
    __case_no_hall_mode:                                 %%\
        mode_jmp(NO_HALL_MODE, __case_low_power_mode)    %%\
        call no_hall_app                                 %%\
        goto __case_common_mode

#endif

#define sys_mode(k)  w = k %% [a_sys_mode] = w
#define case_sys_mode(k)  w = k %% w = [a_sys_mode] - w
#define sys_mode_not_equ_skip(k)  w = k %% dw_not_equ_skip([a_sys_mode])


#define exit_ear_ex_api() call exit_ear_ex


.macro app_evt_jmp evt, fun
if (\evt == 1) skip
    goto __\fun\()_was_end
    \evt = 0
    \fun
__\fun\()_was_end:
.endm

.macro app_evt_orl_jmp evt0, evt1, fun
    if (\evt0 == 0) skip
    goto __\fun\()_evt_0
    if (\evt1 == 1) skip
    goto __\fun\()_was_end
    \evt1 = 0
    goto __\fun\()_evt_thing
__\fun\()_evt_0:
    \evt0 = 0
__\fun\()_evt_thing:
    \fun
__\fun\()_was_end:
.endm

.macro app_case_1_do flag, fun
    if (\flag == 1) skip
    goto __\fun\()_app_end
    \fun
    __\fun\()_app_end:
.endm

.macro app_case_0_do flag, fun
    if (\flag == 0) skip
    goto __\fun\()_app_end
    \fun
__\fun\()_app_end:
.endm

.macro app_case_do flag, fun_1, fun_0
    if (\flag == 1) skip
    goto __\fun_0\()_app
    __\fun_1\()_app:
    \fun_1
    goto __\fun_1\()_app_end
    __\fun_0\()_app:
    \fun_0
    __\fun_1\()_app_end:
.endm
#endif
