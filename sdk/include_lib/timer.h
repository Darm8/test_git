#ifndef __TIMER_H__
#define __TIMER_H__


.extern tmr0_int
.extern tmr0_isr
.extern delay_tmr

#define ONE_MS_BAUD    (SYS_CLK/1000/64)
#define MS_BAUD_L(n)   ((ONE_MS_BAUD * n - 1)   & 0xff)
#define MS_BAUD_H(n)   (((ONE_MS_BAUD * n - 1)  >> 8) & 0xff)

#define ONE_US_BAUD    SYS_CLK/1000000/64
#define US_BAUD_L(n)   ((n * ONE_US_BAUD)   & 0xff)
#define US_BAUD_H(n)   ((( n* ONE_US_BAUD)  >> 8) & 0xff)

#define delay_us(n) \
        w = US_BAUD_L(n) %% [tmr1_prl] = w %% \
        w = US_BAUD_H(n) %% [tmr1_prh] = w %% \
        call delay_tmr

#define goto_delay_ms(n) \
        w = MS_BAUD_L(n) %% [tmr1_prl] = w %% \
        w = MS_BAUD_H(n) %% [tmr1_prh] = w %% \
        goto delay_tmr

#define delay_ms(n) \
        w = MS_BAUD_L(n) %% [tmr1_prl] = w %% \
        w = MS_BAUD_H(n) %% [tmr1_prh] = w %% \
        call delay_tmr

#define delay_1p2_ms() \
        w = [a_keep_1_2ms] %% [tmr1_prl] = w %%\
        w = 1                                %%\
        if([a_keep_1_2ms].7 == 0) skip       %%\
        w = 0                                %%\
        [tmr1_prh] = w %% \
        call delay_tmr

#define delay_n100ms(n) \
        w = n %% call delay_100ms

#define delay_n(n) \
        w = n %% call delay

#define time_out_ms(n) \
        w = MS_BAUD_L(n) %% [tmr1_prl] = w %% \
        w = MS_BAUD_H(n) %% [tmr1_prh] = w %% \
        call time_out

#define TO_IS_UP       [tmr1_con0].7 == 1
#define TO_NOT_UP       [tmr1_con0].7 == 0

#define time_out_close  w = BIT(6) %% [tmr1_con0] = w

#endif

