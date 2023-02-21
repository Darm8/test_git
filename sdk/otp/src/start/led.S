//*INDENT-OFF*
#include "cpu.h"
#include "led.h"
#include "uart.h"

#if 0//UT_DEBUG_EN
#define l_deg_char        put_char
#define l_deg_char_n      put_char_n
#define l_deg_u8          put_u8
#define l_deg_u8_n        put_u8_n
#else

#define l_deg_char(...)
#define l_deg_char_n(...)
#define l_deg_u8(...)
#define l_deg_u8_n(...)
#endif

//function of led scan
m_led_phy_slow_scan(led0,set_pwm0,0)
m_led_phy_slow_scan(led1,set_pwm1,0)
m_led_phy_slow_scan(led2,set_pwm2,0)
//
#if BR_LED_EN
    .global led_duty_init
led_duty_init:
        w = 255
        [a_led0_duty] = w
        [a_led1_duty] = w
        [a_led2_duty] = w
        ret


//----------------------------------------------------------
#define D_BR_STEP   5

    .global led0_duty_up
led0_duty_up:
        w = D_BR_STEP + 1  %% w = [a_led0_duty] - w
        if(NOT_MINUS_ALU)skip
        goto __led0_duty_up
        w = D_BR_STEP %% [a_led0_duty] -= w
        goto __led0_duty_end
    __led0_duty_up:
        [a_led0_duty] = 0
        goto __led0_duty_end

    .global led0_duty_down
led0_duty_down:
        w = 255 -  D_BR_STEP - 1  %% w = [a_led0_duty] - w
        if(MINUS_ALU)skip
        goto __led0_duty_down
        w = D_BR_STEP %% [a_led0_duty] += w
        goto __led0_duty_end
    __led0_duty_down:

        w = 255 %% [a_led0_duty] = w
    __led0_duty_end:
        w = [a_led0_duty]
        ret

//---------------------------------------------------------------
    .global led1_duty_up
led1_duty_up:
        w = D_BR_STEP + 1  %% w = [a_led1_duty] - w
        if(NOT_MINUS_ALU)skip
        goto __led1_duty_up
        w = D_BR_STEP %% [a_led1_duty] -= w
        goto __led1_duty_end
    __led1_duty_up:
        [a_led1_duty] = 0
        goto __led1_duty_end

    .global led1_duty_down
led1_duty_down:
        w = 255 -  D_BR_STEP - 1  %% w = [a_led1_duty] - w
        if(MINUS_ALU)skip
        goto __led1_duty_down
        w = D_BR_STEP %% [a_led1_duty] += w
        goto __led1_duty_end
    __led1_duty_down:
        w = 255 %% [a_led1_duty] = w
    __led1_duty_end:
        w = [a_led1_duty]
        ret

//---------------------------------------------------------------
    .global led2_duty_up
led2_duty_up:
        w = D_BR_STEP + 1  %% w = [a_led2_duty] - w
        if(NOT_MINUS_ALU)skip
        goto __led2_duty_up
        w = D_BR_STEP %% [a_led2_duty] -= w
        goto __led2_duty_end
    __led2_duty_up:
        [a_led2_duty] = 0
        goto __led2_duty_end

    .global led2_duty_down
led2_duty_down:
        w = 255 -  D_BR_STEP - 1  %% w = [a_led2_duty] - w
        if(MINUS_ALU)skip
        goto __led2_duty_down
        w = D_BR_STEP %% [a_led2_duty] += w
        goto __led2_duty_end
    __led2_duty_down:
        w = 255 %%  [a_led2_duty] = w
    __led2_duty_end:
        w = [a_led2_duty]
        ret
