//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : common_app.S
  By   : XXX
  date : 2019-04-28
********************************************************************************************/
#include "cpu.h"
#include "msg.h"
#include "led.h"
#include "uart.h"
#include "app.h"
#include "timer.h"
#include "communicate_api.h"


#if 0//UT_DEBUG_EN

#define cca_deg_char        put_char
#define cca_deg_char_n      put_char_n
#define cca_deg_u8          put_u8
#define cca_deg_u8_n        put_u8_n
#else

#define cca_deg_char(...)
#define cca_deg_char_n(...)
#define cca_deg_u8(...)
#define cca_deg_u8_n(...)
#endif

#define  com_evt_jmp app_evt_jmp

//-------------------------------------
// case hall
.macro ce_hall
        goto sys_mode_sel
.endm

.macro ce_vbat_lowpower
        sys_mode(LOW_POWER_MODE)
.endm

.macro ce_usb_in
        led_usb_insert()
.endm

// case usb inser
.macro ce_usb_out
        led_usb_pullout()
.endm



.macro ce_wpr_online
	call wireless_open_api
    cca_deg_char('w')
    cca_deg_char('p')
    cca_deg_char('r')
    cca_deg_char_n('*')
.endm

.macro ce_100ms_case
    call wireless_100ms_run
.endm

.macro ce_wpr_offline
    cca_deg_char('-')
    call wireless_close_api
.endm

.macro ce_vbat_full
        w = [a_vbat_power] %% w = 80 - w
        if (MINUS_ALU) skip
        goto __ce_vbat_full_0

        led_vbat_full()
        cca_deg_char('f')
        cca_deg_char('u')
        cca_deg_char_n('l')
        goto __ce_vbat_full_end
    __ce_vbat_full_0:
        cca_deg_char('~')
        call clear_vbat_full
__ce_vbat_full_end:
.endm

.macro ce_led_finish
        call led_finish
.endm

    .global common_case
common_case:
        app_evt_jmp   a_evt_vbat_lowpower,  ce_vbat_lowpower
    #if WIRELESS_POWER_EN
        app_evt_jmp   a_evt_wpr_online,     ce_wpr_online
        app_evt_jmp   a_evt_wpr_offline,    ce_wpr_offline
        app_evt_jmp   a_evt_100ms,          ce_100ms_case
    #endif
        com_evt_jmp   a_evt_vbat_full,      ce_vbat_full
        com_evt_jmp   a_evt_led_finish,     ce_led_finish

    #if HALL_EN
        com_evt_jmp  a_evt_hall_change,  ce_hall
    #endif
        com_evt_jmp  a_evt_usb_insert,   ce_usb_in
        com_evt_jmp  a_evt_usb_pullout,  ce_usb_out
#if (HANDSHAKE_EN == 0)
    .global handshake_run
handshake_run:
    .global ppm_2000
ppm_2000:
#endif

#if (WIRELESS_POWER_EN == 0)
    .global wpr_4k
wpr_4k:
#endif

#if HALL_EN
    .global ear0_info_init
ear0_info_init:
    .global ear1_info_init
ear1_info_init:
    .global exit_ear_ex
exit_ear_ex:
#endif
        ret

/*********************************************************
传入:  w   :  CMD
返回:tr3.7 :  0,失败    1,成功
*********************************************************/
    .global return_protocol_case_result
return_protocol_case_result:
        [tr0] = w
        ;w = 0 %% w = [a_chg_rev_len] - w
        ;if(NOT_EQU_ALU) skip
        data_not_zero_skip([a_chg_rev_len])
            goto __return_faild_result0
        w = [tr0]; %% w = [a_chg_buf + 1] - w
        ;if(EQU_ALU) skip
        dw_is_equ_skip([a_chg_buf + 1])
            goto __return_faild_result
        cca_deg_char('o')
        cca_deg_char_n('k')

        data_is_zero_skip([a_ear_fail_cnt])
        [a_ear_fail_cnt]--

        chg_para_success
        ret
    __return_faild_result0:
        cca_deg_char_n('E')
    __return_faild_result:
        if([a_ear_fail_cnt].7 == 0) skip
        goto __return_faild_end
        w = 2 %% [a_ear_fail_cnt] += w
        if([a_ear_fail_cnt].5 == 0) skip
        [a_ear_fail_cnt].7 = 1
        cca_deg_char('e')
        cca_deg_char('r')
        cca_deg_char_n('r')
    __return_faild_end:
        chg_para_faild
        ret



