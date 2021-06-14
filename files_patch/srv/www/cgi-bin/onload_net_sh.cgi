#!/bin/sh
echo "Content-Type: text/html"
echo
#echo "ip=10000"
#echo `sed -n /iface/p ./etc/network/interfaces`

#iface_str=`sed -n /^iface/p ./etc/network/interfaces`
#echo $iface_str

if [ -f /mnt/mmc_fat/syscfg/ntp.conf ]; then
iface_fname=/mnt/mmc_fat/syscfg/interfaces
ntp_fname=/mnt/mmc_fat/syscfg/ntp.conf
dns_fname=/mnt/mmc_fat/syscfg/resolv.conf
else
iface_fname=/etc/network/interfaces
ntp_fname=/etc/ntp.conf
dns_fname=/etc/resolv.conf
fi





#printenv
#echo qstr: $QUERY_STRING

NET_VARS=

parse_interfaces() {

  #iface_str=`sed -n "/^[ ]*iface\ $1/p" $iface_name`
  iface_line_num=`sed -n "/^[ ]*iface\ $1/=" $iface_fname`
  begin=$((iface_line_num + 1))
  end=$((begin + 3))
  NET_VARS=`sed -n $begin,${end}p $iface_fname`' '
  #NET_VARS="asdfasdf"
  #echo "aaaa"
  #echo $NET_VARS
  
}

parse_ntp() {

  ntp_line_num=`sed -n "/^#User\ server:/=" $ntp_fname`
  #echo $ntp_line_num
  
  begin=$((ntp_line_num + 1))
  end=$((begin + 3))
  NET_VARS=$NET_VARS`sed -n $begin,${end}p $ntp_fname`' '
  #echo $NET_VARS

}

parse_resolv(){

  ntp_line_num=`sed -n "/^#User\ DNS\ servers:/=" $dns_fname`
  #echo $ntp_line_num
  
  begin=$((ntp_line_num + 1))
  end=$((begin + 3))
  NET_VARS=$NET_VARS`sed -n $begin,${end}p $dns_fname`' '
  #echo $NET_VARS

}

#net_vars=$(parse_interfaces eth0)
#echo $net_vars
#net_vars=$( parse_ntp )
#echo $net_vars

parse_interfaces eth0
parse_ntp
parse_resolv
 


echo $NET_VARS

