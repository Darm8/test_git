//*INDENT-OFF*
#include "mult.h"

#define psr_adr psr

;======================================
;除法结果保存在 div_bh div_bl
;======================================
    .global div_32x16
div_32x16:
    ;w = 0                       ;movw	#0
	;[div_cl] -= w               ;sub		div_cl
    ;if(EQU_ALU) skip       ;btbn	psr_adr, 7
	data_is_zero_skip([div_cl])
    goto	div_32x16_start
	;w = 0                       ;movw	#0
	;[div_ch] -= w               ;sub		div_ch
	;if(NOT_EQU_ALU) skip       ;btbz	psr_adr, 7
	data_not_zero_skip([div_ch])
    goto	div_32x16_error

div_32x16_start:
	; w = 0                       ;movw	#0
	[remainder_h3] = 0          ;mov		remainder_h3
	[remainder_h2] = 0          ;mov		remainder_h2
	[remainder_h] = 0          ;mov		remainder_h
	[remainder_l] = 0           ;mov		remainder_l

	w = 32                      ;movw	#32
	[multdiv_cnt] = w           ;mov		multdiv_cnt
div_32x16_loop:
	[psr].5 = 0                 ;bc		psr_adr, 5
	[div_bl] = {[div_bl], c} << 1            ;rl		div_bl
    [div_bh] = {[div_bh], c} << 1            ;rl		div_bh
	[div_bh2] = {[div_bh2], c} << 1          ;rl		div_bh2
	[div_bh3] = {[div_bh3], c} << 1          ;rl		div_bh3
	[remainder_l] = {[remainder_l], c} << 1      ;rl		remainder_l
	[remainder_h] = {[remainder_h], c} << 1      ;rl		remainder_h
	[remainder_h2] = {[remainder_h2], c} << 1    ;rl		remainder_h2
	[remainder_h3] = {[remainder_h3], c} << 1    ;rl		remainder_h3

	w = [div_cl]                                ;movw	div_cl
	w = [remainder_l] - w       ;subw	remainder_l
	w = [div_ch]                ;movw	div_ch
	w = [remainder_h] - w - C   ;sbcw	remainder_h
    w = 0	                    ;movw	#0
	w = [remainder_h2] - w - C  ;sbcw	remainder_h2
	w = 0                       ;movw	#0
	w = [remainder_h3] - w - C  ;sbcw	remainder_h3

	if([psr].3 == 1) skip       ;btbn	psr_adr, 3
	goto	div_32x16_set1
div_32x16_set0:
	[div_bl].0 = 0              ;bc		div_bl,0
	goto	div_32x16_next

div_32x16_set1:
	w = [div_cl]                ;movw	div_cl
	[remainder_l] -= w          ;sub		remainder_l
	w = [div_ch]                ;movw	div_ch
	[remainder_h] -= w + C      ;sbc		remainder_h
	w = 0                       ;movw	#0
	[remainder_h2] -= w + C     ;sbc 	remainder_h2
	w = 0                       ;movw	#0
	[remainder_h3] -= w + C     ;sbc 	remainder_h3

	[div_bl].0 = 1              ;bs		div_bl,0
	goto	div_32x16_next
div_32x16_next:
	if(--[multdiv_cnt] == 0) skip   ;decbz	multdiv_cnt
	goto	div_32x16_loop
	ret

div_32x16_error:
	; w = 0           ;movw	#0
	[div_bl]  = 0   ;mov		div_bl
	[div_bh]  = 0   ;mov		div_bh
	[div_bh2] = 0   ;mov		div_bh2
	[div_bh3] = 0   ;mov		div_bh3

	;movw	#0xee
	;mov		sdata
	;call	send_data
	ret
