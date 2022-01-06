#!/usr/bin/env bash

time (
kill -9 $(pidof qemu-system-x86_64); \
rm -fv nixos.img nixos-21.11pre-git-x86_64-linux-kubernetes.iso \
&& nix build github:ES-Nix/NixOS-environments/box#iso-kubernetes \
&& cp -fv result/iso/nixos-21.11pre-git-x86_64-linux.iso nixos-21.11pre-git-x86_64-linux-kubernetes.iso  \
&& chmod +x nixos-21.11pre-git-x86_64-linux-kubernetes.iso \
&& qemu-img create nixos.img 12G
)


time (
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
&& { ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no <<EOF
sudo my-install-mrb
sudo poweroff
EOF
} && echo 'End.'
)
# Maybe make a backup?
# time (
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos.img nixos-mrb-part-1.img.backup
# )

# Maybe restore a backup?
# time (
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos.img.backup nixos.img
# )

time (
kill -9 $(pidof qemu-system-x86_64); \
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
&& { ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no <<EOF
echo '123' | sudo -S nixos-rebuild test --flake '/etc/nixos'#"\$(hostname)"
echo '123' | sudo -S first-rebuild-switch
echo '123' | sudo -S reboot
EOF
} && echo 'End.'
)
# Maybe make a backup?
# time (
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos.img nixos-mrb-part-2.img.backup
# )

# Maybe restore a backup?
# time (
# kill -9 $(pidof qemu-system-x86_64); \
# cp -f nixos-mrb-part-2.img.backup nixos.img
# )

time (
kill -9 "$(pidof qemu-system-x86_64)"; \
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
&& { ssh nixuser@127.0.0.1 -p 10023 -o StrictHostKeyChecking=no <<EOF
echo '123' | sudo -S kubeadm certs renew all

echo '123' | sudo -S systemctl restart kube-apiserver
echo '123' | sudo -S systemctl restart kube-controller-manager
echo '123' | sudo -S systemctl restart kube-scheduler
echo '123' | sudo -S systemctl restart etcd

mkdir -pv "\$HOME"/.kube
echo '123' | sudo -S cp -fv /etc/kubernetes/cluster-admin.kubeconfig "\$HOME"/.kube/config
#echo '123' | sudo -S cp -fv /etc/kubernetes/admin.conf "\$HOME"/.kube/config
#echo '123' | sudo -S cp -fv /etc/kubernetes/kubelet.conf "\$HOME"/.kube/config
echo '123' | sudo -S chmod -v 0644 "\$HOME"/.kube/config
echo '123' | sudo -S chown -v \$(id -u):\$(id -g) "\$HOME"/.kube/config

echo '123' | sudo -S chown kubernetes:kubernetes -Rv /var/lib/kubernetes
# echo '123' | sudo -S stat /var/lib/kubernetes
echo '123' | sudo -S chmod -Rv 0775 /var/lib/kubernetes

# ?
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
EOF
} && echo 'End.'
)


time (
kill -9 "$(pidof qemu-system-x86_64)"; \
cp -f nixos.img nixos-mrb-part-3.img.backup
)
