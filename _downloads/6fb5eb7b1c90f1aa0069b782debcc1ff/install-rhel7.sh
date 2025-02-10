#!/bin/bash 

sudo qemu-system-x86_64 -cpu host -smp 2 -m 1024 -hda rhel7.qcow2 -cdrom rhel-server-7.7-x86_64-dvd.iso -boot d --enable-kvm -vga virtio -vnc :0
