#!/bin/bash 
BUILD_TOOLS_ROOT=$1


cp -v ${BUILD_TOOLS_ROOT}/config/packages.list new_chroot/
cp -v ${BUILD_TOOLS_ROOT}/config/functions.sh new_chroot/

mkdir -p new_chroot/opt/
cp -rv ${BUILD_TOOLS_ROOT}/suckless.org/dwm new_chroot/opt/
cp -rv ${BUILD_TOOLS_ROOT}/config/etc/skel new_chroot/etc/

mkdir -p new_chroot/usr/share/xsessions/
cp -rv ${BUILD_TOOLS_ROOT}/config/usr/share/xsessions/custom-dwm.desktop new_chroot/usr/share/xsessions/
