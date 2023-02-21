//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : __close_lid_app.S
  By   : XXX
  date : 2019-04-28
********************************************************************************************/
#include "cpu.h"
#include "uart.h"
#include "msg.h"
#include "led.h"
#include "app.h"
#include "timer.h"
#include "pmu.h"
//#include "chargestore.h"
#include "communicate_api.h"

/*
   智能充电舱闭盖模式需要做的事
   1、闭盖发送闭盖指令
   2、只需要响应单击事件,处理UI,显示当前充电舱电量信息
   3、充满电后给两只耳机充满后发送关机指令
   4、无操作后关机
   */

.text

#if 0//UT_DEBUG_EN

#define cla_deg_char        put_char
#define cla_deg_char_n      put_char_n
#define cla_deg_u8          put_u8
#define cla_deg_u8_n        put_u8_n
#else

#define cla_deg_char(...)
#define cla_deg_char_n(...)
#define cla_deg_u8(...)
#define cla_deg_u8_n(...)
#endif

.macro lca_ear_inquire_5s
        ldo_5s_trim()
        call vbat_power_read
        
        ; data_not_zero_skip([a_ear_fail_cnt])
        if(b_force_charge == 0) skip
        goto __ear_inquire_5s_end
    __ear_inquire_5s:
        w = CMD_POWER_LVL_CLOSE %% [tr0] = w
        if (b_bit_ear0_full == 1) skip
        call ear0_inquire
        if (b_bit_ear1_full == 1) skip
        call ear1_inquire
        b_bit_goto_sleep = 0
        call vout01_power_cnt
        if (b_bit_goto_sleep == 1) skip
        goto __ear_inquire_5s_end
        call power_2_vout_off
        call power_off
    __ear_inquire_5s_end:
.endm

.macro lca_512ms
        cla_deg_u8_n([a_ear_fail_cnt])
        if(vout0_load_en == 1) skip
        if(vout1_load_en == 0) skip
        goto __lca_512ms_ear_fail_cnt
        goto __lca_512ms_pmu_case
    __lca_512ms_ear_fail_cnt:
        ; w = 0x1f
        ; w -= [a_ear_fail_cnt];
        w = 0x20
        w = [a_ear_fail_cnt] - w;
        if(NOT_MINUS_ALU) skip
        goto __lca_512ms_pmu_case
        [a_ear_fail_cnt]--
        b_force_charge = 1
#if WDT_EN
        [wdt_con].6 = 1
#endif
        goto __lca_512ms_pmu_end
    __lca_512ms_pmu_case:
        if (b_force_charge == 0) skip
        [a_ear_fail_cnt] = 0
        
        b_force_charge = 0
        call pmu_chg_case
    __lca_512ms_pmu_end:
        call led_deal_512ms
        ; lca_ear_inquire_5s
        call is_line_full
.endm

.macro lca_256ms

        data_not_zero_skip([a_close_cnt])
        goto __lac_256ms_allow_end

        call ear0_close_lid_api
	    call ear1_close_lid_api
        [a_close_cnt]--

        data_is_zero_skip([a_close_cnt])
        goto __lac_256ms_allow_end

        b_bit_allow_vout0 = 1
        b_bit_allow_vout1 = 1
    __lac_256ms_allow_end:

        data_not_zero_skip([a_shut0_cnt])
        goto __lac_256ms_shut0_end
		call ear0_shut_down_api
        [a_shut0_cnt]--

        data_is_zero_skip([a_shut0_cnt])
        goto __lac_256ms_shut0_end

        b_bit_allow_vout0 = 0
        b_disable_vout0 = 1
        vout0_load_en = 0
        vout0_output_set0()
    __lac_256ms_shut0_end:

        data_not_zero_skip([a_shut1_cnt])
        goto __lac_256ms_shut1_end
		call ear1_shut_down_api
        [a_shut1_cnt]--

        data_is_zero_skip([a_shut1_cnt])
        goto __lac_256ms_shut1_end

        b_bit_allow_vout1 = 0
        b_disable_vout1 = 1
        vout1_load_en = 0
        vout1_output_set0()
    __lac_256ms_shut1_end:
.endm


.macro lca_key0
        led_lid_close()
#if VOUT_DANGER_MODE
        call vout_danger_retry
#endif
.endm


    .global close_lid_app
close_lid_app:
        cla_deg_char('c')
        cla_deg_char('l')
        cla_deg_char('o')
        cla_deg_char('s')
        cla_deg_char('e')
        cla_deg_char(' ')
        cla_deg_char('a')
        cla_deg_char_n('p')
        put_char('c')
        put_char_n('l')
        b_bit_ear0_full = 0
        b_bit_ear1_full = 0
        [a_tmr_5s_cnt] = 0
        a_evt_5s = 0

        [a_shut0_cnt] = 0
        [a_shut1_cnt] = 0
        w = 3 %% [a_close_cnt] = w
        call ear0_close_lid_api
        call ear1_close_lid_api
        led_lid_close()
__close_lid_app:
        //不处理的消息清除
        clr_ear_evt()
        call common_case
        sys_mode_not_equ_skip(CLOSE_LID_MODE)
        goto __close_lid_app_0
    __exit_close_lid_app:
        b_disable_vout0 = 0
        b_disable_vout1 = 0
        ret
    __close_lid_app_0:
        app_evt_jmp  a_evt_5s,     lca_ear_inquire_5s
        app_evt_jmp  a_evt_512ms,  lca_512ms
        app_evt_jmp  a_evt_256ms,  lca_256ms
        app_evt_jmp  a_bit_key0,   lca_key0
        goto __close_lid_app
























#if 0
        //goto __close_lid_app
        call get_msg
        w = NO_MSG %% w = [tr0] - w
        if(NOT_EQU_ALU) skip
        goto __close_lid_app
        //[tr0] = w
        //w = NO_MSG %% w = [tr0] - w
        //if(NOT_EQU_ALU) skip
        //goto __close_lid_app
    __case_cla_deal:
        //call common_msg_deal
        //PUSH [tr0]
        cla_deg_u8([tr0])
        //POP [tr0]
    __case_cla_short_up_key:
        case_jmp( KEY_0 | KEY_SHORT_UP , __case_cla_long_key)
        cla_deg_u8(KEY_0 | KEY_SHORT_UP)
        goto __close_lid_app

    __case_cla_long_key:
        case_jmp( KEY_0 | KEY_LONG , __case_cla_hold_key)
        cla_deg_u8(KEY_0 | KEY_LONG)
        goto __close_lid_app

    __case_cla_hold_key:
        case_jmp( KEY_0 | KEY_HOLD , __case_cla_default)
        cla_deg_u8(KEY_0 | KEY_HOLD)
        goto __close_lid_app
    __case_cla_default:
        cla_deg_u8([tr0])
        cla_deg_char('d')
        cla_deg_char('e')
        cla_deg_char('f')
        cla_deg_char('a')
        cla_deg_char('u')
        cla_deg_char('l')
        cla_deg_char_n('t')
        goto __close_lid_app
#endif


