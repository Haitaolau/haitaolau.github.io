#!/bin/bash 

ROOTFS=$(realpath elxr-minimal-ostree-amd64/rootfs/)

test -d "/var/www/html/repo" && rm -rf /var/www/html/repo

mkdir -p /var/www/html/repo

ostree init --repo /var/www/html/repo --mode archive-z2 

cd ${ROOTFS}

echo "Setup up the ostree bootdir"

KERNEL_VERSION=`ls boot/vmlinuz* | sed 's/.*vmlinuz-\(.*\)/\1/'`

mv boot/vmlinuz* usr/lib/modules/${KERNEL_VERSION}/vmlinuz
mv boot/initrd.img* usr/lib/modules/${KERNEL_VERSION}/initramfs.img

mv boot/* usr/lib/modules/${KERNEL_VERSION}/

echo "Removing unnecessary files"

test -d "boot/initrd.img" && rm -rf boot/initrd.img

test -d "boot/vmlinuz" && rm -rf boot/vmlinuz

test -d "initrd.img" && rm -rf initrd.img

test -d "initrd.img.old" && rm -rf initrd.img.old

test -d "vmlinuz" && rm -rf vmlinuz

test -d "vmlinuz.old" && rm -rf vmlinuz.old

echo "Moving /var/lib/dpkg to /usr/share/dpkg/database"

mv var/lib/dpkg usr/share/dpkg/database

echo "Backup /var"

mkdir usr/rootdirs

chmod 755 usr/rootdirs

echo "Moving /var to /usr/rootdirs."

mv var/ usr/rootdirs/

mkdir var

chmod 755 var

mv etc usr/

mkdir ostree
mkdir sysroot


echo "Setting up symlinks: media     -> run/media"

rm media -rf
ln -s run/media media

echo "Setting up symlinks. mnt       -> var/mnt"

rm mnt -rf
ln -s var/mnt mnt

echo "Setting up symlinks. opt       -> var/opt"

rm opt -rf 
ln -s var/opt opt

echo "Setting up symlinks. root      -> var/roothome"

rm root -rf 
ln -s var/roothome root

echo "Setting up symlinks. srv       -> var/srv"
rm srv -rf
ln -s var/srv srv

echo "Setting up symlinks. usr/local -> ../var/usrlocal"
rm usr/local -rf
ln -s usr/local var/usrlocal

echo "Committing to ostree"

ostree commit ${ROOTFS} --repo=/var/www/html/repo --branch=elxr/amd64 --subject="Initial commit"

echo "Updating summary of ostree repository"

ostree summary -u --repo=/var/www/html/repo


