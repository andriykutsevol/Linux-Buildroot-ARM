 #!/bin/sh
 
 sync
 sync
 sync
 
 # u-boot
 echo "md5sum /dev/mtd1 > /mnt/D/md5sums/mtd1 ..."
 md5sum /dev/mtd1 > /mnt/D/md5sums/mtd1
 
 # u-boot vars
 echo "md5sum /dev/mtd2 > /mnt/D/md5sums/mtd2 ..."
 md5sum /dev/mtd2 > /mnt/D/md5sums/mtd2
 
 #Второй раздел - переменные u-boot - пропускаем.
 
 # kernel
 echo "md5sum /dev/mtd3 > /mnt/D/md5sums/mtd3 ..."
 md5sum /dev/mtd3 > /mnt/D/md5sums/mtd3
 
 # fs
 echo "md5sum /dev/mtd4 > /mnt/D/md5sums/mtd4 ..."
 #md5sum /dev/mtd4 > /mnt/D/md5sums/mtd4
 dd if=/dev/mtd4 bs=1024 count=40960 | md5sum > /mnt/D/md5sums/mtd4
 
 echo "Done."
 sync
 sync
 sync
