/***********************************XXX tech************************************************
  File : key.h
  By   : XXX
  date : 2019-04-26
********************************************************************************************/
#ifndef __KEY_H__
#define __KEY_H__


#define NO_KEY        0xff
#define KEY_BASE_CNT  4
#define KEY_1S_CNT    63
#define KEY_LONG_CNT  187
#define KEY_HOLD_CNT  19


#define KEY_SHORT_UP      0x00
#define KEY_LONG          0x40
#define KEY_HOLD          0x80
//#define KEY_LONG_UP       0xc0
#define KEY_DBLCLICK      0x00

#define KEY_0             0xa

.extern key_init
.extern key_scan

#endif

