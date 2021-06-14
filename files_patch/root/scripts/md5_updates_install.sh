 #!/bin/sh
 
 sync
 sync
 umount /dev/mmcblk0p3
 sync
 sync
 echo "md5sum /dev/mmcblk0p3 > /mnt/F/md5sums/mmc-e.hash ..."
 md5sum /dev/mmcblk0p3 > /mnt/F/md5sums/mmc-e.hash
 echo "Done."


