rm $1
touch $1
chmod 666 $1
#--------------------------------------
echo '[1PPS]' >> $1
#--------------------------------------
if [ $2 = 'GPS' ]; then
	echo 'GPS' >> $1
else
	echo '#GPS' >> $1
fi


if [ $2 = '1PPS' ]; then
	echo '1PPS' >> $1
else
	echo '#1PPS' >> $1
fi


if [ $2 = 'RS' ]; then
	echo 'RS' >> $1
else
	echo '#RS' >> $1
fi

echo '' >> $1
#--------------------------------------
echo '[Delay]' >>  $1
echo '0' >> $1
echo '' >> $1
#--------------------------------------

#--------------------------------------
echo '[PPSOUT]' >>  $1
echo '1PPS' >> $1
echo '#10M' >> $1
echo '' >> $1
#--------------------------------------

#--------------------------------------
echo '[NMEA]' >>  $1

if [ $3 = 'GPS' ]; then
	echo 'GPS' >> $1
else
	echo '#GPS' >> $1
fi


if [ $3 = 'Emulator' ]; then
	echo 'Emulator' >> $1
else
	echo '#Emulator' >> $1
fi


if [ $3 = 'RS' ]; then
	echo 'RS' >> $1
else
	echo '#RS' >> $1
fi

#--------------------------------------


[1PPS] 1PPS [Delay] 0 [PPSOUT] 1PPS [NMEA] RS

gl_gs=GPS&gl_gs_na=GPS&bt=BUSY&reboot=Reboot

gl_gs=RS&gl_gs_na=RS&bt=BUSY&reboot=Reboot



















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

fname=boot.cfg
#/usr/bin/Demetro/boot.cfg
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
  /[^1PPS/ c 1PPS
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

#gl_gs='GPS'
#gl_gs_na='GPS'

recreate_boot_cfg $fname $gl_gs $gl_gs_na