if [ ! -b /dev/mmcblk0p4 ]; then
  echo "error: ! -b /dev/mmcblk0p4 " >> /etc/immed_reboot
  echo "system will be reboted"
  exit 1
  
else
 mount /dev/mmcblk0p4 /mnt/F
 ln -s /mnt/F /root/F  
fi

#---------------------------------------
#----------  MD5SUM mmc C:  ------------
#---------------------------------------

if [ ! -f /mnt/D/md5sums/mmc-c.hash ]; then

	  echo "ERROR /mnt/D/md5sums/fmmc-c.hash DOES NOT EXIST"
	  echo "ERROR: Check sum will not be calculated"
	  read -p "Continue without /mnt/D/md5sums/fmmc-c.hash file? (y):" crc_file
	  if [ ! "$crc_file" = 'y' ];then
		echo "/mnt/D/md5sums/fmmc-c.hash DOES NOT EXIST" >> /etc/immed_reboot
		echo "System will be reboted"
	  fi
else
	  sh /etc/init.d/md5_check.sh /dev/mmcblk0p1 all /mnt/D/md5sums/mmc-c.hash &
fi


#---------------------------------------
#----------  MD5SUM  nand --------------
#---------------------------------------

if [ ! -f /mnt/D/md5sums/mtd1 ]; then

	  echo "ERROR /mnt/D/md5sums/mtd1 DOES NOT EXIST"
	  echo "ERROR: Check sum will not be calculated"
	  read -p "Continue without /mnt/D/md5sums/mtd1 file? (y):" crc_file
	  if [ ! "$crc_file" = 'y' ];then
		echo "/mnt/D/md5sums/mtd1 DOES NOT EXIST" >> /etc/immed_reboot
		echo "System will be reboted"
	  fi
else
	  sh /etc/init.d/md5_check.sh /dev/mtd1 all /mnt/D/md5sums/mtd1 &
fi

#---------------------------------------

if [ ! -f /mnt/D/md5sums/mtd2 ]; then

	  echo "ERROR /mnt/D/md5sums/mtd2 DOES NOT EXIST"
	  echo "ERROR: Check sum will not be calculated"
	  read -p "Continue without /mnt/D/md5sums/mtd2 file? (y):" crc_file
	  if [ ! "$crc_file" = 'y' ];then
		echo "/mnt/D/md5sums/mtd2 DOES NOT EXIST" > /etc/immed_reboot
		echo "System will be reboted"
	  fi  
else
	  sh /etc/init.d/md5_check.sh /dev/mtd2 all /mnt/D/md5sums/mtd2 & 
fi


#---------------------------------------

if [ ! -f /mnt/D/md5sums/mtd3 ]; then

	  echo "ERROR /mnt/D/md5sums/mtd4 DOES NOT EXIST"
	  echo "ERROR: Check sum will not be calculated"
	  read -p "Continue without /mnt/D/md5sums/mtd3 file? (y):" crc_file
	  if [ ! "$crc_file" = 'y' ];then
		echo "/mnt/D/md5sums/mtd3 DOES NOT EXIST" > /etc/immed_reboot
		echo "System will be reboted"
	  fi
else
	  sh /etc/init.d/md5_check.sh /dev/mtd3 all /mnt/D/md5sums/mtd3 &
fi

#---------------------------------------

#---------------------------------------

if [ ! -f /mnt/D/md5sums/mtd4 ]; then

	  echo "ERROR /mnt/D/md5sums/mtd4 DOES NOT EXIST"
	  echo "ERROR: Check sum will not be calculated"
	  read -p "Continue without /mnt/D/md5sums/mtd4 file? (y):" crc_file
	  if [ ! "$crc_file" = 'y' ];then
		echo "/mnt/D/md5sums/mtd4 DOES NOT EXIST" > /etc/immed_reboot
		echo "System will be reboted"
	  fi
else
	  rdisk_size_KB="73728"
	  sh /etc/init.d/md5_check.sh /dev/mtd4 $rdisk_size_KB /mnt/D/md5sums/mtd4 &  # size in KB
fi