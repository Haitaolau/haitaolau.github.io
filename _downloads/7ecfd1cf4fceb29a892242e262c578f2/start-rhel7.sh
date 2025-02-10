#!/bin/bash 

sudo qemu-system-x86_64 -cpu host -smp 2 -m 1024 -hda rhel7.qcow2 --enable-kvm -vga virtio -vnc :0 -cdrom rhel-server-7.7-x86_64-dvd.iso -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22

