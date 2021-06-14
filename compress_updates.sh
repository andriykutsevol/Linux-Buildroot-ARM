#!/bin/sh

name=`date +"%y-%m-%d-%k-%M-%S" | sed -r 's/\s+//g'`
mkdir ./ARK/updates/${name}

#    -z: Compress archive using gzip program
#    -c: Create archive
#    -v: Verbose i.e display progress while creating archive
#    -f: Archive File name

# $ tar -zcvf prog-1-jan-2005.tar.gz /home/jerry/prog

# $ tar -zxvf prog-1-jan-2005.tar.gz	extract


tar -zcvf ./ARK/updates/${name}/files_patchU.tar.gz ./files_patchU

tar -zcvf ./ARK/updates/${name}/SCRIPTSu.tar.gz ./SCRIPTSu

tar -zcvf ./ARK/updates/${name}/outU.tar.gz ./outU

if [ "$1" = "all" ]; then
tar -zcvf ./ARK/updates/${name}/kernelU.tar.gz ./kernelU
tar -zcvf ./ARK/updates/${name}/u-boot_mmcU.tar.gz ./u-boot_mmcU
tar -zcvf ./ARK/updates/${name}/u-boot_nandU.tar.gz ./u-boot_nandU
tar -zcvf ./ARK/updates/${name}/buildrootU.tar.gz ./buildrootU
fi