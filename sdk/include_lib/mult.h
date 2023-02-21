#include "cpu.h"

//;--------公共寄存器----------
#define    multdiv_cnt   (a_chg_buf + 7)
//;--------乘法寄存器----------
//;--------乘法寄存器----------
#define    mult_a        a_chg_rev_cnt    //8*8
#define    mult_b        a_chg_rev_len    //8*8


#define    mult_ah       a_chg_rev_cnt
#define    mult_al       a_chg_rev_case
#define    mult_bh       a_chg_rev_len
#define    mult_bl       (a_chg_buf + 0)

#define    multiply_b3   (a_chg_buf + 3)
#define    multiply_b2   (a_chg_buf + 4)
#define    multiply_b1   (a_chg_buf + 5)
#define    multiply_b0   (a_chg_buf + 6)


//;--------除法寄存器----------
#define   div_ch        a_chg_rev_cnt
#define   div_cl        a_chg_rev_case
#define   remainder_h3  a_chg_rev_len
#define   remainder_h2  (a_chg_buf + 0)
#define   remainder_h   (a_chg_buf + 1)
#define   remainder_l   (a_chg_buf + 2)
#define   div_bh3       (a_chg_buf + 3)
#define   div_bh2       (a_chg_buf + 4)
#define   div_bh        (a_chg_buf + 5)
#define   div_bl        (a_chg_buf + 6)

//;----------共享缓存----------
#define   share_cache_l   (a_chg_buf + 7)
#define   share_cache_h   (a_chg_buf + 8)


// #define   div_ch        53
// #define   div_cl        54
// #define   div_bh3       55
// #define   div_bh2       56
// #define   div_bh        57
// #define   div_bl        58
// #define   remainder_h3  59
// #define   remainder_h2  60
// #define   remainder_h   61
// #define   remainder_l   62



#define mult_16x16(a,b) \
     w = [a]     %% [mult_ah]=w \
     w = [(a)+1] %% [mult_al]=w \
     w = [b]     %% [mult_bh]=w \
     w = [(b)+1] %% [mult_bl]=w \
     call _mult_16x16

#define mult_16x16_imm(a,b) \
     w = hbyte(a) %% [mult_ah]=w %% \
     w = lbyte(a) %% [mult_al]=w %% \
     w = [b]      %% [mult_bh]=w %% \
     w = [(b)+1]  %% [mult_bl]=w %% \
     call _mult_16x16

#define mult_r01Xr23()     \
            w = [tr0] %% [mult_ah] = w %%\
            w = [tr1] %% [mult_al] = w %%\
            w = [tr2] %% [mult_bh] = w %%\
            w = [tr3] %% [mult_bl] = w %%\
            call _mult_16x16

/*
#define div_16x16(a,b) \
        [div_bh3] = 0  %%\
        [div_bh2] = 0  %%\
        w = [a]        %% [div_bh] = w %%\
        w = [(a)+1]    %% [div_bl] = w %%\
        w = [b]        %% [div_ch] = w %%\
        w = [(b)+1]    %% [div_cl] = w %%\
        call _div_32x16

#define div_24x16(a,b) \
        [div_bh3] = 0  %% \
        w = [a]        %% [div_bh2] = w %% \
        w = [(a)+1)]   %% [div_bh] = w  %% \
        w = [(a)+2]    %% [div_bl] = w  %% \
        w = [b]        %% [div_ch] = w  %% \
        w = [(b)+1]    %% [div_cl] = w  %% \
        call _div_32x16

#define div_32x16(a,b) \
        w = [a]        %% [div_bh3] = w %%\
        w = [(a+1)]    %% [div_bh2] = w %%\
        w = [(a)+2]    %% [div_bh] = w  %%\
        w = [(a)+3]    %% [div_bl] = w  %%\
        w = [b]        %% [div_ch] = w  %%\
        w = [(b)+1]    %% [div_cl] = w  %%\
        call _div_32x16
*/

#define u16_suc_u8(dh,dl,k) w = k %% [dl] -= w %% w = 0 %% [dh] -= w + c

#define u16_adc_u16(dh,dl,k) w = k & 0xff %% [dl] += w %% w = (k >> 8) & 0xff %% [dh] += w + c

