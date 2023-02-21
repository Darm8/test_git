//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : key.S
  By   : XXX
  date : 2019-04-26
********************************************************************************************/
#include "cpu.h"
#include "key.h"
#include "uart.h"
#include "io.h"

#define KEY_DEBUG  0//UT_DEBUG_EN

#if KEY_DEBUG

#define key_deg_char        put_char
#define key_deg_char_n      put_char_n
#define key_deg_u8          put_u8
#define key_deg_u8_n        put_u8_n
#else

#define key_deg_char(...)
#define key_deg_char_n(...)
#define key_deg_u8(...)
#define key_deg_u8_n(...)
#endif

#if 1

    .global key_init
key_init:
        [a_key_cnt] = 0
        [a_old_key] = 0
        w = 0xff
        [a_used_key] = w
        [a_last_key] = w
		[a_key_press_cnt] = 0
        key_io_init
        ret
    .global read_io_key
read_io_key:
        w = NO_KEY
    #if (WIRELESS_POWER_EN == 1) && (IDE_DEBUG_IO == 1)

    #else
        if(key_io_off) skip
        w = KEY_0
    #endif
        ret
/*
used TR0
*/
	.global key_filter
key_filter:
		[TR0] = w
		;W = [a_old_key] - W
		;if (NOT_EQU_ALU) skip
		dw_not_equ_skip([a_old_key])
        goto __key_cnt_plus
		[a_key_cnt] = 0
		w =[TR0] %% [a_old_key] = w
		goto __key_filter_ret
	__key_cnt_plus:
		[a_key_cnt]++
		w = KEY_BASE_CNT ;%%w = [a_key_cnt] - w
        ;if(EQU_ALU) skip
		dw_is_equ_skip([a_key_cnt])
		goto __key_filter_ret
 		w = [tr0] %%[a_used_key] = w

	__key_filter_ret:
		w = [a_used_key]
		ret

//**********************************
// used TR0, TR1, TR2, TR3
#define t_curr_key       tr1
#define t_back_last_key  tr2
;#define t_key_status     tr3
//**********************************
    .global key_scan
key_scan:
        call read_io_key
        // read_key_vlue
        CALL key_filter
        //PUSHW
        //call debug_u8
        //POPW
        [t_curr_key] = w
        w = [a_last_key] %% [t_back_last_key] = w
        //
        w = [t_curr_key] ;%% w = [a_last_key] - w
        ;if (EQU_ALU) skip
        dw_is_equ_skip([a_last_key])
        goto __key_is_changed
    __key_is_still:
        w = NO_KEY ;%% w = [t_curr_key] - w
        ;if (NOT_EQU_ALU) skip
        dw_not_equ_skip([t_curr_key])
        GOTO __key_scan_over
        //-------------------

        w = 0xff; %% w = [a_key_press_cnt] - w
        ;if (EQU_ALU) skip
        dw_is_equ_skip([a_key_press_cnt])
        [a_key_press_cnt]++
        //-----------------

   __find_base_key:
        w = KEY_1S_CNT; %% w = [a_key_press_cnt] - w
        ;if (NOT_EQU_ALU) skip
        dw_not_equ_skip([a_key_press_cnt])
        a_bit_key0_base = 1

#if KEY_DEBUG
        if(a_bit_key0_base == 1) skip
        goto __find_long_key
        a_bit_key0_base = 0
        key_deg_char('B')
#endif

   __find_long_key:
        w = KEY_LONG_CNT; %% w = [a_key_press_cnt] - w
        ;if (EQU_ALU) skip
        dw_is_equ_skip([a_key_press_cnt])
        GOTO __find_long_key_end
        ;w = KEY_LONG %% [t_key_status] = w
        key_deg_char('L')
        a_bit_key0_long = 1
        goto __find_a_keymsg
    __find_long_key_end:
    //----------------------------------------------------

    __key_is_changed:
        w = [t_curr_key] %% [a_last_key] = w
        w = NO_KEY; %% w = [t_curr_key] - w
        ;if (EQU_ALU) skip
        dw_is_equ_skip([a_last_key])
        goto __no_key_and_reset
        w = KEY_LONG_CNT %% w = [a_key_press_cnt] - w
        if(MINUS_ALU) skip
        goto __key_is_long_up

        w = KEY_1S_CNT %% w = [a_key_press_cnt] - w
        if(MINUS_ALU) skip
        goto __key_is_long_up

        ;goto __no_key_and_reset
        ;w = KEY_SHORT_UP %% [t_key_status] = w
        key_deg_char('S')
        a_bit_key0 = 1
        ret
    __key_is_long_up:
        key_deg_char('U')
        a_bit_key0_long_up = 1
        ;w = KEY_LONG_UP %% [t_key_status] = w
    __find_a_keymsg:
        ;w = [t_back_last_key] %%  w |= [t_key_status]
        ret
    __key_scan_over:
        [a_key_press_cnt] = 0
    __no_key_and_reset:
        ret



#endif







