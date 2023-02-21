#ifndef __UART_H__
#define __UART_H__

#define UT_DEBUG_EN     1
#define UT_DEBUG_U8_EN  1

.extern debug_init
.extern debug_char

//#define    iomc1           iomc

// #define DEBUG_BAUD         (UART_CLK/115200 / 4 - 1)
// #define DEBUG_BAUD         (UART_CLK / 1000000 / 4 - 1)
// #define DEBUG_BAUD_L       (DEBUG_BAUD   & 0xff)
// #define DEBUG_BAUD_H       ((DEBUG_BAUD  >> 8) & 0xff)
// #define DEBUG_BAUD_L       [a_ut_1152_baud_l]//(DEBUG_BAUD   & 0xff)
// #define DEBUG_BAUD_H       [a_ut_1152_baud_h]//((DEBUG_BAUD  >> 8) & 0xff)

#define ut0_portab_enable  [iomc4].4 = 1
#define ut0_tx_pnd         [uart0_con1].7
#define ut0_tx_clrpnd      [uart0_con1].5 = 1
#define ut0_rx_pnd         [uart0_con1].6
#define ut0_rx_clrpnd      [uart0_con1].4 = 1
//-----
#define ut0_ios_a          [iomc3].1 = 0 %% [iomc3].0 = 0
#define ut0_ios_b          [iomc3].1 = 0 %% [iomc3].0 = 1
#define ut0_ios_ch0        [iomc3].1 = 1 %% [iomc3].0 = 0
#define ut0_ios_ch1        [iomc3].1 = 1 %% [iomc3].0 = 1

#define ut1_tx_pnd         [uart1_con1].7
#define ut1_tx_clrpnd      [uart1_con1].5 = 1
#define ut1_rx_pnd         [uart1_con1].6
#define ut1_rx_clrpnd      [uart1_con1].4 = 1

#define ut1_portab_enable  [iomc4].5 = 1
#define ut1_ios_a          [iomc3].3 = 0 %% [iomc3].2 = 0
#define ut1_ios_b          [iomc3].3 = 0 %% [iomc3].2 = 1
#define ut1_ios_ch1        [iomc3].3 = 1 %% [iomc3].2 = 0

///////////////////////////////////////////////////////////////////////

#define ut0_tx_sel(port,n) \
    [iomc4].4 = 0 %%\
    [iomc2].0 = 0 %%\
    [iomc2].1 = 1 %%\
    output_map(ch0,port,n)

#define ut0_rx_sel(port,n)  \
    [iomc4].4 = 0 %%\
    ut0_ios_ch0 %%\
    input_map(ch0,port,n) %% \
    bc port ## _pd,n  %% \
    bs port ## _pu,n  %% \
    bs port ## _die,n

#define ut0_port_close(port,n)  \
    [iomc4].4 = 0 %%\
    output_map_close(port,n)
////////////////////////////////////////////////////////////////

#define ut1_tx_sel(port,n) \
    [iomc4].5 = 0 %%\
    [iomc2].4 = 0 %%\
    [iomc2].5 = 0 %%\
    output_map(ch2,port,n)

#define ut1_rx_sel(port,n)  \
    [iomc4].5 = 0 %%\
    ut1_ios_ch1 %%\
    input_map(ch1,port,n) %% \
    bc port ## _pd,n  %% \
    bs port ## _pu,n  %% \
    bs port ## _die,n



#define ut1_port_close(port,n)  \
    [iomc4].5 = 0 %%\
    output_map_close(port,n)
////////////////////////////////////////////////////////////

#define if_ut_tx_pnd(n,m)  \
    if([uart ## n ## _con1].7 == m)

#define if_ut_rx_pnd(n,m)  \
    if([uart ## n ## _con1].6 == m)

#if UT_DEBUG_EN
#define put_uart_init()   call debug_init
// #define put_uart_init()   call debug_init_ut0b
// #define put_uart_init()   call debug_init_iomapping
#define put_char(k)      w = k %% call debug_char
#define goto_put_char(k) w = k %% goto debug_char

#define put_w_char() call debug_char

#define put_char_n(k) w = k %% call debug_char %% call debug_n
// w = 0x0d %% call debug_char %% \
// w = 0x0a %% call debug_char

#define put_u8(k)    w = k %% call debug_u8
#define put_w_u8(k)  call debug_u8
#define put_u8_n(k)  w = k %% call debug_u8_n
#define put_w_u8_n(k)  call debug_u8_n

#define put_n()       call debug_n
#define goto_put_n()  goto debug_n
#else

#define put_uart_init(...)
#define put_char(...)
#define goto_put_char(...) ret
#define put_char_n(...)
#define put_u8(...)
#define put_w_u8(...)
#define put_u8_n(...)
#define put_w_u8_n(...)
#define put_n(...)
#define goto_put_n(...)  ret

#endif

#define utx_buf(n)      uart ## n ## _buf
#define utx_tx_pnd(n)   [uart ## n ## _con1].7
#define utx_rx_pnd(n)   [uart ## n ## _con1].6
#define utx_tx_clrpnd(n)   [uart ## n ## _con1].5  = 1
#define utx_rx_clrpnd(n)   [uart ## n ## _con1].4  = 1

#define utx_con0(n)  uart ## n ## _con0
#define utx_con1(n)  uart ## n ## _con1
#define utx_baud0(n)  uart ## n ## _baud0
#define utx_baud1(n)  uart ## n ## _baud1

#endif
