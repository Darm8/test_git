//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : cpu.h
  By   : XXX
  date : 2019-04-26
********************************************************************************************/
#ifndef __CPU_H__
#define __CPU_H__
#include "f96.h"
#include "my_macro.h"
#include "io.h"

#define BIT(n)  (1L<<n)
//#define SYS_CLK  8000000
//#define UART_CLK  32000000
//#define SRC_CLK  26070000
#define SRC_CLK  32000000
#define SYS_CLK  (SRC_CLK/2)
#define UART_CLK (SRC_CLK/2)

#define TIMER_SHUT_DOWN  50


#define wrt_mem(d,k) w = k %% [d] = w
//isr向量表
#define INT_TMR0           0
#define INT_TMR1           1
#define INT_SARADC         2
#define INT_LVD            3
#define INT_WDT            4
#define INT_PORT           5
#define INT_PMU            6
#define INT_CHG            7
#define INT_UART0          8
#define INT_UART1          9

///
#define ea        [psr].0
#define CY        [psr].5
#define set_ea    [psr].0 = 1 %% nop
#define clr_ea    [psr].0 = 0

#define clr_ie0(n)  bc ie0, n
#define clr_ie1(n)  bc ie1, n
#define set_ie0(n)  bs ie0, n
#define set_ie1(n)  bs ie1, n

#define clr_ip0(n)  bc ip0, n
#define clr_ip1(n)  bc ip1, n
#define set_ip0(n)  bs ip0, n
#define set_ip1(n)  bs ip1, n

#define enter_high_ram   // [psr].2 = 1
#define exit_high_ram    // [psr].2 = 0 #define enter_high_sfr   // [psr].1 = 1
#define exit_high_sfr    // [psr].1 = 0

//负数
#define MINUS_ALU        [psr].5 == 1
#define NOT_MINUS_ALU    [psr].5 == 0
//相等
#define EQU_ALU          [psr].7 == 1
#define NOT_EQU_ALU      [psr].7 == 0

#define ALU_IS_ZERO      [psr].7 == 1
#define ALU_NOT_ZERO     [psr].7 == 0

#define data_is_zero_skip(d)    if(d == 0) skip
#define data_not_zero_skip(d)   if(d != 0) skip

#define dk_is_zero_skip(d,k)    if(d == k) skip
#define dk_not_zero_skip(d,k)   if(d != k) skip

#define dw_is_equ_skip(d)     if(d == w) skip
#define dw_not_equ_skip(d)    if(d != w) skip

//变量列表
//虚拟R寄存器段
#define TR0    0
#define TR1    1
#define TR2    2
#define TR3    3

#define tr0    0
#define tr1    1
#define tr2    2
#define tr3    3

//bit
#define a_bit_zone         4
#define b_ppm_succ             [4].0 //PPM握手成功标记，ppm_lib使用
#if HALL_EN
#define a_bit_hall_online      [4].1 //HALL传感器在线标记，没有被库用到
#endif
//#define a_bit       [4].2
#define b_force_charge         [4].2

#define b_vbat_full            [4].3 //电池满电标记。没有被库用到
#define a_bit_led0_on          [4].4    //led控制变量，没有被库用到
#define a_bit_led0_flash       [4].5    //led控制变量，没有被库用到
#define a_bit_led1_on          [4].6    //led控制变量，没有被库用到
#define a_bit_led1_flash       [4].7    //led控制变量，没有被库用到
//----------------------------------
#define a_bit_led2_on          [5].0    //led控制变量，没有被库用到
#define a_bit_led2_flash       [5].1    //led控制变量，没有被库用到
#define b_bit_goto_sleep       [5].2    //休眠控制变量，没有被库用到
#define a_bit_ear0_enable      [5].3    //led控制变量，没有被库用到
#define a_bit_ear1_enable      [5].4    //led控制变量，没有被库用到
// #define a_bit_chg_ut_crc_err   [5].5
#define a_evt_wpr_offline      [5].5    //无线充离线标记，没有被库用到
//#define a_bit              [5].6
#if IIR_EN
#define a_bit_iir              [5].6   //iir滤波变量，没有被库用到
#endif
#define a_bit_vbat_full        [5].7   //满电标记，没有被库用到
//byte
#if HALL_EN
#define a_hall_cnt         6     //hall检测变量，没有被库用到    //
#endif
#define a_tmr_cnt          7     //系统节拍变量，没有被库使用到
#define a_key_cnt          8     //按键检测变量，没有被库使用到
#define a_old_key          9     //按键检测变量，没有被库使用到
#define a_used_key         10     //按键检测变量，没有被库使用到
#define a_last_key         11     //按键检测变量，没有被库使用到
#define a_key_press_cnt    12     //按键检测变量，没有被库使用到

