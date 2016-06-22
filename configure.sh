#!/bin/bash

#========================================
#========================================
#========================================
# Параметры.

#========================================
# Путь к каталогу M50_Base
# КОМАНДА ./configure.sh basedir

base_dir_path="/media/HLAM/Workspaces/METROTEK_SVN_COPY/Metrotek/M50_PTP/branches/M50_Src_RostM/M50_Base"

#========================================
# IP адрес ( files_patch/etc/network/interfaces ), используется так же и для доступаа по FTP
# КОМАНДА ./configure.sh setip

ip_address="111.21.111.111"

#========================================
# Размер рам диска в мегабайтах.
# КОМАНДА ./configure.sh rdsize

rdisk_size_MB=72

#========================================
# Размеры разделов на флешке.
# КОМАНДА ./configure.sh flashsize

# Имеет смысл держать как можно меньшими,
# так как для больших разделов долго вычисляются md5 суммы.

# Размер цилиндра 255 головок * 63 сектора * 512 байт = 8225280 байт
C_Size=25		# 25 * 8225280 байт = 205632000 байт = 196.10595 MB
D_Size=250		# 250 * 8225280 байт = 1961.05957 MB = 1.91509 GB
E_Size=25
F_Size=5

#========================================
# Включение - on, отключение - off проверки md5 сумм.
# КОМАНДА ./configure.sh md5
md5_switch="off"

#========================================
#========================================
#========================================


ip_flag=""
rdsize_flag=""
base_dir_flag=""
fl_size_flag=""
md5_switch_flag=""

#------------------------------------

rdisk_size_KB=`echo "scale=5; $rdisk_size_MB * 1024" | bc -l`
max_rdisk_size_KB=`echo "scale=5; ($rdisk_size_MB + 1) * 1024" | bc -l`
rdisk_size_BY=`echo "scale=5; $rdisk_size_KB * 1024" | bc -l`
rdisk_size_HEX=`echo "obase=16; ibase=10; $rdisk_size_BY" | bc -l`
rdisk_size_HEX="0x${rdisk_size_HEX}"
echo 'rdisk_size_HEX: ' ${rdisk_size_HEX}

base_dir_sed=`echo $base_dir_path | sed 's/\//\\\ \//g' | sed 's/ //g'`
echo $base_dir_sed


echo $rdisk_size_KB
echo $max_rdisk_size_KB

#========================================
#========================================

com_uncom_line(){
  #echo '$1: ' $1
  #echo '$2: ' $2
  #echo '$3: ' $3
  
  flett=`sed -n "$1 s/^\(.\{1\}\).*/\1/p" $3`
  #echo 'flett: ' $flett 
  if [ "$2" = "on" ]; then
  	  #echo "uncomment"
  	  if [ "$flett" = '#' ]
		then
		  #echo uncomment
		  `sed "$1 s/^#//" -i $3`
	  fi
	  
  else
	  #echo "comment"
  	  if [ "$flett" = "." ]
		then
		   #echo comment
		  `sed "$1 s/^/#/" -i $3`
	  fi

  fi

  echo "out"
}

#========================================
#========================================

md5_switch_func(){

	in_file="./files_patch/etc/init.d/sysfs.sh"
	line_num=`sed -n "/.[ ]\/etc\/init.d\/md5_func.sh/=" ${in_file}`
	com_uncom_line $line_num $md5_switch $in_file
	
	in_file="./SCRIPTS/sd_mk4.sh"
	line_num=`sed -n "/md5_switch=/=" ${in_file}`
	sed  "$line_num s/\(^.*=\"\).*\(\"\)/\1$md5_switch\2/" -i ${in_file}
	
}




#========================================

