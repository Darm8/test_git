//*INDENT-OFF*
#include "cpu.h"
#include "pmu.h"
#include "timer.h"
#include "uart.h"
#include "app.h"
#include "sleep.h"
#include "danger_signal.h"
#include "pmu_common.h"
#include "adc.h"

.macro sleep_hall
#if HALL_EN
        if (a_bit_hall_online == 1) skip
        goto __sleep_set_hall_rise
    __sleep_set_hall_fall:
        hall_io_wkup_en(wkup_fall)
        goto __sleep_set_hall_end
    __sleep_set_hall_rise:
        hall_io_wkup_en(wkup_rise)
    __sleep_set_hall_end:
        call hall_io_init;唤醒源设置时开了上拉,重新初始化关闭上拉
#else
        P05_HR
#endif
.endm

.macro wkup_hall
#if HALL_EN
        if(HALL_WKUP_PND == 1) skip
        goto __sleep_wkup_deal_hall_end
        a_evt_hall_change = 1
        a_bit_hall_online = !a_bit_hall_online
        [a_hall_cnt] = w
    __sleep_wkup_deal_hall_end:
#endif
.endm



#if HALL_EN

.macro sleep_vout01_det
        call vout01_default
        vout_discharge = 0
        vout0_load_discharge = 0
        vout1_load_discharge = 0
.endm

.macro sleep_vout01
        call pmu_isr_init
        vout0_detect_ie_dis()
        vout1_detect_ie_dis()
        call vout_detect_dis
.endm

#else

.macro sleep_vout01_det
.endm

.macro sleep_vout01
        wkup9_vout0_sleep
        wkup10_vout1_sleep
        pmu_sel_rd_page(PMU_PAGE3_ANA_READ2)
        if(vout0_load_det_pg3 == 0) skip
        wkup9_inv = 1
        if(vout1_load_det_pg3 == 0) skip
        wkup10_inv = 1
        call vout_detect_en
        ; wkup9_cpnd = 1
        ; wkup10_cpnd = 1
        call pmu_isr_init
        vout0_detect_ie_en()
        vout1_detect_ie_en()
.endm

#endif


.macro sleep_pmu

#ifdef F95
        vout_discharge = 1
#endif
        bg_en = 0
        bg_buff_en = 0

        boost_en = 0
        boost_vs_en = 0
        boost_zcd_en = 0

        chg_zcd_en = 0

        ot145_en = 0
        ot60_en = 0

        [ana_con10] = 0 ;vbat_div_en/vbat_ok_en/vbat_ov_en/vbat_uv_en

        vout_short_en = 0
        vbat_ov_en = 0
        vout_ov_en = 0
        vcc_ov_en = 0
        vcc_uv_en = 0

        [clk_con].5 = 0 ;boost_clk_en

        vcc_div_en = 0
        vbat_div_en = 0
        vout_div_en = 0
.endm



    .global power_off
power_off:

        clr_ea
        put_char('S')
        sleep_vout01_det
        [lvd_con0] = 0
        [lvd_con1] = 0

#if WDT_EN
        [wdt_con].4 = 0 ;disable wdt
#endif

        sleep_pmu
        ;[rst_con].4 = 0 ;mclr_en
        sfr_clr(p1_pu)
        sfr_clr(p1_pd)
        sfr(p0_pu,0x40) ;mclr
#if IDE_DEBUG_IO
        sfr(p0_pd,0x04) ;isp_clk
        sfr(p0_die,0b01000100)
#else
        [p0_pd] = 0 ;isp_clk
        sfr(p0_die,0b01000000)
#endif


        ;sfr(p1_dir,0xff)
        ;sfr(p0_dir,0xec)
        sfr_clr(p1_die)

        //关闭LEDIO
        w = (~(BIT(5) | BIT(4) | BIT(3))) & 0xff
        [p1_out] &= w
        w = (BIT(5) | BIT(4) | BIT(3))
        [p1_dir] |= w

        w = 0x11 %% [wkup_flt] = w
        w = 0x0f %% [wkup_pnd] = w

        sleep_vout01
        wkup6_cpnd = 1 %% wkup6_eie = 1 %% wkup6_sel_vcc_vbat_cmp()

        key_io_wkup_en()
        vwp_io_wkup_en()
        sleep_hall

		boost_pon_tst = 1
		; boost_non_tst = 0

        delay_ms(1)

        sleep_en = 1
        nop
		boost_pon_tst = 0
		; boost_non_tst = 0
        sleep_wkup_vout_api()
#if HANDSHAKE_EN
        call handshake_run
#endif
        wkup6_cpnd = 1%% wkup6_eie = 0
        wkup6_disable()
        ; CALL key_init
        io_wkup_dis()
        call pmu_init
#ifdef F95
        vout_discharge = 0
#endif

        call lvd_init

        //-----------------
        if(KEY_WKUP_PND == 0) skip
        a_bit_key0 = 1

        wkup_hall

        [a_vbat_chg_cnt] = 0
        put_char('W')
#if WDT_EN
        [wdt_con].4 = 1 ;enable wdt
#endif
        w = 0x0f %% [wkup_pnd] = w
        adc_idle_api()
        goto __set_ea_ret
