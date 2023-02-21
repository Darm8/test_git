//*INDENT-OFF*

#include "cpu.h"
#include "pmu.h"
#include "pmu_common.h"
#include "timer.h"
#include "uart.h"
#include "danger_signal.h"

#ifdef F96
#include "iline_ibuck.h"
#endif

#define trim_vol_42(n) \
            chg_vol_s3     = (n>>3) & 1 %%\
            chg_vol_s2     = (n>>2) & 1 %%\
            chg_vol_s1     = (n>>1) & 1 %%\
            chg_vol_s0     = n & 1 // 0~0xf

#define trim_bg(n)  \
            bg_tm4 =  (n>>4) & 1 %% \
            bg_tm3 =  (n>>3) & 1 %% \
            bg_tm2 =  (n>>2) & 1 %% \
            bg_tm1 =  (n>>1) & 1 %% \
            bg_tm0 =  n & 1     // bg_trim 0~0x1f

.macro pmu_case_1_do flag, flag_pg, fun
    pmu_sel_rd_page(\flag_pg)
    if (\flag == 1) skip
    goto __\fun\()_app_end
    \fun
    __\fun\()_app_end:
.endm


#if (HALL_EN == 0)

.macro wkup_wk9_edge_vout0
        wkup9_cpnd = 1
        a_evt_ear0_insert = 1
        b_vout0_online = 1
        ear0_info_init_api()
.endm

.macro wkup_wk10_edge_vout1
        wkup10_cpnd = 1
        a_evt_ear1_insert = 1
        b_vout1_online = 1
        ear1_info_init_api()
.endm

    .global sleep_wkup_vout
sleep_wkup_vout:
        pmu_case_1_do wk10_edge_vout1_det_pnd_pg7,PMU_PAGE7,wkup_wk10_edge_vout1
        pmu_case_1_do wk9_edge_vout0_det_pnd_pg7, PMU_PAGE7,wkup_wk9_edge_vout0
        ret
#endif

    .global vout0_det_recover
vout0_det_recover:
        if(b_vout0_online == 1) skip
        ret
#if HALL_EN
        if(b_disable_vout0 == 1) skip
        goto __vout0_det_recover_0
        vout0_output_set0()
        ret
#endif
    __vout0_det_recover_0:
        vout_det_sfr(0,1)
        ret

    .global vout1_det_recover
vout1_det_recover:
        if(b_vout1_online == 1) skip
        ret
#if HALL_EN
        if(b_disable_vout1 == 1) skip
        goto __vout1_det_recover_0
        vout1_output_set0()
        ret
#endif
    __vout1_det_recover_0:
        vout_det_sfr(1,1)
        ret



    .global pmu_init
pmu_init:
        boost_clk_en = 1
        vout_div_en = 1 ;//上电时打开
        vcc_div_en = 1 ;
        vbat_div_en =  1

        //bg
        bg_en = 1
        bg_buff_en = 1

        pmu_chg_api()

        //vc uv det enable
        vcc_uv_ref_s1 = 0 %%  vcc_uv_ref_s0 = 0
        vcc_uv_en = 1

        vbat_ov_signal_en(3)
        vbat_uv_signal_en(3)
        vcc_ov_signal_en()
        ;ot_signal_en()
        goto pmu_isr_init
        ;ret

    .global vout01_default
vout01_default:
        //w = 0x0f %% [ana_con14] &= w %% [ana_con12] &= w
        w = 0xf0 %% [ana_con14] |= w %% [ana_con12] |= w
        ret
    .global pmu_init_later
    .global pmu_init_last
pmu_init_later:
        call vout01_default
        ; w = 0x0f %% [ana_con14] &= w %% [ana_con12] &= w
        ; w = 0xf0 %% [ana_con14] |= w %% [ana_con12] |= w
        call vout_detect_en
        //delay_ms(100)
        ret

pmu_init_last:
        call vout_detect_dis
        goto_delay_ms(10)
        ;ret

#if VOUT_DANGER_MODE
    .global vout_danger_retry
