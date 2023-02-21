cd %~dp0

set OBJDUMP=C:\JL\pi32\bin\llvm-objdump.exe
set OBJCOPY=C:\JL\pi32\bin\llvm-objcopy.exe
set NAME=otp

%OBJDUMP% -section-headers %NAME%.elf
%OBJDUMP% -disassemble %NAME%.elf > %NAME%.lst
%OBJCOPY% -O binary -j .otp_code %NAME%.elf  %NAME%.bin
%OBJCOPY% -O binary -j .otp_burn %NAME%.elf  %NAME%.bin1
%OBJCOPY% -O binary -j .otp_deg  %NAME%.elf  %NAME%.bin2

copy /b %NAME%.bin burn.image
copy /b %NAME%.bin+%NAME%.bin1+%NAME%.bin2 otp.image

copy burn.image mif_make\burn.image
copy otp.image mif_make\otp.image
cd mif_make
mif_make.bat

