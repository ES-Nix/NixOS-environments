#!/usr/bin/env bash

PORT="${3:-10023}"
IMAGE_NAME="${1:-nixos.img}"
ISO_NAME="${2:-nixos-21.11pre-git-x86_64-linux-kubernetes.iso}"
UUIID="${4:-$(uuidgen)}"



echo 'Starting the Virtual Machine' \
&& { qemu-kvm \
-boot d \
-drive format=raw,file="${IMAGE_NAME}" \
-cdrom "${ISO_NAME}" \
-m 12G \
-enable-kvm \
-cpu host \
-smp "$(nproc)" \
-nographic \
-device "rtl8139,netdev=net0" \
-netdev 'user,id=net0,hostfwd=tcp:127.0.0.1:'"${PORT}"'-:29980' \
-uuid "${UUIID}" < /dev/null & }
