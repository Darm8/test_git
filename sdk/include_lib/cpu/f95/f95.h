//---------------------------------------------
//                  f95.h
//---------------------------------------------
#ifndef __F95_H__
#define __F95_H__


#define    psr             0x80
#define    wreg            0x81
#define    pcl             0x82
#define    pcht            0x83
#define    sp              0x84
#define    ie0             0x85
#define    ie1             0x86
#define    indp_con        0x87

#define    indp0           0x88
#define    cindr0           0x89
#define    indp1           0x8a
#define    cindr1           0x8b
#define    crc_din         0x8c
#define    crc_reg         0x8d
#define    crc_con         0x8e
#define    wdt_con         0x8f

#define    iomc0           0x90
#define    iomc1           0x91
#define    p0_dir          0x92
#define    p0_out          0x93
#define    p0_pu           0x94
#define    p0_pd           0x95
#define    p0_hd           0x96
#define    p0_die          0x97

#define    p0_in           0x98
#define    p1_dir          0x99
#define    p1_out          0x9a
#define    p1_pu           0x9b
#define    p1_pd           0x9c
#define    p1_hd           0x9d
#define    p1_die          0x9e
#define    p1_in           0x9f

#define    iomc2           0xa0
#define    iomc3           0xa1
#define    wkup_con        0xa2
#define    wkup_flt        0xa3
#define    wkup_pnd        0xa4
#define    uart0_con0      0xa5
#define    uart0_con1      0xa6
#define    uart0_baud0     0xa7

#define    uart0_baud1     0xa8
#define    uart0_buf       0xa9
#define    uart1_con0      0xaa
#define    uart1_con1      0xab
#define    uart1_baud0     0xac
#define    uart1_baud1     0xad
#define    uart1_buf       0xae
#define    rst_con         0xaf

#define    ip0             0xb0
#define    ip1             0xb1
#define    ppm_con0        0xb2
#define    ppm_con1        0xb3
#define    ppm_cnt         0xb4
#define    ppm_hrx_cnt     0xb5
#define    ppm_adr         0xb6
#define    ana_con0        0xb7

#define    ana_con1        0xb8
#define    ana_con2        0xb9
#define    ana_con3        0xba
#define    ana_con4        0xbb
#define    ana_con5        0xbc
#define    ana_con6        0xbd
#define    ana_con7        0xbe
#define    ana_con8        0xbf

#define    ana_con9        0xc0
#define    ana_con10       0xc1
#define    ana_con11       0xc2
#define    ana_con12       0xc3
#define    ana_con13       0xc4
#define    ana_con14       0xc5
#define    ana_con15       0xc6
#define    ana_con16       0xc7

#define    ana_con17       0xc8
#define    ana_con18       0xc9
#define    wkup_con6       0xca
//
#define    isd_addrh       0xcc
#define    isd_addrl       0xcd
#define    wkup_cpnd0      0xce
#define    wkup_cpnd1      0xcf

#define    adc_con0        0xd0
#define    adc_con1        0xd1
#define    adc_resl        0xd2
#define    adc_resh        0xd3
#define    otp_cmd0        0xd4
#define    otp_cmd1        0xd5
#define    otp_wdat        0xd6
#define    mode_con        0xd7

#define    pwr_con         0xd8
#define    clk_con         0xd9
#define    pmu_octl        0xda
#define    hscl_ctl        0xdb
#define    rst_src         0xdc
#define    lvd_con0        0xdd
#define    lvd_con1        0xde
#define    iomc4           0xdf

#define    tmr0_con0       0xe0
#define    tmr0_con1       0xe1
#define    tmr0_cnt        0xe2
#define    tmr0_pr         0xe3
#define    pmu_read        0xe4
#define    tmr1_con0       0xe5
#define    tmr1_con1       0xe6
#define    tmr1_cnth       0xe7

#define    tmr1_cntl       0xe8
#define    tmr1_prh        0xe9
#define    tmr1_prl        0xea
#define    p0_ccen         0xeb
#define    p1_ccen         0xec
#define    led_con0        0xed
#define    led_con1        0xee
#define    led_prd         0xef

#define    led0_duty       0xf0
#define    led1_duty       0xf1
#define    led2_duty       0xf2
#define    wpr_con0        0xf3
#define    wpr_div         0xf4
#define    wpr_dat_adr     0xf5
#define    wpr_dat_cnt     0xf6
#define    wpr_pre_cnt     0xf7

#define    wkup_con0       0xf8
#define    wkup_con1       0xf9
#define    wkup_con2       0xfa
#define    wkup_con3       0xfb
#define    wkup_con4       0xfc
#define    wkup_con5       0xfd
#define    chip_ver        0xfe
#define    chip_id         0xff

///////////////trigger///////////////////////////
#define    trigger         bs  mode_con,7


#endif

