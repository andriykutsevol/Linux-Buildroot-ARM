#!/bin/sh

echo "Content-Type: text/html"
#echo "Content-Type: text/plain"
echo

if [ "$REQUEST_METHOD" = "POST" ]; then
    QUERY_STRING=`cat -`
fi
# echo $QUERY_STRING
# qq: 1pps=rs&emul=rs&bt=Set&reboot=Reboot


#-----------------------------------------------

if [ -f /mnt/mmc_fat/syscfg/boot.cfg ]; then
fname=/mnt/mmc_fat/syscfg/boot.cfg
else
fname=/usr/bin/Demetro/boot.cfg
#/usr/bin/Demetro/boot.cfg
fi


parse_qstring() {
  s='s/^.*'$1'=\([^&]*\).*$/\1/p'
  echo $QUERY_STRING | sed -n $s | sed "s/%20/ /g"
}


recreate_boot_cfg(){

# gl_js:       GPS, 1PPS,     RS
# Сначала меняем gl_gs ( Source selection of 1PPS. )

if [ $2 = "1PPS" ]; then
 
  sed  "/\[1PPS\]/,/^$/{
  /GPS/ c #GPS
  /[^\[]1PPS/ c 1PPS
  /RS/ c #RS
  }" -i $1
   
fi

if [ $2 = "GPS" ]; then
 
  sed  "/\[1PPS\]/,/^$/{
  /GPS/ c GPS
  /[^\[]1PPS/ c #1PPS
  /^1PPS/ c #1PPS
  /RS/ c #RS
  }" -i $1
   
fi

if [ $2 = "RS" ]; then
 
  sed  "/\[1PPS\]/,/^$/{
  /GPS/ c #GPS
  /[^\[]1PPS/ c #1PPS
  /^1PPS/ c #1PPS
  /RS/ c RS
  }" -i $1
   
fi
delay_line_num=`sed -n "/Delay/{=}" $fname`
#sed "${delay_line_num}a\\$Delay" -i $fname
delay_line_num=$((delay_line_num+1))
#echo `sed  "$delay_line_num s/.*/$Delay/" -i $fname`
echo `sed  "$delay_line_num s/.*/$Del_A/" -i $fname` 

#sed ${delay_line_num}d -i $fname
echo $delay_line_num
# -------------------------------------------------------
# Теперь меняем gl_gs_na ( Source selection of NMEA )
# -------------------------------------------------------

# gs_js_na:    GPS, Emulator, RS

if [ $3 = "Emulator" ]; then
 
  sed  "/\[NMEA\]/,/^$/{
  /GPS/ c #GPS
  /Emulator/ c Emulator
  /RS/ c #RS
  }" -i $1
   
fi

if [ $3 = "GPS" ]; then
 
  sed  "/\[NMEA\]/,/^$/{
  /GPS/ c GPS
  /Emulator/ c #Emulator
  /RS/ c #RS
  }" -i $1
   
fi

if [ $3 = "RS" ]; then
 
  sed  "/\[NMEA\]/,/^$/{
  /GPS/ c #GPS
  /Emulator/ c #Emulator
  /RS/ c RS
  }" -i $1
   
fi



}


gl_gs=$(parse_qstring gl_gs)
gl_gs_na=$(parse_qstring gl_gs_na)
Del_A=$(parse_qstring Delay_A)

#gl_gs='GPS'
#gl_gs_na='GPS'

recreate_boot_cfg $fname $gl_gs $gl_gs_na
t_mconfig
