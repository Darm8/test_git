//*INDENT-OFF*
#ifndef __io_h__
#define __io_h__

#define F96
#include "io_common.h"

#define FPGA                  0
#define IDE_DEBUG_IO          0
#define WDT_EN                1
#define EX_LDO_TIRM_EN        0
// #define PMU_CHG_BUCK          0
// #define IIR_EN                0
#define VOUT_DANGER_MODE      1      //VOUT危险信号清除方式，1：有按键的方案，0：没有按键的方案

// #define HANDSHAKE_EN    1
// #define ENCRYPT_EN          0
// #define WIRELESS_POWER_EN   1

#define VBAT_BYPASS_CODE_LIFE  0
#define BR_LED_EN              0


#if WIRELESS_POWER_EN
#if EX_LDO_TIRM_EN
    #error "WIRELESS POWER can't live together with EX_LDO !!!!!!!!!"
#endif
#endif

// io_debug
#define io_debug(n)  \
        [p0_dir].4 = 0 \
_startup_ ## n :  \
        [p0_out].4 = ![p0_out].4 \
        goto _startup_ ## n


#if WIRELESS_POWER_EN
#define vwp_io_wkup_en()  io_wkup_vwp(ch2, p0, 3, wkup_rise)
#else
#define vwp_io_wkup_en()

#endif



//key io
#define KEY_WKUP_PND      WKUP_CH0_PND

#if IDE_DEBUG_IO

#if (WIRELESS_POWER_EN == 0)
#define key_io_wkup_en()  io_wkup_key(ch0, p1, 6, wkup_fall)
#define key_io_init       [p1_pu].6 = 1 %% [p1_pd].6 = 0 %% [p1_dir].6 = 1 %% [p1_die].6 = 1
// #define key_io_on         [p1_in].6 == 0
#define key_io_off        [p1_in].6 == 1

#else

#define key_io_wkup_en()  //io_wkup_key(ch0, p1, 6, wkup_fall)
#define key_io_init       //[p1_pu].6 = 1 %% [p1_pd].6 = 0 %% [p1_dir].6 = 1 %% [p1_die].6 = 1
// #define key_io_on         [p1_in].6 == 0
#define key_io_off        //[p1_in].6 == 1


#endif

#else

#define key_io_wkup_en()  io_wkup_key(ch0, p0, 6, wkup_fall)
#define key_io_init       [p0_pu].6 = 1 %% [p0_pd].6 = 0 %% [p0_dir].6 = 1 %% [p0_die].6 = 1
// #define key_io_on         [p0_in].6 == 0
#define key_io_off        [p0_in].6 == 1

#endif


#define WPR_PORT_INIT   [p1_dir].6 = 0 %% [p1_hd].6 = 1 %% [iomc0].4 = 1
#define WPR_PORT_OVER   [iomc0].4 = 0 %% [p1_dir].6 = 0 %%  [p1_out].6 = 0 %% [p1_hd].6 = 0

//DCDC io
#if IDE_DEBUG_IO
#define DCDC_IO_H       [p1_dir].7 = 0 %% [p1_out].7 = 1
#define DCDC_IO_L       [p1_dir].7 = 0 %% [p1_out].7 = 0

#else
// #define DCDC_IO_H       [p0_dir].2 = 0 %% [p0_out].2 = 1
// #define DCDC_IO_L       [p0_dir].2 = 0 %% [p0_out].2 = 0

#endif



#if WIRELESS_POWER_EN
#define vwp_ad_io_set()   [p0_dir].3 = 1 %% [p0_die].3 = 0 %% [p0_pu].3 = 0 %% [p0_pd].3 = 1

#else

#define vwp_ad_io_set()

#endif


#if EX_LDO_TIRM_EN

// #define ldo_5s_trim()    call ldo_trim_5s

// #define ex_ldo_en()      call ex_ldo_enable

// #if IDE_DEBUG_IO
// #define ex_ldo_io_set   [p0_dir].3 = 1 %% [p0_die].3 = 0 %% [p0_pu].3 = 0 %% [p0_pd].3 = 1 %% \
                        // [p1_dir].7 = 0 %% [p1_hd].7 = 1 %% [p1_out].7 = 1 %% delay_n(10)
// #define ex_ldo_dis()    [p1_out].7 = 0

// #else
// #define ex_ldo_io_set   [p0_dir].3 = 1 %% [p0_die].3 = 0 %% [p0_pu].3 = 0 %% [p0_pd].3 = 1 %% \
                        // [p0_dir].2 = 0 %% [p0_hd].2 = 1 %% [p0_out].2 = 1 %% delay_n(10)

// #define ex_ldo_dis()    [p0_out].2 = 0

// #endif

#else

#define ldo_5s_trim()

#endif

#if HALL_EN
//hall_detect
//#define hall_io_wkup_en(edge)  io_wkup_key(ch1, p0, 5, edge)
#define hall_io_wkup_en(edge)  call hall_io_wkup_ch1 %%  wkup_ch1(edge)
#define HALL_WKUP_PND      WKUP_CH1_PND

//#define hall_io_init       [p0_pu].5 = 0 %% [p0_pd].5 = 0 %% [p0_dir].5 = 1 %% [p0_die].5 = 1
#define hall_io_set        [p0_pu].5 = 0 %% [p0_pd].5 = 0 %% [p0_dir].5 = 1 %% [p0_die].5 = 1
#define hall_io_online     [p0_in].5 == 1
#define hall_io_offline    [p0_in].5 == 0

#else
#define P05_HR        [p0_pu].5 = 0 %% [p0_pd].5 = 0 %% [p0_dir].5 = 1 %% [p0_die].5 = 0
#endif


// io map input---------------------------------------------------------
#define p0_input_map_bit 0
#define p1_input_map_bit BIT(3)

#define input_map_bit_ch0  ((~0x0f) & 0xff)
#define input_map_bit_ch1  ((~0xf0) & 0xff)
#define input_map_bit_ch2  ((~0x0f) & 0xff)
#define input_map_bit_ch3  ((~0xf0) & 0xff)

#define input_map_rl_ch0   0
#define input_map_rl_ch1   4
#define input_map_rl_ch2   0
#define input_map_rl_ch3   4
#define input_iomc_ch0     iomc1
#define input_iomc_ch1     iomc1
#define input_iomc_ch2     iomc5
#define input_iomc_ch3     iomc5
/* input example:
 * ch:    ch0,ch1.
 * port:  p0,p1.
 * n:     0 ~ 7.
 * use ch0 remapping p12. -->   input_map(ch0, p1, 2)
 */

#define input_map(ch,port,n) \
    w = input_map_bit_ ## ch  %% [input_iomc_ ## ch] &= w %% \
    w = ((n | port ## _input_map_bit) << input_map_rl_ ## ch) %% \
    [input_iomc_ ## ch] |= w   %%\
    bs port ## _dir,n

/*
#define input_map_ch0(port,n) \
    w = 0xf0 %% [iomc1] &= w %% \
    w = (n | port ## _input_map_bit)\
    [iomc1] |= w   %%\
    bs port ## _dir,n

#define input_map_ch1(port,n) \
    w = 0x0f %% [iomc1] &= w %% \
    w = ((n | port ## _input_map_bit) << 4)\
    [iomc1] |= w   %%\
    bs port ## _dir,n
*/

#endif



