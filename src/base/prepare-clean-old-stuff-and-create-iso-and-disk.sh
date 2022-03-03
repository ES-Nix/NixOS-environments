#!/usr/bin/env bash


ISO_NAME='nixos-21.11pre-git-x86_64-linux.iso'
ISO_NAME_K8S='nixos-21.11pre-git-x86_64-linux-kubernetes.iso'

kill -9 "$(pidof qemu-system-x86_64)"; \
rm -fv nixos.img "$ISO_NAME_K8S"


# TODO: make it work for remote too
test -f result/iso/"$ISO_NAME" || nix build #iso
cp -fv result/iso/"$ISO_NAME" "$ISO_NAME_K8S"

chmod +x "$ISO_NAME_K8S" \
&& qemu-img create nixos.img 12G