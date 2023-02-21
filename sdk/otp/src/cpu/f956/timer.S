//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : timer.S
  By   : XXX
  date : 2019-04-19
********************************************************************************************/
#include "cpu.h"
#include "timer.h"
#include "msg.h"
#include "uart.h"
#include "platform.S"

#if 0//UT_DEBUG_EN

#define tim_deg_char        put_char
#define tim_deg_char_n      put_char_n
#define tim_deg_u8          put_u8
#define tim_deg_u8_n        put_u8_n
#else

#define tim_deg_char(...)
#define tim_deg_char_n(...)
#define tim_deg_u8(...)
#define tim_deg_u8_n(...)
#endif





.text
    .global tmr0_int
tmr0_int:
        [a_tmr_cnt] = 0
        w = 0x40 %% [tmr0_con0] = w
        [tmr0_cnt] = 0
        ;wrt_mem(tmr0_pr ,((SYS_CLK*2/1000)/256))
        [tmr0_con1].6 = 1
        wrt_mem(tmr0_con0,0x41)
        //[ie0].0 = 1;
        set_ie0(INT_TMR0)
        ret

//used : w
    .global delay_tmr
delay_tmr:
        [tmr1_cntl] = 0 %% [tmr1_cnth] = 0
        w = (BIT(6) | BIT(5) | BIT(4) | BIT(0)) %% [tmr1_con0] = w
    _wait_tmr1_pnd:
        if([tmr1_con0].7 == 1) skip
        goto _wait_tmr1_pnd
        w = BIT(6) %% [tmr1_con0] = w
        ret
/******
 * used: w,tr0
 * para: w : 100ms number
 * */
    .global delay_100ms
delay_100ms:
        [tr0] = w
    __delay_100ms:
        ;w = 0 %% w = [tr0] - w
        ;if(NOT_EQU_ALU) skip
        data_not_zero_skip([tr0])
        ret
        delay_ms(100)
        [tr0]--
        goto __delay_100ms



    .global delay
delay:
        [tr0] = w
    __delay0:
        ;w = 0 %% w = [tr0] - w
        ;if(NOT_EQU_ALU) skip
        data_not_zero_skip([tr0])
        ret
        nop
        [tr0]--
        goto __delay0



    .global time_out
time_out:
        [tmr1_con0] = 0;
        [tmr1_cntl] = 0 %% [tmr1_cnth] = 0
        w = (BIT(6) | BIT(5) | BIT(4) | BIT(0)) %% [tmr1_con0] = w
        ret



