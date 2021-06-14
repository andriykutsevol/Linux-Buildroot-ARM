  flash_erase /dev/mtd3 0 0
  echo "  /dev/mtd3 was erased"
  nandwrite -m -p /dev/mtd3 /mnt/E/uImageU
  echo "  /mnt/E/uImageU was nandwired" 