#define a_led0_flash_cnt   13    //led控制变量，没有被库用到
#define a_led0_on_cnt      14    //led控制变量，没有被库用到
#define a_led1_flash_cnt   15    //led控制变量，没有被库用到
#define a_led1_on_cnt      16    //led控制变量，没有被库用到
#define a_led2_flash_cnt   17    //led控制变量，没有被库用到
#define a_led2_on_cnt      18    //led控制变量，没有被库用到


// #define a_key_delay_cnt    11
// #define a_key_dblclick     12

// #define FRIST_MSG_RAM      11
// #define a_msg_write        11
// #define a_msg_read         12
// #define a_msg_pool         13
// #define MAX_MSG_POOL       5
// #define LAT_MSG_RAM        17



#define a_sys_mode         19      //系统工作模式，没有被库用到
#define a_sys_event        20       //系统事件
#define a_evt_ear0_insert     [a_sys_event].0      //耳机事件，库使用到，不可变动
#define a_evt_ear0_pullout    [a_sys_event].1      //耳机事件，库使用到，不可变动
#define a_evt_ear1_insert     [a_sys_event].2      //耳机事件，库使用到，不可变动
#define a_evt_ear1_pullout    [a_sys_event].3      //耳机事件，库使用到，不可变动
#define is_ear_changed()      w = 0x0f %%  w &= [a_sys_event]
#define clr_ear_evt()         w = 0xf0 %% [a_sys_event] &= w

#define a_evt_usb_insert      [a_sys_event].4      //外接电源事件，库使用到，不可变动
#define a_evt_usb_pullout     [a_sys_event].5      //外接电源事件，库使用到，不可变动
#if HALL_EN
#define a_evt_hall_change     [a_sys_event].6      //hall事件，没有被库使用到
#endif
#define a_evt_256ms           [a_sys_event].7      //256ms事件，没有被库使用到
#define a_sys_event_1       21
#define a_evt_512ms           [a_sys_event_1].0    //512ms事件，没有被库使用到
#define a_evt_vbat_full       [a_sys_event_1].1    //充电仓电池满电标记，没有被库使用到
#define a_evt_vbat_lowpower   [a_sys_event_1].2    //充电仓低电事件，没有被库使用到
//#define a_bit          [a_sys_event_1].3
#define a_evt_led_finish      [a_sys_event_1].4    //led结束事件，没有被库调用到
#define a_evt_5s              [a_sys_event_1].5    //5秒事件，没有被酷调用到
#define a_evt_wpr_online      [a_sys_event_1].6    //无线充在线状态，没有被库时用到
#define a_evt_100ms           [a_sys_event_1].7    //100mS事件，没有被库使用到

#define a_vout01_offline_cnt  22        //左右耳全部离线计数，没有被库是用到
#define a_led_ui              23        //led亮灯UI

#define a_tmr_5s_cnt          24        //5S计数，没有被库使用到
#define a_wpr_cnt          25           //无线充变量，库没有直接使用到
#define a_last_vbat_power  26           //电池电量检测变量，库没有直接使用到
#define a_ear0_power       27           //耳机0的电量，库有使用到，不可变动
#define a_ear1_power       28           //耳机1的电量，库有使用到，不可变动
#define a_vbat_power       29           //充电仓的电量，库有使用到，不可变动

//lid open app
#define a_loa_allow_vout01_cnt  30      //开盖模式下允许充电计数，库没有直接使用到
//

