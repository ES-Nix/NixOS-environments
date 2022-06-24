#!/usr/bin/env bash



ISO_NAME='nixos-22.11pre-git-x86_64-linux.iso'

nix build --refresh .#nixos-iso

cp result/iso/"${ISO_NAME}" .

chmod 0755 "${ISO_NAME}"

qemu-img create nixos.img 16G \
&& echo \
&& qemu-kvm \
-boot order=d nixos.img \
-cdrom "${ISO_NAME}" \
-m 8G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980"

#ssh-keygen -R '[127.0.0.1]:10023' \
#&& ssh nixuser@127.0.0.1 -X -Y -p 10023 -o StrictHostKeyChecking=no
