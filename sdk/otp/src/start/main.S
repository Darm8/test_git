//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : main.S
  By   : XXX
  date : 2019-04-19
********************************************************************************************/
//change vout01 detect
#include "cpu.h"
#include "uart.h"
#include "timer.h"
#include "app.h"
#include "detect.h"
#include "pmu.h"
#include "ppm.h"
#include "mult.h"
#include "adc.h"
#include "platform.S"
#include "user_led.h"

#if 0//UT_DEBUG_EN
#define m_deg_char        put_char
#define m_deg_char_n      put_char_n
#define m_deg_u8          put_u8
#define m_deg_u8_n        put_u8_n
#else

#define m_deg_char(...)
#define m_deg_char_n(...)
#define m_deg_u8(...)
#define m_deg_u8_n(...)
#endif

.text

    .global sys_mode_sel
sys_mode_sel:
        sys_mode_api()
        ret

    .global sys_info_init
sys_info_init:
        [a_ear0_power] = 0
        [a_ear1_power] = 0
        b_bit_ear0_full = 0
        b_bit_ear1_full = 0
        [a_vout01_offline_cnt] = 0
        goto sys_mode_sel
//----------------------------------------

//isr
    .global tmr0_isr
tmr0_isr:
        isr_push_psr
        PUSH [indp_con]
        PUSH [indp0]


        PUSH [TR0]
        PUSH [TR1]
        PUSH [TR2]
        PUSH [TR3]

        [tmr0_con0].6 = 1

        [a_tmr_cnt]++



    __tmr0_evt_512ms:
        data_is_zero_skip([a_tmr_cnt])
        goto __tmr0_evt_512ms_end
        a_evt_512ms = 1
        w = 2
        dw_is_equ_skip([a_tmr_1s_cnt])
        goto __5s_detect
        [a_tmr_1s_cnt] = 0
        a_evt_1s = 1
        ; put_char('1')
        if(power_on_flag == 1)skip
        goto __5s_detect
        if(low_power_flag == 0)skip
        call led_timer_deal
    __5s_detect:
        w = 8;11 
        dw_is_equ_skip([a_tmr_5s_cnt])
        goto __tmr0_evt_5s_end
        [a_tmr_5s_cnt] = 0
        a_evt_5s = 1
        ; put_char('5')
        if(power_on_flag == 1)skip
        goto __tmr0_evt_5s_end
        call V_mode_detect
        call get_voltage_final

    __tmr0_evt_5s_end:
        [a_tmr_5s_cnt]++
        
    ; __tmr0_evt_1s_end:
        [a_tmr_1s_cnt]++

    __tmr0_evt_512ms_end:

        w = (~0x80) & 0xff  %% w &= [a_tmr_cnt]; & w
        if(ALU_NOT_ZERO) skip
        a_evt_256ms = 1
    __tmr0_evt_256ms_end:


    __tmr0_isr_1:
        w = 0x7 %% [tr0] = w %% w &= [a_tmr_cnt]

        dw_is_equ_skip([tr0])
        GOTO __tmr0_isr_0
    __tmr0_isr_8cnt:

    __tmr0_isr_0:
    __tmr0_isr_010:

        POP [TR3]
        POP [TR2]
        POP [TR1]
        POP [TR0]
    __pop_for_isr_comm:  //公共使用，不可改变顺序
        POP [indp0]
        POP [indp_con]
        isr_pop_psr
        ret

    .global __pop_for_isr_comm



#if 0
    .global sys_clk_2_p14
sys_clk_2_p14:
        [iomc2].3 = 0
        [iomc2].2 = 1   //sys_clk ----> out ch1
        output_map(ch1, p1, 4)
        ret
#endif
//----------------------------------------------
#if WIRELESS_POWER_EN
.macro main_wpr_init
        call wireless_open_api
.endm

.macro main_wpr_keep
        if(b_wpr_online == 0) skip
        goto __main_wpr_online
    __main_wpr_offline:
        call wireless_close_api
        goto __main_wpr_end
    __main_wpr_online:
        a_evt_wpr_online = 0
        call wireless_100ms_run
    __main_wpr_end:
.endm

#else

.macro main_wpr_init
.endm

.macro main_wpr_keep
.endm

#endif


    .global main
main:

#if IDE_DEBUG_IO
        //just for ide
        w = 0x0c %% [rst_con] = w
        [rst_con].0 = 0 ;长按复位使能
        ; w = 0b11110111 %% [pwr_con] &= W
        
#else
        ; [rst_con].4 = 0 ;mclr_en
        ; [rst_con].3 = 1 ;长按复位8秒
        ; [rst_con].2 = 1
        ; [rst_con].1 = 0 ;低电平有效
        ; [rst_con].0 = 1 ;长按复位使能
        ; w = 0x0d %% [rst_con] = w
        w = 0x0c %% [rst_con] = w
        [rst_con].0 = 0 ;长按复位使能

        ; [p0_die].6 = 1
        ; [p0_dir].6 = 1
        ; [p0_pu].6 = 1
        ; [p0_pd].6 = 0
        ; [iomc1].3 = 0 ;选择p06引脚
        ; [iomc1].2 = 1
        ; [iomc1].1 = 1
        ; [iomc1].0 = 0
#endif

        lvd_clr_pnd = 1

#if WDT_EN
        //4s
        w = 0x5d %% [wdt_con] = w
#endif

        [p1_pd].0 = 0
        put_uart_init()
        put_u8_n([rst_src])  ;; bit0(POR) 1(LVD) 3(PINR) 4(WDT) 5(SOFT)

        UART_POWER_UP

        power_on_flag = 0
        CALL tmr0_int

        set_ea;开中断
        delay_ms(50)

        put_char_n('S')
        ; user2.14 ----- 
        call V_mode_detect_io_init
        call vlotage_detect_io_init
        ; call led_level_1
        call led_io_init
        call power_on_led

     __die_here:
    ;  put_char('a')
        ; call led_level_3
        [wdt_con].6 = 1
        goto __die_here

    .global chg_iline_set
    .global wpr_4k
    .global chg_vol_set_for_burn
    .global ppm_2000
chg_iline_set:
chg_vol_set_for_burn:
wpr_4k:
ppm_2000:
        ret







