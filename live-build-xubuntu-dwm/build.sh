#!/bin/bash

echo -e "
#----------------------#
# INSTALL DEPENDENCIES #
#----------------------#
"

apt-get update
apt-get install -y live-build patch ubuntu-keyring

patch -d /usr/lib/live/build/ < live-build-fix-syslinux.patch


BASECODENAME="bionic"
CODENAME="bionic"
KERNEL_FLAVORS="generic"
MIRROR_URL="http://archive.ubuntu.com/ubuntu/"
NAME="my-buntu-dwm-xfce"
BASEVERSION="18.04"
VERSION="18.04"


LOGFILE="${NAME}-`date '+%Y-%m-%d_%H%M%S'`.log"

#--bootappend-live "boot=casper maybe-ubiquity quiet splash" 

lb clean |tee -a $LOGFILE


lb config noauto \
    --architectures amd64 \
    --grub-splash grub2.png \
    --mode ubuntu \
    --initramfs none \
    --distribution "$BASECODENAME" \
    --parent-distribution "$BASECODENAME" \
    --archive-areas "main restricted universe multiverse" \
    --parent-archive-areas "main restricted universe multiverse" \
    --linux-packages linux-image \
    --linux-flavours "$KERNEL_FLAVORS" \
    --bootappend-live "boot=casper maybe-ubiquity " \
    --mirror-bootstrap "$MIRROR_URL" \
    --parent-mirror-bootstrap "$MIRROR_URL" \
    --mirror-chroot-security "http://security.ubuntu.com/ubuntu/" \
    --parent-mirror-chroot-security "http://security.ubuntu.com/ubuntu/" \
    --mirror-binary-security "http://security.ubuntu.com/ubuntu/" \
    --parent-mirror-binary-security "http://security.ubuntu.com/ubuntu/" \
    --mirror-binary "http://archive.ubuntu.com/ubuntu/" \
    --parent-mirror-binary "http://archive.ubuntu.com/ubuntu/" \
    --keyring-packages ubuntu-keyring \
    --apt-options "--yes --option Acquire::Retries=5 --option Acquire::http::Timeout=100" \
    --uefi-secure-boot enable \
    --binary-images iso-hybrid \
    --iso-application "$NAME" \
    --iso-volume "$NAME" \
    --firmware-binary false \
    --firmware-chroot false \
    --zsync false  |tee -a $LOGFILE


#build ISO
lb build --debug --verbose 2>&1 |tee -a $LOGFILE


FNAME="$NAME-$VERSION-`date '+%Y-%m-%d_%H%M%S'`"
mv "live-image-amd64.hybrid.iso" ${FNAME}.iso | tee -a $LOGFILE


md5sum "${FNAME}.iso" > "${FNAME}.md5.txt" |tee -a $LOGFILE

sha256sum "${FNAME}.iso" > "${FNAME}.sha256.txt" |tee -a $LOGFILE

    

#mkdir artifacts
#docker run --privileged -i \
#    -v /proc:/proc \
#    -v ${PWD}/artifacts:/artifacts \
#    -v ${PWD}:/working_dir \
#    -w /working_dir \
#    debian:latest \
#    /bin/bash -s etc/terraform.conf < build.sh
