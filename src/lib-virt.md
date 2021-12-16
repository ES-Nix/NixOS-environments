# Lib virt


```bash
virt-install \
--name=nixos \
--memory=8196 \
--vcpus=2 \
--disk=my-nixos-disk-image.qcow2,device=disk,bus=virtio,size=10 \
--cdrom=nixos-minimal-21.11.334247.573095944e7-x86_64-linux.iso \
--os-type=generic  \
--boot=uefi \
--graphics none \
--console=pty,target_type=virtio
```
Refs.:
- [Test-Driving a NixOS VM Using Libvirt](https://www.technicalsourcery.net/posts/nixos-in-libvirt/)


```bash
virsh destroy nixos
virsh undefine nixos --nvram
rm -fv my-nixos-disk-image.qcow2
```


```bash
virt-install \
--name=nixos \
--memory=8196 \
--vcpus=2 \
--disk=my-nixos-disk-image.qcow2,device=disk,bus=virtio,size=10 \
--location nixos-minimal-21.11.334247.573095944e7-x86_64-linux.iso \
--os-type=generic  \
--boot=uefi \
--nographics \
--console=pty,target_type=virtio
```

```bash
virt-install \
--name=nixos \
--memory=8196 \
--vcpus=2 \
--disk=my-nixos-disk-image.qcow2,device=disk,bus=virtio,size=10 \
--location nixos-minimal-21.11.334247.573095944e7-x86_64-linux.iso \
--os-type=generic  \
--boot=uefi \
--nographics \
--extra-args console=ttyS0
```

```bash
virt-install \
--name theta-1 \
--ram 4000 \
--disk=my-nixos-disk-image.qcow2,device=disk,bus=virtio,size=10 \
--vcpus 4 \
--os-type generic \
--graphics none \
--console pty,target_type=serial \
--location=nixos-minimal-21.11.334247.573095944e7-x86_64-linux.iso \
--extra-args 'console=ttyS0,115200n8 serial'
```



```bash
qemu-system-x86_64 \
-bios /run/libvirt/nix-ovmf/OVMF_VARS.fd \
-cdrom ubuntu-21.04-desktop-amd64.iso
```
Refs.:
- [How To Boot UEFI on QEMU](https://www.ubuntubuzz.com/2021/04/how-to-boot-uefi-on-qemu.html)



nix shell nixpkgs#cdrtools

isoinfo -J -i 'nixos-minimal-21.11.334247.573095944e7-x86_64-linux.iso' -l


```bash
virt-install \
--name=ubuntu \
--memory=8196 \
--vcpus=2 \
--disk=my-ubuntu-disk-image.qcow2,device=disk,bus=virtio,size=10 \
--cdrom=ubuntu-20.04.3-desktop-amd64.iso \
--os-type=generic  \
--boot=uefi \
--nographics \
--console=pty,target_type=virtio
```


```bash
virt-install \
--name=ubuntu \
--memory=8196 \
--vcpus=2 \
--disk=my-ubuntu-disk-image.qcow2,device=disk,bus=virtio,size=10 \
--os-type=generic \
--boot=uefi \
--graphics none \
--location=ubuntu-20.04.3-desktop-amd64.iso,initrd=casper/initrd.img,kernel=casper/vmlinuz \
--extra-args 'console=ttyS0,115200n8 serial'
```

```bash
virt-install \
--name=ubuntu \
--memory=8196 \
--vcpus=2 \
--os-type=generic \
--boot=uefi \
--graphics=none \
--disk=my-ubuntu-disk-image.qcow2,device=disk,bus=virtio,size=10 \
--location=ubuntu-20.04.3-desktop-amd64.iso \
--extra-args console=ttyS0
```


```bash
virt-install \
--name=nixos \
--memory=8196 \
--vcpus=2 \
--disk=my-nixos-disk-image.qcow2,device=disk,bus=virtio,size=10 \
--cdrom=nixos-minimal-21.11.334247.573095944e7-x86_64-linux.iso \
--os-type=generic \
--boot=uefi \
--graphics none \
--console=pty,target_type=virtio
```
Refs.:
- [Test-Driving a NixOS VM Using Libvirt](https://www.technicalsourcery.net/posts/nixos-in-libvirt/)



```bash
virt-install \
--name debian8 \
--ram 1024 \
--disk path=./debian8.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://ftp.nl.debian.org/debian/dists/jessie/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```
Refs.:
- [Installing Virtual Machines with virt-install, plus copy pastable distro install one-liners](https://raymii.org/s/articles/virt-install_introduction_and_copy_paste_distro_install_commands.html#toc_2)


```bash
virsh destroy debian8
virsh undefine debian8 --nvram
rm -fv debian8
```


```bash
virt-install \
--name debian8 \
--ram 1024 \
--disk path=./nixos.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'nixos-minimal-21.11.334247.573095944e7-x86_64-linux.iso' \
--extra-args 'console=ttyS0,115200n8 serial'
```
