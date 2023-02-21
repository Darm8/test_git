//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : playform.S
  By   : XXX
  date : 2020-01-13
********************************************************************************************/
#ifdef F96

#warning 这是F95,不是F96!!!

#endif


.macro isr_push_psr

.endm

.macro isr_pop_psr

.endm

.macro set_ut1_baud bh,bl
	     w = [\bh]
         [uart1_baud1] = w
         w = [\bl]
         [uart1_baud0] = w
.endm

.macro set_ut0_baud bh,bl
	     w = [\bh]
         [uart0_baud0] = w
         w = [\bl]
         [uart0_baud1] = w
.endm

; .macro set_w_ut_baud_h
        ; [deg_baud1] = w
; .endm

; .macro set_w_ut_baud_l
        ; [deg_baud0] = w
; .endm

#define set_w_ut_baud_h  [deg_baud1] = w
#define set_w_ut_baud_l  [deg_baud0] = w


#define  if_zero_skip(n)  \
	     w = 0 %% w = n - w %%\
         if(EQU_ALU) skip


#define if_not_zero_skip(n) \
	     w = 0 %% w = n - w %%\
         if(NOT_EQU_ALU) skip

#define if_w_equ_skip(ram) \
        w = [ram] - w     %%\
        if(EQU_ALU) skip

#define if_w_not_equ_skip(ram)   \
        w = [ram] - w          %%\
        if(NOT_EQU_ALU) skip


.macro ram_jmp_push_psr
	     PUSH  [psr]
.endm

