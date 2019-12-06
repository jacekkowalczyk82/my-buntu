# my-buntu
Build scripts and customization files to build custom Ubuntu ISO image

![screenshot](my-buntu-dwm-2019-07-02-133014_1440x900_scrot.png)


### Different ways to build custom ISO I found in the Internet resources

1. https://sourceforge.net/projects/pinguy-os/files/ISO_Builder/

2. https://www.debuntu.org/how-to-customize-your-ubuntu-live-cd/
https://www.debuntu.org/how-to-customize-your-ubuntu-live-cd-page-2/

3. https://help.ubuntu.com/community/LiveCDCustomization
use genisoimage  
do not use mkisofs
https://nathanpfry.com/how-to-customize-an-ubuntu-installation-disc/

4. https://help.ubuntu.com/community/LiveCDCustomizationFromScratch

5. CUBIC
https://www.techrepublic.com/article/how-to-create-a-custom-ubuntu-iso-with-cubic/
https://www.linuxuprising.com/2018/07/how-to-customize-ubuntu-or-linux-mint.html

## LiveCDCustomization way 

* Based on https://nathanpfry.com/how-to-customize-an-ubuntu-installation-disc/

* run as root user:

```
apt -y install squashfs-tools genisoimage


BUILD_TOOLS_ROOT=`pwd`
cd ~/

BASE_ISO_IMAGE_NAME="xubuntu-18.04.2-desktop-amd64.iso"
BASE_ISO_IMAGE_PATH=~/Downloads/${BASE_ISO_IMAGE_NAME}
if [ ! -e ${BASE_ISO_IMAGE_PATH} ]; then
	wget -O ${BASE_ISO_IMAGE_NAME} http://nl.archive.ubuntu.com/ubuntu-cdimage-xubuntu/releases/18.04/release/xubuntu-18.04.2-desktop-amd64.iso 
fi 
sleep 1 
sudo rm -rf ~/custom-img/  || true 


mkdir -p ~/custom-img/
echo "cp ${BASE_ISO_IMAGE_PATH} ~/custom-img/"
cp -v ${BASE_ISO_IMAGE_PATH} ~/custom-img/
cd ~/custom-img
ls -alh 

mkdir mnt
sudo mount -o loop ${BASE_ISO_IMAGE_NAME} mnt

mkdir iso_image_disk

rsync --exclude=/casper/filesystem.squashfs -a mnt/ iso_image_disk
ls -alh iso_image_disk/

sudo rm -rf squashfs-root || true 
sudo unsquashfs mnt/casper/filesystem.squashfs
mv squashfs-root new_chroot

#sudo cp -rv ${BUILD_TOOLS_ROOT}/includes.chroot/* new_chroot/

sudo bash customization-script.sh ${BUILD_TOOLS_ROOT}

sudo cp /etc/resolv.conf new_chroot/etc/

sudo mount --bind /dev/ new_chroot/dev
sudo chroot new_chroot

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts


export HOME=/root
export LC_ALL=C
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

apt-get update && apt-get -y upgrade
source functions.sh

install_custom_packages

apt-get autoremove && apt-get autoclean
rm -rf /tmp/* ~/.bash_history
rm /var/lib/dbus/machine-id
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl

#Unmount the directories from the beginning of this guide:

umount /proc || umount -lf /proc
umount /sys
umount /dev/pts
exit
sudo umount new_chroot/dev

#Generate a new file manifest:
sudo chmod +w iso_image_disk/casper/filesystem.manifest
sudo chroot new_chroot dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee iso_image_disk/casper/filesystem.manifest
sudo cp iso_image_disk/casper/filesystem.manifest iso_image_disk/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' iso_image_disk/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' iso_image_disk/casper/filesystem.manifest-desktop

#Compress the filesystem:
sudo mksquashfs new_chroot iso_image_disk/casper/filesystem.squashfs -b 1048576

#Update filesystem size (needed by the installer):
printf $(sudo du -sx --block-size=1 new_chroot | cut -f1) | sudo tee iso_image_disk/casper/filesystem.size

#Delete the old md5sum:
cd iso_image_disk
sudo rm md5sum.txt

#…and generate a fresh one: (single command, copy and paste in one piece)

find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt

#And finally, create the ISO. This is a single long command, be sure to copy and paste it in one piece and don’t forget the period at the end, it’s important:

DATE_TIME=`date '+%Y-%m-%d_%H%M'`
sudo genisoimage -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../my-buntu-18.04.4-${DATE_TIME}.iso . 


cd ..
ls -alh `pwd`/my-buntu-18.04.4-${DATE_TIME}.iso
exit 0 

```


## DRAFT - testing Live build - not sure it that will work 

```
mkdir -p my-buntu/live-build-xubuntu-dwm
cd my-buntu/live-build-xubuntu-dwm

#sudo lb config --debian-installer live -d buster --debian-installer-distribution daily

BASECODENAME="bionic"
CODENAME="bionic"
KERNEL_FLAVORS="generic"
MIRROR_URL="http://archive.ubuntu.com/ubuntu/"
NAME="my-buntu-dwm"
BASEVERSION="18.04"

sudo lb config noauto \
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
    --bootappend-live "boot=casper maybe-ubiquity quiet splash" \
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
    --zsync false


#add your packages to config/package-lists/live.list.chroot
#add your customization files to config/includes.chroot/
#when rebuilding run also clean
sudo lb clean --purge

#build ISO
sudo lb build --debug --verbose 2>&1 |tee ${NAME}-`date '+%Y-%m-%d_%H%M%S'`.log



mkdir artifacts
docker run --privileged -i \
    -v /proc:/proc \
    -v ${PWD}/artifacts:/artifacts \
    -v ${PWD}:/working_dir \
    -w /working_dir \
    debian:latest \
    /bin/bash < build.sh

```
