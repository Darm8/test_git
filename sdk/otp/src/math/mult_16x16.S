//*INDENT-OFF*
#include "cpu.h"
#include "mult.h"

    .global _mult_16x16
_mult_16x16:
	    ;w = 0
		[multiply_b3] = 0
		[multiply_b2] = 0
		[multiply_b1] = 0
		[multiply_b0] = 0
	    w = 16
	    [multdiv_cnt] = w

	mult_16x16_loop:
	    CY = 0
	    [mult_ah] = {c,[mult_ah]} >> 1
	    [mult_al] = {c,[mult_al]} >> 1
	    if(CY == 1) skip
		goto	mult_16x16_nocarry
	    w = [mult_bl]
	    [multiply_b2] += w
	    w = [mult_bh]
	    [multiply_b3] += w + c

	mult_16x16_nocarry:
	    CY = 0
	    [multiply_b3] = {c,[multiply_b3]} >> 1
	    [multiply_b2] = {c,[multiply_b2]} >> 1
	    [multiply_b1] = {c,[multiply_b1]} >> 1
	    [multiply_b0] = {c,[multiply_b0]} >> 1
	    if(--[multdiv_cnt] == 0) skip
		goto    mult_16x16_loop
	    ret

#if WIRELESS_POWER_EN

    .global _mult_8x8
_mult_8x8:
        ; put_u8([mult_a])
        ; put_u8([mult_b])
        [multiply_b1] = 0
        [multiply_b0] = 0
        w = 8
        [multdiv_cnt] = w

    mult_8x8_loop:
        CY = 0
        ; put_u8([mult_a])
        [mult_a] = {c,[mult_a]} >> 1
        if(CY == 1) skip
        goto    mult_8x8_nocarry
        w = [mult_b]
        [multiply_b1] += w
        ; put_char('*')
    mult_8x8_nocarry:
        CY = 0
        [multiply_b1] = {c,[multiply_b1]} >> 1
        [multiply_b0] = {c,[multiply_b0]} >> 1
        if(--[multdiv_cnt] == 0) skip
        goto    mult_8x8_loop
        ret

#endif





