#!/usr/bin/env bash

# TODO: Add an check that only root can run this script!
parted -s /dev/sda -- mklabel msdos
parted -s /dev/sda -- mkpart primary 1MiB -2GiB
parted -s /dev/sda -- mkpart primary linux-swap -1GiB 100%

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2

# this is magic/hardcoded too in fileSystems."/".device = "/dev/disk/by-label/nixos";?
mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2
