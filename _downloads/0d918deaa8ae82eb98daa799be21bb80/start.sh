#!/bin/bash 

sudo qemu-system-x86_64 -cpu host \
	-smp 8 -m 8192 \
	-hda elxr-dev.qcow2 \
	-cdrom elxr-12.9.0.0-amd64-CD-1.iso \
	-enable-kvm -vga virtio -vnc :3 \
	-device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22
