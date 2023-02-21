MEMORY
{
	otp_code(rx) : ORIGIN = 0x0000 , LENGTH = 6K-64
	otp_burn(rx) : ORIGIN = 6k-64 , LENGTH = 64
	otp_deg(rx) : ORIGIN = 6k , LENGTH = 2k
    ram(rw) : ORIGIN = 0x04, LENGTH = 0x00040
    ram1(rw) : ORIGIN = 0x04, LENGTH = 0x0020

}
ENTRY(_start)
SECTIONS
{
    . = ORIGIN(otp_code);
    .otp_code ALIGN(8):
    {
        *startup.o(.text)
        *(.text)
        *(.common)
        *(.rodata*)
        *(.ins)
        . = LENGTH(otp_code);
        /* . = . + 32; */
    } >otp_code = 0x7fff

    . = ORIGIN(otp_burn);
    .otp_burn ALIGN(8):
    {
        *(.burn)
        . = LENGTH(otp_burn);
    } >otp_burn = 0x7fff
    
    . = ORIGIN(otp_deg);
    .otp_deg ALIGN(8):
    {
        *(.d_burn)
        . = LENGTH(otp_deg);
    } >otp_deg = 0x7fff
    text_size = SIZEOF(.otp_code);

}


