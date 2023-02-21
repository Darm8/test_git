#ifndef __PMU_COMMON_H__
#define __PMU_COMMON_H__
#include "cpu.h"
#include "uart.h"


#if UT_DEBUG_EN

#define p_deg_char        put_char
#define p_goto_deg_char   goto_put_char
#define p_deg_char_n      put_char_n
#define p_deg_u8          put_u8
#define p_deg_u8_n        put_u8_n
#define p_goto_deg_n      goto_put_n
#else

#define p_deg_char(...)
#define p_goto_deg_char(...) ret
#define p_deg_char_n(...)
#define p_deg_u8(...)
#define p_deg_u8_n(...)
#define p_goto_deg_n(...) ret
#endif

#define vout_det_sfr(i,n)   vout ## i ##_load_det = n

#define vout0_output_set0() [p1_dir].0 = 0 %% [p1_out].0 = 0
#define vout1_output_set0() [p1_dir].1 = 0 %% [p1_out].1 = 0

#define vout0_input() [p1_dir].0 = 1
#define vout1_input() [p1_dir].1 = 1

#define vout_all_hr()  w = 0x07         %% \
                       [p1_dir] |= w    %% \
                       w = 0xf8         %% \
                       [p1_pu]  &= w    %% \
                       [p1_pd]  &= w    %% \
                       [p1_die] &= w

#if HALL_EN
#define  sleep_wkup_vout_api()
#else
#define  sleep_wkup_vout_api() call sleep_wkup_vout
#endif
#define  ear0_info_init_api()  call ear0_info_init
#define  ear1_info_init_api()  call ear1_info_init

//------------------------------------------------------
#define a_trim_buff   a_chg_buf

#define T_INDEX_RC_L         0
#define T_INDEX_RC_H         1
#define T_INDEX_VBG_VOL_L    2
#define T_INDEX_VBG_VOL_H    3
#define T_INDEX_BG_TM        4
#define T_INDEX_CHG_VOL      5
#define T_INDEX_BOOST_VOUT   6
#define T_INDEX_IBUCK        7

#define T_CHG_VOL_S    a_trim_buff + T_INDEX_CHG_VOL
#define T_CHG_VOL_S3   [a_trim_buff + T_INDEX_CHG_VOL].3
#define T_CHG_VOL_S2   [a_trim_buff + T_INDEX_CHG_VOL].2
#define T_CHG_VOL_S1   [a_trim_buff + T_INDEX_CHG_VOL].1
#define T_CHG_VOL_S0   [a_trim_buff + T_INDEX_CHG_VOL].0

#ifdef F96
#define T_BCHG_VOL_S3   [a_trim_buff + T_INDEX_BOOST_VOUT].3
#define T_BCHG_VOL_S2   [a_trim_buff + T_INDEX_BOOST_VOUT].2
#define T_BCHG_VOL_S1   [a_trim_buff + T_INDEX_BOOST_VOUT].1
#define T_BCHG_VOL_S0   [a_trim_buff + T_INDEX_BOOST_VOUT].0
#endif


#endif
