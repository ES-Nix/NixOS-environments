#!/usr/bin/env bash



ISO_NAME='nixos-22.11pre-git-x86_64-linux.iso'

rm -fv "${ISO_NAME}" nixos.img

nix build --refresh .#nixos-iso

cp result/iso/"${ISO_NAME}" .

chmod 0755 "${ISO_NAME}"

qemu-img create nixos.img 16G

echo \
&& qemu-kvm \
-boot order=d nixos.img \
-cdrom "${ISO_NAME}" \
-m 8G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" >/dev/null 2>&1



retry 200 ssh -T -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o StrictHostKeyChecking=accept-new nixuser@127.0.0.1 -p 10023

ssh-keygen -R '[127.0.0.1]:10023' \
&& ssh \
  -o StrictHostKeyChecking=no \
  -o StrictHostKeyChecking=accept-new \
  -o LogLevel=ERROR \
  -i "${HOME}"/.ssh/id_rsa \
  nixuser@127.0.0.1 \
  -p 10023

#-X \
#-Y \
#-o GlobalKnownHostsFile=/dev/null \
#-o UserKnownHostsFile=/dev/null \
#-i "${HOME}"/.ssh/id_rsa \

rm -fv "${ISO_NAME}" nixos.img