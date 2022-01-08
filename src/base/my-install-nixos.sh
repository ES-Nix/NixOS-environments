#!/usr/bin/env bash

# sudo gdisk -l /dev/sda | rg -q 'MBR: MBR only' || echo 'Error'

[ -d /sys/firmware/efi ] && echo 'The system was detected as ''UEFI' || echo 'The system was detected as ''BIOS'

[ -d /sys/firmware/efi ] && install-nixos-with-parted-in-gpt || install-nixos-with-parted-in-mbr
