#!/bin/bash 

test -f elxr-dev.qcow2 && rm elxr-dev.qcow2

qemu-img create -f qcow2 elxr-dev.qcow2 60G

sudo qemu-system-x86_64 -cpu host -smp 2  -m 1024 -hda elxr-dev.qcow2 -cdrom elxr-12.9.0.0-amd64-CD-1.iso -boot d --enable-kvm -vga virtio -vnc :3
