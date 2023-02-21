//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : __open_lid_app.S
  By   : XXX
  date : 2019-04-28
********************************************************************************************/
#include "cpu.h"
#include "uart.h"
#include "msg.h"
#include "led.h"
#include "app.h"
// #include "chargestore.h"
#include "communicate_api.h"
#include "common.S"

#if 0//UT_DEBUG_EN

#define ola_deg_char        put_char
#define ola_deg_char_n      put_char_n
#define ola_deg_u8          put_u8
#define ola_deg_u8_n        put_u8_n
#else

#define ola_deg_char(...)
#define ola_deg_char_n(...)
#define ola_deg_u8(...)
#define ola_deg_u8_n(...)
#endif

/*
   智能充电舱开盖模式需要做的事:
   1、检测耳机插入拔出.发送开盖指令,交换地址信息
   2、超时退出开盖模式,电池电量正常或者VCC有插入,则进入关盖模式,否则进入低电模式
   3、插拔耳机UI显示
   4、插拔USB UI显示
   5、按键交换地址信息,UI显示

   UI:
   1、开盖亮绿灯3s
   2、单击抬起事件亮绿灯3s
   3、长按事件白灯亮起
   4、长按超过3s后白灯呼吸闪烁,并开始配对
   5、长按不超过3s抬起白灯灭
   6、配对成功白灯灭
   */

//;.section text_lid_open_app,"ax"
.text


.macro loa_512ms_not_allow_vout01_func
        ola_ear0_inquire()
        ola_ear1_inquire()
        ; ola_deg_char('N')
        ; ola_deg_char('o')
        ola_deg_u8_n([a_loa_allow_vout01_cnt])
        w = 234 %% w = [a_loa_allow_vout01_cnt] - w
        ; w = 10 %% w = [a_loa_allow_vout01_cnt] - w
        if(NOT_MINUS_ALU)skip
        goto __loa_512ms_not_allow_vout01_func_inc
        //开盖超时后,检测当前是否电池低电,低电则去lowpower app,否则去close app走充电流程
        if (b_vbat_lowpower == 0) skip
        goto __loa_vbat_lopower_deal
        sys_mode(CLOSE_LID_MODE)
        goto __loa_512ms_not_allow_vout01_func_end
    __loa_vbat_lopower_deal:
        sys_mode(LOW_POWER_MODE)
    __loa_512ms_not_allow_vout01_func_inc:
        [a_loa_allow_vout01_cnt]++
    __loa_512ms_not_allow_vout01_func_end:
        ; call pmu_chg_case     ;call pmu_for_open_lid
.endm

.macro loa_ear_inquire_5s
        ldo_5s_trim()   //call ldo_trim_5s
.endm

.macro loa_512ms
        call vbat_power_read
        call pmu_chg_case
        loa_512ms_not_allow_vout01_func
        call led_deal_512ms
        call is_line_full
        w = EAR_EX_STATUS_ING
        dw_not_equ_skip([a_ear_ex_status])
        call fun_ear_exchange
.endm
//------------512ms case end

.macro loa_ear0_insert
        ola_ear0_inquire()
.endm

.macro loa_ear1_insert
        ola_ear1_inquire()
.endm

.macro loa_ear_pullout
        call led_ear_pullout
.endm

.macro loa_ear0_pullout
        nop
.endm


.macro loa_ear1_pullout
        nop
.endm

//------------ear event case end

.macro loa_key0
        [a_loa_allow_vout01_cnt] = 0
#if VOUT_DANGER_MODE
        call vout_danger_retry
#endif
.endm



    .global open_lid_app
open_lid_app:
        ola_deg_char('o')
        ola_deg_char('p')
        ola_deg_char('e')
        ola_deg_char('n')
        ola_deg_char(' ')
        ola_deg_char('a')
        ola_deg_char_n('p')
        put_char('o')
        put_char_n('p')

        [a_loa_allow_vout01_cnt] = 0
        [a_detect_status] = 0
        [a_tmr_5s_cnt] = 0
        a_evt_5s = 0
        [a_ear_ex_status] = EAR_EX_STATUS_NULL ; w = EAR_EX_STATUS_NULL %% [a_ear_ex_status] = w
        led_lid_open()
        call vout_2_vout01_close
    __open_lid_app:
        call common_case
        sys_mode_not_equ_skip(OPEN_LID_MODE)
        goto __open_lid_app_0
    __exit_open_lid_app:
        [a_ear_ex_status] = EAR_EX_STATUS_NULL ; w = EAR_EX_STATUS_NULL %% [a_ear_ex_status] = w
        ret
    __open_lid_app_0:
        ;清除不需要处理的消息
        a_evt_ear0_pullout = 0
        a_evt_ear1_pullout = 0
        app_evt_jmp  a_evt_5s,           loa_ear_inquire_5s
        app_evt_jmp  a_evt_512ms,        loa_512ms
        app_evt_jmp  a_bit_key0,         loa_key0
        app_evt_jmp  a_bit_key0_base,    loa_ear_ex_start
        app_evt_jmp  a_bit_key0_long,    loa_ear_ex_ing
        app_evt_jmp  a_bit_key0_long_up, loa_ear_ex_end
        is_ear_changed()
        if(ALU_NOT_ZERO) skip
        goto __find_is_ear_changed_end
        [a_loa_allow_vout01_cnt] = 0
        led_ear_change()
        app_evt_jmp      a_evt_ear0_insert,  loa_ear0_insert
        app_evt_jmp      a_evt_ear1_insert,  loa_ear1_insert
    __find_is_ear_changed_end:
        goto __open_lid_app

