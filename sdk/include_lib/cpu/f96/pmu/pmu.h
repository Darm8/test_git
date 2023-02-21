//*INDENT-OFF*
#ifndef __PMU_H__
#define __PMU_H__
#include "cpu.h"
#include "uart.h"
#include "pmu_common.h"


/* ****************************************
 * SFR PAGE SEL
 * ***************************************/

#define sfr_rd_sel0               [pmu_rsel].0
#define sfr_rd_sel1               [pmu_rsel].1
#define sfr_rd_sel2               [pmu_rsel].3
#define sfr_rd_sel3               [pmu_rsel].4
#define wkup6_sel_vcc_vbat_cmp()  wkup6_sel = 1 %% wkup6_en = 1
#define wkup6_disable()           wkup6_en = 0


#define PMU_PAGE0_WKUP_GUIDE    0
#define PMU_PAGE1_ANA_READ0     1
#define PMU_PAGE2_ANA_READ1     2
#define PMU_PAGE3_ANA_READ2     3
#define PMU_PAGE4_WKUP_LEVEL0   4
#define PMU_PAGE5_WKUP_LEVEL1   5
#define PMU_PAGE6_WKUP_PND0     6
#define PMU_PAGE7_WKUP_PND1     7

#define PMU_PAGE0   0
#define PMU_PAGE1   1
#define PMU_PAGE2   2
#define PMU_PAGE3   3
#define PMU_PAGE4   4
#define PMU_PAGE5   5
#define PMU_PAGE6   6
#define PMU_PAGE7   7


#define pmu_sel_rd_page(n) w = n %% call pmu_sel_rd_page_api
/* **********************
 * isr pending in page
 * **********************/
//page0 wkup guide
#define PG0_WKUP8_10_EDGE_PND    [pmu_read].3
#define PG0_WKUP0_7_EDGE_PND     [pmu_read].2
#define PG0_WKUP8_10_LEVEL_PND   [pmu_read].1
#define PG0_WKUP0_7_LEVEL_PND    [pmu_read].0



/*
#define     [pmu_read].7
#define     [pmu_read].6
#define     [pmu_read].5
#define     [pmu_read].4
#define     [pmu_read].3
#define     [pmu_read].2
#define     [pmu_read].1
#define     [pmu_read].0
*/


//page4 wkup level pnd0
#define  PG4_WKUP7_LEVEL_PND      [pmu_read].7
#define  PG4_WKUP6_LEVEL_PND      [pmu_read].6
#define  PG4_WKUP5_LEVEL_PND      [pmu_read].5
#define  PG4_WKUP4_LEVEL_PND      [pmu_read].4
#define  PG4_WKUP3_LEVEL_PND      [pmu_read].3
#define  PG4_WKUP2_LEVEL_PND      [pmu_read].2
#define  PG4_WKUP1_LEVEL_PND      [pmu_read].1
#define  PG4_WKUP0_LEVEL_PND      [pmu_read].0

//page5 wkup level pnd1
#define  PG5_WKUP10_LEVEL_PND     [pmu_read].2
#define  PG5_WKUP9_LEVEL_PND      [pmu_read].1
#define  PG5_WKUP8_LEVEL_PND      [pmu_read].0

//page6 wkup edge pnd0
#define  PG6_WKUP7_EDGE_PND       [pmu_read].7
#define  PG6_WKUP6_EDGE_PND       [pmu_read].6
#define  PG6_WKUP5_EDGE_PND       [pmu_read].5
#define  PG6_WKUP4_EDGE_PND       [pmu_read].4
#define  PG6_WKUP3_EDGE_PND       [pmu_read].3
#define  PG6_WKUP2_EDGE_PND       [pmu_read].2
#define  PG6_WKUP1_EDGE_PND       [pmu_read].1
#define  PG6_WKUP0_EDGE_PND       [pmu_read].0

//page7 wkup edge pnd1
#define  PG7_WKUP10_EDGE_PND      [pmu_read].2
#define  PG7_WKUP9_EDGE_PND       [pmu_read].1
#define  PG7_WKUP8_EDGE_PND       [pmu_read].0



/* **********************
 * isr pending normal
 * **********************/
