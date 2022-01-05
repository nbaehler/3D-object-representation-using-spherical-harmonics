#!/bin/bash
# Normally count=4 but for SPHARM you need 32

sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=1G count=32
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# Should contain: /swapfile none swap sw 0 0
cat /etc/fstab
grep SwapTotal /proc/meminfo
