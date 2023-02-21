//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : trim_bg.S
  By   : XXX
  date : 2019-12-30
********************************************************************************************/

#include "cpu.h"
#include "msg.h"
#include "uart.h"
#include "data_compare.h"
#include "adc.h"
#include "app.h"
#include "pmu.h"
#include "timer.h"
#include "danger_signal.h"

#if 0//UT_DEBUG_EN
#define b_deg_char        put_char
#define b_deg_char_n      put_char_n
#define b_deg_u8          put_u8
#define b_deg_u8_n        put_u8_n
#else

#define b_deg_char(...)
#define b_deg_char_n(...)
#define b_deg_u8(...)
#define b_deg_u8_n(...)
#endif

;#define a_keep_trim_bg   a_keep_trim_bg



#define vlu_1_2v_h   multiply_b1
#define vlu_1_2v_l   multiply_b0



#define TRIM_BG_PRECISION_H   40
#define TRIM_BG_PRECISION_L   15

#if EX_LDO_TIRM_EN

    .global ex_ldo_enable
ex_ldo_enable:
        ex_ldo_io_set
        goto_delay_ms(1)
        ;ret



    .global ldo_trim_5s
ldo_trim_5s:
    .global f_trim_bg
f_trim_bg:
        b_deg_char_n(' ')
        b_deg_char('T')
        b_deg_char('r')
        b_deg_char('i')
        b_deg_char('m')
        b_deg_char(' ')
        clr_ea
        ex_ldo_en()
        call _trim_bg
        ex_ldo_dis()
        goto __set_ea_ret

    .global _trim_bg
_trim_bg:
        w = (~0x83) & 0xff %% [a_keep_trim_bg] &= w
        adc_get_voltage(ADC_EX_LDO,0)


        adc_read_api(ADC_EX_LDO,0)

        data_not_zero_skip([tr0])
        ret
        a_bit_bg_1_8 = 1
        adc_get_voltage(ADC_CH_ANA,ANA_VBG)
        a_bit_bg_1_8 = 0

        w = (1200 >> 8) & 0xff %% u16_bh = w
        w = 1200 & 0xff %% u16_bl = w


        call u16_compare
        if(U16_BIG) skip          // >=
        goto __trim_bg_less

    __trim_bg_big:
        w = 1200 & 0xff       %% [__ADC_RESL] -= w
        w = (1200 >>8) & 0xff %% [__ADC_RESH] -= w + c
        b_deg_u8   ([__ADC_RESH])
        b_deg_u8_n ([__ADC_RESL])
        data_is_zero_skip([__ADC_RESH])
        goto __trim_bg_too_big
        w = [__ADC_RESL] %% w -= TRIM_BG_PRECISION_H
        if(NOT_MINUS_ALU) skip
        ret
    __trim_bg_too_big:
        b_deg_char('-')

        data_not_zero_skip([a_keep_trim_bg])
        ret
        b_deg_char('-')

        w = 0x04 %% [a_keep_trim_bg] -= w
        w = [a_keep_trim_bg]
        goto bg_gear_set

    __trim_bg_less:
        b_deg_char('s')
        b_deg_char('s')
        w = 1200 & 0xff        %% [tr3] = w
        w = (1200 >> 8) & 0xff %% [tr2] = w
        w = [__ADC_RESL] %% [tr3] -= w
        w = [__ADC_RESH] %% [tr2] -= w + c
        b_deg_u8  ([tr2])
        b_deg_u8_n([tr3])

        data_is_zero_skip([tr2])
        goto __trim_bg_too_less
        w = [tr3] %% w -= TRIM_BG_PRECISION_L
        if(NOT_MINUS_ALU) skip
        ret
    __trim_bg_too_less:
        b_deg_char('+')
        w = 0x7c
        dw_not_equ_skip([a_keep_trim_bg])
        ret
        b_deg_char('+')
        w = 0x04 %% [a_keep_trim_bg] += w
        b_deg_u8_n([a_keep_trim_bg])
        w = [a_keep_trim_bg]
        goto bg_gear_set
#endif




