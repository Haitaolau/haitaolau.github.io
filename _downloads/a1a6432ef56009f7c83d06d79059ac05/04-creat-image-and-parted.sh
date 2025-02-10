#!/bin/bash 
#
#

CURRENT=`pwd`

LOOPDEV="$(losetup -f)"

IMAGE_NAME="$(pwd)/elxr-minimal-ostree-amd64-0.1-amd64.img"
ROOTFS="$(pwd)/elxr-minimal-ostree-amd64/rootfs"


echo "Create raw image ${IMAGE_NAME}"

test -f "${IMAGE_NAME}" && rm -rf ${IMAGE_NAME}

truncate -s 4G ${IMAGE_NAME}

echo "Attach ${IMAGE_NAME} to ${LOOPDEV}"

losetup --partscan ${LOOPDEV} ${IMAGE_NAME}


echo "Erase available filesystem on ${LOOPDEV}"

wipefs -f -a ${LOOPDEV}


echo "Creating gpt disk label"

parted ${LOOPDEV} --script mklabel gpt 

echo "Creating partition 1: EFI"

parted -a optimal -s ${LOOPDEV} -- mkpart EFI 0% 128MB 
parted -a optimal -s ${LOOPDEV} -- set 1 boot on
parted -a optimal -s ${LOOPDEV} -- set 1 esp on
sfdisk --part-type ${LOOPDEV} 1 c12a7328-f81f-11d2-ba4b-00a0c93ec93b


echo "Creating partition 2: BOOT"

parted -a optimal -s ${LOOPDEV} -- mkpart BOOT 128M 640M
sfdisk --part-type ${LOOPDEV} 2 bc13c2ff-59e6-4262-a352-b275fd6f7172


echo "Creating partition 3: ROOT"

parted -a optimal -s ${LOOPDEV} -- mkpart ROOT 640MB 100%

echo "Formatting filesystems for EFI."

mkfs.vfat -F 32 -n EFI ${LOOPDEV}p1

echo "Formatting filesystems for BOOT."

mkfs -F -t ext4 -L BOOT ${LOOPDEV}p2


echo "Formatting filesystems for ROOT"

mkfs -F -t ext4 -L ROOT ${LOOPDEV}p3


echo "Mounting ${LOOPDEV}"

systemd-dissect -m ${LOOPDEV} ${ROOTFS}


echo "Creating ${ROOTFS}/ostree/repo"

test -d "${ROOTFS}/ostree/repo" || mkdir -p ${ROOTFS}/ostree/repo

echo "Create ostree repository"

ostree init --repo ${ROOTFS}/ostree/repo --mode archive-z2

echo "Pull ostree from /var/www/html/repo"

echo "Pulling elxr/amd64 from /var/www/html/repo" 

ostree pull-local --repo ${ROOTFS}/ostree/repo /var/www/html/repo elxr/amd64

echo "Updating summary of ostree repository"

ostree summary -u --repo=${ROOTFS}/ostree/repo

echo "Deploy ostree elxr/amd64 to ${LOOPDEV}"
echo "Configuring ${LOOPDEV} for ostree"

ostree admin init-fs ${ROOTFS}

ostree admin os-init --sysroot ${ROOTFS} elxr

echo "Deploying elxr/amd64"

ostree admin deploy --sysroot ${ROOTFS} --os elxr elxr/amd64 --karg=root=LABEL=ROOT --karg=rw --karg='console=ttyS0,115200n8 console=tty0'

echo "Restoring /var"
VAR_SRC=$(realpath ${ROOTFS}/ostree/deploy/elxr/deploy/*.0)
VAR_DST="${ROOTFS}/ostree/deploy/elxr"
echo "Copying ${VAR_SRC}/usr/rootdirs/var/ -> ${VAR_DST}"

cp -af ${VAR_SRC}/usr/rootdirs/var ${VAR_DST}

echo "Installing boot loader for OSTree"
bwrap --bind ${VAR_SRC} / \
	--proc /proc \
	--dev-bind /dev /dev \
	--dir /run \
	--bind /sys /sys \
	--dir /run \
	--bind /tmp /tmp \
	--share-net \
	--die-with-parent \
	--chdir / \
	--bind ${ROOTFS}/boot /boot \
	--bind ${ROOTFS}/efi /efi \
	bootctl \
	install \
	--boot-path /boot \
	--no-variables \
	--entry-token \
	os-id 

echo "Configuring boot loader"

sed -i 's/#timeout/timeout/' ${ROOTFS}/efi/loader/loader.conf

echo "Install ext4 file system driver for UEFI"

cp ${VAR_SRC}/usr/share/edk2/drivers ${ROOTFS}/efi/EFI/systemd/ -rfv 

echo "Unmounting ${LOOPDEV}"

systemd-dissect -u ${ROOTFS}

echo "Compress image $CURRENT/elxr-minimal-ostree-amd64-0.1-amd64.img"

zstd -3 --keep -f -T128 $CURRENT/elxr-minimal-ostree-amd64-0.1-amd64.img


