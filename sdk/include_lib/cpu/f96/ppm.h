/***********************************XXX tech************************************************
  File : ppm.h
  By   : XXX
  date : 2019-05-14
********************************************************************************************/
#ifndef __PPM_H__
#define __PPM_H__


.extern ppm_start
.extern ppm_stop
.extern ppm_send
.extern ppm_start_lib

#if HANDSHAKE_EN
#define ppm_io_reset_api() call ppm_io_rest

#else
#define ppm_io_reset_api()

#endif

#endif

