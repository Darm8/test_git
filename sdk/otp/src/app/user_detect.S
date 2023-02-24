#include "cpu.h"
#include "detect.h"
#include "uart.h"
#include "data_compare.h"
#include "adc.h"
#include "user_led.h"
#include "io.h"

#define detect_mode_is_48v          1
#define detect_mode_is_36v          0
; #define voltage_level               0

    ;检测36v/48v的检测模式
    .global V_mode_detect_io_init   
V_mode_detect_io_init:
    [p0_pd].1 = 0 %% [p0_pu].1 = 1 %% [p0_die].1 = 1 %% [p0_dir].1 = 1  ;P01上拉
    ; [p1_pd].0 = 0 %% [p1_pu].0 = 1 %% [p1_die].0 = 1 %% [p1_dir].0 = 1  ;P10上拉
    ret

    .global vlotage_detect_io_init
vlotage_detect_io_init:
#if IDE_DEBUG_IO
    [p1_pd].3 = 0 %% [p1_pu].3 = 0 %% [p1_die].3 = 0 %% [p1_dir].3 = 1
    [p1_pd].4 = 0 %% [p1_pu].4 = 0 %% [p1_die].4 = 0 %% [p1_dir].4 = 1
    [p1_pd].5 = 0 %% [p1_pu].5 = 0 %% [p1_die].5 = 0 %% [p1_dir].5 = 1
    ; [p0_pd].6 = 0 %% [p0_pu].6 = 0 %% [p0_die].6 = 0 %% [p0_dir].6 = 1
    ; [p0_pd].1 = 0 %% [p0_pu].1 = 0 %% [p0_die].1 = 0 %% [p0_dir].1 = 1
#else
    [p1_pd].3 = 0 %% [p1_pu].3 = 0 %% [p1_die].3 = 0 %% [p1_dir].3 = 1
    [p1_pd].4 = 0 %% [p1_pu].4 = 0 %% [p1_die].4 = 0 %% [p1_dir].4 = 1
    [p1_pd].5 = 0 %% [p1_pu].5 = 0 %% [p1_die].5 = 0 %% [p1_dir].5 = 1
    [p0_pd].6 = 0 %% [p0_pu].6 = 0 %% [p0_die].6 = 0 %% [p0_dir].6 = 1
    ; [p0_pd].1 = 0 %% [p0_pu].1 = 0 %% [p0_die].1 = 0 %% [p0_dir].1 = 1
#endif
    ret

    .global V_mode_detect
V_mode_detect:
    ; V_mode_detect_io_init
    ; put_char('G')

    ; adc_get_voltage(ADC_CH_P01,0)
    ; K_2_U16_B(2000)
    ; call u16_compare
    if([p0_in].1 == 1) skip
    goto _detect_mode_36v
    goto _detect_mode_48v

    _detect_mode_36v:
    detect_mode = detect_mode_is_36v
    put_char('3')
    put_char('6')
    put_char_n('v')
    ret
    _detect_mode_48v:
    detect_mode = detect_mode_is_48v
    put_char('4')
    put_char('8')
    put_char_n('v')
    ret

    .global voltage_cnt_clear
voltage_cnt_clear:
    [voltage_cnt_h] = 0
    [voltage_cnt_l] = 0
    ret

    .global get_voltage_1 ;p13
get_voltage_1:
    adc_get_voltage(ADC_CH_P13,0)
    put_char('1')
    put_char(':')
    put_u8([div_bh])
    put_u8([div_bl])
    ;adc电压结果保留在div_bh、div_bl当中，随后参加下面的除法
    w = 0  %% [div_bh2] = w
    w = 0  %% [div_bh3] = w
    w = 64 %% [div_cl] = w  ;io口电压值除以（4*16），  16是系数，4是取平均
    w = 0  %% [div_ch] = w 
    call div_32x16
    w = [div_bh] %% [mult_ah]=w
    w = [div_bl] %% [mult_al]=w
    w = 0x01     %% [mult_bh]=w
    w = 0x27     %% [mult_bl]=w  ;0x127 = 295
    call _mult_16x16  ;乘系数，结果保留在multiply_b0、multiply_b1
    w = [multiply_b0] %% [voltage_cnt_l] += w 
    w = [multiply_b1] %% [voltage_cnt_h] += w + C ;此时最终的voltage_cnt_l、voltage_cnt_h求和即是最终的结果
    put_u8([voltage_cnt_h])
    put_u8_n([voltage_cnt_l])
    ret
    
    .global get_voltage_2 ;p14
