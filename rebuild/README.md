
```bash
sudo su

cd /etc/nixos/

rm configuration.nix

vim configuration.nix

vim flake.nix

git init 
git add .

nixos-rebuild switch --flake '/etc/nixos#vm'
```



parted -l
fdisk -l


sudo fdisk /dev/sda

# Format first partition as FAT32
mkfs.fat -F 32 -n boot /dev/sda1

# Format second partition as ext4 (can be xfs or btrfs) and label it as 'nixos' (any label is fine)
mkfs.ext4 -L nixos /dev/sda2

# Swap partition
mkswap -L swap /dev/sda3



mkdir -p /mnt
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda3


nixos-generate-config –root /mnt

nixos-install --no-root-passwd

shutdown -r now


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

- https://nixos.wiki/wiki/NixOS_Installation_Guide
- https://github.com/NixOS/nixpkgs/issues/55332
- https://mdleom.com/blog/2021/03/09/nixos-oracle/
- https://discourse.nixos.org/t/how-to-deal-with-grub-error-during-nixos-install-flake/12800
- https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows
- https://gianarb.it/blog/how-i-started-with-nixos
- https://unix.stackexchange.com/a/164595
- https://github.com/NixOS/nixpkgs/issues/13106
- https://github.com/NixOS/nixpkgs/issues/38477
- https://github.com/aljce/nixos-configuration/blob/4a5439cdb3af3fad3724f871f156ae967a8a4dde/install/iso.nix#L10
- https://discourse.nixos.org/t/how-to-override-set-isoimage-contents/5763/4
- https://githubmemory.com/repo/colemickens/nixcfg/issues/3
- https://totaltrash.xyz/posts/blog/install-nixos.html
- https://superuser.com/a/332322
- https://linuxhint.com/install-nix-os/
- https://stackoverflow.com/questions/24727789/nixos-boot-loader-extra-entry-format
- https://discourse.nixos.org/t/booting-nixos-installation-iso-fails-on-hosters-qemu-kvm-virtual-machine/8783/5 and https://search.nixos.org/packages?channel=21.11&show=cdrtools&from=0&size=50&sort=relevance&type=packages&query=cdrtools
- https://github.com/NixOS/nixpkgs/issues/94210
- https://calcagno.blog/m1dev/


Download the ISO from https://nixos.org/download.html

```bash
nix \
shell \
github:NixOS/nixpkgs/96b4157790fc96e70d6e6c115e3f34bba7be490f#qemu
```

To be able to use KVM your user need has permission to access `/dev/kvm` and in your BIOS nestest virtualization need to enable!

```bash
qemu-img create -f raw nixos.img 11G # Is it big enough??

qemu-system-x86_64 \
-enable-kvm \
-m 8192 \
-boot d \
-cdrom nixos-gnome-21.11.333896.a640d8394f3-x86_64-linux.iso \
-hda nixos.img
```

To solve a warning change `-hda nixos.img` to `-drive format=raw,file=nixos.img`.

```bash
qemu-system-x86_64 \
-enable-kvm \
-m 8192 \
-boot a \
-hda nixos.img
```

```bash
qemu-kvm --help | rg -e '-boot ' -A5
```


### BIOS


```bash
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MiB -2GiB
parted /dev/sda -- mkpart primary linux-swap -8GiB 100%

mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2
nixos-generate-config --root /mnt

sed -i 's/  # boot.loader.grub.device = /  boot.loader.grub.device = /' /mnt/etc/nixos/configuration.nix
nixos-install --no-root-passwd

shutdown -r now
```
