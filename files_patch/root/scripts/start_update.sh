  #!/bin/sh
  
  sync
  mount /dev/mmcblk0p3 /mnt/E
  ln -s /mnt/E /root/E
  echo "ok"
