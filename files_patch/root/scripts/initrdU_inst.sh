#!/bin/sh

  flash_erase /dev/mtd4 0 0
  echo "  /dev/mtd4 was erased"
  nandwrite -m -p /dev/mtd4 /mnt/E/initrd.bin
  echo "  /mnt/E/initrdU.bin was nandwired"
  #echo "./md5_nand_install.sh ..."
  #sh /root/scripts/md5_nand_install.sh
  #echo "./md5_updates_install.sh ..."
  #sh /root/scripts/md5_updates_install.sh

date
exit 0