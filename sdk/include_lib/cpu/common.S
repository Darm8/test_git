//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : common.S
  By   : XXX
  date : 2020-05-19
********************************************************************************************/

.macro loa_ear_ex_start
        put_char_n('Y')
        [a_loa_allow_vout01_cnt] = 0

        ; w = EAR_EX_STATUS_NULL
        ; dw_is_equ_skip([a_ear_ex_status])
        dk_is_zero_skip([a_ear_ex_status], EAR_EX_STATUS_NULL)
        goto __loa_ear_ex_start_end

        w = EAR_EX_STATUS_START %% [a_ear_ex_status] = w
        call led_ear_ex_start

    __loa_ear_ex_start_end:
.endm

.macro loa_ear_ex_ing
        put_char_n('Z')
        [a_loa_allow_vout01_cnt] = 0
        w = EAR_EX_STATUS_START
        dw_is_equ_skip([a_ear_ex_status])
        goto __loa_ear_ex_ing_end
        w = EAR_EX_STATUS_ING %% [a_ear_ex_status] = w
        call led_ear_ex_ing
    __loa_ear_ex_ing_end:
.endm

.macro loa_ear_ex_end
        put_char_n('Q')
        [a_loa_allow_vout01_cnt] = 0
        ; w = EAR_EX_STATUS_ING
        ; dw_not_equ_skip([a_ear_ex_status])
        ; goto __loa_ear_ex_end_end
        w = EAR_EX_STATUS_START
        dw_is_equ_skip([a_ear_ex_status])
        goto __loa_ear_ex_end_end
        call led_ear_ex_exit ;//call led_ear_ex_end
        [a_ear_ex_status] = EAR_EX_STATUS_NULL ; w = EAR_EX_STATUS_NULL %% [a_ear_ex_status] = w
    __loa_ear_ex_end_end:
.endm

