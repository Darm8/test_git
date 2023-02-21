//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : startup.S
  By   : XXX
  date : 2019-04-19
********************************************************************************************/
#include "cpu.h"
#include "uart.h"
#include "pmu.h"


.macro cpu_int_io index,fun,en
	.extern _fun_\index
	.extern \fun
    .global _int_\index
_int_\index:
.if \en
    pushw
    //GOTO _fun_\index
	call \fun
	popw
	reti
.else
   .short 0x7fff
   .short 0x7fff
   .short 0x7fff
   .short 0x7fff
.endif
.endm

.macro cpu_int_fun index,fun
    .extern \fun
	.global _fun_\index
_fun_\index:
    //trigger
	CALL \fun
    popw
    reti
.endm

.text
    .global _start
    .extern main
    .type _start,@function
_start:
        w = sys_stack
        [sp] = w
        GOTO   _startup

//< 中断入口，不可改变顺序
cpu_int_io INT_TMR0,   tmr0_isr,    1
cpu_int_io INT_TMR1,   tmr1_isr,    0
cpu_int_io INT_SARADC, saradc_isr,  0
cpu_int_io INT_LVD,    lvd_isr,     0
cpu_int_io INT_WDT,    wdt_isr,     0
cpu_int_io INT_PORT,   port_isr,    0
cpu_int_io INT_PMU,    pmu_isr,     0
cpu_int_io INT_CHG,    chg_isr,     0
cpu_int_io INT_UART0,  ut0_isr,     0
cpu_int_io INT_UART1,  chg_ut_isr,  0




    .extern clock_init
.section .text
    .align 2
    .global _startup
    .type _startup,@function
_startup:

        boost_pon_tst = 0
		; boost_non_tst = 0

        CALL clock_init
        call burn_func

        CALL lvd_init

        call pro_operation
        [TR0] = 0
        indr0_inc(4)
__clear_data_ram:
        indr0 = 0  ; //[cindr0] = 0
        [TR0]++
        w = (a_keep_ram - 4); %% w = [tr0] - w
        dw_is_equ_skip([tr0])
        goto __clear_data_ram

        GOTO main






