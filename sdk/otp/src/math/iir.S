/***********************************XXX tech************************************************
  File : data_compare.S
  By   : XXX
  date : 2019-12-05
********************************************************************************************/
#include "cpu.h"
#include "pmu.h"
#include "data_compare.h"


#if 0//UT_DEBUG_EN

#define iir_deg_char        put_char
#define iir_deg_char_n      put_char_n
#define iir_deg_u8          put_u8
#define iir_deg_u8_n        put_u8_n
#else

#define iir_deg_char(...)
#define iir_deg_char_n(...)
#define iir_deg_u8(...)
#define iir_deg_u8_n(...)
#endif

.text

#if IIR_EN

#define last_flth     tr0
#define last_fltl     tr1
/*********************************************************
    used : w,tr0,tr1
*********************************************************/
    .global iir_flt
iir_flt:
        ;subiw #0xd

        data_is_zero_skip([last_flth])
        goto __iir_flt_old_not0

        data_is_zero_skip([last_fltl])
        goto __iir_flt_old_not0

    __iir_flt_old_is0:
        [last_flth] = 0
        [last_fltl] = 0
        goto __iir_flt_old_end
    __iir_flt_old_not0:
        w = [last_flth] %% [last_fltl] -= w
        if(CY == 0) skip
        [last_flth]--
    //-----------------------------
    __iir_flt_old_end:
        w = 0
        if(a_bit_iir == 0) skip
        w = 1
        w += [last_flth]
        if(CY == 0) skip
        goto __iir_res_full
    __iir_res_not_full:
       [last_flth] = w
        goto __iir_flt_end
    __iir_res_full:
        w = 0xff
        [last_flth] = w
        [last_fltl] = w
    __iir_flt_end:
        ret


/*********************************************************
    used : w,tr0,tr1,tr2,tr3
*********************************************************/
    .global iir_for_line_chg
iir_for_line_chg:

        if(b_vcc_online == 0) skip
        goto __iir_line_chg_0
        [a_vbat_chg_cnt] = 0
        [a_last_flth] = 0
        [a_last_fltl] = 0
        a_bit_vbat_full = 0
        ret

    __iir_line_chg_0:
        if(chg_line_en == 1) skip
        ret

    __iir_line_chg:
        call store_pmu_pg

        pmu_sel_rd_page(PMU_PAGE2_ANA_READ1)
        if(vcc_line_full_pg2 == 1) skip
        goto __read_line_full_0
        a_bit_iir = 1
        ; iir_deg_char('1')
        goto __read_line_full_end
    __read_line_full_0:
        a_bit_iir = 0
        ; iir_deg_char('0')
    __read_line_full_end:
        w = [a_last_flth] %% [last_flth] = w
        w = [a_last_fltl] %% [last_fltl] = w
        call iir_flt
        w = [last_flth] %% [a_last_flth] = w
        w = [last_fltl] %% [a_last_fltl] = w
        ; iir_deg_u8([a_last_flth])
        ; iir_deg_u8_n([a_last_fltl])
        call restore_pmu_pg


        w = 0xab %% u16_bh = w
        w = 0xff %% u16_bl = w
        call u16_compare
        if(U16_BIG) skip          // >=
        goto __line_chg_not_full
    //---------------------------
        w = [a_vbat_chg_cnt] %% w -= 100
        if(NOT_MINUS_ALU) skip
        goto __iir_line_chg_full_inc
        ;if(a_bit_vbat_full == 1)skip
        b_vbat_full = 1
        ; a_evt_vbat_full = 1
        ; a_bit_vbat_full = 1
        goto __iir_line_chg_end
    __iir_line_chg_full_inc:
        [a_vbat_chg_cnt]++
        goto __iir_line_chg_end
    //------------------------
    __line_chg_not_full:
        if(b_vbat_full == 1) skip
        goto __line_chg_not_full_0

        w = 0x50 %% u16_bh = w
        u16_bl = 0 ; w = 0x00 %% u16_bl = w

        call u16_compare
        if(U16_LESS) skip          // >=
        goto __iir_line_chg_end

    __line_chg_not_full_0:
clear_vbat_full:
        b_vbat_full = 0
        [a_vbat_chg_cnt] = 0
        [a_vbat_full_cnt] = 0
        a_bit_vbat_full = 0
    __iir_line_chg_end:
        ret
    .global clear_vbat_full


    .global is_line_full
is_line_full:
        if(chg_line_en == 1) skip
        ret

        w = '1'
        if(a_bit_vbat_full == 1) skip
        w = '0'
        call debug_char


        if(b_vbat_full == 1)skip
        ret
        w = '.'
        call debug_char
    __is_line_full_0:
        ; w = 100 %% w = [a_vbat_full_cnt] - w
        ; if(NOT_MINUS_ALU) skip
        ; goto __is_line_full_0_inc
        if(a_bit_vbat_full == 1) skip
        a_evt_vbat_full = 1
        a_bit_vbat_full = 1
        ret
    __is_line_full_0_inc:
        ; [a_vbat_full_cnt]++
        ret
#else

#if PMU_CHG_BUCK
#define vbat_ichg_full vcc_buck_full_pg2

.macro vbat_ichg_ret
    if(chg_buck_en == 1) skip
    ret
.endm

#else
#define vbat_ichg_full vcc_line_full_pg2

.macro vbat_ichg_ret
    if(chg_line_en == 1) skip
    ret
.endm

#endif

    .global iir_for_line_chg
    .global clear_vbat_full
iir_for_line_chg:
        if(b_vcc_online == 0) skip
        goto __iiflc_0
        [a_ibuck_cnt] = 0
        [a_ibuck_full_cnt] = 0
    clear_vbat_full:
        a_evt_vbat_full = 0
        a_bit_vbat_full = 0
        ret
    __iiflc_0:

        vbat_ichg_ret

        ; if(chg_buck_en == 1) skip
        ; ret

        [a_ibuck_cnt]++
        w = 100
        dw_is_equ_skip([a_ibuck_cnt])
        goto __iiflc_judge_end
    __iiflc_judge:

        w = [a_ibuck_full_cnt]
        [a_ibuck_cnt] = 0
        [a_ibuck_full_cnt] = 0
        w -= 50

        if(NOT_MINUS_ALU) skip
        goto __iiflc_judge_end
        if(a_bit_vbat_full  == 1) skip
        a_evt_vbat_full = 1
        a_bit_vbat_full = 1
    __iiflc_judge_end:
        pmu_sel_rd_page(PMU_PAGE2)
        if(ci_chg_pg2 == 0) skip
        if(vbat_ichg_full == 1) skip
        ret
        [a_ibuck_full_cnt]++
        ret


    .global is_line_full
is_line_full:
        vbat_ichg_ret
        w = '1'
        if(a_bit_vbat_full == 1) skip
        w = '0'
        goto debug_char

#endif