//#define HSCL_PND         [hscl_ctl].7
//#define hscl_pnd_clr()   [hscl_ctl].6 = 1

#define sfr_clr(adr)              [adr] = 0
#define ram_clr(adr)              [adr] = 0
#define sfr(adr,data)              w = data %% [adr] = w
#define ram(adr,data)              w = data %% [adr] = w
#define bit(out,in)                if(in==1) skip %% out = 0 %% if(in==0) skip %% out = 1
#define bit_not(out,in)            if(in==1) skip %% out = 1 %% if(in==0) skip %% out = 0
#define bit_and(out,in0,in1)       out = 0 %% if(in0==0) skip %% if(in1==1) skip %% out = 1
#define bit_nand(out,in0,in1)      out = 1 %% if(in0==0) skip %% if(in1==1) skip %% out = 0
#define jump(bit_case,case0,case1) if(bit_case==1) skip %% case0 %% if(bit_case==0) skip %% case1
//#define judge(adr,data)            w = data %% w = [adr] - w %% if(NOT_EQU_ALU) skip
//#define judge_not(adr,data)        w = data %% w = [adr] - w %% if(EQU_ALU) skip

//sfr
#define lvd_pnd                 [lvd_con0].7
#define lvd_clr_pnd             [lvd_con0].6
#define lvd_md                  [lvd_con0].5 //0:rst 1:int
#define lvd_ps                  [lvd_con0].4
#define lvd_en                  [lvd_con0].3
#define lvd_oe                  [lvd_con0].2
#define lvd_set1                [lvd_con0].1
#define lvd_set0                [lvd_con0].0
#define lvd_wkup_en             [lvd_con1].2
#define lvd_wkup_edge           [lvd_con1].1
#define lvd_flt_on              [lvd_con1].0

#define boost_clk_en            [clk_con].5

#define sleep_en                [pwr_con].2

#define boost_hscl_s2           [ana_con0].7
#define boost_hscl_s1           [ana_con0].6
#define boost_hscl_s0           [ana_con0].5
#define boost_hscl_en           [ana_con0].4
#define bypass_ss_en            [ana_con0].3
#define bypass_en               [ana_con0].2
#define io_current_mode_en      [ana_con0].1
#define boost_en                [ana_con0].0

#define boost_vout_tm           ana_con1
#define boost_vout_tm3          [ana_con1].7
#define boost_vout_tm2          [ana_con1].6
#define boost_vout_tm1          [ana_con1].5
#define boost_vout_tm0          [ana_con1].4
#define boost_pon_tst           [ana_con1].3
#define boost_non_tst           [ana_con1].2
#define boost_gm_rush_5v        [ana_con1].1
#define boost_gm_tsel0          [ana_con1].0