#if IIR_EN == 0
#define a_ibuck_cnt        31           //开关充状态计数，库没有直接使用到
#define a_ibuck_full_cnt   32           //开关充状态计数，库没有直接使用到
#else
#define a_last_flth        31           //iir滤波变量，库没有直接使用到
#define a_last_fltl        32           //iir滤波变量，库没有直接使用到
#endif
#define a_vbat_chg_cnt     33           //iir滤波变量，库没有使用到
#define a_vout0_online_cnt 34           //耳机0检测变量，库有使用，不可变动
#define a_vout1_online_cnt 35           //耳机1检测变量，库有使用，不可变动

#define a_vout_ov_cnt      36           //vout过压变量，库有使用，不可变动
#define a_close_cnt        37           //关盖命令计数，库没有直接使用到
#define a_shut0_cnt        38           //关机命令包计数，库没有直接使用到
#define a_shut1_cnt        39           //关机命令包计数，库没有直接使用到

#define a_detect_status    40
#define b_bit_allow_vout0  [a_detect_status].0   //耳机0开电允许位，库有使用到，不可变动
#define b_bit_allow_vout1  [a_detect_status].1   //耳机1开电允许位，库有使用到，不可变动
#define b_bit_ear0_full    [a_detect_status].2   //耳机0满电标记，库有使用到，不可变动
#define b_bit_ear1_full    [a_detect_status].3   //耳机0满电标记，库有使用到，不可变动
#define a_bit_key0         [a_detect_status].4   //按键变量，库没有直接使用到
#define a_bit_key0_base    [a_detect_status].5   //按键变量，库没有直接使用到
#define a_bit_key0_long    [a_detect_status].6   //按键变量，库没有直接使用到
#define a_bit_key0_long_up [a_detect_status].7   //按键变量，库没有直接使用到

#define a_ear_ex_status    41                    // 库变量，不可变动
// #define a_ldo_trim_bg_cnt  42
#define a_vout_retry_cnt   42                    // 危险信号消除变量，没有被库直接调用
#define a_vbat_full_cnt    43                    // 满电标记，没有被库直接调用

#if (HALL_EN == 0)
    #define a_ear0_close_cnt   44               //耳机命令包计数，没有被库直接调用
    #define a_ear1_close_cnt   45               //耳机命令包计数，没有被库直接调用
#endif

#define a_bit_zone2           46
#if ENCRYPT_EN
#define b_send_encrypt        [46].0           //库变量，不可变动
#define b_receive_encrypt     [46].1           //库变量，不可变动
#define b_encrypt_not_first   [46].2           //库变量，不可变动
#endif
#define b_adc_busy            [46].3
#define b_wpr_online          [46].4 //PMU库会使用到，没有无线充也不能删除即使
#define b_dcdc_enable         [46].5
#define b_wireless_open       [46].6
#define b_wireless_flag       [46].7

#define   a_key_source      47           //库变量，不可变动
#define   a_key_u8          48           //库变量，不可变动

#define a_ppm_rcnt         49 //库变量，不可变动
#define a_ppm_step         50 //库变量，不可变动
#define a_ppm_div          51 //库变量，不可变动

#define a_ppm_buf          a_chg_buf
#define MAX_PPM_POOL       8

#define a_wpr_buf          52           //库变量，不可变动
#define a_chg_rev_cnt      52 //库变量，不可变动
#define a_chg_rev_case     53 //库变量，不可变动
#define a_chg_rev_len      54 //库变量，不可变动
#define a_chg_buf          55 //库变量，不可变动
#define a_chg_buf0         56 //库变量，不可变动
#define a_chg_buf1         57 //库变量，不可变动
#define a_chg_buf2         58 //库变量，不可变动
#define a_chg_buf3         59 //库变量，不可变动
#define a_chg_buf4         60 //库变量，不可变动
#define a_chg_buf5         61 //库变量，不可变动
#define a_chg_buf6         62 //库变量，不可变动
#define a_chg_buf7         63 //库变量，不可变动
#define a_chg_buf8         64 //库变量，不可变动


#define a_pmu_status0     65

#define b_vbat_boost_on      [a_pmu_status0].0 //库变量，不可变动
#define b_vcc_bypass_on      [a_pmu_status0].2 //库变量，不可变动
#define b_vout_2_vbat_on     [a_pmu_status0].3 //库变量，不可变动
#define b_vout0_load_on      [a_pmu_status0].4 //库变量，不可变动
#define b_vout1_load_on      [a_pmu_status0].5 //库变量，不可变动
#define b_disable_vout0      [a_pmu_status0].7 //库变量，不可变动