get_voltage_2:
    adc_get_voltage(ADC_CH_P14,0)
    put_char('2')
    put_char(':')
    put_u8([div_bh])
    put_u8([div_bl])
    ;adc电压结果保留在div_bh、div_bl当中，随后参加下面的除法
    w = 0  %% [div_bh2] = w
    w = 0  %% [div_bh3] = w
    w = 68 %% [div_cl] = w  ;io口电压值除以（4*17），  17是系数，4是取平均
    w = 0  %% [div_ch] = w 
    call div_32x16
    w = [div_bh] %% [mult_ah]=w
    w = [div_bl] %% [mult_al]=w
    w = 0x01     %% [mult_bh]=w
    w = 0x27     %% [mult_bl]=w  ;0x127 = 295
    call _mult_16x16  ;乘系数，结果保留在multiply_b0、multiply_b1
    w = [multiply_b0] %% [voltage_cnt_l] += w 
    w = [multiply_b1] %% [voltage_cnt_h] += w + C ;此时最终的voltage_cnt_l、voltage_cnt_h求和即是最终的结果
    put_u8([multiply_b1])
    put_u8_n([multiply_b0])
    if(CY == 0)skip
    put_char('E')
    ret
    
    .global get_voltage_3 ;p15
get_voltage_3:
    adc_get_voltage(ADC_CH_P15,0)
    put_char('3')
    put_char(':')
    put_u8([div_bh])
    put_u8([div_bl])
    ;adc电压结果保留在div_bh、div_bl当中，随后参加下面的除法
    w = 0  %% [div_bh2] = w
    w = 0  %% [div_bh3] = w
    w = 76 %% [div_cl] = w  ;io口电压值除以（4*19），  19是系数，4是取平均
    w = 0  %% [div_ch] = w 
    call div_32x16
    w = [div_bh] %% [mult_ah]=w
    w = [div_bl] %% [mult_al]=w
    w = 0x01     %% [mult_bh]=w
    w = 0x27     %% [mult_bl]=w  ;0x127 = 295
    call _mult_16x16  ;乘系数，结果保留在multiply_b0、multiply_b1
    w = [multiply_b0] %% [voltage_cnt_l] += w 
    w = [multiply_b1] %% [voltage_cnt_h] += w + C ;此时最终的voltage_cnt_l、voltage_cnt_h求和即是最终的结果
    put_u8([multiply_b1])
    put_u8_n([multiply_b0])
    if(CY == 0)skip
    put_char('E')
    ret
    
    .global get_voltage_4 ;p06
get_voltage_4:
#if IDE_DEBUG_IO
    adc_get_voltage(ADC_CH_P15,0)
#else
    adc_get_voltage(ADC_CH_P06,0)
#endif
    put_char('4')
    put_char(':')
    put_u8([div_bh])
    put_u8([div_bl])
    ;adc电压结果保留在div_bh、div_bl当中，随后参加下面的除法
    w = 0  %% [div_bh2] = w
    w = 0  %% [div_bh3] = w
    w = 60 %% [div_cl] = w  ;io口电压值除以（4*15），  15是系数，4是取平均
    w = 0  %% [div_ch] = w 
    call div_32x16
    w = [div_bh] %% [mult_ah]=w
    w = [div_bl] %% [mult_al]=w
    w = 0x01     %% [mult_bh]=w
    w = 0x27     %% [mult_bl]=w  ;0x127 = 295
    call _mult_16x16  ;乘系数，结果保留在multiply_b0、multiply_b1
    w = [multiply_b0] %% [voltage_cnt_l] += w 
    w = [multiply_b1] %% [voltage_cnt_h] += w + C ;此时最终的voltage_cnt_l、voltage_cnt_h求和即是最终的结果
    put_u8([multiply_b1])
    put_u8_n([multiply_b0])
    if(CY == 0)skip
    put_char('E')
    ret

;     .global get_voltage_4 ;p06
; get_voltage_4:
; #if IDE_DEBUG_IO
;     adc_get_voltage(ADC_CH_P15,0)
; #else
;     adc_get_voltage(ADC_CH_P06,0)
; #endif
;     w = [div_bh] %% [mult_ah]=w
;     w = [div_bl] %% [mult_al]=w
;     w = 0x01     %% [mult_bh]=w
;     w = 0x27     %% [mult_bl]=w  ;0x127 = 295
;     call _mult_16x16  ;乘系数，结果保留在multiply_b0、multiply_b1
;     w = 0  %% [div_bh2] = w
;     w = 0  %% [div_bh3] = w
;     w = [multiply_b0] %% [div_bl] = w
;     w = [multiply_b1] %% [div_bh] = w
;     w = 60 %% [div_cl] = w  ;除以（4*15），  15是系数，4是取平均
;     w = 0  %% [div_ch] = w 
;     call div_32x16
;     w = [div_bl] %% [voltage_cnt_l] += w 
;     w = [div_bh] %% [voltage_cnt_h] += w + C
;     put_char('4')
;     put_char(':')
;     put_u8([div_bh])
;     put_u8([div_bl])
;     put_u8([voltage_cnt_h])
;     put_u8_n([voltage_cnt_l])
;     if(CY == 0)skip
;     put_char('E')
;     ret
    
    .global Four_voltage_ptf
