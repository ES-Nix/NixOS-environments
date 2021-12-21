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
-cdrom ubuntu-20.04.3-desktop-amd64.iso


qemu-system-x86_64 \
-bios /run/libvirt/nix-ovmf/OVMF_CODE.fd \
-cdrom ubuntu-20.04.3-desktop-amd64.iso


sudo \
qemu-system-x86_64 \
-drive format=raw,file=nixos-uefi.img \
-enable-kvm \
-bios /run/libvirt/nix-ovmf/OVMF_VARS.fd \
-drive if=pflash,format=raw,readonly=on,file=/run/libvirt/nix-ovmf/OVMF_CODE.fd \
-drive if=pflash,format=raw,file=/run/libvirt/nix-ovmf/OVMF_VARS.fd \
-cdrom ubuntu-20.04.3-desktop-amd64.iso

sudo \
qemu-system-x86_64 \
-drive format=raw,file=nixos-uefi.img \
-enable-kvm \
-nographic \
-bios /run/libvirt/nix-ovmf/OVMF_VARS.fd \
-drive if=pflash,format=raw,readonly=on,file=/run/libvirt/nix-ovmf/OVMF_CODE.fd \
-drive if=pflash,format=raw,file=/run/libvirt/nix-ovmf/OVMF_VARS.fd \
-cdrom ubuntu-20.04.3-desktop-amd64.iso

--machine q35,accel=kvm,kernel_irqchip=split \
-device intel-iommu,intremap=on \

-boot c -drive file=/dev/sda,if=ide,index=0 -serial none -parallel none

qemu-img create nixos-uefi.img 10G \
&& echo 'Starting VM'

sudo \
qemu-kvm \
-drive format=raw,file=nixos-uefi.img,if=virtio \
-enable-kvm \
-drive if=pflash,format=raw,readonly=on,file=/run/libvirt/nix-ovmf/OVMF_CODE.fd \
-drive if=pflash,format=raw,file=/run/libvirt/nix-ovmf/OVMF_VARS.fd \
-cdrom ubuntu-20.04.3-desktop-amd64.iso

qemu-system-x86_64 \
-drive format=raw,file=nixos-uefi.img \
-enable-kvm \
-bios /run/libvirt/nix-ovmf/OVMF_VARS.fd \
-cdrom ubuntu-20.04.3-desktop-amd64.iso

qemu-system-x86_64 \
-drive format=raw,file=nixos-uefi.img \
-enable-kvm \
-bios "$(nix eval --raw nixpkgs#OVMF.fd)/FV/OVMF_VARS.fd" \
-cdrom ubuntu-20.04.3-desktop-amd64.iso

qemu-system-x86_64 \
-bios "$(nix eval --raw nixpkgs#OVMF.fd)/FV/OVMF_VARS.fd" \
-drive format=raw,file=nixos-uefi.img \
-enable-kvm \
-L "$(nix eval --raw github:NixOS/nixpkgs/a640d8394f34714578f3e6335fc767d0755d78f9#qemu)/share/qemu/bios.bin" \
-cdrom ubuntu-20.04.3-desktop-amd64.iso


sudo qemu-kvm \
-drive format=raw,file=nixos-uefi.img \
-enable-kvm \
--machine q35,accel=kvm,kernel_irqchip=split \
-device intel-iommu,intremap=on \
-drive if=pflash,format=raw,readonly=on,file=/run/libvirt/nix-ovmf/OVMF_CODE.fd \
-drive if=pflash,format=raw,file=/run/libvirt/nix-ovmf/OVMF_VARS.fd \
-cdrom ubuntu-20.04.3-desktop-amd64.iso


qemu-kvm \
-boot d \
-drive format=raw,file=nixos-uefi.img \
-cdrom nixos-21.11pre-git-x86_64-linux.iso \
-m 18G \
--machine q35,accel=kvm,kernel_irqchip=split \
-enable-kvm \
-drive if=pflash,format=raw,readonly=on,file=/run/libvirt/nix-ovmf/OVMF_CODE.fd \
-drive if=pflash,format=raw,file=/run/libvirt/nix-ovmf/OVMF_VARS.fd \
-cpu host \
-smp $(nproc)

