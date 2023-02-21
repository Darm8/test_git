//*INDENT-OFF*
#ifndef __DATA_COMPARE_H__
#define __DATA_COMPARE_H__

#define u16_ah         [tr0]
#define u16_al         [tr1]
#define u16_bh         [tr2]
#define u16_bl         [tr3]

#define SET_U16_EQU    [tr3].0 = 0 %% [tr3].1 = 0
#define SET_U16_BIG    [tr3].0 = 0 %% [tr3].1 = 1
#define SET_U16_LESS   [tr3].0 = 1 %% [tr3].1 = 0

//#define U16_EQU        [tr3].0 == 0
#define U16_BIG        [tr3].1 == 1
#define U16_LESS       [tr3].0 == 1


#define K_2_U16_A(k)   \
            w = ((k) >> 8) & 0xff %% u16_ah = w %% \
            w = ((k) & 0xff) %% u16_al = w

#define K_2_U16_B(k)   \
            w = ((k) >> 8) & 0xff %% u16_bh = w %% \
            w = ((k) & 0xff) %% u16_bl = w

#define m_16_compare(ah,al,bh,bl) \
            w = ah %% u16_ah = w  %% \
            w = al %% u16_al = w  %% \
            w = bh %% u16_bh = w  %% \
            w = bl %% u16_bl = w  %% \
            call u16_compare

#endif

