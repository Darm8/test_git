//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : low_power_app.S
  By   : XXX
  date : 2019-04-28
********************************************************************************************/
#include "cpu.h"
#include "uart.h"
#include "msg.h"
#include "app.h"
#include "led.h"



#if 0//UT_DEBUG_EN

#define lpa_deg_char        put_char
#define lpa_deg_char_n      put_char_n
#define lpa_deg_u8          put_u8
#define lpa_deg_u8_n        put_u8_n
#else

#define lpa_deg_char(...)
#define lpa_deg_char_n(...)
#define lpa_deg_u8(...)
#define lpa_deg_u8_n(...)
#endif

#define a_shut_cnt  a_shut0_cnt
#define a_life_cnt  a_shut1_cnt

.text

.macro pla_512ms
        ; call pmu_status_read
        call vcc_detect_read
        if(b_vcc_online == 0) skip
        goto  __pla_usb_insert
        ; goto __pla_512ms
        ; goto sys_mode_sel
    __pla_512ms:

        ; w = [a_life_cnt] %% w -= 0
        ; if(ALU_IS_ZERO) skip
        data_is_zero_skip([a_life_cnt])
        goto __pla_512ms_end

        lpa_deg_char('5')
        lpa_deg_char_n('m')
        call power_off
        w = 8 %% [a_life_cnt] = w
    __pla_512ms_end:
        [a_life_cnt]--
.endm

.macro pla_256ms
        //发送4次close, 发完在发送shutdown
        data_not_zero_skip([a_close_cnt])
        goto __pla_256ms_close_end
        if (b_bit_ear0_full == 1) skip
		call ear0_close_lid_api
        if (b_bit_ear1_full == 1) skip
		call ear1_close_lid_api
        [a_close_cnt]--
        data_is_zero_skip([a_close_cnt])
        goto __pla_256ms_close_end
        w = 3 %% [a_shut_cnt] = w
    __pla_256ms_close_end:

        //发送4次shut down, 若是耳机充满电后才进入低电的,不需要发送shutdown
        data_not_zero_skip([a_shut_cnt])
        goto __pla_256ms_end
        if (b_bit_ear0_full == 1) skip
		call ear0_shut_down_api
        if (b_bit_ear1_full == 1) skip
		call ear1_shut_down_api
        [a_shut_cnt]--
#if HALL_EN
        data_not_zero_skip([a_shut_cnt])
        call chg_port_set0
#endif
    __pla_256ms_end:

.endm

.macro pla_key0
        call sys_mode_sel
        sys_mode_not_equ_skip(LOW_POWER_MODE)
        call led_vbat_lowpower
.endm

.macro pla_hall
        call sys_mode_sel
.endm
.macro pla_vwp
        call sys_mode_sel
.endm

.macro pla_usb_in
    __pla_usb_insert:
        call sys_mode_sel
        led_usb_insert()
.endm

    .global low_power_app
low_power_app:
        put_char('L')
        put_char_n('p')

        call led_vbat_lowpower
        call power_2_vout_off
        [a_shut_cnt] = 0
        w = 8 %% [a_life_cnt] = w
        w = 3 %% [a_close_cnt] = w
        if (b_bit_ear0_full == 1) skip
		call ear0_close_lid_api
        if (b_bit_ear1_full == 1) skip
		call ear1_close_lid_api
    __low_power_app:
        //不处理消息需要把消息清掉
        clr_ear_evt()
        app_evt_jmp  a_evt_512ms,  pla_512ms
        app_evt_jmp  a_evt_256ms,  pla_256ms
        app_evt_jmp  a_evt_usb_insert,  pla_usb_in
        if(b_vbat_lowpower == 0) skip
        goto __lowp_power_app_1
    __lowp_power_app_0:
        app_evt_jmp  a_bit_key0,   pla_key0
#if HALL_EN
        app_evt_jmp  a_evt_hall_change,  pla_hall
#endif
    #if WIRELESS_POWER_EN
        app_evt_jmp   a_evt_wpr_online,  pla_vwp
    #endif
    __lowp_power_app_1:
        sys_mode_not_equ_skip(LOW_POWER_MODE)
        goto __lowp_usb_deal_over
    __exit_low_power_app:
        //---
        a_bit_key0 = 0
#if HALL_EN
        a_evt_hall_change = 0
#endif
        a_evt_vbat_lowpower = 0
        b_vbat_lowpower = 0
        ret
    __lowp_usb_deal_over:
        goto __low_power_app