#define boost_zcd_lsel          [ana_con2].7
#define boost_zcd_hsel2         [ana_con2].6
#define boost_zcd_hsel1         [ana_con2].5
#define boost_zcd_hsel0         [ana_con2].4
#define boost_zcd_en            [ana_con2].3
#define boost_vs_s1             [ana_con2].2
#define boost_vs_s0             [ana_con2].1
#define boost_vs_en             [ana_con2].0
#define chg_duty_s2             [ana_con3].7
#define chg_duty_s1             [ana_con3].6
#define chg_duty_s0             [ana_con3].5
#define chg_civol_s2            [ana_con3].4
#define chg_civol_s1            [ana_con3].3
#define chg_civol_s0            [ana_con3].2
#define chg_buck_en             [ana_con3].1
#define chg_bg_en               [ana_con3].0
#define chg_iline_s2            [ana_con4].7
#define chg_iline_s1            [ana_con4].6
#define chg_iline_s0            [ana_con4].5
#define chg_line_en             [ana_con4].4
#define chg_ibuck_s3            [ana_con4].3
#define chg_ibuck_s2            [ana_con4].2
#define chg_ibuck_s1            [ana_con4].1
#define chg_ibuck_s0            [ana_con4].0
#define chg_ready               [ana_con5].7
#define chg_zcd_en              [ana_con5].6
#define chg_oscvl_s2            [ana_con5].5
#define chg_oscvl_s1            [ana_con5].4
#define chg_oscvl_s0            [ana_con5].3
#define chg_oscvh_s2            [ana_con5].2
#define chg_oscvh_s1            [ana_con5].1
#define chg_oscvh_s0            [ana_con5].0
#define chg_vol_s0              [ana_con6].7
#define chg_vilpvol_s2          [ana_con6].6
#define chg_vilpvol_s1          [ana_con6].5
#define chg_vilpvol_s0          [ana_con6].4
#define chg_viloop_en           [ana_con6].3
#define chg_osc_s2              [ana_con6].2
#define chg_osc_s1              [ana_con6].1
#define chg_osc_s0              [ana_con6].0
#define ot_ref_s1               [ana_con7].7
#define ot_ref_s0               [ana_con7].6
#define chg_ifull_s2            [ana_con7].5
#define chg_ifull_s1            [ana_con7].4
#define chg_ifull_s0            [ana_con7].3
#define chg_vol_s3              [ana_con7].2
#define chg_vol_s2              [ana_con7].1
#define chg_vol_s1              [ana_con7].0
#define rc32m_ptrim_s3          [ana_con8].7
#define rc32m_ptrim_s2          [ana_con8].6
#define rc32m_ptrim_s1          [ana_con8].5
#define rc32m_ptrim_s0          [ana_con8].4
#define rc32m_ntrim_s2          [ana_con8].3
#define rc32m_ntrim_s1          [ana_con8].2
#define rc32m_ntrim_s0          [ana_con8].1
#define ot145_en                [ana_con8].0
#define ot60_ref_s1             [ana_con9].7
#define ot60_ref_s0             [ana_con9].6
#define ot60_en                 [ana_con9].5
#define tst_ana_s2              [ana_con9].4
#define tst_ana_s1              [ana_con9].3
#define tst_ana_s0              [ana_con9].2
#define tst_ana_en              [ana_con9].1
#define tstchg_en               [ana_con9].0

#define vbat_uv_ref_s1          [ana_con10].7
#define vbat_uv_ref_s0          [ana_con10].6
#define vbat_uv_en              [ana_con10].5
#define vbat_ov_ref_s1          [ana_con10].4
#define vbat_ov_ref_s0          [ana_con10].3
#define vbat_ov_en              [ana_con10].2
#define ana_con10_null          [ana_con10].1
#define vbat_div_en             [ana_con10].0

#define vout0_vsense_mode_5v    [ana_con11].7
#define vout0_is_s2             [ana_con11].6
#define vout0_is_s1             [ana_con11].5
#define vout0_is_s0             [ana_con11].4
#define vout0_is_rs2            [ana_con11].3
#define vout0_is_rs1            [ana_con11].2
#define vout0_is_rs0            [ana_con11].1
#define vout0_is_en             [ana_con11].0

#define vout0_load_det_tm3      [ana_con12].7
#define vout0_load_det_tm2      [ana_con12].6
#define vout0_load_det_tm1      [ana_con12].5
#define vout0_load_det_tm0      [ana_con12].4
#define vout0_load_det          [ana_con12].3
#define vout0_load_fast_pu      [ana_con12].2
#define vout0_load_en           [ana_con12].1
#define vout0_load_discharge    [ana_con12].0

#define vout1_vsense_mode_5v    [ana_con13].7
#define vout1_is_s2             [ana_con13].6
#define vout1_is_s1             [ana_con13].5
#define vout1_is_s0             [ana_con13].4
#define vout1_is_rs2            [ana_con13].3
#define vout1_is_rs1            [ana_con13].2
#define vout1_is_rs0            [ana_con13].1
#define vout1_is_en             [ana_con13].0
#define vout1_load_det_tm3      [ana_con14].7
#define vout1_load_det_tm2      [ana_con14].6
#define vout1_load_det_tm1      [ana_con14].5
#define vout1_load_det_tm0      [ana_con14].4
#define vout1_load_det          [ana_con14].3
#define vout1_load_fast_pu      [ana_con14].2
#define vout1_load_en           [ana_con14].1
#define vout1_load_discharge    [ana_con14].0
#define vout_load_det_s3        [ana_con15].7
#define vout_load_det_s2        [ana_con15].6
#define vout_load_det_s1        [ana_con15].5
#define vout_load_det_s0        [ana_con15].4
#define vout_load_det           [ana_con15].3
#define vout_load_fast_pu       [ana_con15].2
#define vout_div_en             [ana_con15].1
#define vout_discharge          [ana_con15].0

