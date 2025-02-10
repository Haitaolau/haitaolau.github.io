#!/bin/bash 

test -d "elxr-minimal-ostree-amd64" && rm -rf elxr-minimal-ostree-amd64/  

mkdir -p elxr-minimal-ostree-amd64/rootfs 

tar -C elxr-minimal-ostree-amd64/rootfs --exclude=./dev/* -zxf elxr-ostree-0.1-amd64.tar.gz --numeric-owner
