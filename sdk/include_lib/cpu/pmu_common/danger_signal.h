//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : danger_signal.h
  By   : XXX
  date : 2019-12-09
********************************************************************************************/
#ifndef __DANGER_SIGNAL_H__
#define __DANGER_SIGNAL_H__

#define vout0_detect_ie_en()        wkup9_cpnd = 1 %% wkup9_eie = 1 %% wkup9_en = 1
#define vout0_detect_ie_dis()       wkup9_lie = 0 %% wkup9_en = 0

#define vout1_detect_ie_en()        wkup10_cpnd = 1 %% wkup10_eie = 1 %% wkup10_en = 1
#define vout1_detect_ie_dis()       wkup10_eie = 0 %% wkup10_en = 0

// #define vout_sov_signal_en()        call wkup45_vout_sov_signal_en
// #define vout_sov_signal_dis()        call wkup45_vout_sov_signal_dis

#define vout_ov_signal_dis()           call wkup4_vout_ov_signal_dis
#define vout_short_signal_dis()        call wkup5_vout_short_signal_dis

#define vcc_uv_signal_en()          wkup3_cpnd = 1 %% wkup3_lie = 1 %% wkup3_eie = 1 %% wkup3_en = 1
#define vcc_uv_signal_dis_isr()     wkup3_lie = 0
#define vcc_uv_signal_dis()         wkup3_lie = 0 %% wkup3_eie = 0 %% wkup3_en = 0

#define vcc_ov_signal_en()          call wkup2_vcc_ov_signal_en
#define vcc_ov_signal_dis_isr()     wkup2_lie = 0
#define vcc_ov_signal_dis()         wkup2_lie = 0 %% wkup2_eie = 0  %% wkup2_en = 0


#define vbat_ov_signal_en(n)        vbat_ov_ref_s1 = (n>>1) & 1 %% vbat_ov_ref_s0 = n & 1 %% vbat_ov_en = 1
#define vbat_uv_signal_en(n)        vbat_uv_ref_s1 = (n>>1) & 1 %% vbat_uv_ref_s0 = n & 1 %% vbat_uv_en = 1



#define ot_signal_en()            call wkup1_ot_signal_en
//#define ot_signal_dis()           ot_signal_ie_dis()
//--------------------------------

#define ot_signal_ie_en()         wkup1_cpnd = 1 %% wkup1_lie = 1 %% wkup1_eie = 1
#define ot_signal_ie_dis()        wkup1_lie = 0 %% wkup1_eie = 0
#define ot_signal_ie_dis_isr()    wkup1_eie = 0

#define ot_signal_null()      wkup1_sel1 = 0 %% wkup1_sel0 = 0
#define ot60_signal_set()     wkup1_sel1 = 0 %% wkup1_sel0 = 1
#define ot145_signal_set()    wkup1_sel1 = 1 %% wkup1_sel0 = 0

//--------------------------------------------------------------------------------------------------------
#define vout_short_sfr_en()      vout_short_en = 1 %% vout_short_ref_s1 = 0 %% vout_short_ref_s0 = 0 %%\
                                    wkup5_cpnd = 1 %% wkup5_lie = 1 %% wkup5_eie = 1 %% wkup5_en = 1
#define vout_short_sfr_dis()     wkup5_lie = 0 %% wkup5_eie = 0 %% wkup5_en = 0

#define vout_ov_sfr_en()         vout_ov_en = 1 %%\
                                    wkup4_cpnd = 1 %% wkup4_lie = 1 %% wkup4_eie = 1 %% wkup4_en = 1
#define vout_ov_sfr_dis()        wkup4_lie = 0 %% wkup4_eie = 0 %% wkup4_en = 0

#endif
