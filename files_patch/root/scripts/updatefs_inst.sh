#!/bin/sh

  flash_erase /dev/mtd4 0 0 > /dev/null
  echo "  /dev/mtd4 was erased"
  nandwrite -m -p /dev/mtd4 /mnt/E/initrdU.bin > /dev/null
  echo "  /mnt/E/initrdU.bin was nandwired"
  
  date
  echo "***IC";
  exit 0