//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : uart.S
  By   : XXX
  date : 2019-04-19
********************************************************************************************/
#include "cpu.h"
#include "uart.h"
#include "platform.S"
#include "mult.h"


.text
/*
    .align 2
    .global _startup
    .type _startup,@function
*/
#if 1
//io map
#define deg_tx_sel      ut0_tx_sel
#define deg_rx_sel      ut0_rx_sel
//port ab
; #define deg_portab_sel  ut0_portab_enable %% ut0_ios_b
#define deg_portab_sel  ut0_portab_enable %% ut0_ios_a
////
#define deg_con0        uart0_con0
#define deg_con1        uart0_con1
#define deg_baud        uart0_baud
#define deg_baud0       uart0_baud0
#define deg_baud1       uart0_baud1
#define deg_buf         uart0_buf
#define deg_tx_pnd      ut0_tx_pnd
#define deg_tx_clrpnd   ut0_tx_clrpnd
#else
//io map
#define deg_tx_sel      ut1_tx_sel
#define deg_rx_sel      ut1_rx_sel
//port ab
#define deg_portab_sel  ut1_portab_enable %% ut1_ios_b
////
#define deg_con0        uart1_con0
#define deg_con1        uart1_con1
#define deg_baud        uart1_baud
#define deg_baud0       uart1_baud0
#define deg_baud1       uart1_baud1
#define deg_buf         uart1_buf
#define deg_tx_pnd      ut1_tx_pnd
#define deg_tx_clrpnd   ut1_tx_clrpnd
#endif



#if UT_DEBUG_EN


#ifdef F96

    .global set_debug_baud_h
    .global set_debug_baud_l
set_debug_baud_h:
set_debug_baud_l:
        set_w_ut_baud
        ret

#else

    .global set_debug_baud_h
set_debug_baud_h:
        set_w_ut_baud_h
        ret

    .global set_debug_baud_l
set_debug_baud_l:
		set_w_ut_baud_l
        ret
#endif







#if 1
    .global debug_init
debug_init:
        //set tx 2 p01
        deg_tx_sel(p1,6)
        //set rx 2 p02
        deg_rx_sel(p0,7)
        //clr pending
        w = (BIT(4) | BIT(5))
        [deg_con1] = w
	    [deg_con0].0 = 1
        ret
#else
    .global debug_init
debug_init:

        deg_portab_sel ;;ut0_ios_a,  io = p10

        ; [p0_pd].0 = 0 %% [p0_pu].0 = 0 %% [p0_die].0 = 1 %% [p0_dir].0 = 1
        ; //[p0_pd].1 = 0 %% [p0_pu].1 = 0 %% [p0_die].1 = 1 %% [p0_dir].1 = 0
        ; [p0_die].1 = 1 %% [p0_out].1 = 1 %% [p0_dir].1 = 0
        [p1_die].0 = 1 %% [p1_out].0 = 1 %% [p1_dir].0 = 0 %% [p1_pd].0 = 0
        //clr pending

        w = (BIT(4) | BIT(5))
        [deg_con1] = w
	    //baud set
	    //enable uart
	    [deg_con0].0 = 1

        ; trigger
; __ttttt0:
        ; goto __ttttt0
        ret
#endif
////////////////////////////////////////////
    .global debug_char
debug_char:
        [deg_buf] = W
    _debug_char0:
        if(deg_tx_pnd == 1) skip
        GOTO _debug_char0
        deg_tx_clrpnd
    _debug_char1:
        ret
    .global debug_n
debug_n:
        w = 0x0a
        call debug_char
        w = 0x0d
        goto debug_char

#if UT_DEBUG_U8_EN
///////////////////////////////////////////
    .global get_hex_data
get_hex_data:
        w &= 0xf
        [tr0] = w
        w = 0x0a %% w = [tr0] - w
        if(MINUS_ALU) skip
        goto __hex_2_char
    __hex_2_number:
        w = '0'
        goto __get_hex_data_over
    __hex_2_char:
        w = ('A' - 0x0a)
    __get_hex_data_over:
        w += [tr0]
        ret

////////
    .global
debug_u4:
        call get_hex_data
        goto debug_char
#endif
/*
used w tr0
*/
/////////////////////////////////////////
    .global debug_u8
    .global debug_u8_n
#if UT_DEBUG_U8_EN
debug_u8_n:
        call debug_u8
        PUSHW
        put_char(0x0a)
        put_char(0x0d)
        POPW
        ret
debug_u8:
        PUSH [TR0]
        PUSHW
        put_char(' ')
        put_char('0')
        put_char('x')
        POPW
        [TR0] = W
        PUSHW
        W = swap([tr0])
        call debug_u4
        POPW
        call debug_u4
        POP [TR0]
        ret
#else
debug_u8_n:
debug_u8:
        ret
#endif

#define ut_bn_115200      (1152*8/10)
    .global uart_115200
uart_115200:
        w = (ut_bn_115200 >> 8) & 0xff %% [div_ch] = w ;%% put_w_u8()
        w = (ut_bn_115200) & 0xff      %% [div_cl] = w ;%% put_w_u8_n()
        call uart_baud_com
        w = [div_bh]
        call set_debug_baud_h
        w = [div_bl]
        goto set_debug_baud_l


#else

    .global set_debug_baud_h
    .global set_debug_baud_l
set_debug_baud_h:
set_debug_baud_l:
    .global uart_115200
uart_115200:
    .global debug_char
debug_char:
        ret
#endif

