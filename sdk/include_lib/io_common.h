#ifndef __IO_COMMON_H__
#define __IO_COMMON_H__


// io map output--------------------------------------------------------
#define output_map_close(port, n) \
    bc port ## _pu,n %% bc port ## _pd,n %% bs port ## _die,n
// 0b00
#define output_map_bi0_ch0    bc
#define output_map_bi1_ch0    bc
// 0b01
#define output_map_bi0_ch1    bs
#define output_map_bi1_ch1    bc
// 0b10
#define output_map_bi0_ch2    bc
#define output_map_bi1_ch2    bs
// 0b11
#define output_map_bi0_ch3    bs
#define output_map_bi1_ch3    bs

/* output example:
 * ch:    ch0,ch1,ch2,ch3.
 * port:  p0,p1.
 * n:     0 ~ 7.
 * use ch0 remapping p12. -->   output_map(ch0, p1, 2)
 * use ch1 remapping p01. -->   output_map(ch1, p0, 1)
 */

#define output_map(ch,port,n) \
    output_map_bi1_ ## ch port ## _out,n %%\
    output_map_bi0_ ## ch port ## _die,n %%\
    bs port ## _pu,n %% bs port ## _pd,n %% bc port ## _dir,n %%\

/*
#define output_map_ch0(port,n) \
    bc port ## _dir,n %% bs port ## _pu,n %% bs port ## _pd,n   %%\
    bc port ## _out,n %% bc port ## _die,n

#define output_map_ch1(port,n) \
    bc port ## _dir,n %% bs port ## _pu,n %% bs port ## _pd,n   %%\
    bc port ## _out,n %% bs port ## _die,n

#define output_map_ch2(port,n) \
    bc port ## _dir,n %% bs port ## _pu,n %% bs port ## _pd,n   %%\
    bs port ## _out,n %% bc port ## _die,n

#define output_map_ch3(port,n) \
    bc port ## _dir,n %% bs port ## _pu,n %% bs port ## _pd,n   %%\
    bs port ## _out,n %% bs port ## _die,n
*/

#define pmu_out0_sel(port,n) \
    [iomc2].2 = 0 %%\
    [iomc2].3 = 1 %%\
    output_map(ch1,port,n)

#define pmu_out1_sel(port,n) \
    [iomc2].6 = 0 %%\
    [iomc2].7 = 1 %%\
    output_map(ch3,port,n)

#define hbyte(a) (((a) >> 8) & 0xff)
#define lbyte(a) ((a) & 0xff)


#define indr0_inc(addr) \
        w = addr  %% call f_indr0_inc

#define indr1_inc(addr) \
        w = addr  %% call f_indr1_inc



#endif
