#!/bin/bash 
#
#

/usr/bin/mmdebstrap \
	--architecture amd64 \
	--verbose \
	--include=systemd-boot \
	--include=dracut \
	--include=linux-image-amd64 \
	--include=ca-certificates \
	--include=vim \
	--include=sudo \
	--include=net-tools \
	--include=openssh-client \
	--include=openssh-server \
	--include=procps \
	--include=less \
	--include=dbus \
	--include=policykit-1 \
	--include=curl \
	--include=wget \
	--include=ca-certificates \
	--include=ostree \
	--include=ostree-boot \
	--include=python3-apt-ostree \
	--include=uefi-ext4 \
	--include=systemd-resolved \
	--include=cloud-guest-utils \
	--include=xterm \
	--customize-hook='sync-in overlay/ostree/usr/lib /usr/lib' \
	--customize-hook='echo "root:root" | chroot "$1" chpasswd' \
	--customize-hook='systemctl enable --root="$1" systemd-networkd' \
	--customize-hook='systemctl enable --root="$1" elxr-growfs' \
	--customize-hook='chroot $1 echo "localhost" > $1/etc/hostname' \
	--customize-hook='mkdir -p $1/efi' \
	--setup-hook='sync-in overlay/debian/ /' \
	bookworm \
	/usr/src/tmp/elxr-ostree-0.1-amd64.tar.gz \
	/var/tmp/rucksack/elxr.list
