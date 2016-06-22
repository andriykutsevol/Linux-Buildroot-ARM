#!/bin/bash

rdisk_size_KB=73728


if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi


cur_dir=`pwd`
path_to_out=$cur_dir/../out


if [ ! -f ${path_to_out}/rootfs.tar ]; then
echo "	error: BuildRoot is clean!"
exit 1
fi

#cd ../../M50_Base/buildroot/output/images
cd $path_to_out


mkdir ./untar 2>/dev/null
#=======================================
cd ./untar
tar xvf ../rootfs.tar > /dev/null
read -p  "	Image was untarED"  x
rm ./etc/init.d/* 2>/dev/null
#rm ./etc/rcS.d/*
#rm ./etc/rc3.d/*
cd ../
#=======================================



mkdir ./mnt   2>/dev/null
#=======================================

if [ -f $path_to_out/initrd.bin ]; then
  mount -o loop -t ext2 $path_to_out/initrd.bin ./mnt/
  read -p '	Was Done: mount -t ext2 $path_to_out/initrd.bin ./mnt/' x
else
  dd if=/dev/zero of=$path_to_out/initrd.bin bs=1K count=$rdisk_size_KB
  echo "------------"
  echo $count
  echo "------------"
  mke2fs -F -m0 $path_to_out/initrd.bin
  echo "	mkfs Done"
  mount -o loop -t ext2 $path_to_out/initrd.bin ./mnt/
  read -p '	Was Done: mount -t ext2 $path_to_out/initrd.bin ./mnt/' x
fi


#=======================================


  rsync -a --exclude='.svn*' $path_to_out/../files_patch/ ./untar/
  read -p "	Files was patched" x
  echo "	Files was patched"
  #rsync -raAXI ./untar/ ./mnt/
  rsync -a --exclude='.svn*' ./untar/ ./mnt/
  chown root:root ./mnt/etc/vsftpd.conf
  chown root:root ./mnt/var
  chown root:root ./mnt/var/empty
  chmod 711 ./mnt/var/empty
  read -p "	./untar --> ./mnt was synced" x
  sync
  
  #--------------
  cd ./mnt
  chmod 777 ./afterupdate.sh
  chmod 777 ./bin/busybox
  chmod -R 777 ./usr/bin
  chmod -R 777 ./usr/sbin
  chmod -R 777 ./etc/init.d
  chmod -R 777 ./etc/rcS.d
  chmod -R 777 ./etc/rc3.d
  chmod -R 777 ./etc/rc6.d
  chmod -R 777 ./root/scripts
  
  cd ./etc/rc3.d
  rm ./*
  ln -s ../init.d/telnetd 		./S10telnetd 		2>/dev/null
  ln -s ../init.d/thttpd 		./S20thttpd		2>/dev/null
  ln -s ../init.d/Demetro 		./S23Demetro		2>/dev/null
  ln -s ../init.d/inetd 		./S23inetd		2>/dev/null
  ln -s ../init.d/ntp 			./S23ntp		2>/dev/null
  ln -s ../init.d/networking	 	./S41networking		2>/dev/null
  ln -s ../init.d/dcron 		./S90dcron		2>/dev/null
  ln -s ../init.d/mparam 		./S91mparam		2>/dev/null
  ln -s ../init.d/immedreboot	 	./S92immedreboot	2>/dev/null
  
  cd ../../
  cd ./etc/rc6.d
  rm ./*	2>/dev/null
  ln -s ../init.d/reboot 		./S90reboot		2>/dev/null
  
  cd ../../
  cd ./etc/rcS.d
  rm ./*	2>/dev/null
  
  ln -s ../init.d/banner 		./S02banner		2>/dev/null
  ln -s ../init.d/sysfs.sh 		./S03sysfs		2>/dev/null
  ln -s ../init.d/hostname.sh 		./S93hostname		2>/dev/null
  
  cd ../../
  
  sync
  cd ../
  sync
  #--------------

  umount ./mnt
  rm -R ./untar	2>/dev/null
  rm -R ./mnt	2>/dev/null
  read -p "	./mnt was umounted" x
  echo "	./mnt was umounted"
  echo "	Done"
  date
  exit