Four_voltage_ptf:
    put_char('T')
    put_char('-')
    put_char('V')
    put_char(':')
    ; put_u8([voltage_cnt_h3])
    ; put_u8([voltage_cnt_h2])
    put_u8([voltage_cnt_h])
    put_u8_n([voltage_cnt_l])
    ret

    .global final_voltage_ptf
final_voltage_ptf:
    put_char('v')
    put_char('l')
    put_char('o')
    put_char(':')
    put_u8([voltage_cnt_h])
    put_u8_n([voltage_cnt_l])
    ret


;************************************************
;     结果保存在voltage_cnt_l、voltage_cnt_h
;************************************************
    .global get_voltage_final
get_voltage_final:
    call voltage_cnt_clear
    call get_voltage_1
    delay_ms(10)
    call get_voltage_2
    delay_ms(10)
    call get_voltage_3
    delay_ms(10)
    call get_voltage_4
    call final_voltage_ptf
    call voltage_level_judge
    ret


    .global voltage_level_judge
voltage_level_judge:
    if(detect_mode == detect_mode_is_48v)skip
    goto _judge_mode_36v
    goto _judge_mode_48v

  _judge_mode_48v:
    w = [voltage_cnt_h] %% u16_ah = w
    w = [voltage_cnt_l] %% u16_al = w
    K_2_U16_B(48500) 
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_1
    K_2_U16_B(45500) 
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_2
    K_2_U16_B(43500) 
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_3
    K_2_U16_B(40500) 
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_4
    K_2_U16_B(38500) 
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_5
    goto __vlotage_level_lowpower
  
  _judge_mode_36v:
    w = [voltage_cnt_h] %% u16_ah = w
    w = [voltage_cnt_l] %% u16_al = w
    K_2_U16_B(39500)
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_1
    K_2_U16_B(37500)
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_2
    K_2_U16_B(35000)
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_3
    K_2_U16_B(32500)
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_4
    K_2_U16_B(30500)
    call u16_compare
    if(U16_LESS) skip
    goto __vlotage_level_5
    goto __vlotage_level_lowpower

  __vlotage_level_1:
    w = 1 %% [voltage_level] = W
    put_char('L')
    put_char_n('1')
    ; call led_level_1
    ; ret
    goto __vlotage_to_led
    
  __vlotage_level_2:
    w = 2 %% [voltage_level] = w
    put_char('L')
    put_char_n('2')
    ; call led_level_2
    ; ret
    goto __vlotage_to_led

  __vlotage_level_3:
    w = 3 %% [voltage_level] = w
    put_char('L')
    put_char_n('3')
    ; call led_level_3
    ; ret
    goto __vlotage_to_led
    
  __vlotage_level_4:
    w = 4 %% [voltage_level] = w
    put_char('L')
    put_char_n('4')
    ; call led_level_4
    ; ret
    goto __vlotage_to_led
    
  __vlotage_level_5:
    w = 5 %% [voltage_level] = w
    put_char('L')
    put_char_n('5')
    ; call led_level_5
    ; ret
    goto __vlotage_to_led
    
  __vlotage_level_lowpower:
    w = 6 %% [voltage_level] = w
    put_char('L')
    put_char_n('6')
    ; ret

  __vlotage_to_led:
    if(power_on_flag == 1)skip
    goto _jump_fliter
    call vlotage_detect_fliter
    if(level_change_flag == 1)skip
    ret
_jump_fliter:
    w = [voltage_level]
    dw_not_equ_skip(1)
    call led_level_1
    w = [voltage_level]
    dw_not_equ_skip(2)
    call led_level_2
    w = [voltage_level]
    dw_not_equ_skip(3)
    call led_level_3
    w = [voltage_level]
    dw_not_equ_skip(4)
    call led_level_4
    w = [voltage_level]
    dw_not_equ_skip(5)
    call led_level_5
    level_change_flag = 0
    w = [voltage_level]
    dw_not_equ_skip(6)
    low_power_flag = 1 
    level_change_flag = 0
    ret


    .global vlotage_detect_fliter
vlotage_detect_fliter:    
    w = [voltage_level]
    dw_not_equ_skip([level_temp_reg])
    goto __equ
    goto __not_equ
__not_equ:
    put_char('-')
    [fliter_cnt] = 0
    level_change_flag = 0
    goto __fliter_end
__equ:
    put_char('+')
    [fliter_cnt]++
    w = [fliter_cnt] %% w -= 3  ;;滤波数值
    if(NOT_MINUS_ALU) skip
    goto __fliter_end
    level_change_flag = 1
    [fliter_cnt] = 0
    put_char('Y')

__fliter_end:
    w = [voltage_level] %% [level_temp_reg] = w
    ret



