#!/usr/bin/env bash




nix build --refresh .#nixos-iso

cp result/iso/nixos-21.11pre-git-x86_64-linux.iso .

chmod 0755 nixos-21.11pre-git-x86_64-linux.iso

qemu-img create nixos.img 16G \
&& echo \
&& qemu-kvm \
-boot order=d nixos.img \
-cdrom nixos-21.11pre-git-x86_64-linux.iso \
-m 8G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980"

#ssh-keygen -R '[127.0.0.1]:10023' \
#&& ssh nixuser@127.0.0.1 -X -Y -p 10023 -o StrictHostKeyChecking=no
