#!/bin/bash
##
#  Copyright (C) 2015, Samsung Electronics, Co., Ltd.
#  Written by System S/W Group, S/W Platform R&D Team,
#  Mobile Communication Division.
##
set -e -o pipefail

DEFCONFIG=BlackKernel_defconfig
VERSION=v3.10.17
DEVICE=vivalto3mveml3g
OWNER=CarlosGallego
NOW=`date "+%d%m%Y-%H%M%S"`
PREFIX=BK

export CROSS_COMPILE=/home/jean/armebi-4.9/bin/arm-eabi-
export ARCH=arm
export LOCALVERSION=-`echo Blackkernel`

KERNEL_PATH=$(pwd)
KERNEL_ZIP=${KERNEL_PATH}/kernel_zip
KERNEL_ZIP_NAME=${NAME}
MODULES=${KERNEL_PATH}/drivers

JOBS=`grep processor /proc/cpuinfo | wc -l`

function make_zip() {
	cd ${KERNEL_PATH}/kernel_zip
	zip -r ${KERNEL_ZIP_NAME}.zip ./
	mv ${KERNEL_ZIP_NAME}.zip ${KERNEL_PATH}
}

function build_kernel() {
	make ${DEFCONFIG}
	make -j${JOBS}
	find ${KERNEL_PATH}/drivers -name "*.ko" -exec cp -f {} ${KERNEL_ZIP}/system/lib/modules \;
	find ${KERNEL_PATH} -name zImage -exec cp -f {} ${KERNEL_ZIP}/tools \;
}

function make_clean(){
	find ${KERNEL_PATH} -name zImage -exec rm -f {} \;
	find ${KERNEL_PATH} -name "*.ko" -exec rm -f {} \;
	make mrproper && make clean
	rm  ${KERNEL_PATH}/*.zip
}

COLOR_RED=$(tput bold)$(tput setaf 1)
COLOR_BLUE=$(tput bold)$(tput setaf 4)
COLOR_YELLOW=$(tput bold)$(tput setaf 3)
COLOR_NEUTRAL="\033[0m"	
COLOR_GREEN="\033[1;32m"

clear

echo
echo -e $COLOR_RED"================================================"
echo -e $COLOR_BLUE"       BUILD SCRIPT FOR BUILDING KERNEL"
echo               "             MODIFIED BY CarlosGallego"
echo               "       Script By MUHAMMAD IHSAN <Ih24n>"
echo -e $COLOR_RED"================================================"
echo
echo -e $COLOR_YELLOW"  Device name     :  Ace 4 (SM-G318)"
echo -e $COLOR_YELLOW"  Kernel version  :  $VERSION"
echo -e $COLOR_YELLOW"  Build user      :  $USER"
echo -e $COLOR_YELLOW"  Build date      :  $NOW"
echo
echo "================================================"
echo -e $COLOR_GREEN"               Function menu flag"$COLOR_NEUTRAL
echo "================================================"
echo
echo "  1  = Delete .config/clean cache"
echo -e $COLOR_GREEN"  2  = Start building kernel"
echo "  3  = Make zImage to flashable.zip" 
echo "  4  = Do 2-3 process"$COLOR_NEUTRAL
echo
echo "================================================"
echo -e $COLOR_YELLOW"       JUST CHOOSE THE NUMBER,"
echo "       AND WAIT UNTIL PROCESS DONE!"
echo "================================================"
read -p "$COLOR_BLUE Whats Your Choice? " -n 1 -s x
echo -e $COLOR_GREEN

case "$x" in
	1)
		make_clean
		exit
		;;
	2)
		build_kernel
		exit
		;;
	3)
		make_zip
		exit
		;;
	4)
		build_kernel
		make_zip
		exit
		;;
	esac

exit