#define  br_off_now(a,b) \
    w = 255  %% \
    [a_##a##_duty] = w %%\
    [a_##b##_duty] = w 

#else 

#define  br_off_now(a,b)

#endif
//---------------------------------------------------------------



    .global led0_set
led0_set:
        m_led_off(led1)
        m_led_off(led2)
        m_led_set(led0)
        br_off_now(led1, led2)
        ret

    .global led1_set
led1_set:
        m_led_off(led0)
        m_led_off(led2)
        m_led_set(led1)
        br_off_now(led0, led2)
        ret

    .global led2_set
led2_set:
        m_led_off(led0)
        m_led_off(led1)
        m_led_set(led2)
        br_off_now(led0, led1)
        ret

//----中断扫描函数
    .global led_phy_sacn
led_phy_sacn:
        call led0_phy_sacn
        call led1_phy_sacn
        goto led2_phy_sacn

//---512MS处理函数，控制LED灯亮灭次数
    .global led_deal_512ms
led_deal_512ms:
        m_led_deal_512ms(led0)
        m_led_deal_512ms(led1)
        m_led_deal_512ms(led2)
        ret

    .global led_ui_set
led_ui_set:
        [a_led_ui] = w
        a_evt_led_finish = 0
        ret




//vcc 在线的处理函数
    .global led_ear_ex_exit
    .global led_finish
led_ear_ex_exit:
        if(b_vcc_online == 1) skip
        goto __led_all_off

    __ui_then_ear_exi_lid_close:
        if(b_vcc_online == 1) skip
        goto __led_lid_close
led_finish:
    __led_usb_insert:
        if(b_vcc_online == 1) skip
        goto __led_ui_clear
    __led_finish_0:
        if(a_bit_vbat_full == 0) skip
        goto  __led_vbat_full

        orange_led_long_on()
        w = UI_LED_VCC_ONLINE
        goto led_ui_set

    __led_vbat_full:
        green_led_long_on()
        w = UI_LED_VCC_ONLINE
        goto led_ui_set

    __led_all_off:
        m_led_off(led0)
        m_led_off(led1)
        m_led_off(led2)
    __led_ui_clear:
        [a_led_ui] = 0
        ret

    __led_ear_insert:
        green_led_flash_ns(2)
        w = UI_LED_EAR_INSERT
        goto led_ui_set

    __led_lid_open:
        green_led_on_ns(29) //15秒
        w = UI_LED_LID_OPEN
        goto led_ui_set

__led_lid_close:
        if(b_vout0_online == 0) skip
        if(b_vout1_online == 1) skip
        goto __led_all_off
        green_led_on_ns(20)
        w = UI_LED_LID_CLOSE
        goto led_ui_set


    .global led_ear_ex_start
led_ear_ex_start:
        white_led_long_on()
        goto  __led_ear_ex_ui

    .global led_ear_ex_ing
led_ear_ex_ing:
        white_led_long_flash()
        goto  __led_ear_ex_ui


    .global led_ear_ex_succ
led_ear_ex_succ:
        white_led_flash_ns(10)
    __led_ear_ex_ui:
        w = UI_LED_EX_EAR
        goto led_ui_set

    .global led_vbat_lowpower
led_vbat_lowpower:
        orange_led_long_flash()
        w = UI_LED_VBAT_LOWP0WER
        goto led_ui_set

.macro ui_jmp k,fun
    w = \k
    dw_not_equ_skip([tr0])
    goto \fun
.endm



__ui_then_ear_ex:
        ui_jmp   UI_LED_LID_CLOSE, __ui_then_ear_exi_lid_close
        ret
__ui_then_vcc_online:
        ui_jmp   UI_LED_VCC_ONLINE, __led_usb_insert
        ui_jmp   UI_LED_VBAT_FULL,  __led_vbat_full
        ret

    .global ui_ctl_api
ui_ctl_api:
        [tr0] = w
    __ui_ctl_api_ear_start:
        w = UI_LED_EX_EAR
        dw_not_equ_skip([a_led_ui])
        goto __ui_then_ear_ex
    __ui_ctl_api_ear_end:

        if(b_vcc_online == 0) skip
        goto __ui_then_vcc_online
        ui_jmp   UI_LED_VCC_OFFLINE, __led_all_off       ;//ui for usb pull off
        ui_jmp   UI_LED_EAR_INSERT,  __led_ear_insert    ;//ui for ear insert
        ui_jmp   UI_LED_LID_CLOSE,   __led_lid_close
        ui_jmp   UI_LED_LID_OPEN,   __led_lid_open
        ret






