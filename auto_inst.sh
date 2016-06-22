#!/bin/bash
#----------------------------------
export m50_ftp_ip="111.21.111.111"
export m50_src_dir=`pwd`
export m50_base_dir="/media/HLAM/Workspaces/METROTEK_SVN_COPY/Metrotek/M50_PTP/branches/M50_Src_RostM/M50_Base"
if [ ! -d "$m50_base_dir" ]; then
  echo "ERROR: M50_Base directory does not exist. Please run configure.sh script first"
  exit 1
fi
#-----------------------------------

buildroot=""
ubootm=""
ubootn=""
uboot_scr=""
kernel=""
updates=""
fs=""


for var in "$@"
do
   case "$var" in
   	  buildroot) 
		buildroot="ok"
		;; 
	  ubootm) 
		ubootm="ok"
		;;
	  ubootn) 
		ubootn="ok"
		;;
	  uscr) 
		uscr="ok"
		;;
	  kernel) 
		kernel="ok"
		;;
	  updates) 
		updates="ok"
		;;
	  fs) 
		fs="ok"
		;;
	  *)
		echo "ERROR: Wrong parameter: $var"
		exit 1
		;;
   esac
done


uscrd=""
uImage=""
ubootd=""



if [ "${buildroot}" = "ok" ]; then
  cd $m50_base_dir/buildroot
  ls
  echo "Build buildroot"
 # make clean
  make xconfig
  make					# одинаковый.
  echo '---------'
  ls
  cp ./output/images/rootfs.tar $m50_src_dir/out
fi

cd $m50_src_dir/SCRIPTS


if [ "${ubootn}" = "ok" ]; then
  echo "Build uboot_nand"
  ./uboot_nand.sh			# одинаковый.
  ubootd="ok"
fi

if [ "${ubootm}" = "ok" ]; then
  echo "Build uboot_mmc"
  ./uboot_mmc.sh			# одинаковый.
fi

if [ "${uscr}" = "ok" ]; then
  echo "Build u_boot_scr"
  
  if [ "${updates}" = "ok" ]; then
    echo "uboot_scrU.sh"
    ./uboot_scrU.sh
  else
    echo "uboot_scr.sh"
    ./uboot_scr.sh
  fi
  
  uscrd="ok"
fi

if [ "${kernel}" = "ok" ]; then
  echo "Build uImage"
  ./uImage.sh				# одинаковое.
  uImage="ok"
fi





#-----------------------


yn=""
read -p  "??? Create RamDisk (y/n): "  yn
if [ "${yn}" = "y" ]; then
  sudo $m50_src_dir/SCRIPTS/ramd_mk.sh		# сборка initrd.bin одинаковая
  fs="ok"
else
  echo "Done"
fi

#-------------
read -p  "??? Create/Update MMC (y/n): "  yn
if [ "${yn}" = "y" ]; then
#-------------

if [ "${updates}" = "ok" ]; then

  if [ "$fs" = "ok" ]; then
    echo "download initrd.bin"
      ./mmc_update.sh initrd
  fi
  
  
  if [ "$ubootn" = "ok" ];then
    echo "Download ubootn"
    ./mmc_update.sh ubootn
  fi
  

  if [ "$uImage" = "ok" ];then
    echo "Download uImage"
    ./mmc_update.sh uImage
  fi
  

  if [ "$uscr" = "ok" ];then
    echo "Download uscr"
    ./mmc_update.sh uscr
  fi


else
  sudo $m50_src_dir/SCRIPTS/sd_mk4.sh
fi

#-------------
else
  echo "Done"
fi
#-------------
#-----------------------


exit 0
