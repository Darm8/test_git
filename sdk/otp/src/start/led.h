//*INDENT-OFF*
#ifndef __LED_H__
#define __LED_H__

#include "platform.S"

#define LED_MAX_CNT         (50 & 0xff)
#define LED_MID_CNT         (25 & 0xff)

#define LED_SLOW_MAX_CNT         (124 & 0xff)
#define LED_SLOW_MID_CNT         (62 & 0xff)

#if BR_LED_EN
.macro led_phy_sacn led,on,flash,flash_cnt,pwm,m_cnt,i_cnt,duty
    .global \led\()_phy_sacn
\led\()_phy_sacn:
        if(\on == 0) skip
        goto __\led\()_not_turn_off

        if_not_zero_skip([\flash_cnt])
        goto __\led\()_turn_off
    __\led\()_not_turn_off:
        if(\flash == 1) skip
        goto __\led\()_turn_on

        [\flash_cnt]++

        w = \m_cnt

        if_w_not_equ_skip([\flash_cnt])
        [\flash_cnt] = 0
        w = \i_cnt %% w = [\flash_cnt] -w
        if(NOT_MINUS_ALU) skip\
        goto __\led\()_turn_off
    __\led\()_turn_on:
        //w = 0
        call \led\()_duty_up
        goto \pwm
    __\led\()_turn_off:
        //w = 255
        call \led\()_duty_down
        goto \pwm
.endm
#else
.macro led_phy_sacn led,on,flash,flash_cnt,pwm,m_cnt,i_cnt,duty
    .global \led\()_phy_sacn
\led\()_phy_sacn:
        if(\on == 0) skip
        goto __\led\()_not_turn_off

        if_not_zero_skip([\flash_cnt])
        goto __\led\()_turn_off
    __\led\()_not_turn_off:
        if(\flash == 1) skip
        goto __\led\()_turn_on

        [\flash_cnt]++

        w = \m_cnt

        if_w_not_equ_skip([\flash_cnt])
        [\flash_cnt] = 0
        w = \i_cnt %% w = [\flash_cnt] -w
        if(NOT_MINUS_ALU) skip\
        goto __\led\()_turn_off
    __\led\()_turn_on:
        w = 0
        // call \led\()_duty_up
        goto \pwm
    __\led\()_turn_off:
        w = 255
        // call \led\()_duty_down
        goto \pwm
.endm

#endif

//; led_phy_sacn led0,a_bit_led0_on,a_bit_led0_flash,a_led0_flash_cnt,set_pwm0
#define m_led_phy_scan(led,pwm,duty)      led_phy_sacn led,a_bit_##led##_on,a_bit_##led##_flash,a_##led##_flash_cnt,pwm,LED_MAX_CNT,LED_MID_CNT,duty
#define m_led_phy_slow_scan(led,pwm,duty) led_phy_sacn led,a_bit_##led##_on,a_bit_##led##_flash,a_##led##_flash_cnt,pwm,LED_SLOW_MAX_CNT,LED_SLOW_MID_CNT,duty

.macro m_led_512ms led,on,cnt

#ifdef F95
        if(\on == 1) skip
        goto __\led\()_deal_512ms_end
        if((w = [\cnt] + 1) == 0) skip
        goto __\led\()_deal_512ms_a
        goto __\led\()_deal_512ms_end
    __\led\()_deal_512ms_a:
        w = 0 %% w = [\cnt] - w
        if(NOT_EQU_ALU) skip
        goto __\led\()_deal_512ms_0
        if(--[\cnt] == 0) skip
        goto __\led\()_deal_512ms_end
    __\led\()_deal_512ms_0:
        \on = 0
        a_evt_led_finish = 1
    __\led\()_deal_512ms_end:
#endif

