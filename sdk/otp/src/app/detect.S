//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : detect.S
  By   : XXX
  date : 2019-04-28
********************************************************************************************/
#include "cpu.h"
#include "msg.h"
#include "detect.h"
#include "uart.h"
#include "data_compare.h"
#include "adc.h"
#include "app.h"
#include "sleep.h"


#ifdef F95
#define D_DEG_UT_EN  0//UT_DEBUG_EN
#endif

#ifdef F96
#define D_DEG_UT_EN  0//UT_DEBUG_EN
#endif

#if D_DEG_UT_EN

#define d_deg_char        put_char
#define d_deg_char_n      put_char_n
#define d_deg_u8          put_u8
#define d_deg_u8_n        put_u8_n
#else

#define d_deg_char(...)
#define d_deg_char_n(...)
#define d_deg_u8(...)
#define d_deg_u8_n(...)
#endif

#if HALL_EN
.text
    .global hall_io_wkup_ch1
hall_io_wkup_ch1:
        io_wkup_set(ch1, p0, 5)
        ret

    .global hall_io_init
hall_io_init:
        hall_io_set
        ret

    .global hall_detect
hall_detect:
        call hall_io_init
        if(hall_io_online) skip
        goto __hall_io_offline
    __hall_io_online:
        [a_hall_cnt]++
        w = 5
        dw_is_equ_skip([a_hall_cnt])
        ret
        if(a_bit_hall_online == 0) skip
        ret
        a_bit_hall_online = 1
        goto __hall_io_msg
    __hall_io_offline:
        [a_hall_cnt] = 0
        if(a_bit_hall_online == 1) skip
        ret
        a_bit_hall_online = 0
    __hall_io_msg:
        a_evt_hall_change = 1
        ret
#endif


/**************************************
    used: w tr0,tr1,tr2,tr3
**************************************/
.macro i_trickle_in
#if PMU_CHG_BUCK == 0
        K_2_U16_B(3000)
        call u16_compare
        if(U16_LESS) skip
        goto __vbat_power_real_read_0
        ; put_char('j')
        w = 0
        call chg_iline_set
    __vbat_power_real_read_0:
#endif
.endm
.macro i_trickle_exit
#if PMU_CHG_BUCK == 0
        ; put_char('J')
        w = [a_keep_chg_bit]
        call chg_iline_set
#endif
.endm

    .global vbat_power_real_read
vbat_power_real_read:
#if EX_LDO_TIRM_EN
        a_bit_bg_1_8 = 1
        ex_ldo_en()
        delay_ms(10)

    __adc_get_vbat:
        clr_ea
        adc_get_voltage(ADC_CH_ANA,ANA_VBAT)
        set_ea
        ex_ldo_dis()
#else
    __adc_get_vbat:
        adc_get_voltage(ADC_CH_ANA,ANA_VBAT)
#endif

        [TR2] = 0
        w = 3 %% [TR3] = w
        mult_r01Xr23()
        w = [multiply_b1] %% u16_ah = w
        w = [multiply_b0] %% u16_al = w
        K_2_U16_B(2000)
        call u16_compare
#if EX_LDO_TIRM_EN
        if(U16_LESS) skip
        goto __adc_get_vbat_end
        if(a_bit_bg_1_8 == 1) skip
        ret
        a_bit_bg_1_8 = 0
        goto __adc_get_vbat
    __adc_get_vbat_end:
        a_bit_bg_1_8 = 0
#else
        if(U16_BIG) skip
        ret
