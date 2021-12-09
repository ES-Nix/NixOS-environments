
```bash


```bash
qemu-img create nixos.img 16G \
&& echo \
&& qemu-kvm \
-boot order=d nixos.img \
-cdrom nixos-gnome-21.11.333896.a640d8394f3-x86_64-linux.iso \
-m 8G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980"
```


```bash
qemu-img create nixos.img 16G \
&& echo \
&& qemu-kvm \
-boot d \
-cdrom nixos-gnome-21.11.333896.a640d8394f3-x86_64-linux.iso \
-hda nixos.img \
-m 8G \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:29980"
```
Refs.:
- http://www.cs.fsu.edu/~langley/CNT4603/2019-Fall/assignment-nixos-2019-fall.html

```bash
qemu-system-kvm -enable-kvm -m 8192 -boot a -hda nixos.img
```

```bash
nix build .#empty-qcow2
cp result/nixos.qcow2 nixos.qcow2
chmod 0755 nixos.qcow2

qemu-kvm \
-drive "file=nixos.qcow2,format=qcow2" \
-m 8G \
-enable-kvm \
-nographic
```
