//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : wireless_power.S
  By   : XXX
  date : 2020-03-27
********************************************************************************************/
#include "cpu.h"
#include "uart.h"
#include "adc.h"
#include "timer.h"
#include "platform.S"

#if 0//UT_DEBUG_EN
#define wp_deg_char        put_char
#define wp_deg_char_n      put_char_n
#define wp_deg_u8          put_u8
#define wp_deg_u8_n        put_u8_n
#define wp_deg_w_u8        put_w_u8
#define wp_deg_w_u8_n      put_w_u8_n
#else

#define wp_deg_char(...)
#define wp_deg_char_n(...)
#define wp_deg_u8(...)
#define wp_deg_u8_n(...)
#define wp_deg_w_u8(...)
#define wp_deg_w_u8_n(...)
#endif

#if WIRELESS_POWER_EN

#if 1
    .global get_wireless_power
get_wireless_power:
        vwp_ad_io_set()
        [a_power_acc_h] = 0
        [a_power_acc_l] = 0
        [a_power_acc_cnt] = 0
        delay_ms(5)
    __get_wireless_power_loop:

        adc_get_voltage(ADC_SCAN_VWP_AD, 0)
        CY = 0 %% RR TR0 %% RR TR1
        CY = 0 %% RR TR0 %% RR TR1

        w = [tr1] %% [a_power_acc_l] += w
        w = [tr0] %% [a_power_acc_h] += w + c
        [a_power_acc_cnt]++
        w = 16 %% w = [a_power_acc_cnt] - w
        if(EQU_ALU)skip
        goto __get_wireless_power_loop
        w = [a_power_acc_l] %% [tr1] = w
        w = [a_power_acc_h] %% [tr0] = w
        ret

#else
    .global get_wireless_power
get_wireless_power:
        vwp_ad_io_set()
        delay_ms(5)
        adc_get_voltage(ADC_SCAN_VWP_AD, 0)
        //voltage * 4
        CY = 0 %% RL TR0 %% RL TR1
        CY = 0 %% RL TR0 %% RL TR1

        ret
#endif
    .global wireless_100ms_run
wireless_100ms_run:
        if(b_wireless_open == 1)skip
        ret
        if(b_dcdc_enable == 1) skip
        goto __w1r_err_cnt
        b_wireless_flag  = !b_wireless_flag
        if(b_wireless_flag == 1) skip
        ret
    __w1r_err_cnt:
        [a_wireless_err_cnt]++
        w = 6 %% w = [a_wireless_err_cnt] -w
        if(NOT_MINUS_ALU) skip
        goto __w1r_control_err
        [a_wireless_err_cnt] = 0
        goto get_rectified_value
    __w1r_control_err:
        goto get_control_error

    .global wireless_open
wireless_open:
        call wpr_init
        b_wireless_open = 1
        ret

    .global wireless_close
wireless_close:
        b_wireless_open = 0
        ret

    .global dcdc_en
dcdc_en:
        DCDC_IO_H
        ret

    .global wireless_open_api
wireless_open_api:
        call wireless_open
        call get_signal_value
        delay_ms(6)
        call get_identification

        delay_ms(6)
        call get_configurtion
        [a_100ms_cnt] = 0
        a_evt_100ms = 1
        wp_deg_char('W')
        wp_deg_char('P')
        wp_deg_char(' ')
        wp_deg_char('o')
        wp_deg_char_n('P')
        ret
    .global wireless_close_api
wireless_close_api:
        call wireless_close
        DCDC_IO_L
        wp_deg_char('W')
        wp_deg_char('P')
        wp_deg_char(' ')
        wp_deg_char('c')
        wp_deg_char_n('l')
        ret


#endif




