#!/bin/sh

if [ $1 = "all" ]; then

rm /mnt/D/etc/ntp.conf 2> /dev/null
cp ./defaults/etc/ntp.conf /mnt/D/etc/ntp.conf

rm /mnt/D/etc/resolv.conf 2> /dev/null
cp ./defaults/etc/resolv.conf /mnt/D/etc/resolv.conf

rm /mnt/D/etc/vsftpd.conf 2> /dev/null
cp ./defaults/etc/vsftpd.conf /mnt/D/etc/vsftpd.conf

rm /mnt/D/etc/network/interfaces 2> /dev/null
cp ./defaults/etc/network/interfaces /mnt/D/etc/network/interfaces

rm /mnt/D/usr/bin/Demetro/boot.cfg 2> /dev/null
cp ./defaults/usr/bin/Demetro/boot.cfg /mnt/D/usr/bin/Demetro/boot.cfg

fi

#----------------------------

if [ $1 = "ntp.conf" ]; then
rm /mnt/D/etc/ntp.conf 2> /dev/null
cp ./defaults/etc/ntp.conf /mnt/D/etc/ntp.conf
fi

#----------------------------

if [ $1 = "resolv.conf" ]; then
rm /mnt/D/etc/resolv.conf 2> /dev/null
cp ./defaults/etc/resolv.conf /mnt/D/etc/resolv.conf
fi

#----------------------------

if [ $1 = "vsftpd.conf" ]; then
rm /mnt/D/etc/vsftpd.conf 2> /dev/null
cp ./defaults/etc/vsftpd.conf /mnt/D/etc/vsftpd.conf
fi

#----------------------------

if [ $1 = "interfaces" ]; then
rm /mnt/D/etc/network/interfaces 2> /dev/null
cp ./defaults/etc/network/interfaces /mnt/D/etc/network/interfaces
fi

#----------------------------

if [ $1 = "demetro" ]; then
rm /mnt/D/usr/bin/Demetro/boot.cfg 2> /dev/null
cp ./defaults/usr/bin/Demetro/boot.cfg /mnt/D/usr/bin/Demetro/boot.cfg
fi
  
  sync
  
  exit 0