#ifndef __ILINE_IBUCK_H__
#define __ILINE_IBUCK_H__
#include "cpu.h"
#include "uart.h"

#define iline_2_buck(n) \
        chg_civol_s2 = (n>>2) & 1 %%\
        chg_civol_s1 = (n>>1) & 1 %%\
        chg_civol_s0 = n & 1

#define ibuck(n) \
        chg_ibuck_s3 = (n>>3) & 1 %%\
        chg_ibuck_s2 = (n>>2) & 1 %%\
        chg_ibuck_s1 = (n>>1) & 1 %%\
        chg_ibuck_s0 = n & 1

#define buck_ifull(n) \
        chg_ifull_s2 = (n>>2) & 1 %%\
        chg_ifull_s1 = (n>>1) & 1 %%\
        chg_ifull_s0 = n & 1

#define buck_duty(n) \
        chg_duty_s2 = (n >> 2) & 1 %%\
        chg_duty_s1 = (n >> 1) & 1 %%\
        chg_duty_s0 = n & 1

#define buck_oscvh(n) \
        chg_oscvh_s2 = (n >> 2) & 1 %%\
        chg_oscvh_s1 = (n >> 1) & 1 %%\
        chg_oscvh_s0 = n & 1

#define buck_oscvl(n) \
        chg_oscvl_s2 = (n >> 2) & 1 %%\
        chg_oscvl_s1 = (n >> 1) & 1 %%\
        chg_oscvl_s0 = n & 1


#define buck_osc(n) \
        chg_osc_s2 = (n >> 2) & 1 %%\
        chg_osc_s1 = (n >> 1) & 1 %%\
        chg_osc_s0 = n & 1

#define buck_vilpvol(n) \
        chg_vilpvol_s2 = (n >> 2) & 1 %%\
        chg_vilpvol_s1 = (n >> 1) & 1 %%\
        chg_vilpvol_s0 = n & 1

#define ibuck_open() \
        chg_viloop_en = 0  %%\
        vcloop_en_5v = 1   %%\
        tstchg_en = 0      %%\
        chg_line_en = 1    %%\
        chg_buck_en = 1    %%\
        chg_zcd_en = 1     %%\
        chg_bg_en = 1

#define iline_open()    \
        chg_bg_en = 1   %%\
        delay_ms(1)     %%\
        tstchg_en = 1 %% chg_buck_en = 0 %% chg_line_en = 1

#endif
