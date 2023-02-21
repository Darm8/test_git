//*INDENT-OFF*
#include "cpu.h"
#include "user_led.h"
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


    .global led_io_init
led_io_init:
#if IDE_DEBUG_IO
    [p0_pd].0 = 0 %% [p0_pu].0 = 1 %% [p0_die].0 = 1 %% [p0_dir].0 = 0
    [p1_pd].1 = 0 %% [p1_pu].1 = 0 %% [p1_die].1 = 1 %% [p1_dir].1 = 0
    ; [p1_pd].6 = 0 %% [p1_pu].6 = 0 %% [p1_die].6 = 1 %% [p1_dir].6 = 0  //打印口
    [p1_pd].0 = 0 %% [p1_pu].0 = 0 %% [p1_die].0 = 1 %% [p1_dir].0 = 0
    [p0_pd].3 = 0 %% [p0_pu].3 = 0 %% [p0_die].3 = 1 %% [p0_dir].3 = 0
    [p1_pd].7 = 0 %% [p1_pu].7 = 0 %% [p1_die].7 = 1 %% [p1_dir].7 = 0
#else
    [p0_pd].0 = 0 %% [p0_pu].0 = 0 %% [p0_die].0 = 1 %% [p0_dir].0 = 0  ;D5
    [p0_pd].2 = 0 %% [p0_pu].2 = 0 %% [p0_die].2 = 1 %% [p0_dir].2 = 0  ;D4
    [p0_pd].3 = 0 %% [p0_pu].3 = 0 %% [p0_die].3 = 1 %% [p0_dir].3 = 0  ;D3
    [p0_pd].4 = 0 %% [p0_pu].4 = 0 %% [p0_die].4 = 1 %% [p0_dir].4 = 0  ;D2
    [p0_pd].5 = 0 %% [p0_pu].5 = 0 %% [p0_die].5 = 1 %% [p0_dir].5 = 0  ;D1
#endif
    ret


    .global led_level_1
led_level_1:
    low_power_flag = 0
    led_5_on
    led_4_on
    led_3_on
    led_2_on
    led_1_on
    ret

    .global led_level_2
led_level_2:
    low_power_flag = 0
    led_5_on
    led_4_on
    led_3_on
    led_2_on
    led_1_off
    ret

    .global led_level_3
led_level_3:
    low_power_flag = 0
    led_5_on
    led_4_on
    led_3_on
    led_2_off
    led_1_off
    ret

    .global led_level_4
led_level_4:
    low_power_flag = 0
    led_5_on
    led_4_on
    led_3_off
    led_2_off
    led_1_off
    ret

    .global led_level_5
led_level_5:
    low_power_flag = 0
    led_5_on
    led_4_off
    led_3_off
    led_2_off
    led_1_off
    ret

    .global led_timer_deal
led_timer_deal:
    w = [voltage_level]
    dw_is_equ_skip(6)
    ret
    led_1_4_off
    if(led_5_is_on)skip
    goto _led_off_det
    led_5_off
    ret
  _led_off_det:  
    if(led_5_is_off)skip
    ret
    led_5_on
    ret
