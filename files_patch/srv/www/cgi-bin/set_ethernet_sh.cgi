#!/bin/sh

echo "Content-Type: text/html"
#echo "Content-Type: text/plain"
echo
#echo This is a sample mult_sh.cgisss
#echo $QUERY_STRING
#m=192.168.2.100&n=255.255.255.0&l=192.168.2.1&x=192.168.2.1


if [ "$REQUEST_METHOD" = "POST" ]; then
    QUERY_STRING=`cat -`
    echo post:
    #echo "<br>"
fi

echo set_ethernet_sh.cgi
echo $QUERY_STRING
#echo "<br>"
#echo "asd"

if [ -f /mnt/mmc_fat/syscfg/interfaces ]; then
  iface_fname=/mnt/mmc_fat/syscfg/interfaces
else
  iface_fname=/etc/network/interfaces
fi

set_ethernet(){
  #echo set_ethernet
  iface_line_num=`sed -n "/^[ ]*iface\ $1/=" $iface_fname`
  #echo $iface_line_num
  ip_lnum=$((iface_line_num + 1))
  mask_lnum=$((iface_line_num + 2))
  subn_lnum=$((iface_line_num + 3))
  getw_lnum=$((iface_line_num + 4))
  #echo $ip_lnum

  #echo `sed  "$ip_lnum,$ip_lnum s/[[:digit:]]\{3\}/x/" $iface_fname > ./out.txt`
  echo `sed  "$ip_lnum s/address .*/address $2/" -i $iface_fname`
  echo `sed  "$mask_lnum s/netmask .*/netmask $3/" -i $iface_fname`
  echo `sed  "$subn_lnum s/network .*/network $4/" -i $iface_fname`
  echo `sed  "$getw_lnum s/gateway .*/gateway $5/" -i $iface_fname`


}

#QUERY_STRING='m=192.168.2.109&n=255.255.255.22&l=192.168.2.2&x=192.168.2.2'
parse_qstring() {
  s='s/^.*'$1'=\([^&]*\).*$/\1/p'
  echo $QUERY_STRING | sed -n $s | sed "s/%20/ /g"
}
 
ip=$(parse_qstring m)
echo $ip

mask=$(parse_qstring n)
echo $mask

subn=$(parse_qstring l)
echo $subn

getw=$(parse_qstring x)
echo $getw

set_ethernet eth0 $ip $mask $subn $getw




#---------------------------------

#I packaged the sed command up into another script:

#$cat getvar.sh
#
#s='s/^.*'${1}'=\([^&]*\).*$/\1/p'
#echo $QUERY_STRING | sed -n $s | sed "s/%20/ /g"

#and I call it from my main cgi as:

#id=`./getvar.sh id`
#ds=`./getvar.sh ds`
#dt=`./getvar.sh dt`



 