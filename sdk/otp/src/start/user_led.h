//*INDENT-OFF*
#ifndef __USER_LED_H__
#define __USER_LED_H__

#if IDE_DEBUG_IO
#define led_5_is_on     [p1_out].7 == 1
#define led_5_is_off    [p1_out].7 == 0
// #define led_5_on        [p1_out].1 = 1 %% put_char('5') %% put_char('O')
// #define led_5_off       [p1_out].1 = 0 %% put_char('5') %% put_char('F')
#else
#define led_5_is_on     [p0_out].0 == 1
#define led_5_is_off    [p0_out].0 == 0
// #define led_5_on        [p0_out].0 = 1 %% put_char('5') %% put_char('O')
// #define led_5_off       [p0_out].0 = 0 %% put_char('5') %% put_char('F')
#endif

// #define led_3_on        [p0_out].3 = 1 %% put_char('3') %% put_char('O')
// #define led_3_off       [p0_out].3 = 0 %% put_char('3') %% put_char('F')

// #define led_1_on        [p0_out].5 = 1 %% put_char('1') %% put_char('O')
// #define led_1_off       [p0_out].5 = 0 %% put_char('1') %% put_char('F')

// #if IDE_DEBUG_IO
// #define led_4_on        [p1_out].0 = 1 %% put_char('4') %% put_char('O')
// #define led_4_off       [p1_out].0 = 0 %% put_char('4') %% put_char('F')
// #define led_2_on        [p0_out].4 = 1 %% put_char('2') %% put_char('O')
// #define led_2_off       [p0_out].4 = 0 %% put_char('2') %% put_char('F')
// #else
// #define led_4_on        [p0_out].2 = 1 %% put_char('4') %% put_char('O')
// #define led_4_off       [p0_out].2 = 0 %% put_char('4') %% put_char('F')
// #define led_2_on        [p0_out].4 = 1 %% put_char('2') %% put_char('O')
// #define led_2_off       [p0_out].4 = 0 %% put_char('2') %% put_char('F')
// #endif





#if IDE_DEBUG_IO
#define led_1_on        [p0_out].0 = 1 %% put_char('1') %% put_char('O')  
#define led_1_off       [p0_out].0 = 0 %% put_char('1') %% put_char('F')
#define led_2_on        [p1_out].1 = 1 %% put_char('2') %% put_char('O')
#define led_2_off       [p1_out].1 = 0 %% put_char('2') %% put_char('F')
#define led_3_on        [p1_out].0 = 1 %% put_char('3') %% put_char('O')
#define led_3_off       [p1_out].0 = 0 %% put_char('3') %% put_char('F')
#define led_4_on        [p0_out].3 = 1 %% put_char('4') %% put_char('O')
#define led_4_off       [p0_out].3 = 0 %% put_char('4') %% put_char('F')
#define led_5_on        [p1_out].7 = 1 %% put_char('5') %% put_char('O')
#define led_5_off       [p1_out].7 = 0 %% put_char('5') %% put_char('F')

#else
#define led_1_on        [p0_out].5 = 1 %% put_char('1') %% put_char('O')
#define led_1_off       [p0_out].5 = 0 %% put_char('1') %% put_char('F')
#define led_2_on        [p0_out].4 = 1 %% put_char('2') %% put_char('O')
#define led_2_off       [p0_out].4 = 0 %% put_char('2') %% put_char('F')
#define led_3_on        [p0_out].3 = 1 %% put_char('3') %% put_char('O')
#define led_3_off       [p0_out].3 = 0 %% put_char('3') %% put_char('F')
#define led_4_on        [p0_out].2 = 1 %% put_char('4') %% put_char('O')
#define led_4_off       [p0_out].2 = 0 %% put_char('4') %% put_char('F')
#define led_5_on        [p0_out].0 = 1 %% put_char('5') %% put_char('O')
#define led_5_off       [p0_out].0 = 0 %% put_char('5') %% put_char('F')
#endif














#define led_1_4_off     led_1_off %% led_2_off %% led_3_off %% led_4_off //%% led_5_off 

#endif


