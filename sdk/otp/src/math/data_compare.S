//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : data_compare.S
  By   : XXX
  date : 2019-12-05
********************************************************************************************/
#include "cpu.h"
#include "uart.h"
#include "data_compare.h"

.text
/*********************************************************
    used : w,tr0,tr1,tr2,tr3
    tr0-tr1 > tr2-tr3
    res : rqual : tr3.0 == 1
          big   : tr3.1 == 1
          small : tr3.1 == 0
*********************************************************/
    .global u16_compare
u16_compare:
        ; put_u8(u16_ah)
        ; put_u8_n(u16_al)
        ; put_u8(u16_bh)
        ; put_u8_n(u16_bl)

        //b - a
        w = u16_ah %% w = u16_bh -w
        if(NOT_MINUS_ALU) skip ;b>=a?
        goto __is_greater_than
        //a <= b
        if(EQU_ALU) skip
        goto __is_less_than

    __high_8bit_euqal:
        w = u16_al %% w = u16_bl -w
        if(NOT_MINUS_ALU) skip ;b >= a?
        goto __is_greater_than ;b < a
        if(EQU_ALU) skip
        goto __is_less_than
    __u16_is_equal:
        ; put_char('=')
        SET_U16_EQU
        ret
    __is_greater_than:
        ; put_char('>')
        SET_U16_BIG
        ret
    __is_less_than:
        ; put_char('<')
        SET_U16_LESS
        ret
