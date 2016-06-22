#!/bin/bash
 
if [ "$EUID" -ne 0 ]; then
  echo "error: Please run as root"
  exit 1
fi

md5_switch="off"
 
#DRIVE='/dev/mmcblk0p'
#DRIVE_base='/dev/mmcblk0'

echo "!!! ----------- dmesg output ------------"

dmesg | tail -20

read -p "!!! ------- Enter DRIVE ------------ : " DRIVE
#DRIVE='/dev/sdb'

read -p "!!! ------- Enter DRIVE_base ------------ : " DRIVE_base
#DRIVE_base='/dev/sdb'

echo "!!! ------------ Selected disk IS ------------- "
fdisk -l $DRIVE_base

read -p "!!! Do you wand to RECREATE this disk (y/n): " x

if [ "$x" != "y" ]; then
  exit 1
fi

if [ ! -b ${DRIVE_base} ]; then
  echo "error: ${DRIVE_base} NOT FOUND"
  exit 1
fi
 

#-------------------------------------
 
start_path=`pwd`



LABEL_FAT1='C'
LABEL_FAT2='D'
LABEL_EXT1='E'
LABEL_EXT2='F'

out_dir=../out

#echo " 1 !!!!!!!!! "
umount ${DRIVE}1	2> /dev/null
umount ${DRIVE}2	2> /dev/null
umount ${DRIVE}3	2> /dev/null
umount ${DRIVE}4	2> /dev/null
sync
sync

if [ -d ./${LABEL_FAT1} ]; then rm -R ./${LABEL_FAT1}; fi
if [ -d ./${LABEL_FAT2} ]; then rm -R ./${LABEL_FAT2}; fi
if [ -d ./${LABEL_EXT1} ]; then rm -R ./${LABEL_EXT1}; fi
if [ -d ./${LABEL_EXT2} ]; then rm -R ./${LABEL_EXT2}; fi


#-------------------------------------------
# sfdisk -d /dev/mmcblk0 > ./clean_mmc.table

sfdisk ${DRIVE_base} < ./clean_mmc.table

dd if=/dev/zero of=$DRIVE_base bs=1024 count=1024