#ifdef F96
        if(\on == 1) skip
        goto __\led\()_deal_512ms_end
        w = 0xff %%  w = [\cnt] -w
        if(NOT_EQU_ALU) skip
        goto __\led\()_deal_512ms_end
    __\led\()_deal_512ms_a:
        if([\cnt] != 0) skip
        goto __\led\()_deal_512ms_0
        if(--[\cnt] == 0) skip
        goto __\led\()_deal_512ms_end
    __\led\()_deal_512ms_0:
        \on = 0
        a_evt_led_finish = 1
        //[a_led_ui] = 0
    __\led\()_deal_512ms_end:

#endif
.endm


//; m_led_512ms led0,a_bit_led0_on,a_led0_on_cnt
#define m_led_deal_512ms(led)   m_led_512ms led,a_bit_##led##_on,a_##led##_on_cnt

#define m_led_set(led)              \
        [a_##led##_on_cnt] = w %%   \
        [a_##led##_flash_cnt] = 0 %%\
        a_bit_##led##_on = 1

#define m_led_ctl(led,x,flash) \
        a_bit_##led##_flash = flash %% \
        w = x  %%\
        call led##_set //led0_set,led1_set,led2_set

        // [a_##led##_on_cnt] = w %% \
        // [a_##led##_flash_cnt] = 0 %%\
        // a_bit_##led##_on = 1

#define m_led_off(led)  a_bit_##led##_on = 0 %% [a_##led##_flash_cnt] = 0 //这一句宏不能改变W的值
#define m_led_off_now(led)  \
    a_bit_##led##_on = 0 %% [a_##led##_flash_cnt] = 0 %% w = 255 %%  [a_##led##_duty] = w  //这一句宏不能改变W的值

//-----------------------------------------
#define green_led_long_on()       m_led_ctl(led1, 0xff, 0)
#define green_led_on_ns(x)        m_led_ctl(led1, x,    0)
#define green_led_long_flash()    m_led_ctl(led1, 0xff, 1)
#define green_led_flash_ns(x)     m_led_ctl(led1, x,    1)
#define green_led_off()           //m_led_off(led1)

//-----------------------------------------
#define orange_led_long_on()      m_led_ctl(led2, 0xff, 0)
#define orange_led_on_ns(x)       m_led_ctl(led2, x,    0)
#define orange_led_long_flash()   m_led_ctl(led2, 0xff, 1)
#define orange_led_flash_ns(x)    m_led_ctl(led2, x,    1)
#define orange_led_off()          //m_led_off(led2)

//-----------------------------------------
#define white_led_long_on()      m_led_ctl(led0, 0xff, 0)
#define white_led_on_ns(x)       m_led_ctl(led0, x,    0)
#define white_led_long_flash()   m_led_ctl(led0, 0xff, 1)
#define white_led_flash_ns(x)    m_led_ctl(led0, x,    1)
#define white_led_off()          //m_led_off(led0)



//----------------- UI------------------------
#define  UI_LED_NULL           0
#define  UI_LED_VCC_ONLINE     1
#define  UI_LED_VCC_OFFLINE    2
#define  UI_LED_EAR_INSERT     3
#define  UI_LED_EX_EAR         4
#define  UI_LED_LID_CLOSE      5
#define  UI_LED_LID_OPEN       6
#define  UI_LED_VBAT_FULL      7
#define  UI_LED_VBAT_LOWP0WER  8
#define  UI_LED_FINISH         0x80

#define ui_api(k) w = k %% call ui_ctl_api

#define led_vbat_full()   ui_api(UI_LED_VBAT_FULL)
#define led_usb_insert()  ui_api(UI_LED_VCC_ONLINE)
#define led_usb_pullout() ui_api(UI_LED_VCC_OFFLINE)
#define led_ear_insert()  ui_api(UI_LED_EAR_INSERT)
#define led_ear_pullout() ui_api(UI_LED_EAR_INSERT)
#define led_ear_change()  ui_api(UI_LED_EAR_INSERT)
#define led_lid_close()   ui_api(UI_LED_LID_CLOSE)
#define led_lid_open()    ui_api(UI_LED_LID_OPEN)






#endif