-device "rtl8139,netdev=net0"
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




### Fedora ISO

```bash
curl https://getfedora.org/static/fedora.gpg | gpg --import
```

```bash
curl -O https://getfedora.org/static/checksums/35/iso/Fedora-Workstation-35-1.2-x86_64-CHECKSUM
```

```bash
sha256sum -c *-CHECKSUM
```

```bash
gpg --verify Fedora-Workstation-35-1.2-x86_64-CHECKSUM
```

Refs.:
- https://ask.fedoraproject.org/t/sha256sum-on-f32-iso-what-does-the-message-mean/6617/2
- https://forums.fedoraforum.org/showthread.php?312802-The-CHECKSUM-file&p=1778941#post1778941


```bash
nix shell nixpkgs#gptfdisk
```

```bash
gdisk -l nixos-21.11pre-git-x86_64-linux.iso
gdisk -l ubuntu-20.04.3-desktop-amd64.iso
```



[Howto: QEMU w/ Ubuntu Xenial host + UEFI guest](https://blog.system76.com/post/139138591598/howto-uefi-qemu-guest-on-ubuntu-xenial-host)

```bash
cp /run/libvirt/nix-ovmf/OVMF_VARS.fd example_OVMF_VARS.fd
qemu-img create -f qcow2 example.qcow2 10G

sudo \
qemu-system-x86_64 \
  -m 1G \
  -enable-kvm \
  -drive if=pflash,format=raw,readonly=on,file=/run/libvirt/nix-ovmf/OVMF_VARS.fd \
  -drive if=pflash,format=raw,file=example_OVMF_VARS.fd \
  -drive if=virtio,file=example.qcow2 \
  -cdrom ubuntu-20.04.3-desktop-amd64.iso

rm -fv example_OVMF_VARS.fd
rm -fv example.qcow2
```

-vga qxl \
--machine q35,accel=kvm,kernel_irqchip=split \
-device intel-iommu,intremap=on \

```bash
cp -v /run/libvirt/nix-ovmf/OVMF_VARS.fd example_OVMF_VARS.fd
chmod -v 0644 example_OVMF_VARS.fd
qemu-img create -f qcow2 example2.qcow2 10G

qemu-system-x86_64 \
  -m 1G \
  -enable-kvm \
  -cpu host,kvm=off \
  -drive if=pflash,format=raw,readonly=on,file=/run/libvirt/nix-ovmf/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=example_OVMF_VARS.fd \
  -drive if=virtio,file=example2.qcow2 \
  -machine q35,accel=kvm,kernel_irqchip=split \
  -device intel-iommu,intremap=on \
  -device vfio-pci,host=0000:02:00.0 \
  -boot order=dc \
  -serial none -parallel none \
  -cdrom ubuntu-20.04.3-desktop-amd64.iso

rm -fv example_OVMF_VARS.fd
rm -fv example2.qcow2
```
Refs.:
- https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Plain_QEMU_without_libvirt


```bash
cat << EOF > ~/.config/libvirt/qemu.conf
nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
EOF
```

Refs.:
- 

Tests commands:
```bash
dmesg | grep -e IOMMU -e DMAR

cat /sys/power/mem_sleep

sudo dmesg | grep -i acpi | grep supports

sudo modprobe msr

nix shell nixpkgs#pciutils
lspci -tv

dmesg | grep -iE "dmar|iommu" 

sudo journalctl -k | grep 'DMAR\|iommu' | sed 's/^.*kernel: //'

dmesg | grep 'remapping'

grep -w -o lm /proc/cpuinfo | uniq

# Must match boot.kernelModules
lsmod | grep vfio

virt-host-validate

lscpu

nix shell nixpkgs#coreboot-utils

lspci -nn -D | grep VGA
BDF="0000:00:02.0"

readlink -e /sys/bus/pci/devices/0000:00:02.0

ls -al /sys/devices/pci*
```
Refs.:
- 