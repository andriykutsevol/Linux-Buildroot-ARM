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

echo q: $QUERY_STRING

#QUERY_STRING='a=208.67.220.221&ds1e=w1&b=208.67.222.222&ds2e=w2&c=8.8.8.3&ds3e=w3&f=8.8.8.4&ds4e=w4'

if [ -f /mnt/mmc_fat/syscfg/resolv.conf ]; then
dns_fname=/mnt/mmc_fat/syscfg/resolv.conf
else
dns_fname=/etc/resolv.conf
fi

set_dns(){
  #echo set_ethernet
  dns_line_num=`sed -n "/^#User\ DNS\ servers:/=" $dns_fname`
  #echo $iface_line_num
  dns_1_lnum=$((dns_line_num + 1))
  dns_2_lnum=$((dns_line_num + 2))
  dns_3_lnum=$((dns_line_num + 3))
  dns_4_lnum=$((dns_line_num + 4))
  #echo $ip_lnum

  # m=91.226.136.136& s1e=a1& n=88.147.254.233& s2e=a2&l=109.195.19.73&s3e=a3&x=88.147.254.235&s4e=a4
  # m=91.226.136.136& s1e=a1& n=88.147.254.233& l=109.195.19.73&s3e=a3&x=88.147.254.235&s4e=a4
 
#---------------------------
  if [ $ds1e ]; then
  	  echo "uncomment"
  	  echo `sed  "$dns_1_lnum c server $1"  -i  $dns_fname`
  else
	  echo "comment"
	  echo `sed  "$dns_1_lnum c #server $1" -i  $dns_fname`
  fi
 
#---------------------------
  
  if [ $ds2e ]; then
  	  echo "uncomment"
  	  echo `sed  "$dns_2_lnum c server $2"  -i  $dns_fname`
  else
	  echo "comment"
	  echo `sed  "$dns_2_lnum c #server $2" -i  $dns_fname`
  fi
  
#---------------------------
  
  if [ $ds3e ]; then
  	  echo "uncomment"
  	  echo `sed  "$dns_3_lnum c server $3"  -i  $dns_fname`
  else
	  echo "comment"
	  echo `sed  "$dns_3_lnum c #server $3" -i  $dns_fname`
  fi
  
#---------------------------
  
  if [ $ds4e ]; then
  	  echo "uncomment"
  	  echo `sed  "$dns_4_lnum c server $4"  -i  $dns_fname`
  else
	  echo "comment"
	  echo `sed  "$dns_4_lnum c #server $4" -i  $dns_fname`
  fi
 


}


parse_qstring() {
  s='s/^.*'$1'=\([^&]*\).*$/\1/p'
  echo $QUERY_STRING | sed -n $s | sed "s/%20/ /g"
}

#a=208.67.220.221&ds1e=w1&b=208.67.222.222&ds2e=w2&c=8.8.8.3&ds3e=w3&f=8.8.8.4&ds4e=w4

dns_1=$(parse_qstring a)
echo $dns_1
  ds1e=$(parse_qstring ds1e)
  echo $ds1e

dns_2=$(parse_qstring b)
echo $dns_2
  ds2e=$(parse_qstring ds2e)
  echo $ds2e

dns_3=$(parse_qstring c)
echo $dns_3
  ds3e=$(parse_qstring ds3e)
  echo $ds3e
  
dns_4=$(parse_qstring f)
echo $dns_4
  ds4e=$(parse_qstring ds4e)
  echo $ds4e
  
set_dns $dns_1 $dns_2 $dns_3 $dns_4
