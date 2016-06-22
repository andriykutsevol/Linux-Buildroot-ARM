#!/bin/bash

# Сейчас мы в M50_Src/SCRIPTS
# Переходим в каталог сборки u-boot_mmc
cd ${m50_base_dir}/u-boot_mmc

#make CROSS_COMPILE=arm-arago-linux-gnueabi- ARCH=arm distclean
make CROSS_COMPILE=arm-arago-linux-gnueabi- ARCH=arm am3517_evm_config
make CROSS_COMPILE=arm-arago-linux-gnueabi- ARCH=arm


uboot_out="${m50_src_dir}/out"

cp ./u-boot.img		${uboot_out}/u-boot.img
cp ./MLO		${uboot_out}/MLO

echo "cp ./u-boot.img	${uboot_out}/u-boot.img"
echo "cp ./MLO	${uboot_out}/MLO"