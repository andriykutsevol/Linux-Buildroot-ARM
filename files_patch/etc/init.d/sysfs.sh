#!/bin/sh

#echo "We are: $0 : $1"


if [ -e /proc ] && ! [ -e /proc/mounts ]; then
  mount -t proc proc /proc
  #echo "		mount -t proc proc /proc"
fi

if [ -e /sys ] && ! [ -e /sys/kernel ] && grep -q sysfs /proc/filesystems; then
  mount sysfs /sys -t sysfs
  #echo "		mount sysfs /sys -t sysfs"
fi

#echo "		From sysfs.h"
#if [ -d /sys/class ]; then echo "/sys/class OK"; fi
#if [ -d /sys/class/gpio ]; then echo "/sys/class/gpio OK"; fi
#if [ -d /sys/class/gpio/gpio76 ]; then echo "/sys/class/gpio/gpio76 OK"; fi
#if [ -f /sys/class/gpio/gpio76/value ]; then echo "/sys/class/gpio/gpio76/value OK"; fi


#echo "From sysfs.h"

mount -t devtmpfs devtmpfs /dev
mkdir -m 0755 /dev/pts
mkdir -m 1777 /dev/shm
mount -a



if [ ! -e "/lib/modules/$(uname -r)"/modules.dep ] ; then
	#echo "			mkdir -p /lib/modules/uname"
	mkdir -p /lib/modules/$(uname -r)
	# depmod not install yet
	# see http://buildroot.uclibc.org/downloads/manual/manual.html  -- /dev managenemt
	#depmod -ae
fi


#---------------------------------------




# md5

#if [ ! -b /dev/mmcblk0p4 ]; then
#   echo "error: ! -b /dev/mmcblk0p4 " >> /etc/immed_reboot
#   echo "system will be reboted"
#   exit 1
#   
#else
#  mount /dev/mmcblk0p4 /mnt/f
#  ln -s /mnt/f /root/f  
#fi

#---------------------------------------


# logs

mkdir /mnt/D/usr
mkdir /mnt/D/usr/bin
mkdir /mnt/D/usr/bin/Demetro


touch /mnt/D/usr/bin/Demetro/stat.txt
touch /mnt/D/usr/bin/Demetro/errorlog.log
touch /mnt/D/usr/bin/Demetro/nmea_emul_flag.txt



# configs

if [ ! -b /dev/mmcblk0p2 ]; then
  echo "Warning: Using default settings."
else
  mount /dev/mmcblk0p2 /mnt/D
  ln -s /mnt/D /root/D
  ln -s /ftpdir /mnt/D/ftpdir
fi



# updates
if [ ! -b /dev/mmcblk0p3 ]; then
  echo "Warning: Update is imposible."
else
  mount /dev/mmcblk0p3 /mnt/E
  ln -s /mnt/E /root/E
fi

# # #---------------------------------------
# # 
# # #---------------------------------------
# # #----------  MD5SUM mmc C:  ------------
# # #---------------------------------------
# # 
# # if [ ! -f /mnt/D/md5sums/mmc-c.hash ]; then
# # 
# # 	  echo "ERROR /mnt/D/md5sums/fmmc-c.hash DOES NOT EXIST"
# # 	  echo "ERROR: Check sum will not be calculated"
# # 	  read -p "Continue without /mnt/D/md5sums/fmmc-c.hash file? (y):" crc_file
# # 	  if [ ! "$crc_file" = 'y' ];then
# # 		echo "/mnt/D/md5sums/fmmc-c.hash DOES NOT EXIST" >> /etc/immed_reboot
# # 		echo "System will be reboted"
# # 	  fi
# # else
# # 	  sh /etc/init.d/md5_check.sh /dev/mmcblk0p1 all /mnt/D/md5sums/mmc-c.hash &
# # fi
# # 
# # 
# # #---------------------------------------
# # #----------  MD5SUM   ------------------
# # #---------------------------------------
# # 
# # if [ ! -f /mnt/D/md5sums/mtd1 ]; then
# # 
# # 	  echo "ERROR /mnt/D/md5sums/mtd1 DOES NOT EXIST"
# # 	  echo "ERROR: Check sum will not be calculated"
# # 	  read -p "Continue without /mnt/D/md5sums/mtd1 file? (y):" crc_file
# # 	  if [ ! "$crc_file" = 'y' ];then
# # 		echo "/mnt/D/md5sums/mtd1 DOES NOT EXIST" >> /etc/immed_reboot
# # 		echo "System will be reboted"
# # 	  fi
# # else
# # 	  sh /etc/init.d/md5_check.sh /dev/mtd1 all /mnt/D/md5sums/mtd1 &
# # fi
# # 
# # #---------------------------------------
# # 
# # if [ ! -f /mnt/D/md5sums/mtd2 ]; then
# # 
# # 	  echo "ERROR /mnt/D/md5sums/mtd2 DOES NOT EXIST"
# # 	  echo "ERROR: Check sum will not be calculated"
# # 	  read -p "Continue without /mnt/D/md5sums/mtd2 file? (y):" crc_file
# # 	  if [ ! "$crc_file" = 'y' ];then
# # 		echo "/mnt/D/md5sums/mtd2 DOES NOT EXIST" > /etc/immed_reboot
# # 		echo "System will be reboted"
# # 	  fi  
# # else
# # 	  sh /etc/init.d/md5_check.sh /dev/mtd2 all /mnt/D/md5sums/mtd2 & 
# # fi
# # 
# # 
# # #---------------------------------------
# # 
# # if [ ! -f /mnt/D/md5sums/mtd3 ]; then
# # 
# # 	  echo "ERROR /mnt/D/md5sums/mtd4 DOES NOT EXIST"
# # 	  echo "ERROR: Check sum will not be calculated"
# # 	  read -p "Continue without /mnt/D/md5sums/mtd3 file? (y):" crc_file
# # 	  if [ ! "$crc_file" = 'y' ];then
# # 		echo "/mnt/D/md5sums/mtd3 DOES NOT EXIST" > /etc/immed_reboot
# # 		echo "System will be reboted"
# # 	  fi
# # else
# # 	  sh /etc/init.d/md5_check.sh /dev/mtd3 all /mnt/D/md5sums/mtd3 &
# # fi
# # 
# # #---------------------------------------
# # 
# # #---------------------------------------
# # 
# # if [ ! -f /mnt/D/md5sums/mtd4 ]; then
# # 
# # 	  echo "ERROR /mnt/D/md5sums/mtd4 DOES NOT EXIST"
# # 	  echo "ERROR: Check sum will not be calculated"
# # 	  read -p "Continue without /mnt/D/md5sums/mtd4 file? (y):" crc_file
# # 	  if [ ! "$crc_file" = 'y' ];then
# # 		echo "/mnt/D/md5sums/mtd4 DOES NOT EXIST" > /etc/immed_reboot
# # 		echo "System will be reboted"
# # 	  fi
# # else
# # 	  sh /etc/init.d/md5_check.sh /dev/mtd4 40960 /mnt/D/md5sums/mtd4 &  # size in KB
# # fi



