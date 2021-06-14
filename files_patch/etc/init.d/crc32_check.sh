 #!/bin/sh
 
line1=`cksum /dev/mtd4  | grep -o  "^[[:digit:]]*"`
line2=`cat /mnt/M50DATA/syscfg/crc32_sum | grep -o  "^[[:digit:]]*"`
dbg_flg= `cat /mnt/M50DATA/syscfg/crc32_sum | grep -o  "[[:alpha:]]*$"`

if [ "$dbg_flg" = 'dbg' ]; then
  echo "\n Calculated CRC SUM: $line1"
  echo "Cheked sum: $line2"
  read -p "Press any key." x
  exit 0
fi


if [ "$line1" = "$line2" ]; then
  echo 'System Message: CRC32 sum is OK'
  exit 0
else
  echo 'ERROR: CRC32 sum os wrong'
  echo 'system is reboted now...'
  reboot
fi