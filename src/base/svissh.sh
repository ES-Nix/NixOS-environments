

{ qemu-kvm \
-boot c \
-cpu host \
-device "rtl8139,netdev=net0" \
-drive format=raw,file=nixos.img \
-enable-kvm \
-m 12G \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980" \
-nographic \
-smp $(nproc) \
-uuid 366f0d14-0de1-11e4-b0fa-82c9dd2b1400 < /dev/null & } \
&& sleep 60 \
&& ssh-keygen -R '[127.0.0.1]:10023' \
&& ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no