#---------------------------------------
#---------  Configs  -------------------
#---------------------------------------

# First remove configs.

rm /etc/ntp.conf    2> /dev/null
rm /etc/resolv.conf 2> /dev/null
rm /etc/vsftpd.conf 2> /dev/null
rm /etc/network/interfaces     2> /dev/null
rm /usr/bin/Demetro/boot.cfg   2> /dev/null
rm /usr/bin/Demetro/enable.cfg 2> /dev/null



# Then check configs on D:

if [ ! -f /mnt/D/etc/ntp.conf ]; then
  echo "ERROR: /mnt/D/etc/ntp.conf DOES NOT EXIST"
  echo "System will be reboted"
  echo "/mnt/D/etc/ntp.conf DOES NOT EXIST" >> /etc/immed_reboot
fi

if [ ! -f /mnt/D/etc/resolv.conf ]; then
  echo "ERROR: /mnt/D/etc/resolv.conf DOES NOT EXIST"
  echo "System will be reboted"
  echo "/mnt/D/etc/resolv.conf DOES NOT EXIST" >> /etc/immed_reboot
fi

if [ ! -f /mnt/D/etc/network/interfaces ]; then
  echo "ERROR: /mnt/D/etc/network/interfaces DOES NOT EXIST"
  echo "System will be reboted"
  echo "/mnt/D/etc/network/interfaces DOES NOT EXIST" >> /etc/immed_reboot
fi

if [ ! -f /mnt/D/etc/vsftpd.conf ]; then
  echo "ERROR: /mnt/D/etc/vsftpd.conf DOES NOT EXIST"
  echo "System will be reboted"
  echo "/mnt/D/etc/vsftpd.conf DOES NOT EXIST" >> /etc/immed_reboot
fi

if [ ! -f /mnt/D/usr/bin/Demetro/boot.cfg ]; then
  echo "ERROR: /mnt/D/usr/bin/Demetro/boot.cfg DOES NOT EXIST"
  echo "System will be reboted"
  echo "/mnt/D/usr/bin/Demetro/boot.cfg DOES NOT EXIST" >> /etc/immed_reboot
fi

if [ ! -f /mnt/D/usr/bin/Demetro/boot.cfg ]; then
  echo "ERROR: /mnt/D/usr/bin/Demetro/boot.cfg DOES NOT EXIST"
  echo "System will be reboted"
  echo "/mnt/D/usr/bin/Demetro/boot.cfg DOES NOT EXIST" >> /etc/immed_reboot
fi

if [ ! -f /mnt/D/usr/bin/Demetro/enable.cfg ]; then
  echo "ERROR: /mnt/D/usr/bin/Demetro/enable.cfg DOES NOT EXIST"
  echo "System will be reboted"
  echo "/mnt/D/usr/bin/Demetro/enable.cfg DOES NOT EXIST" >> /etc/immed_reboot
fi


# And now create the links

ln -s /mnt/D/etc/ntp.conf /etc/ntp.conf

ln -s /mnt/D/etc/resolv.conf /etc/resolv.conf

ln -s /mnt/D/etc/network/interfaces /etc/network/interfaces

ln -s /mnt/D/etc/vsftpd.conf /etc/vsftpd.conf

ln -s /mnt/D/usr/bin/Demetro/boot.cfg /usr/bin/Demetro/boot.cfg

ln -s /mnt/D/usr/bin/Demetro/enable.cfg /usr/bin/Demetro/enable.cfg


ln -s /dev/rtc0 /dev/rtc
ln -s /dev/ttyO0 /dev/gps0
ln -s /dev/pps0 /dev/gpspps0


#---------------------------------------


exit 0

#!/bin/bash
# mountpoint -q $1
# if [ $? == 0 ]
# then
# echo "$1 is a mountpoint"
# else
# echo "$1 is not a mountpoint"
# fi
#-----------------------
# if mountpoint -q $1; then
#     echo "$1 is a mountpoint"
# else
#     echo "$1 is not a mountpoint"
# fi
