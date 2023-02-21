//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : playform.S
  By   : XXX
  date : 2020-01-13
********************************************************************************************/
#ifdef F95

#warning 这是F96,不是F95!!!

#endif


.macro isr_push_psr
	    push [psr]
.endm

.macro isr_pop_psr
	    pop [psr]
.endm

.macro set_ut0_baud bh,bl
	     w = [\bh]
         [uart0_baud] = w
         w = [\bl]
         [uart0_baud] = w
.endm

.macro set_ut1_baud bh,bl
	     w = [\bh]
         [uart1_baud] = w
         w = [\bl]
         [uart1_baud] = w
.endm

; .macro set_w_ut_baud_h
        ; [deg_baud] = w
; .endm

; .macro set_w_ut_baud_l
        ; [deg_baud] = w
; .endm

#define set_w_ut_baud        [deg_baud] = w


#define if_zero_skip(d)      if(d == 0) skip
#define if_not_zero_skip(d)  if(d != 0) skip

#define  if_w_equ_skip(d)    if([d] == w) skip

#define if_w_not_equ_skip(d)  if([d] != w) skip


.macro ram_jmp_push_psr

.endm




