del otp.mif

.\bin2mif -b 0x00 -l 0x2000 -E -w 16 -i otp.image -o otp.mif
bin_to_fw_v2_0_6.exe -out AC951.fw -chip AC951 -otp burn.image -named_otp_crc -loader f95.isp -log info.log -burner-option option.ini

exit

