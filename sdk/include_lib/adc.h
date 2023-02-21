#ifndef __ADC_H__
#define __ADC_H__
#include "cpu.h"
#include "pmu.h"
#include "timer.h"
#include "uart.h"
#include "mult.h"
#define     ADC_CH_P01  0
#define     ADC_CH_P03  1
#define     ADC_CH_P05  2
#define     ADC_CH_P06  3
#define     ADC_CH_P13  4
#define     ADC_CH_P14  5
#define     ADC_CH_P15  6
#define     ADC_CH_ANA  7
#define     ADC_EX_LDO       ADC_CH_P03
#define     ADC_VWP_AD       ADC_CH_P03
#define     ADC_SCAN_VWP_AD  ADC_VWP_AD



#define     ANA_VBG             0
#define     ANA_VCC             1
#define     ANA_VEB             2
#define     ANA_Vsense_OUT1     3
#define     ANA_Vsense_OUT0     4
#define     ANA_LINE_PROGI      5
#define     ANA_BUCK_PROGI      6
#define     ANA_VBAT            7

//结果存在TR0 TR1
#define     __ADC_RESH      TR0
#define     __ADC_RESL      TR1

#define     __VBG_TRIM_H    a_vbg_vol_h
#define     __VBG_TRIM_L    a_vbg_vol_l

#define    ADC_DIV6   1
#define    ADC_DIV12  2
#define    ADC_DIV24  3
#define    ADC_DIV32  4

//adc_res = ((TR0<<8)|TR1)>>6
//放大了64倍
#if WIRELESS_POWER_EN
#define adc_busy_api()   b_adc_busy = 1
#define adc_idle_api()   call ks_wpr_adc
#define wpr_detect_api() call wpr_detect

#else
#define adc_busy_api()
#define adc_idle_api()
#define wpr_detect_api()

#endif

#define adc_read_phy(ch,ana_ch) \
        [adc_con0] = 0 \
        sfr(adc_con1,(0x2<<4)|(ch)) \
        [ana_con9].4 = (ana_ch>>2) & 1 \
        [ana_con9].3 = (ana_ch>>1) & 1 \
        [ana_con9].2 = (ana_ch>>0) & 1 \
        call _adc_continue_read

#define adc_read_api(ch,ana_ch) \
        adc_busy_api()               \
        adc_read_phy(ch, ana_ch) \
        adc_idle_api()

#define adc_get_voltage(ch,ana_ch) \
        adc_busy_api()              %% \
        adc_read_phy(ch,ana_ch) %% \
        call _adc_get_voltage       %% \
        adc_idle_api()

#endif
