#!/bin/sh

  flash_erase /dev/mtd3 0 0 > /dev/null
  echo "  /dev/mtd3 was erased"
  nandwrite -m -p /dev/mtd3 /mnt/E/uImage > /dev/null
  echo "  /mnt/E/uImage was nandwired"
  echo "./md5_nand_install.sh ..."
  sh /root/scripts/md5_nand_install.sh
#  echo "./md5_updates_install.sh ..."
#  sh /root/scripts/md5_updates_install.sh

date
#echo "***IC";
exit 0