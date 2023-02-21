//*INDENT-OFF*


#include "adc.h"


#if 0// UT_DEBUG_EN
#define adc_deg_char        put_char
#define adc_deg_char_n      put_char_n
#define adc_deg_u8          put_u8
#define adc_deg_u8_n        put_u8_n
#define adc_deg_w_u8        put_w_u8
#define adc_deg_w_u8_n      put_w_u8_n
#else

#define adc_deg_char(...)
#define adc_deg_char_n(...)
#define adc_deg_u8(...)
#define adc_deg_u8_n(...)
#define adc_deg_w_u8(...)
#define adc_deg_w_u8_n(...)
#endif


#define a_adc_cnt          a_tmr_5s_cnt
#define a_adc_resh         tr2
#define a_adc_resl         tr3

    .global _adc_continue_read
_adc_continue_read:
        sfr(adc_con0,0x58|ADC_DIV24) \
        [ana_con9].1 = 1
        [adc_con0].6 = 1
    _adc_get_value:
        if([adc_con0].7 == 1) skip
        goto _adc_get_value
        w = [adc_resh] %% [__ADC_RESH] = w
        w = [adc_resl] %% [__ADC_RESL] = w
        [adc_con0] = 0
        ret

#if WIRELESS_POWER_EN
    .global ks_wpr_adc
ks_wpr_adc:
        b_adc_busy = 0
        vwp_ad_io_set()
        [adc_con0] = 0
        sfr(adc_con1,(0x2<<4)|(ADC_VWP_AD))
        sfr(adc_con0,0x58|ADC_DIV24)
        w = 0xe3 %% [ana_con9] &= w
        [ana_con9].1 = 1
        [adc_con0].6 = 1
        ret

    .global wpr_detect
wpr_detect:
        if(b_adc_busy == 1) skip
        if([adc_con0].7 == 1) skip
        ret
        w = [adc_resh] %% [tr0] = w
        ; w = [adc_resh]
        w = 0x2a %% w = [tr0] - w
        if(NOT_MINUS_ALU) skip
        goto __wpr_detect_offline
        w = 10 %% w = [a_wpr_cnt] - w
        if(NOT_MINUS_ALU) skip
        goto  __wpr_detect_inc
        if(b_wpr_online == 1) skip
        a_evt_wpr_online = 1
        a_evt_wpr_offline = 0
        b_wpr_online = 1
        goto __wpr_detect_end
    __wpr_detect_inc:
        [a_wpr_cnt]++
        goto __wpr_detect_end
    __wpr_detect_offline:
        [a_wpr_cnt] = 0
        if(b_wpr_online == 0) skip
        a_evt_wpr_offline = 1
        a_evt_wpr_online = 0
        b_wpr_online = 0
    __wpr_detect_end:
        [adc_con0].6 = 1
        ret
#endif



// V_ch_xx = const_vbg_value * adc_ch_xx / adc_ch_vbg
    .global _adc_get_voltage
_adc_get_voltage:

#if __ADC_RESH != TR0
        w = [__ADC_RESH] %% [TR0] = w
        w = [__ADC_RESL] %% [TR1] = w
#endif

#if EX_LDO_TIRM_EN
        if(a_bit_bg_1_8 == 0) skip
        goto __adc_bg_1_8
#endif
    __adc_bg_1_2:
        w = [__VBG_TRIM_H] %% [TR2] = w
        w = [__VBG_TRIM_L] %% [TR3] = w

        mult_r01Xr23()  //const_vbg_value * adc_ch_xx

        adc_read_phy(ADC_CH_ANA,ANA_VBG)

#if EX_LDO_TIRM_EN
        goto __adc_bg_v_end

    __adc_bg_1_8:
        w = (1800 >> 8) & 0xff %% [TR2] = w
        w = 1800 & 0xff        %% [TR3] = w

        mult_r01Xr23()  //const_vbg_value * adc_ch_xx

        adc_read_phy(ADC_EX_LDO,0)
#endif
    __adc_bg_v_end:


#if div_ch != __ADC_RESH
        w = [__ADC_RESH] %% [div_ch] = w
        w = [__ADC_RESL] %% [div_cl] = w
#endif

#if div_bh3 != multiply_b3
        w = [multiply_b3] %% [div_bh3] = w
        w = [multiply_b2] %% [div_bh2] = w
        w = [multiply_b1] %% [div_bh] = w
        w = [multiply_b0] %% [div_bl] = w
#endif

        call div_32x16

        w = [div_bh] %% [TR0] = w
        w = [div_bl] %% [TR1] = w
        ret





