#!/bin/bash -e
 
 ARCH=arm
 
 BASECOMPILE="CROSS_COMPILE=arm-arago-linux-gnueabi- ARCH=$ARCH"
 
 cd ${m50_base_dir}/kernel/linux
#--------------
#make O=$BUILDPATH/linux/build $BASECOMPILE mrproper
#make O=$BUILDPATH/linux/build $BASECOMPILE distclean

#CONFIG=am3517_evm_defconfig
#make O=$BUILDPATH/linux/build $BASECOMPILE mrproper
#make O=$BUILDPATH/linux/build $BASECOMPILE distclean
 
# make O=../build $BASECOMPILE clean
 #make O=$BUILDPATH/linux/build $BASECOMPILE $CONFIG menuconfig
#--------------

 make O=../build $BASECOMPILE menuconfig
 make O=../build $BASECOMPILE uImage -j 2
 
 uimage_out="${m50_src_dir}/out/uImage"
 cp ../build/arch/${ARCH}/boot/uImage ${uimage_out}
 
 