#endif

        i_trickle_in

        K_2_U16_B(POWER_BOOT_LVL)
        call u16_compare
        if(U16_BIG) skip
        goto __vbat_power_real_read_1

        i_trickle_exit

        goto __get_a_vbat_power
    __vbat_power_real_read_1:

         if(b_vcc_online == 0) skip
        goto __get_a_vbat_power

        //如果低电标记没有设置则发送低电事件
        if (b_vbat_lowpower == 1) skip
        a_evt_vbat_lowpower = 1
        b_vbat_lowpower = 1
        d_deg_char('L')
        [a_vbat_power] = 0
        goto __get_a_vbat_power_end
    __get_a_vbat_power:
        w = [multiply_b1] %% [tr0] = w
        w = [multiply_b0] %% [tr1] = w


        w = (POWER_BOOT_LVL & 0xff) %% [tr1] -= w
        w = (POWER_BOOT_LVL >> 8) & 0xff %% [tr0] -= w + c
        [div_bh3] = 0
        [div_bh2] = 0
        w = [tr0] %% [div_bh] = w
        w = [tr1] %% [div_bl] = w

        [div_ch] = 0
        w = (42 - 32) %% [div_cl] = w

        call div_32x16
        ; d_deg_u8_n([a_vbat_power])
        w = [div_bl] %% [a_vbat_power] = w
    __get_a_vbat_power_end:
        ret

    .global vbat_power_read
vbat_power_read:

        call vbat_power_real_read

        w = [a_last_vbat_power]
        w = [a_vbat_power] - w
        if(MINUS_ALU) skip
        goto __a_vbat_comp_1
        if(b_vcc_online == 1) skip
        [a_last_vbat_power]--
        goto __a_vbat_comp_2

    __a_vbat_comp_1:

        w = [a_vbat_power] %% w = [a_last_vbat_power] - w
        if(MINUS_ALU) skip
        goto __a_vbat_comp_2

        if(b_vcc_online == 0) skip
        [a_last_vbat_power]++

    __a_vbat_comp_2:
        if(b_vcc_online == 1)skip
        goto __a_vbat_comp_3
        if(a_bit_vbat_full == 1) skip
        goto __a_vbat_comp_100
        w = 100
        [a_last_vbat_power] = w
        goto __a_vbat_comp_3
    __a_vbat_comp_100:
        w = 100
        w = [a_last_vbat_power] -w
        if(NOT_MINUS_ALU) skip
        goto __a_vbat_comp_3
        w = 99
        [a_last_vbat_power] = w
    __a_vbat_comp_3:
        w = [a_last_vbat_power] %% [a_vbat_power] = w
        ret

//---------------------------------------------------------------------------
__vout01_offline_cnt:
        w = [a_vout01_offline_cnt] %% w -= 2
        if(MINUS_ALU) skip
        goto __vout01_offline_long_time
        [a_vout01_offline_cnt]++
        d_deg_char('v')
        d_deg_char('0')
        d_deg_u8_n([a_vout01_offline_cnt])
        ret
    __vout01_offline_long_time:
        [a_vout01_offline_cnt] = 0
        b_bit_goto_sleep = 1
        ret

//5s call one time
    .global vout01_power_cnt
vout01_power_cnt:
        if(b_vcc_online == 0) skip
        [a_vout01_offline_cnt] = 0

        if (b_vout0_online == 1) skip
        goto __vout_power_vout1
    __vout_power_vout0:
        //---------------------------
        d_deg_char('e')
        d_deg_char('p')
        d_deg_char('0')
        d_deg_u8_n([a_ear0_power])
        w = [a_ear0_power] %% w -= 100
        if(NOT_MINUS_ALU) skip
        goto __vout_power_vout0_end
        if (b_bit_ear0_full == 0) skip
        goto __vout_power_vout1
        b_bit_ear0_full = 1
        w = 4 %% [a_shut0_cnt] = w
        goto __vout_power_vout1

    __vout_power_vout0_end:
        b_bit_ear0_full = 0
        [a_vout01_offline_cnt] = 0

    __vout_power_vout1:
        if(b_vout1_online == 1)skip
        goto __vout_power_end
        //----------------------------
        d_deg_char('e')
        d_deg_char('p')
        d_deg_char('1')
        d_deg_u8_n([a_ear1_power])
        w = [a_ear1_power] %% w -= 100
        if(NOT_MINUS_ALU) skip
        goto __vout_power_vout1_end
        if (b_bit_ear1_full == 0) skip
        goto __vout_power_end
        b_bit_ear1_full = 1
        w = 4 %% [a_shut1_cnt] = w
        goto __vout_power_end

    __vout_power_vout1_end:
        b_bit_ear1_full = 0
        [a_vout01_offline_cnt] = 0

    __vout_power_end:
        goto __vout01_offline_cnt






