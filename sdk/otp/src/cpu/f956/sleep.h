#ifndef __SLEEP_H__
#define __SLEEP_H__



#define wkup_rise  0
#define wkup_fall  1

#define wkup_ch0(edge)  [wkup_con].4 = edge %% [wkup_con].0 = 1
#define wkup_ch1(edge)  [wkup_con].5 = edge %% [wkup_con].1 = 1
#define wkup_ch2(edge)  [wkup_con].6 = edge %% [wkup_con].2 = 1
#define wkup_ch3(edge)  [wkup_con].7 = edge %% [wkup_con].3 = 1

#define wkup_ch0_dis()  [wkup_con].0 = 0

#define WKUP_CH0_PND    [wkup_pnd].4
#define WKUP_CH1_PND    [wkup_pnd].5
#define WKUP_CH2_PND    [wkup_pnd].6
#define WKUP_CH3_PND    [wkup_pnd].7

#define io_wkup_set(ch,port,n)  \
    input_map(ch,port,n) %% \
    bc port ## _pd,n  %% \
    bs port ## _pu,n  %% \
    bs port ## _die,n

#define io_wkup_key(ch,port,n,edge)  \
    input_map(ch,port,n) %% \
    bc port ## _pd,n  %% \
    bs port ## _pu,n  %% \
    bs port ## _die,n %% \
    wkup_##ch(edge)

#define io_wkup_vwp(ch,port,n,edge)  \
    input_map(ch,port,n) %% \
    bc port ## _pd,n  %% \
    bc port ## _pu,n  %% \
    bs port ## _die,n %% \
    wkup_##ch(edge)

#define io_wkup_dis()  [wkup_con] = 0



#endif

