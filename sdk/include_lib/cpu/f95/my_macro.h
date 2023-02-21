//*INDENT-OFF*
#ifndef __MY_MACRO_H__
#define __MY_MACRO_H__

#define UART_POWER_UP m_deg_char('P') %% m_deg_char('5')

//; and_jmp
#define orl_jmp(a,b,a_orl_b) \
    if(a == 1) skip %%\
    if(b == 0) skip %%\
    goto a_orl_b

#define orl_ret(a,b) \
    if(a == 1) skip %%\
    if(b == 0) skip %%\
    ret






#endif


