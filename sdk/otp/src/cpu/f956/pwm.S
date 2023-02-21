//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : pwm.c
  By   : XXX
  date : 2019-08-20
********************************************************************************************/
#include "cpu.h"
#include "uart.h"
#include "pwm.h"
#include "timer.h"

#define pwm_con0 led_con0
#define pwm_con1 led_con1
#define pwm_prd  led_prd

#define pwm0_duty led0_duty
#define pwm1_duty led1_duty
#define pwm2_duty led2_duty

#define D_PWM_PRD 254

#define set_pwm0_enable(n)  [pwm_con1].0 = n %% [iomc0].0 = 1
#define set_pwm1_enable(n)  [pwm_con1].1 = n %% [iomc0].1 = 1
#define set_pwm2_enable(n)  [pwm_con1].2 = n %% [iomc0].2 = 1

; #define set_pwm0_io    [p0_dir].5 = 0 %% [p0_out].5 = 1
; #define set_pwm1_io    [p0_dir].6 = 0 %% [p0_out].6 = 1
; #define set_pwm2_io    [p0_dir].7 = 0 %% [p0_out].7 = 1

#define set_pwm0_io    [p1_dir].3 = 0 %% [p1_out].3 = 1
#define set_pwm1_io    [p1_dir].4 = 0 %% [p1_out].4 = 1
#define set_pwm2_io    [p1_dir].5 = 0 %% [p1_out].5 = 1

#define set_pwm0_duty    [pwm0_duty] = w
#define set_pwm1_duty    [pwm1_duty] = w
#define set_pwm2_duty    [pwm2_duty] = w

/*********************************************************
    used : tr1, w
    tr0  : pwm_duty0
    tr1  : pwm_duty1
    tr2  : pwm_duty2
    return tr0
*********************************************************/
.text
    .global pwm_led_init
pwm_led_init:
        [iomc3].7 = 1
        w = D_PWM_PRD %% [pwm_prd] = w
        w = 1 %% [pwm_con0] = w
        ret
/*********************************************************
    used : w
    w  : pwm_duty
*********************************************************/
    .global set_pwm0
set_pwm0:
        ; [tr0] = w
        ; w = 255 %% w = [tr0] - w
        ; if (NOT_EQU_ALU) skip
        ;     GOTO __rest_led0
        ; w = [tr0]
        set_pwm0_duty
        set_pwm0_io
        set_pwm0_enable(1)
        ret
    ; __rest_led0:
    ;     [iomc0].0 = 0
    ;     [p1_out].3 = 0
    ;     ret

//-------------------------------------------------------
    .global set_pwm1
set_pwm1:
        ; [tr0] = w
        ; w = 255 %% w = [tr0] - w
        ; if (NOT_EQU_ALU) skip
        ;     GOTO __rest_led1
        ; w = [tr0]
        set_pwm1_duty
        set_pwm1_io
        set_pwm1_enable(1)
        ret
    ; __rest_led1:
    ;     [iomc0].1 = 0
    ;     [p1_out].4 = 0
    ;     ret
//-------------------------------------------------------
    .global set_pwm2
set_pwm2:
        ; [tr0] = w
        ; w = 255 %% w = [tr0] - w
        ; if (NOT_EQU_ALU) skip
        ;     GOTO __rest_led2
        ; w = [tr0]
        set_pwm2_duty
        set_pwm2_io
        set_pwm2_enable(1)
        ret
    ; __rest_led2:
    ;     [iomc0].2 = 0
    ;     [p1_out].5 = 0
    ;     ret

#if 0
    .global pwm_led_test
pwm_led_test:
        w = 0 %% call set_pwm0
        w = 0 %% call set_pwm1
        w = 0 %% call set_pwm2
        call pwm_led_init

        w = 0 %% [a_br_led_cnt] = w
        w = 1 %% [a_br_led_plus] = w
    __pwm_led_loop:
        //put_u8([a_br_led_cnt])
        delay_ms(7)
    __pwn_plus_1:
        ;w = 0
        ;w = [a_br_led_cnt] - w
        ;if(EQU_ALU) skip
        data_is_zero_skip([a_br_led_cnt])
        goto __pwm_plus_255
        w = 0x01 %% [a_br_led_plus] = w
        goto __pwm_call
    __pwm_plus_255:
        w = 255
        ;w = [a_br_led_cnt] - w
        ;if(EQU_ALU) skip
        dw_is_equ_skip([a_br_led_cnt])
        goto __pwm_call
        w = 0xff %% [a_br_led_plus] = w
    __pwm_call:
        w = [a_br_led_plus]
        [a_br_led_cnt] += w
        w = [a_br_led_cnt]
        set_pwm0_duty
        set_pwm1_duty
        set_pwm2_duty
        goto __pwm_led_loop


        ret

#endif
