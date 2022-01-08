

echo 'Starting VM' \
&& { qemu-kvm \
-boot d \
-drive format=raw,file=nixos.img \
-cdrom nixos-21.11pre-git-x86_64-linux-kubernetes.iso \
-m 12G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-nographic \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" \
-uuid 366f0d14-0de1-11e4-b0fa-82c9dd2b1400 < /dev/null & } \
&& sleep 30 \
&& ssh-keygen -R '[127.0.0.1]:10023' \
&& ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no