#define line_bypass_qtr         [ana_con16].7
#define line_bypass_full        [ana_con16].6
#define vcc_div_en              [ana_con16].5
#define vout_ov_en              [ana_con16].4
#define vout_short_ref_s1       [ana_con16].3
#define vout_short_ref_s0       [ana_con16].2
#define vout_short_en           [ana_con16].1
#define ana_con16_null          [ana_con16].0

#define vcc_uv_ref_s1           [ana_con17].7
#define vcc_uv_ref_s0           [ana_con17].6
#define vcc_uv_en               [ana_con17].5
#define vcc_ov_en               [ana_con17].4
#define vcloop_en_5v            [ana_con17].3
#define chgzcd_short_5v         [ana_con17].2
#define wkup6_close_chg         [ana_con17].1
#define wkup6_close_boost       [ana_con17].0

#define bg_tm                   ana_con18
#define bg_tm4                  [ana_con18].6
#define bg_tm3                  [ana_con18].5
#define bg_tm2                  [ana_con18].4
#define bg_tm1                  [ana_con18].3
#define bg_tm0                  [ana_con18].2
#define bg_en                   [ana_con18].1
#define bg_buff_en              [ana_con18].0

//NOTE:
//wkup0  : chg_buck_full (or cichg or chg_line_full)
//wkup1  : vbat_ot60 (or vbat_ot145)
//wkup2  : vcc_ov
//wkup3  : vcc_uv
//wkup4  : vout_ov
//wkup5  : vout_short
//wkup6  : vcc_det（or vcc_vbat_comp)
//wkup7  : out_is
//wkup8  : vout_load
//wkup9  : vout0_load
//wkup10 : vout1_load

#define wkup1_eie               [wkup_con0].7
#define wkup1_lie               [wkup_con0].6
#define wkup1_inv               [wkup_con0].5
#define wkup1_sel1              [wkup_con0].4
#define wkup1_sel0              [wkup_con0].3
#define wkup0_lie               [wkup_con0].2
#define wkup0_sel1              [wkup_con0].1
#define wkup0_sel0              [wkup_con0].0

#define wkup5_lie               [wkup_con1].7
#define wkup4_lie               [wkup_con1].6
#define wkup3_lie               [wkup_con1].5
#define wkup2_lie               [wkup_con1].4
#define wkup5_en                [wkup_con1].3
#define wkup4_en                [wkup_con1].2
#define wkup3_en                [wkup_con1].1
#define wkup2_en                [wkup_con1].0

#define wkup6_flt_div           [wkup_con2].4
#define wkup5_eie               [wkup_con2].3
#define wkup4_eie               [wkup_con2].2
#define wkup3_eie               [wkup_con2].1
#define wkup2_eie               [wkup_con2].0

#define wkup6_sel               [wkup_con3].7
#define wkup6_flt_sel2          [wkup_con3].6
#define wkup6_flt_sel1          [wkup_con3].5
#define wkup6_flt_sel0          [wkup_con3].4
#define wkup6_eie               [wkup_con3].3
#define wkup6_lie               [wkup_con3].2
#define wkup6_inv               [wkup_con3].1
#define wkup6_en                [wkup_con3].0

#define wkup7_flt_sel2          [wkup_con4].6
#define wkup7_flt_sel1          [wkup_con4].5
#define wkup7_flt_sel0          [wkup_con4].4
#define wkup7_eie               [wkup_con4].3
#define wkup7_lie               [wkup_con4].2
#define wkup7_inv               [wkup_con4].1
#define wkup7_en                [wkup_con4].0

#define wkup8_flt_sel2          [wkup_con5].6
#define wkup8_flt_sel1          [wkup_con5].5
#define wkup8_flt_sel0          [wkup_con5].4
#define wkup8_eie               [wkup_con5].3
#define wkup8_lie               [wkup_con5].2
#define wkup8_inv               [wkup_con5].1
#define wkup8_en                [wkup_con5].0

