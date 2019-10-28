# Building Ubuntu custom ISO with bulifs

* https://launchpad.net/~bfeber/+archive/ubuntu/bulifs

```
sudo add-apt-repository ppa:bfeber/bulifs
sudo apt-get update
sudo apt-get install bulifs

mkdir customIso
cd customIso

bulifs config 

mkdir -p work/chroot/var/tmp/
touch work/chroot/var/tmp/packages.list.bak
bulifs build

```