vout_danger_retry:
        ; p_deg_char('v')
        ; p_deg_char('o')
        ; p_deg_char_n('c')
        b_vout_ov = 0
        b_vout_short_b = 0
        ret
#else

    .global vout_danger_retry_isr
vout_danger_retry_isr:

        if(b_vout_ov == 1) skip
        if(b_vout_short_b == 0) skip
        goto __vout_danger_retry_isr_0
        [a_vout_retry_cnt] = 0
        ret
    __vout_danger_retry_isr_0:

        w = 225 %% w = [a_vout_retry_cnt] - w
        if(NOT_MINUS_ALU) skip
        goto __vout_danger_retry_isr_inc
        b_vout_ov = 0
        b_vout_short_b = 0
        ret

    __vout_danger_retry_isr_inc:
        [a_vout_retry_cnt]++
        ret
#endif

/*********************************************************
    func : pmu_api_deg
*********************************************************/
    .global pmu_chg_case_deg
pmu_chg_case_deg:

        w = 'M'
        if(b_vout0_online == 0)skip
        call debug_char
        w = 'N'
        if(b_vout1_online == 0)skip
        call debug_char

#if ENCRYPT_EN
        w = 'P'
        if(b_send_encrypt == 0) skip
        call debug_char
#endif
    //---- vcc is ov ? ----------------
        if(b_vcc_ov == 0) skip
        goto __pcc_vcc_ov_deal
    //---- vcc is uv ? ----------------
        p_deg_char('A')
        if(b_vcc_uv == 0) skip
        goto __power_2_vout_all_off
    //---- vout is short or ov ? ------
        p_deg_char('B')
        if(b_vout_short_b == 0) skip
        goto __power_2_vout_all_off
        p_deg_char('b')
        if(b_vout_short_v == 0) skip
        goto __power_2_vout_all_off
        p_deg_char('C')
        if(b_vout_ov == 0) skip
        goto __power_2_vout_all_off
        p_deg_char('D')
        ; if(b_ot_60 == 0) skip
        if(b_ot_145 == 0) skip
        goto __pcc_deal_ot
        p_deg_char('d')
        goto __pmu_chg_case_deal


    .global chg_vol_set_for_burn
chg_vol_set_for_burn:
        w = 0xf8 %% [ana_con7] &= w
        chg_vol_s0 = 0
#if PMU_CHG_BUCK == 0//开关充电电流挡位
        if(T_CHG_VOL_S0 == 0) skip %% chg_vol_s0 = 1
        if(T_CHG_VOL_S1 == 0) skip %% chg_vol_s1 = 1
        if(T_CHG_VOL_S2 == 0) skip %% chg_vol_s2 = 1
        if(T_CHG_VOL_S3 == 0) skip %% chg_vol_s3 = 1
#else
        if(T_BCHG_VOL_S0 == 0) skip %% chg_vol_s0 = 1
        if(T_BCHG_VOL_S1 == 0) skip %% chg_vol_s1 = 1
        if(T_BCHG_VOL_S2 == 0) skip %% chg_vol_s2 = 1
        if(T_BCHG_VOL_S3 == 0) skip %% chg_vol_s3 = 1
#endif
        ret

    .global vout_detect_en
vout_detect_en:
        call vout_2_vout01_close

        if (b_bit_allow_vout0 == 1) skip
        goto __vout_detect_en_vout0_0_end
        vout0_output_set0()
    __vout_detect_en_vout0_0_end:

        if (b_bit_allow_vout1 == 1) skip
        goto __vout_detect_en_vout1_0_end
        vout1_output_set0()
    __vout_detect_en_vout1_0_end:

        delay_us(10)
        vout_all_hr()

        ; w = 0x0f %% [ana_con14] &= w %% [ana_con12] &= w %% [ana_con15] &= w
        ; w = 0xf0 %% [ana_con14] |= w %% [ana_con12] |= w %% [ana_con15] |= w


        vout_det_sfr(0,1)
        vout_det_sfr(1,1)
        ret




