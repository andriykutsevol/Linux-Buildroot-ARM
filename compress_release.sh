#!/bin/sh

name=`date +"%y-%m-%d-%k-%M-%S" | sed -r 's/\s+//g'`
mkdir ./ARK/release/${name}

#    -z: Compress archive using gzip program
#    -c: Create archive
#    -v: Verbose i.e display progress while creating archive
#    -f: Archive File name

# $ tar -zcvf prog-1-jan-2005.tar.gz /home/jerry/prog

# $ tar -zxvf prog-1-jan-2005.tar.gz	extract


tar -zcvf ./ARK/release/${name}/files_patch.tar.gz ./files_patch

tar -zcvf ./ARK/release/${name}/SCRIPTS.tar.gz ./SCRIPTS

tar -zcvf ./ARK/release/${name}/out.tar.gz ./out

if [ "$1" = "all" ]; then
tar -zcvf ./ARK/release/${name}/kernel.tar.gz ./kernel
tar -zcvf ./ARK/release/${name}/u-boot_mmc.tar.gz ./u-boot_mmc
tar -zcvf ./ARK/release/${name}/u-boot_nand.tar.gz ./u-boot_nand
tar -zcvf ./ARK/release/${name}/buildroot.tar.gz ./buildroot
fi