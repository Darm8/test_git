//*INDENT-OFF*
/***********************************XXX tech************************************************
  File : ppm_api.S
  By   : XXX
  date : 2019-05-14
********************************************************************************************/
#include "cpu.h"
#include "ppm.h"
#include "uart.h"
#include "timer.h"
#include "pmu.h"
#include "io.h"

    .global ppm_io_rest
    .global ppm_io_common
ppm_io_rest:
        [p0_dir].7 = 1
#if (IDE_DEBUG_IO == 0)
        [p0_dir].0 = 1
#endif
ppm_io_common:
        [p0_die].7 = 1
        [p0_pu].7 = 0
        [p0_pd].7 = 0
#if (IDE_DEBUG_IO == 0)
        [p0_die].0 = 1
        [p0_pu].0 = 0
        [p0_pd].0 = 0
#endif
    .global ppm_2000
ppm_2000:
        ret

    .global ppm_send
    .global ppm_start
ppm_send:
ppm_start:
        b_ppm_succ = 0
        [ppm_con0] = 0

        [iomc3].6 = 0 %% [iomc3].4 = 0
        if (b_ppm_port_sel == 0) skip
        goto ppm_sel_port_other
        [iomc3].5 = 0 //P07
        goto ppm_sel_port_end
ppm_sel_port_other:
#if (IDE_DEBUG_IO == 0)
        [iomc3].5 = 1 //P00
#endif
ppm_sel_port_end:
        goto ppm_start_lib

