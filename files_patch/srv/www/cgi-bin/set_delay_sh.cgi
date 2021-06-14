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

com_uncom_line(){
  echo '$1: ' $1
  echo '$2: ' $2
  
  flett=`sed -n "$1,$1 s/^\(.\{1\}\).*/\1/p" $delay_fname`
  echo 'flett: ' $flett 
  if [ $2 ]; then
  	  echo "uncomment"
  	  if [ $flett = '#' ]
		then
		  echo uncomment
		  `sed "$1,$1 s/^#//" -i $delay_fname`
	  fi
	  
  else
	  echo "comment"
  	  if [ $flett = 's' ]
		then
		  echo comment
		  `sed "$1,$1 s/^/#/" -i $delay_fname`
	  fi

  fi

  echo "out"
}

delay_fname=/usr/bin/Demetro/boot.cfg

set_delay(){
  #echo set_ethernet
  delay_line_num=`sed -n "/^[Delay]/=" $delay_fname`
  #echo $iface_line_num
  delay_1_lnum=$((delay_line_num + 1))
  #echo $ip_lnum

  # m=91.226.136.136& s1e=a1& n=88.147.254.233& s2e=a2&l=109.195.19.73&s3e=a3&x=88.147.254.235&s4e=a4
  # m=91.226.136.136& s1e=a1& n=88.147.254.233& l=109.195.19.73&s3e=a3&x=88.147.254.235&s4e=a4
  
  echo `sed  "$delay_1_lnum,$delay_1_lnum s/[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+/$1/" -i  $delay_fname`
	  com_uncom_line $delay_1_lnum $s1e

}


parse_qstring() {
  s='s/^.*'$1'=\([^&]*\).*$/\1/p'
  echo $QUERY_STRING | sed -n $s | sed "s/%20/ /g"
}


delay_1=$(parse_qstring m)
echo $delay_1
  s1e=$(parse_qstring s1e)
  echo $d1e

  
set_delay $delay_1