#define wkup9_sel               [wkup_con6].7
#define wkup9_flt_sel2          [wkup_con6].6
#define wkup9_flt_sel1          [wkup_con6].5
#define wkup9_flt_sel0          [wkup_con6].4
#define wkup9_eie               [wkup_con6].3
#define wkup9_lie               [wkup_con6].2
#define wkup9_inv               [wkup_con6].1
#define wkup9_en                [wkup_con6].0

#define wkup10_flt_sel2         [wkup_con7].6
#define wkup10_flt_sel1         [wkup_con7].5
#define wkup10_flt_sel0         [wkup_con7].4
#define wkup10_eie              [wkup_con7].3
#define wkup10_lie              [wkup_con7].2
#define wkup10_inv              [wkup_con7].1
#define wkup10_en               [wkup_con7].0

#define wkup10_cpnd             [wkup_cpnd1].2
#define wkup9_cpnd              [wkup_cpnd1].1
#define wkup8_cpnd              [wkup_cpnd1].0

#define wkup7_cpnd              [wkup_cpnd0].7
#define wkup6_cpnd              [wkup_cpnd0].6
#define wkup5_cpnd              [wkup_cpnd0].5
#define wkup4_cpnd              [wkup_cpnd0].4
#define wkup3_cpnd              [wkup_cpnd0].3
#define wkup2_cpnd              [wkup_cpnd0].2
#define wkup1_cpnd              [wkup_cpnd0].1
#define wkup0_cpnd              [wkup_cpnd0].0

#define hscl_pnd                [hscl_ctl].7
#define hscl_cpnd               [hscl_ctl].6
#define hscl_cnt_sel1           [hscl_ctl].3
#define hscl_cnt_sel0           [hscl_ctl].2
#define hscl_ie                 [hscl_ctl].1
#define hscl_en                 [hscl_ctl].0

#define pmu_out1_sel3           [pmu_octl].7
#define pmu_out1_sel2           [pmu_octl].6
#define pmu_out1_sel1           [pmu_octl].5
#define pmu_out1_sel0           [pmu_octl].4
#define pmu_out0_sel3           [pmu_octl].3
#define pmu_out0_sel2           [pmu_octl].2
#define pmu_out0_sel1           [pmu_octl].1
#define pmu_out0_sel0           [pmu_octl].0


#define wk8_10_edge_pnd_pg0     [pmu_read].3 //sfr_rd_sel = 0b000
#define wk0_7_edge_pnd_pg0      [pmu_read].2 //sfr_rd_sel = 0b000
#define wk8_10_level_pnd_pg0    [pmu_read].1 //sfr_rd_sel = 0b000
#define wk0_7_level_pnd_pg0     [pmu_read].0 //sfr_rd_sel = 0b000

#define vbat_uv_pg1             [pmu_read].7  //sfr_rd_sel = 0b001
#define vbat_ov_pg1             [pmu_read].6  //sfr_rd_sel = 0b001
#define out1_is_comp_pg1        [pmu_read].5
#define out0_is_comp_pg1        [pmu_read].4

#define vcc_uv_pg2              [pmu_read].7  //sfr_rd_sel = 0b010
#define vcc_ov_pg2              [pmu_read].6  //sfr_rd_sel = 0b010
#define ot_145_pg2              [pmu_read].5  //sfr_rd_sel = 0b010
#define ot_60_pg2               [pmu_read].4  //sfr_rd_sel = 0b010
#define ci_chg_pg2              [pmu_read].3  //sfr_rd_sel = 0b010
#define vcc_line_full_pg2       [pmu_read].2  //sfr_rd_sel = 0b010
#define vcc_buck_full_pg2       [pmu_read].1  //sfr_rd_sel = 0b010
#define vout_vmax_comp          [pmu_read].0  //sfr_rd_sel = 0b010

#define vout1_load_det_pg3      [pmu_read].7  //sfr_rd_sel = 0b011
#define vout0_load_det_pg3      [pmu_read].6  //sfr_rd_sel = 0b011
#define boost_zcd               [pmu_read].4  //sfr_rd_sel = 0b011
#define vcc_vbat_comp_pg3       [pmu_read].3  //sfr_rd_sel = 0b011
#define vcc_det_pg3             [pmu_read].2  //sfr_rd_sel = 0b011
#define vout_short              [pmu_read].1  //sfr_rd_sel = 0b011
#define vout_ov                 [pmu_read].0  //sfr_rd_sel = 0b011