#define b_vout_power_read()  w = [a_pmu_status0] %% w &= 0x0f
// #define b_vout_power_read()  w = [a_pmu_status0] %% w &= 0x0f

//#define b_power_2_vout01_on  [a_pmu_status0].6
//#define b_vcc_2_vbat_on      [a_pmu_status0].7

#define a_pmu_status1     66
#define b_vcc_online         [a_pmu_status1].0 //库变量，不可变动
#define b_vout_online        [a_pmu_status1].1 //库变量，不可变动
#define b_vout0_online       [a_pmu_status1].2 //库变量，不可变动
#define b_vout1_online       [a_pmu_status1].3 //库变量，不可变动
#define b_ot_case_ot60145    [a_pmu_status1].4 //库变量，不可变动
// #define b_ot_power_dis       [a_pmu_status1].5
#define b_disable_vout1      [a_pmu_status1].5 //库变量，不可变动
#define b_vbat_lowpower         [a_pmu_status1].6 //库变量，不可变动
#define b_vout_short_v          [a_pmu_status1].7 //库变量，不可变动

#define a_pmu_status2     67
#define b_vout_short_b       [a_pmu_status2].0 //库变量，不可变动
#define b_vout_ov            [a_pmu_status2].1 //库变量，不可变动
#define b_vcc_ov             [a_pmu_status2].2 //库变量，不可变动
#define b_vcc_uv             [a_pmu_status2].3 //库变量，不可变动
#define b_ot_60              [a_pmu_status2].4 //库变量，不可变动
#define b_ot_145             [a_pmu_status2].5 //库变量，不可变动
#define b_vbat_ov            [a_pmu_status2].6 //库变量，不可变动
#define b_vbat_uv            [a_pmu_status2].7 //库变量，不可变动

//#define a_pmu_test        68
#define a_err_packet_fast_cnt    68 //库变量，不可变动
#define a_vcc_ov_cnt      69 //库变量，不可变动
#define a_vbat_ov_cnt     70 //库变量，不可变动

//#define a_vcc_online_cnt  71

#define a_wireless_err_cnt  71  //库变量，不可变动
#define a_100ms_cnt         72  //100ms计数，没有被库直接调用
#define a_power_acc_h       73  //无线充变量，没有被库直接调用
#define a_power_acc_l       74  //无线充变量，没有被库直接调用
#define a_power_acc_cnt     75  //无线充变量，没有被库直接调用
#define a_ear_fail_cnt      76

#define a_led0_duty         77
#define a_led1_duty         78
#define a_led2_duty         79


/***********************************************************
 * 警告！！！
 * 从a_keep_ram开始以后的变量去不可使用，不可变动！！！！
 **********************************************************/
#define a_keep_ram         80
#define a_keep_chg_bit     80
// #define a_chg_iline_s0   [a_chg_bit].5
// #define a_chg_iline_s1   [a_chg_bit].6
// #define a_chg_iline_s2   [a_chg_bit].7
#define a_keep_1_2ms       81
#define a_keep_trim_bg     82
#define a_ut_9600_baud_h   83
#define a_ut_9600_baud_l   84
#define a_vbg_vol_h        85
#define a_vbg_vol_l        86
#define a_src_clk_h        87
#define a_src_clk_l        88
#define sys_stack          90

#define ppm_port           89
#define b_ppm_port_sel     [ppm_port].0

// #define case_jmp(curr,next) \
        // w = curr %% \
        // w = [tr0] - W %% \
        // if(EQU_ALU) skip %% \
        // GOTO next

#define case_jmp(curr,next) \
        w = curr %% \
        dw_is_equ_skip([tr0]) \
        GOTO next

//#define indr0_inc(addr) \
//        w = 1 %% [indp_con] = w %% \
//        w = addr %% [indp0] = w






#define SYS_VERSION    BIT(4)

#define POWER_TOP_LVL       4100L
#define POWER_BOOT_LVL      3200L

#define EAR_EX_STATUS_NULL  0
#define EAR_EX_STATUS_START 1
#define EAR_EX_STATUS_ING   2

#endif