SIZE=`fdisk -l $DRIVE_base | grep Диск | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes

CYLINDERS=`echo $SIZE/255/63/512 | bc`

sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE_base << EOF
,25,0x0C,*
,250,,-
,25,0x0C,-
,5,0x0C,-
EOF

umount ${DRIVE}1	2> /dev/null
umount ${DRIVE}2	2> /dev/null
umount ${DRIVE}3	2> /dev/null
umount ${DRIVE}4	2> /dev/null
sync
sync

#echo " 2 !!!!!!!!! "
mkfs.vfat -F 32 -n "$LABEL_FAT1" ${DRIVE}1
#mkfs.vfat -F 32 -n "$LABEL_FAT2" ${DRIVE}p2
mkfs.ext3 -L "$LABEL_FAT2" ${DRIVE}2
mkfs.vfat -F 32 -n "$LABEL_EXT1" ${DRIVE}3
mkfs.vfat -F 32 -n "$LABEL_EXT2" ${DRIVE}4
sync
sync

#-------------------------------------------
# Fill C: with base system

#echo " 3 !!!!!!!!! "

mkdir ./${LABEL_FAT1}
chmod -R 777 ./${LABEL_FAT1}

mount ${DRIVE}1 ./${LABEL_FAT1}

cp ${out_dir}/MLO 			./${LABEL_FAT1}
cp ${out_dir}/u-boot.img 		./${LABEL_FAT1}
cp ${out_dir}/uImage			./${LABEL_FAT1}
cp ${out_dir}/u-boot-nand.img 		./${LABEL_FAT1}
cp ${out_dir}/initrd.bin 		./${LABEL_FAT1}
cp ${out_dir}/rdallinst.scr 		./${LABEL_FAT1}
cp ${out_dir}/rdinst.scr 		./${LABEL_FAT1}
cp ${out_dir}/uimageinst.scr 		./${LABEL_FAT1}
cp ${out_dir}/unandinst.scr 		./${LABEL_FAT1}
sync
sync
chmod -R 777 ./${LABEL_FAT1}
read -p "Look at Drive C: ..." x
umount ${DRIVE}1
rmdir ./${LABEL_FAT1}
#-------------------------------------------

#-------------------------------------------

#-------------------------------------------
#-------------------------------------------
#-------------------------------------------

# Fill D: with Configs

mkdir ./${LABEL_FAT2}
mount ${DRIVE}2 ./${LABEL_FAT2}
mkdir ./${LABEL_FAT2}/md5sums
chmod -R 777 ./${LABEL_FAT2}

#-------------------------------------------
if [ ${md5_switch} = "on" ]; then

	# Calculate md5sum for ${DRIVE}p1
	echo "Starting Calculate md5sum for Drive C: ..."
	md5sum ${DRIVE}1 > ./${LABEL_FAT2}/md5sums/mmc-c.hash
	echo "Done"
fi
#-------------------------------------------
#-------------------------------------------
#-------------------------------------------


# logs -----------------------

mkdir ./${LABEL_FAT2}/ftpdir
chmod -R 777 ./${LABEL_FAT2}
# ----------------------------


# Copy /etc/configs
mkdir ./${LABEL_FAT2}/etc
cp ../files_patch/etc/resolv.conf 	./${LABEL_FAT2}/etc/resolv.conf
cp ../files_patch/etc/ntp.conf 		./${LABEL_FAT2}/etc/ntp.conf
cp ../files_patch/etc/vsftpd.conf 	./${LABEL_FAT2}/etc/vsftpd.conf
mkdir ./${LABEL_FAT2}/etc/network
cp ../files_patch/etc/network/interfaces 	./${LABEL_FAT2}/etc/network/interfaces

mkdir ./${LABEL_FAT2}/usr
mkdir ./${LABEL_FAT2}/usr/bin
mkdir ./${LABEL_FAT2}/usr/bin/Demetro
#touch ./${LABEL_EXT2}/usr/bin/Demetro/nmea_emul_flag.txt
#touch ./${LABEL_EXT2}/usr/bin/Demetro/errorlog.log
#touch ./${LABEL_EXT2}/usr/bin/Demetro/stat.txt

cp ../files_patch/usr/bin/Demetro/boot.cfg 		./${LABEL_FAT2}/usr/bin/Demetro/boot.cfg
cp ../files_patch/usr/bin/Demetro/enable.cfg	./${LABEL_FAT2}/usr/bin/Demetro/enable.cfg
sync
sync
chmod -R 777 ./${LABEL_FAT2}
read -p "Look at Drive D: ..." x
umount ${DRIVE}2
rmdir ./${LABEL_FAT2}
#-------------------------------------------

#-------------------------------------------
# Fill E: with Updates
# 

mkdir ./${LABEL_EXT1}
chmod -R 777 ./${LABEL_EXT1}
mount ${DRIVE}3 ./${LABEL_EXT1}

#cp ${SRC_FAT}/u-bootUP-nand.img 	./${LABEL_EXT1}
#cp ${SRC_FAT}/u-bootUP.img 			./${LABEL_EXT1}
#cp ${SRC_FAT}/initrdUP.bin 			./${LABEL_EXT1}
#cp ${SRC_FAT}/driveE_lock 			./${LABEL_EXT1}
sync
sync
chmod -R 777 ./${LABEL_EXT1}
read -p "Look at Drive E: ..." x
umount ${DRIVE}3
rmdir ./${LABEL_EXT1}

#-------------------------------------------

#-------------------------------------------
# Fill F: with mmc-e.hash LATER
# AFTER upload on FTP !!!

mkdir ./${LABEL_EXT2}
chmod -R 777 ./${LABEL_EXT2}
mount ${DRIVE}4 ./${LABEL_EXT2}
mkdir ./${LABEL_EXT2}/md5sums

#cp ${SRC_FAT}/mmc-e.hash 			./${LABEL_EXT2}
sync
sync
chmod -R 777 ./${LABEL_EXT2}
read -p "Look at Drive F: ..." x
umount ${DRIVE}4
rmdir ./${LABEL_EXT2}

#-------------------------------------------

umount ${DRIVE}1	2> /dev/null
umount ${DRIVE}2	2> /dev/null
umount ${DRIVE}3	2> /dev/null
umount ${DRIVE}4	2> /dev/null
sync
sync



date
exit 0


# mmc rescan
# fatls mmc 0:0
# fatload mmc 0:0 0x81000000 rdallinst.scr
# source 0x81000000

# mmc rescan
# fatls mmc 0:3
# fatload mmc 0:3 0x81000000 rdallinstu.scr
# source 0x81000000