change_flash_size_func(){
	echo "Change Flash Size Function"
	
	#-------------------
	# sd_mk4.sh
	
	in_file="./SCRIPTS/sd_mk4.sh"	
	search_string="sfdisk -D -H 255 -S 63"
	line_num=`sed -n "/$search_string/=" $in_file`
	echo "sd_mk41.sh: " ${line_num}
	C_lnum=$((line_num + 1))
	D_lnum=$((line_num + 2))
	E_lnum=$((line_num + 3))
	F_lnum=$((line_num + 4))
	
	sed  "$C_lnum s/.*/,${C_Size},0x0C,\*/" -i $in_file
	sed  "$D_lnum s/.*/,${D_Size},,-/" -i $in_file
	sed  "$E_lnum s/.*/,${E_Size},0x0C,-/" -i $in_file
	sed  "$F_lnum s/.*/,${F_Size},0x0C,-/" -i $in_file

	
}



#========================================


change_base_dir_func(){
	echo "Change Base Dir Function: $base_dir_path"
	
	#-------------------
	# auto_inst.sh
	
	in_file="./auto_inst.sh"
	line_num=`sed -n "/export m50_base_dir=/=" ${in_file}`
	sed  "$line_num s/\(^.*=\"\).*\(\"\)/\1${base_dir_sed}\2/" -i ${in_file}
	
}


#========================================
change_ip_function(){
	#echo "Change IP Function: $ip_address"
	
	#-------------------
	# auot_inst.sh
	#	export M50_FTP_IP=192.168.2.106
	
	in_file="./auto_inst.sh"
	ip_line_num=`sed -n "/export m50_ftp_ip=/=" ${in_file}`
	#echo 'line_num: ' ${ip_line_num}
	sed  "$ip_line_num s/\(^.*=\"\).*\(\"\)/\1${ip_address}\2/" -i ${in_file}
	
	#-------------------
	# /files_patch/etc/network/interfaces
	# 	address 192.168.2.106

	in_file="./files_patch/etc/network/interfaces"
	iface_line_num=`sed -n "/^[ ]*iface\ eth0/=" ${in_file}`
	echo 'iface_line_num: ' ${iface_line_num}
	ip_lnum=$((iface_line_num + 1))
	sed  "$ip_lnum s/address .*/address $ip_address/" -i ${in_file}
	
}

#========================================

