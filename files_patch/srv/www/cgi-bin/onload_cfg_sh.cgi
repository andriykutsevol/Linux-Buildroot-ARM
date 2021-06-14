#!/bin/sh

echo "Content-Type: text/html"
#echo "Content-Type: text/plain"
echo

if [ -f /mnt/mmc_fat/syscfg/boot.cfg ]; then
f_fname=/mnt/mmc_fat/syscfg/boot.cfg
else
f_fname=/usr/bin/Demetro/boot.cfg
fi

some_vars=

parse_boot_cfg(){

  sed -n "/\[$1\]/,/^$/{
  /^[^#]/p
  }" $f_fname
 # /usr/bin/Demetro/boot.cfg
}



some_vars=$(parse_boot_cfg 1PPS)
some_vars=$some_vars' '$(parse_boot_cfg Delay)
some_vars=$some_vars' '$(parse_boot_cfg PPSOUT)
some_vars=$some_vars' '$(parse_boot_cfg NMEA)


echo $some_vars

#parse_boot_cfg Delay

#parse_boot_cfg NMEA