#define wk7_level_out_is_pnd_pg4          [pmu_read].7  //sfr_rd_sel = 0b100
#define wk6_level_vcc_det_pnd_pg4         [pmu_read].6  //sfr_rd_sel = 0b100
#define wk5_level_vout_short_pnd_pg4      [pmu_read].5  //sfr_rd_sel = 0b100
#define wk4_level_vout_ov_pnd_pg4         [pmu_read].4  //sfr_rd_sel = 0b100
#define wk3_level_vcc_uv_pnd_pg4          [pmu_read].3  //sfr_rd_sel = 0b100
#define wk2_level_vcc_ov_pnd_pg4          [pmu_read].2  //sfr_rd_sel = 0b100
#define wk1_level_ot_pnd_pg4              [pmu_read].1  //sfr_rd_sel = 0b100
#define wk0_level_cichg_pnd_pg4           [pmu_read].0  //sfr_rd_sel = 0b100

#define wk10_level_vout1_det_pnd_pg5           [pmu_read].2  //sfr_rd_sel = 0b101
#define wk9_level_vout1_det_pnd_pg5            [pmu_read].1  //sfr_rd_sel = 0b101
#define wk8_level_vout_det_pnd_pg5             [pmu_read].0  //sfr_rd_sel = 0b101


#define wk7_edge_out_is_pnd_pg6          [pmu_read].7  //sfr_rd_sel = 0b110
#define wk6_edge_vcc_det_pnd_pg6         [pmu_read].6  //sfr_rd_sel = 0b110
#define wk5_edge_vout_short_pnd_pg6      [pmu_read].5  //sfr_rd_sel = 0b110
#define wk4_edge_vout_ov_pnd_pg6         [pmu_read].4  //sfr_rd_sel = 0b110
#define wk3_edge_vcc_uv_pnd_pg6          [pmu_read].3  //sfr_rd_sel = 0b110
#define wk2_edge_vcc_ov_pnd_pg6          [pmu_read].2  //sfr_rd_sel = 0b110
#define wk1_edge_ot_pnd_pg6              [pmu_read].1  //sfr_rd_sel = 0b110
#define wk0_edge_cichg_pnd_pg6           [pmu_read].0  //sfr_rd_sel = 0b110

#define wk10_edge_vout1_det_pnd_pg7           [pmu_read].2  //sfr_rd_sel = 0b111
#define wk9_edge_vout0_det_pnd_pg7            [pmu_read].1  //sfr_rd_sel = 0b111

#define vpwm_pg8                         [pmu_read].2  //sfr_rd_sel = 0b1000
#define vqr_pg8                          [pmu_read].1  //sfr_rd_sel = 0b1000
#define vzcd_pg8                         [pmu_read].0  //sfr_rd_sel = 0b1000

#define saradc_pnd              [adc_con0].7
#define saradc_clr_pnd          [adc_con0].6
#define saradc_ie               [adc_con0].5

#define psr_cy                  [psr].5


#if PMU_CHG_BUCK
#define vout2vbat_open()    ibuck_open()
#else
#define vout2vbat_open()    iline_open()
#endif

#if PMU_CHG_BUCK
#define pmu_chg_api() \
        iline_2_buck(0b100) %%\
        /* ibuck(0b1000)  %% */  \
        buck_ifull(0b010)   %%\
        w = 0               %%\
        call chg_iline_set  %%\
        buck_duty(0b001)    %%\
        buck_oscvh(0b100)   %%\
        buck_oscvl(0b100)   %%\
        buck_osc(0b110)     %%\
        buck_vilpvol(0)     %%\
        [a_ibuck_cnt] = 0   %%\
        [a_ibuck_full_cnt] = 0
#else
#define pmu_chg_api() \
        buck_ifull(0b010)
#endif

// #define wkup9_sel_vout0()    wkup9_sel = 0

.macro wkup9_vout0_sleep
        w = 0x78 %% [wkup_con6] = w
.endm

.macro wkup10_vout1_sleep
        w = 0x78  %% [wkup_con7] = w
.endm



#endif


