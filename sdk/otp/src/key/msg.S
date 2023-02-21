//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : msg.S
  By   : XXX
  date : 2019-04-26
********************************************************************************************/
#include "cpu.h"
#include "msg.h"
#include "uart.h"

#if 0
/*****************************************
*  used     :  w,tr0
*  函数原型 :  void put_msg(u8 msg)
*  msg      : w
*****************************************/
    .global put_msg
put_msg:
        [tr0] = w
        //wrt_mem(indp_con,0)
        w = [a_msg_write] %% w += a_msg_pool
        //call debug_u8
        [indp0] = w
        w = [tr0] %% [cindr0] = w
        //w = 0x5a %% [cindr0] = w
__loop_xx:
    //goto __loop_xx
        [a_msg_write]++
        w = MAX_MSG_POOL; %% w = [a_msg_write] - w
        ;if(NOT_EQU_ALU) skip
        dw_not_equ_skip([a_msg_write])
        [a_msg_write] = 0
        ret
/*****************************************
*  used     :  w , tr0
*  函数原型 :  u8 get_msg(void)
*  return   :  w
*****************************************/
    .global get_msg
get_msg:
        //w = [a_msg_write] %% call debug_char
        //w = [a_msg_read] %% call debug_char
        //w = 'x' %% call debug_char

        w = [a_msg_write] ;%% w = [a_msg_read] - w
        ;if(EQU_ALU) skip
        dw_is_equ_skip([a_msg_read])
        goto __get_msg
        //put_char('x')
        w = NO_MSG
        [tr0] = w
        ret
    __get_msg:
        //put_char('y')
//        wrt_mem(indp_con,0)
        //w = 'x' %% call debug_char
        w = [a_msg_read] %% w += a_msg_pool
        [indp0] = w
        w = [cindr0]
        [tr0] = w
        [a_msg_read]++
        w = MAX_MSG_POOL ;%% w = [a_msg_read] - w
        ;if(NOT_EQU_ALU) skip
        dw_not_equ_skip([a_msg_read])
        [a_msg_read] = 0
        w = [tr0]
        ret

/*****************************************
*  used     :  w
*  函数原型 :  void flush_all_msg(void)
*****************************************/
    .global flush_all_msg
flush_all_msg:
        [a_msg_read] = 0
        [a_msg_write] = 0
        indr0_inc(a_msg_pool)
        w = MAX_MSG_POOL %% [tr0] = w
    __clr_msg_pool:
        ; put_u8([tr0])
        indr0 = NO_MSG ; w = NO_MSG %% [cindr0] = W
        if(--[tr0] == 0) skip
        goto __clr_msg_pool
        //wrt_mem(indp_con,0)
        ret








#endif


