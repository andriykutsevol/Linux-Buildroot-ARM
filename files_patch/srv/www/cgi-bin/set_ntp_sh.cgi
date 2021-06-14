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

#echo q: $QUERY_STRING

if [ -f /mnt/mmc_fat/syscfg/ntp.conf ]; then
ntp_fname=/mnt/mmc_fat/syscfg/ntp.conf
else
ntp_fname=/etc/ntp.conf
fi



set_ntp(){
  #echo set_ethernet
  ntp_line_num=`sed -n "/^#User\ server:/=" $ntp_fname`
  #echo $iface_line_num
  ntp_1_lnum=$((ntp_line_num + 1))
  ntp_2_lnum=$((ntp_line_num + 2))
  ntp_3_lnum=$((ntp_line_num + 3))
  ntp_4_lnum=$((ntp_line_num + 4))
  #echo $ip_lnum

  # m=91.226.136.136& s1e=a1& n=88.147.254.233& s2e=a2&l=109.195.19.73&s3e=a3&x=88.147.254.235&s4e=a4
  # m=91.226.136.136& s1e=a1& n=88.147.254.233& l=109.195.19.73&s3e=a3&x=88.147.254.235&s4e=a4
  
  if [ $s1e ]; then
  	  echo "uncomment"
  	  echo `sed  "$ntp_1_lnum c server $1" -i  $ntp_fname`
  else
	  echo "comment"
	  echo `sed  "$ntp_1_lnum c #server $1" -i  $ntp_fname`

  fi
  
	  
  if [ $s2e ]; then
  	  echo "uncomment"
  	  echo `sed  "$ntp_2_lnum c server $2" -i  $ntp_fname`
  else
	  echo "comment"
	  echo `sed  "$ntp_2_lnum c #server $2" -i  $ntp_fname`

  fi
  
  if [ $s3e ]; then
  	  echo "uncomment"
  	  echo `sed  "$ntp_3_lnum c server $3" -i  $ntp_fname`
  else
	  echo "comment"
	  echo `sed  "$ntp_3_lnum c #server $3" -i  $ntp_fname`

  fi
  
  if [ $s4e ]; then
  	  echo "uncomment"
  	  echo `sed  "$ntp_4_lnum c server $4" -i  $ntp_fname`
  else
	  echo "comment"
	  echo `sed  "$ntp_4_lnum c #server $4" -i  $ntp_fname`

  fi
  

}


parse_qstring() {
  s='s/^.*'$1'=\([^&]*\).*$/\1/p'
  echo $QUERY_STRING | sed -n $s | sed "s/%20/ /g"
}


ntp_1=$(parse_qstring m)
echo $ntp_1
  s1e=$(parse_qstring s1e)
  echo $s1e

ntp_2=$(parse_qstring n)
echo $ntp_2
  s2e=$(parse_qstring s2e)
  echo $s2e

ntp_3=$(parse_qstring l)
echo $ntp_3
  s3e=$(parse_qstring s3e)
  echo $s3e
  
ntp_4=$(parse_qstring x)
echo $ntp_4
  s4e=$(parse_qstring s4e)
  echo $s4e
  
set_ntp $ntp_1 $ntp_2 $ntp_3 $ntp_4