# ./configure.sh rdsize
change_ram_disk_size_function(){
	echo "Change Ram Disk Size Function: $rd_size"
	rm ./out/initrd.bin 2>/dev/null
	
	#-------------------
	# ramd_mk.sh -- установить размер
	# 	rdisk_size=xxxxx
	
	in_file="./SCRIPTS/ramd_mk.sh"
	rds_line_num=`sed -n "/rdisk_size_KB=/=" ${in_file}`
	sed  "$rds_line_num s/\(^.*=\).*/\1${rdisk_size_KB}/" -i ${in_file}
	
	#-------------------
	# ./etc/init.d/md5_func.sh
	echo "lllllllllll"
	in_file="./files_patch/etc/init.d/md5_func.sh"
	line_num=`sed -n "/rdisk_size_KB=/=" ${in_file}`
	sed  "$line_num s/\(^.*=\"\).*\(\"\)/\1${rdisk_size_KB}\2/" -i ${in_file}
	
	#-------------------
	
# 	# /u-boot_nand/include/configs/am3517_evm.h
# 	# 	"bootrd=nand read 0x81600000 0x780000 0x1E00000; " \
	in_file="${base_dir_path}/u-boot_nand/include/configs/am3517_evm.h"	
	search_string="bootrd=nand read 0x81600000 0x780000 "
	line_num=`sed -n "/$search_string/=" $in_file`
	sed  "$line_num s/\($search_string\).*\(;.*$\)/\1$rdisk_size_HEX\2/" -i $in_file

	search_string='bootargs_rd=setenv bootargs root=${boot_dev} ${bootopts} initrd=${rdisk_addr},'
	end_of_line=' console=${console}\\0" \\'
	line_num=`sed -n "/$search_string/=" $in_file`
	sed  "$line_num s/\($search_string\).*\($end_of_line\)/\1${rdisk_size_MB}M ramdisk_size=${max_rdisk_size_KB}\2/" -i $in_file
	
	
	#u-boot_mmc/include/configs/am3517_evm.h
	in_file="${base_dir_path}/u-boot_mmc/include/configs/am3517_evm.h"	
	search_string='bootargs_rd=setenv bootargs root=${boot_dev} ${bootopts} initrd=${rdisk_addr},'
	end_of_line=' console=${console}\\0" \\'
	line_num=`sed -n "/$search_string/=" $in_file`
	sed  "$line_num s/\($search_string\).*\($end_of_line\)/\1${rdisk_size_MB}M ramdisk_size=${max_rdisk_size_KB}\2/" -i $in_file
	
	
	#-------------------
	# ./SCRIPTS/u-boot/rdallinst.txt
	# Тут в строках 16  и в 18

	in_file="./SCRIPTS/u-boot/rdallinst.txt"

	search_string="mw.b 0x81600000 0xff "
	line_num=16
	sed  "$line_num s/\($search_string\).*/\1$rdisk_size_HEX/" -i $in_file

	search_string="nand write.e 0x81600000 0x780000 "
	line_num=18
	sed  "$line_num s/\($search_string\).*/\1$rdisk_size_HEX/" -i $in_file
	
	#-------------------
	# /SCRIPTS/u-boot/rdinst.txt
	# Тут в строках 2,3,5

	in_file="./SCRIPTS/u-boot/rdinst.txt"

	search_string="nand erase 0x780000 "
	line_num=2
	sed  "$line_num s/\($search_string\).*/\1$rdisk_size_HEX/" -i $in_file

	search_string="mw.b 0x81600000 0xff "
	line_num=3
	sed  "$line_num s/\($search_string\).*/\1$rdisk_size_HEX/" -i $in_file

	search_string="nand write.e 0x81600000 0x780000 "
	line_num=5
	sed  "$line_num s/\($search_string\).*/\1$rdisk_size_HEX/" -i $in_file
	
	#-----------------
	export m50_src_dir=`pwd`
	export m50_base_dir=${base_dir_path}
	
	cd $m50_src_dir/SCRIPTS
	./uboot_nand.sh
	./uboot_mmc.sh
	./uboot_scr.sh
	./uboot_scrU.sh
}

#========================================


#!/bin/bashfor var in "$@"
for var in "$@"
do

	par_name=`echo $var | sed 's/=.*$//'`
	par_value=`echo $var | sed 's/^.*=//'`

	case "$par_name" in
	
		setip) 
			ip_flag="ok"
			#ip_address=${par_value}
		;;
		
		rdsize) 
			rdsize_flag="ok"
			#rdisk_size_MB=${par_value}
		;;
		
		basedir)
			base_dir_flag="ok"
			#base_dir_path=${par_value}
		;;
		
		flashsize)
			fl_size_flag="ok"
		;;
		
		md5)
			md5_switch_flag="ok"
		;;
		
		*)
			echo "ERROR: Wrong parameter: $var"
			exit 1
		;;
	esac
done

#========================================
echo "#-----------------------------------"
echo "IP addres set to: $ip_address"
echo "RAM Disk size set to: $rdisk_size_MB MB"
echo "#-----------------------------------"


#========================================
# SET Ram Disk Size ( basedir )
if [ "${base_dir_flag}" = "ok" ]; then
	echo 'Start: change_base_dir_func'
	change_base_dir_func
fi


#========================================
# SET IP	( setip )
if [ "${ip_flag}" = "ok" ]; then
	echo 'Start: change_ip_function'
	change_ip_function
fi


#========================================
# SET Ram Disk Size ( rdsize )
if [ "${rdsize_flag}" = "ok" ]; then
	echo 'Start: change_ram_disk_size_function'
	change_ram_disk_size_function
fi

#========================================
# SET Partition Sizes of Flash ( flashsize )
if [ "${fl_size_flag}" = "ok" ]; then
	echo 'Start: change_flash_size_func'
	change_flash_size_func
fi

# #========================================
# Switch md5 sum checking ( md5 )
if [ "${md5_switch_flag}" = "ok" ]; then
	md5_switch_func
fi