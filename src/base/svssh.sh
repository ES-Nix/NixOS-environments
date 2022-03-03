#!/usr/bin/env bash


IMAGE_NAME="${1:-nixos.img}"
ISO_NAME="${2:-nixos-21.11pre-git-x86_64-linux-kubernetes.iso}"
PORT="${3:-10023}"
UUID="${4:-$(uuidgen)}"
IP="${5:-127.0.0.1}"
USER="${6:-nixuser}"


# echo 'AAAA'
virtual-machine-ssh

start-qemu-vm-in-backround -in "${IMAGE_NAME}" -is "${ISO_NAME}" -p "${PORT}" -u "${UUID}"

retry 100 virtual-machine-ssh "${USER}" "${IP}" "${PORT}"
