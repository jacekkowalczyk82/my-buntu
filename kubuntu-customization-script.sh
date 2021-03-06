#!/bin/bash 
BUILD_TOOLS_ROOT=$1


cp -v ${BUILD_TOOLS_ROOT}/config-kubuntu/packages.list new_chroot/
cp -v ${BUILD_TOOLS_ROOT}/config-kubuntu/functions.sh new_chroot/

mkdir -p new_chroot/opt/
cp -rv ${BUILD_TOOLS_ROOT}/suckless.org/dwm new_chroot/opt/
cp -rv ${BUILD_TOOLS_ROOT}/backgrounds new_chroot/opt/

cp -rv ${BUILD_TOOLS_ROOT}/config-kubuntu/etc/skel new_chroot/etc/


mkdir -p new_chroot/usr/share/xsessions/
cp -rv ${BUILD_TOOLS_ROOT}/config-kubuntu/usr/share/xsessions/custom-dwm.desktop new_chroot/usr/share/xsessions/
