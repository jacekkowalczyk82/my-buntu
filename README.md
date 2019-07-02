# my-buntu
Build scripts and customization files to build custom Ubuntu ISO image

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

* run as root user:

```
apt -y install squashfs-tools genisoimage


BUILD_TOOLS_ROOT=`pwd`
cd ~/

BASE_ISO_IMAGE_NAME="xubuntu-18.04.2-desktop-amd64.iso"
BASE_ISO_IMAGE_PATH=~/Downloads/${BASE_ISO_IMAGE_NAME}
if [ ! -e ${BASE_ISO_IMAGE} ]; then
	wget -O ${BASE_ISO_IMAGE} http://nl.archive.ubuntu.com/ubuntu-cdimage-xubuntu/releases/18.04/release/xubuntu-18.04.2-desktop-amd64.iso 
fi 
sleep 1 
mkdir -p ~/custom-img/
set -x 
echo "cp ${BASE_ISO_IMAGE_PATH} ~/custom-img/"
cp ${BASE_ISO_IMAGE_PATH} ~/custom-img/
cd ~/custom-img
ls -alh 

mkdir mnt
sudo mount -o loop ${BASE_ISO_IMAGE_NAME} mnt

mkdir iso_image_disk
#rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract
rsync --exclude=/casper/filesystem.squashfs -a mnt/ iso_image_disk
ls -alh iso_image_disk/

sudo rm -rf squashfs-root
sudo unsquashfs mnt/casper/filesystem.squashfs
mv squashfs-root new_chroot


sudo cp -v ${BUILD_TOOLS_ROOT}/config/packages.list new_chroot/
sudo cp -v ${BUILD_TOOLS_ROOT}/config/functions.sh new_chroot/
sudo mkdir -p new_chroot/opt/
sudo cp -rv ${BUILD_TOOLS_ROOT}/suckless.org/dwm new_chroot/opt/
sudo cp -rv ${BUILD_TOOLS_ROOT}/config/etc/skel new_chroot/etc/

sudo mkdir -p new_chroot/usr/share/xsessions/
sudo cp -rv ${BUILD_TOOLS_ROOT}/config/usr/share/xsessions/custom-dwm.desktop new_chroot/usr/share/xsessions/



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
sudo chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee iso_image_disk/casper/filesystem.manifest
sudo cp iso_image_disk/casper/filesystem.manifest iso_image_disk/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' iso_image_disk/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' iso_image_disk/casper/filesystem.manifest-desktop

#Compress the filesystem:
sudo mksquashfs new_chroot iso_image_disk/casper/filesystem.squashfs -b 1048576

#Update filesystem size (needed by the installer):
printf $(sudo du -sx --block-size=1 new_chroot | cut -f1) | sudo tee iso_image_disk/casper/filesystem.size




```
