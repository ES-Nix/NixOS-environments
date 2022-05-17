
# NixOS environments

```bash
nix \
develop \
--refresh \
github:ES-Nix/NixOS-environments/box \
--command \
bash \
-c \
"nixos-box-volume"
```

About the `--refresh` [see this issue](https://github.com/NixOS/nix/issues/4743) 
and [this](https://github.com/NixOS/nix/issues/3781#issuecomment-716440620).

For local development:
```bash
nix \
develop \
--refresh \
.# \
--command \
bash \
-c \
"nixos-box-volume"
```

```bash
rm -fv nixos-vm-volume.qcow2 result \
&& nix store gc --verbose
```

Not so obvious, this is the way to update the nixpkgs: 
```bash
nix \
flake \
update \
--override-input \
nixpkgs \
nixpkgs
```

Also, possible:
```bash
nix \
flake \
update \
--override-input \
nixpkgs \
nixpkgs/549044ea1c1e938cd5bcc337b7061edf029691da
```


```bash
nix \
develop \
--refresh \
github:ES-Nix/NixOS-environments/box \
--command \
bash \
-c \
"build \
&& refresh-vm \
&& nixos-box"
```


```bash
nix \
develop \
--refresh \
--command \
bash \
-c \
"build-dev \
&& refresh-vm-dev \
&& ssh-vm"
```

```bash
nix build github:ES-Nix/NixOS-environments#image.image \
&& cp result/nixos.qcow2 nixos-vm-volume.qcow2 \
&& chmod 0755 nixos.qcow2
```


```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos-vm-volume.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```

For now, login as `root` and passwd is `r00t`

You can, once logged in, change de passwd of the user `nixuser` with `passwd nixuser` and logout and
login as the `nixuser` with the passwd that was chosen.

```bash
nix build github:ES-Nix/NixOS-environments#image.image
```

```bash
cp result/nixos.qcow2 nixos.qcow2
chmod 0755 nixos.qcow2
```

TODO: 
- https://discourse.nixos.org/t/list-available-services-and-their-options/6123/13
  and https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-options-doc/default.nix
- https://stackoverflow.com/questions/35075262/nixos-list-all-possible-configuration-options
- https://www.reddit.com/r/NixOS/comments/pgymm4/listing_of_the_100_most_frequently_set_nixos/

TODO:
- [Reproducible NixOS installation w/ flakes](https://www.youtube.com/watch?v=_j8kDS6GLJs)
- [NixOs native flake deployment with LUKS drive encryption and LVM](https://mudrii.medium.com/nixos-native-flake-deployment-with-luks-drive-encryption-and-lvm-b7f3738b71ca)
- https://www.reddit.com/r/NixOS/comments/owfmr0/tutorial_building_bootable_iso_image/


TODO:
- https://github.com/Brettm12345/nixos-config/blob/4fbd8ac7b2faa37e17c54abf8ddf97fee9a00487/modules/overlay.nix#L33-L42

TODO: https://typeclasses.com/nixos-on-aws really interesting

TODO: nixos-option does not support flakes https://github.com/NixOS/nixpkgs/issues/97855

TODO: hardening https://github.com/anoother/etc-nixos/blob/b5865bf75543e2cab0a069f5bebc926b8bc86068/configuration.nix#L96
https://christine.website/blog/paranoid-nixos-2021-07-18


### What about inside an OCI image?


```bash
podman \
run \
--env=PATH=/root/.nix-profile/bin:/usr/bin:/bin \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
docker.nix-community.org/nixpkgs/nix-flakes \
<<COMMANDS
mkdir --parent --mode=0755 ~/.config/nix
echo 'experimental-features = nix-command flakes ca-references ca-derivations' >> ~/.config/nix/nix.conf

nix \
develop \
--refresh \
github:ES-Nix/NixOS-environments/box \
--command \
bash \
-c \
"nixos-box-volume"
COMMANDS
```

### Local development 

Go to the directory that you want to clone and:
```bash
git clone https://github.com/ES-Nix/NixOS-environments.git \
&& cd NixOS-environments
```

```bash
nix build .#image.image
```

```bash
cp result/nixos.qcow2 nixos.qcow2
chmod 0755 nixos.qcow2
```


```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```


```bash
nix build .#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2 \
&& qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```


### The cacerts


```bash
ls -al /nix/store/ | grep cert
```

```bash
ls /etc/ssl/certs
```



TODO:
- [Erase your darlings](https://grahamc.com/blog/erase-your-darlings)
- [NixOs Native Flake Deployment With LUKS Drive Encryption and LVM](https://dzone.com/articles/nixos-native-flake-deployment-with-luks-and-lvm)
- [Encypted Btrfs Root with Opt-in State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)
- https://www.reddit.com/r/NixOS/comments/ebgezb/passwordless_ssh_authentication_in_nixos/fb4r5cj/?utm_source=reddit&utm_medium=web2x&context=3

TODO: the ssh thing
- https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/src/branch/ylmcc-ssh/services/ssh.nix?lang=pt-PT
- https://nixos.wiki/wiki/Install_NixOS_on_a_Server_With_a_Different_Filesystem


### Tests

```bash
(result/run-vm-kvm < /dev/null &) \
&& result/ssh-vm
```

```bash
podman run -it --rm busybox echo 'Ok!'
sudo -k -n podman run -it --rm busybox echo 'Ok!'
```

```bash
sudo \
sed \
  's@Defaults\ssecure_path=\"@&'"$HOME"'\/.nix-profile\/bin:@' \
  /etc/sudoers
```


```bash
nix build .#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2 \
&& qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```


```bash
nix \
    profile \
    install \
    github:ES-Nix/podman-rootless/from-nixpkgs \
    nixpkgs#cni \
    nixpkgs#cni-plugins \
    nixpkgs#kubernetes-helm \
    nixpkgs#minikube \
    nixpkgs#ripgrep \
&& mkdir -p -v /usr/lib/cni \
&& ln -fsv $(which firewall) /usr/lib/cni/firewall \
&& ln -fsv $(which bridge) /usr/lib/cni/bridge \
&& ln -fsv $(which portmap) /usr/lib/cni/portmap \
&& ln -fsv $(which tuning) /usr/lib/cni/tuning \
&& ln -fsv $(which host-local) /usr/lib/cni/host-local
podman network create podman
podman run -it --rm busybox echo 'Ok!'
```

TODO: remove all this `sudo ln`, podman itself should know how to install itself.
```bash
nix \
    profile \
    install \
    github:ES-Nix/podman-rootless/from-nixpkgs \
    nixpkgs#cni \
    nixpkgs#cni-plugins \
    nixpkgs#kubernetes-helm \
    nixpkgs#minikube \
    nixpkgs#ripgrep \
&& echo '123' | sudo --stdin mkdir -p /usr/lib/cni \
&& sudo ln -fsv $(which bandwidth) /usr/lib/cni/bandwidth \
&& sudo ln -fsv $(which bridge) /usr/lib/cni/bridge \
&& sudo ln -fsv $(which dhcp) /usr/lib/cni/dhcp \
&& sudo ln -fsv $(which firewall) /usr/lib/cni/firewall \
&& sudo ln -fsv $(which host-device) /usr/lib/cni/host-device \
&& sudo ln -fsv $(which host-local) /usr/lib/cni/host-local \
&& sudo ln -fsv $(which ipvlan) /usr/lib/cni/ipvlan \
&& sudo ln -fsv $(which loopback) /usr/lib/cni/loopback \
&& sudo ln -fsv $(which macvlan) /usr/lib/cni/macvlan \
&& sudo ln -fsv $(which portmap) /usr/lib/cni/portmap \
&& sudo ln -fsv $(which ptp) /usr/lib/cni/ptp \
&& sudo ln -fsv $(which sbr) /usr/lib/cni/sbr \
&& sudo ln -fsv $(which static) /usr/lib/cni/static \
&& sudo ln -fsv $(which tuning) /usr/lib/cni/tuning \
&& sudo ln -fsv $(which vlan) /usr/lib/cni/vlan \
&& sudo ln -fsv $(which vrf) /usr/lib/cni/vrf \
&& echo '123' | sudo --stdin mkdir -p /lib/modules \
&& sudo podman network exists podman || sudo podman network create podman
```


```bash
sudo \
podman \
--log-level=error \
run \
-it \
--network=host \
--rm \
busybox \
echo \
'Ok!'
```


sudo podman network exists podman
sudo podman network ls
sudo -k -n podman run -it --rm busybox echo 'Ok!'

sudo rm -fr /usr/lib/cni /lib/modules
sudo podman network rm podman
sudo rm -fr /etc/cni/net.d/podman.conflist

sudo -k -n podman run -it --rm busybox echo 'Ok!'

sudo podman network exists podman || sudo podman network create podman
minikube start --driver=podman


echo 'net.ipv4.ip_forward=1' > /etc/sysctl.conf


## Troubleshoot

WIP


## Refs

- [Custom live media with Nix flakes](https://hoverbear.org/blog/nix-flake-live-media/)
- [Mein kleines aber feines Cheatsheet für NixOS.](https://noqqe.de/sammelsurium/nixos/)






### NixOS

nix build .#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2

```bash
cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2 \
&& qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-fsdev local,security_model=passthrough,id=fsdev0,path="$(pwd)" \
-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
```

Login with `root` and `r00t`.

```bash
passwd nixuser
```

Logout, `Ctrl + d`.


If you want to make a backup of this state, exit the `qemu` process, use `Ctrl + a` unpress the keys, and press `c` (you
could open another terminal in the same directory too):
```bash
cp nixos.qcow2 nixos-setted-passwd-for-nix-user.qcow2
```

```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-fsdev local,security_model=passthrough,id=fsdev0,path="$(pwd)" \
-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
```


```bash
cp nixos-setted-passwd-for-nix-user.qcow2 nixos.qcow2
```


```bash
export VOLUME_MOUNT_PATH=/home/nixuser/code

cat <<WRAP >> "$HOME"/.zshrc
sudo mount -t 9p \
-o trans=virtio,access=any,cache=none,version=9p2000.L,cache=none,msize=262144,rw \
hostshare \
"$VOLUME_MOUNT_PATH"

cd "$VOLUME_MOUNT_PATH"
WRAP

test -d "$VOLUME_MOUNT_PATH" || sudo mkdir -p "$VOLUME_MOUNT_PATH"

sudo mount -t 9p \
-o trans=virtio,access=any,cache=none,version=9p2000.L,cache=none,msize=262144,rw \
hostshare "$VOLUME_MOUNT_PATH"

OLD_UID=$(getent passwd "$(id -u)" | cut -f3 -d:)
NEW_UID=$(stat -c "%u" "$VOLUME_MOUNT_PATH")

OLD_GID=$(getent group "$(id -g)" | cut -f3 -d:)
NEW_GID=$(stat -c "%g" "$VOLUME_MOUNT_PATH")


if [ "$OLD_UID" != "$NEW_UID" ]; then
    echo "Changing UID of $(id) from $OLD_UID to $NEW_UID"
    #sudo usermod -u "$NEW_UID" -o $(id -un $(id -u))
    sudo find / -xdev -uid "$OLD_UID" -exec chown -h "$NEW_UID" {} \;
fi

if [ "$OLD_GID" != "$NEW_GID" ]; then
    echo "Changing GID of $(id) from $OLD_GID to $NEW_GID"
    #sudo groupmod -g "$NEW_GID" -o $(id -gn $(id -u))
    sudo find / -xdev -group "$OLD_GID" -exec chgrp -h "$NEW_GID" {} \;
fi

sudo su -c "sed -i -e \"s/^\(nixuser:[^:]\):[0-9]*:[0-9]*:/\1:${NEW_UID}:${NEW_GID}:/\" /etc/passwd && sed -i \"/^users/s/:[0-9]*:/:${NEW_GID}:/g\" /etc/group && reboot"

unset VOLUME_MOUNT_PATH
```

```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-fsdev local,security_model=passthrough,id=fsdev0,path="$(pwd)" \
-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
```

```bash
cp nixos.qcow2 nixos-with-volume-nixuser.qcow2
```


```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-fsdev local,security_model=passthrough,id=fsdev0,path="$(pwd)" \
-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
```

```bash
cp nixos-with-volume-nixuser.qcow2 nixos.qcow2
```


```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-fsdev local,security_model=passthrough,id=fsdev0,path="$(pwd)" \
-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
```


```bash
NEW_UID=12345
sudo sed -i -e 's/^\(nixuser:[^:]\):[0-9]*:[0-9]*:/\1:${NEW_UID}:0:/' /etc/passwd
```
From: https://unix.stackexchange.com/a/397257


```bash
NEW_GID=5678
sed -i "/^users/s/:[0-9]*:/:${NEW_GID}:/g" /etc/group
```
From: https://stackoverflow.com/q/49833264


Extra: https://unix.stackexchange.com/a/33874

mkdir -p /tmp/host_files
mount -t 9p -o trans=virtio,version=9p2000.L hostshare /tmp/host_files
umount -t 9p share01 /tmp/host_files

sudo mount -t 9p -o trans=virtio,access=any,cache=none,version=9p2000.u,cache=none,msize=262144,rw share01 /tmp/host_files
sudo mount -t 9p -o trans=virtio,access=1000,cache=none,version=9p2000.u,cache=none,msize=262144,rw share01 /tmp/host_files



### ssh


```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:22" \
-fsdev local,security_model=passthrough,id=fsdev0,path="$(pwd)" \
-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
```



```bash
kill -9 $(pidof qemu-system-x86_64) || true \
&& result/refresh || nix build .#qemu.vm \
```


```bash
kill -9 $(pidof qemu-system-x86_64) || true \
&& nix build .#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2 \
&& (run-vm < /dev/null &) \
&& { ssh-vm << COMMANDS
sudo mount -t 9p \
-o trans=virtio,access=any,cache=none,version=9p2000.L,cache=none,msize=262144,rw \
hostshare \
"\$VOLUME_MOUNT_PATH"

cd "\$VOLUME_MOUNT_PATH"
WRAP

test -d "\$VOLUME_MOUNT_PATH" || sudo mkdir -p "\$VOLUME_MOUNT_PATH"

sudo mount -t 9p \
-o trans=virtio,access=any,cache=none,version=9p2000.L,cache=none,msize=262144,rw \
hostshare "\$VOLUME_MOUNT_PATH"

OLD_UID=\$(getent passwd "\$(id -u)" | cut -f3 -d:)
NEW_UID=\$(stat -c "%u" "\$VOLUME_MOUNT_PATH")

OLD_GID=\$(getent group "\$(id -g)" | cut -f3 -d:)
NEW_GID=\$(stat -c "%g" "\$VOLUME_MOUNT_PATH")


if [ "\$OLD_UID" != "\$NEW_UID" ]; then
    echo "Changing UID of \$(id) from \$OLD_UID to \$NEW_UID"
    #sudo usermod -u "\$NEW_UID" -o \$(id -un \$(id -u))
    sudo find / -xdev -uid "\$OLD_UID" -exec chown -h "\$NEW_UID" {} \;
fi

if [ "\$OLD_GID" != "\$NEW_GID" ]; then
    echo "Changing GID of \$(id) from \$OLD_GID to \$NEW_GID"
    #sudo groupmod -g "\$NEW_GID" -o \$(id -gn \$(id -u))
    sudo find / -xdev -group "\$OLD_GID" -exec chgrp -h "\$NEW_GID" {} \;
fi

sudo su -c "sed -i -e \"s/^\(nixuser:[^:]\):[0-9]*:[0-9]*:/\1:\\${NEW_UID}:\\${NEW_GID}:/\" /etc/passwd && sed -i \"/^users/s/:[0-9]*:/:\${NEW_GID}:/g\" /etc/group && reboot"

COMMANDS
}
```


```bash
(run-vm < /dev/null &) \
&& { ssh-vm << COMMANDS
id
COMMANDS
}
```


cat $(type ssh-vm | cut -d' ' -f3)

```bash
build \
&& refresh-vm \
&& run-vm-kvm
```
ssh-vm
nix run nixpkgs#xorg.xclock


sudo systemctl cat fix-zsh-warning


```bash
build \
&& refresh-vm \
&& (run-vm-kvm < /dev/null &) \
&& { ssh-vm << COMMANDS
volume-mount-hack
COMMANDS
} && { ssh-vm << COMMANDS
ls -al /home/nixuser/code
COMMANDS
} && { ssh-vm << COMMANDS
timeout 100 nix run nixpkgs#xorg.xclock
COMMANDS
} && ssh-vm
```

```bash
nix \
develop \
--refresh \
github:ES-Nix/NixOS-environments/box \
--command \
nixos-box-test
```



### Injecting ssh key from github


```bash
nix build .#image.image \
&& cp -fv result/nixos.qcow2 nixos.qcow2 \
&& chmod -v 0755 nixos.qcow2
```


```bash
qemu-kvm \
-m 18G \
-nic user \
-hda nixos.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10022-:22"
```

In some terminal:
```bash
ssh nixuser@127.0.0.1 -p 10022
```


If needed login as `root` with the passwd `r00t` to lookaround stuff:
```bash
cat /etc/ssh/authorized_keys.d/nixuser
```

```bash
qemu-img convert nixos.qcow2 nixos.iso
```

```bash
qemu-img info nixos.iso

stat -c %s nixos.iso
wc -c < nixos.iso
wc -c nixos.iso
du -b nixos.iso
du -b -h nixos.iso
du -h nixos.iso
stat -c '%s' nixos.iso | numfmt --to=si
ls -l --block-size=G nixos.iso
ls -lh nixos.iso
```
Refs.:
- https://unix.stackexchange.com/a/64149
- https://unix.stackexchange.com/a/405713




virt-sparsify nixos.iso --compress nixos-compressed.iso
virt-sparsify nixos.qcow2 --compress nixos-compressed.qcow2

https://serverfault.com/a/432342

cp nixos.qcow2 nixos-backup.qcow2
qemu-img resize nixos-backup.qcow2 2G
qemu-img resize --shrink nixos-backup.qcow2 2G

qemu-img convert -O qcow2 nixos-backup.qcow2 nixos-compressed.qcow2


```bash
nix build .#image.image \
&& cp -fv result/nixos.qcow2 nixos.qcow2 \
&& chmod -v 0755 nixos.qcow2 \
&& qemu-img info nixos.qcow2 \
&& qemu-img convert nixos.qcow2 nixos.iso \
&& qemu-img info nixos.iso \
&& sha256sum nixos.iso
```
cp -fv result/nixos.qcow2 ~/nixos.qcow2 \
&& chmod -v 0755 ~/nixos.qcow2 \
&& qemu-img info ~/nixos.qcow2 \
&& sha256sum ~/nixos.qcow2 \
&& qemu-img convert ~/nixos.qcow2 ~/nixos.iso

```bash
qemu-kvm \
-m 16G \
-nic user \
-hda nixos.iso \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10022-:29980"
```


```bash
ssh-keygen -R '[127.0.0.1]:10022' \
&& ssh nixuser@127.0.0.1 -p 10022 -o StrictHostKeyChecking=no
```
Refs.:
- https://serverfault.com/a/723917

```bash
sudo kind create cluster --retain --image=docker.io/kindest/node:v1.21.1
```

In steps:
```bash
sudo podman pull docker.io/kindest/node:v1.21.1
sudo podman images
sudo export KIND_EXPERIMENTAL_PROVIDER=podman
sudo kind create cluster --retain --image=docker.io/kindest/node:v1.21.1
```

```bash
kind delete cluster
```

### ISO


```bash
nix build .#iso \
&& cp result/iso/nixos-*.iso . \
&& chmod +x nixos-*.iso \
&& qemu-img create nixos.img 10G
```

```bash
qemu-kvm \
-boot d \
-hda nixos.img \
-cdrom nixos-*.iso \
-m 10000 \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10022-:29980"
```
Refs.:
- [Booting from an ISO image using qemu](https://linux-tips.com/t/booting-from-an-iso-image-using-qemu/136)

rm -fv nixos.img nixos-*.iso


```bash
qemu-kvm \
-boot d \
-cdrom nixos-*.iso \
-m 512 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10022-:29980"
```

-nographic \

```bash
qemu-kvm \
-m 16G \
-nic user \
-hda nixos-21.11pre-git-x86_64-linux.iso \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc) \
-device "rtl8139,netdev=net0" \
-netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10022-:29980"
```

https://alpinelinux.org/downloads/


### NixOS minimal


```bash
podman \
run \
--device=/dev/kvm \
--env=PATH=/root/.nix-profile/bin:/usr/bin:/bin \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
--volume="$(pwd)":/code \
--workdir=/code \
docker.nix-community.org/nixpkgs/nix-flakes

nix build .#iso-minimal

sha256sum result/iso/nixos-21.11pre-git-x86_64-linux.iso

ISO_SHA256='66d7c39ebf2f92549c5ca7a01dcee2ea4787d628ba6bdaa72822ada22afe8a09'
echo "$ISO_SHA256" result/iso/nixos-21.11pre-git-x86_64-linux.iso | sha256sum -c
```

```bash
podman \
run \
--interactive=true \
--privileged=true \
--tty=false \
--rm=true \
docker.nix-community.org/nixpkgs/nix-flakes \
bash \
<< COMMANDS
echo 'Build start:'

nix build github:ES-Nix/NixOS-environments/box#iso-minimal

sha256sum result/iso/nixos-21.11pre-git-x86_64-linux.iso

echo 'd7576766d5c6873357923bd04e3b166a8151c718a09b254de214762778864967  result/iso/nixos-21.11pre-git-x86_64-linux.iso' | sha256sum -c

echo 'Build end!'
COMMANDS
```

```bash
podman \
run \
--interactive=true \
--privileged=true \
--tty=false \
--rm=true \
--volume="$(pwd)":/code \
--workdir=/code \
docker.nix-community.org/nixpkgs/nix-flakes \
bash \
<< COMMANDS
echo 'Build start:'

nix build .#iso-minimal

ISO_SHA256='66d7c39ebf2f92549c5ca7a01dcee2ea4787d628ba6bdaa72822ada22afe8a09'
echo "$ISO_SHA256" result/bin/nixos-21.11pre-git-x86_64-linux.iso | sha256sum -c

echo 'Build end!'
COMMANDS
```

```bash
nix build github:ES-Nix/NixOS-environments/box#iso-minimal
nix build github:ES-Nix/NixOS-environments/box#testCacheInFlakeCheck
```

```bash
time nix build --rebuild --json github:ES-Nix/NixOS-environments/box#iso-minimal
```


### NixOS modules 

https://av.tib.eu/media/50717

https://cfp.nixcon.org/media/nixcon-oct-2020.pdf

```bash
{
  outputs = { self, nixpkgs }: {
    system = "x86_64-linux";

    modules.hello = {
      doc = "A program that prints a friendly greeting.";
      extends = [
        nixpkgs.modules.package
        nixpkgs.modules.stdenv
      ];
      options = {
        who = {
          default = "World";
          doc = "Who to greet.";
        };
      };
      config = { config }: {
        pname = "hello";
        version = "1.12";
        buildCommand = ''
          mkdir -p$out/bin
          cat > $out/bin/hello <<EOF
          #! /bin/sh
            echo Hello ${config.who}
          EOF
          chmod +x $out/bin/hello
        '';
      };
    };
  };
}
```

#### NixOS build.vm 


```bash
cat <<'EOF' > flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ self, nixpkgs }: {

    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ({ pkgs, ... }: {
          #disabledModules = [ "services/desktops/pipewire/pipewire.nix" ];
          imports = [

            # For virtualisation settings
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"

            # Provide an initial copy of the NixOS channel so that the user
            # doesn't need to run "nix-channel --update" first.
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            
            ({ lib, pkgs, config, ... }:
                with lib;                      
                let
                  cfg = config.services.hello;
                in {
                  options.services.hello = {
                    enable = mkEnableOption "hello service";
                    greeter = mkOption {
                      type = types.str;
                      default = "world";
                    };
                  };
                
                  config = mkIf cfg.enable {
                    systemd.services.hello = {
                      wantedBy = [ "multi-user.target" ];
                      serviceConfig.ExecStart = "${pkgs.hello}/bin/hello -g'Hello, ${escapeShellArg cfg.greeter}!'";
                    };
                  };
                })
          ];

          services.hello = {
            enable = true;
            greeter = "Nix";
          };

          # https://nixos.wiki/wiki/Libvirt
          #
          boot.extraModprobeConfig = "options kvm_intel nested=1";
          boot.kernelModules = [
            "kvm-intel"
          ];

          # Documentation for these is in nixos/modules/virtualisation/qemu-vm.nix
          virtualisation = {
            memorySize = 1024 * 3;
            diskSize = 1024 * 3;
            cores = 4;
            msize = 104857600;
          };

          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search, run:
          # $ nix search wget
          environment.systemPackages = with pkgs; [
             # hello

             oh-my-zsh
             zsh
             zsh-autosuggestions
             zsh-completions

          ];

          users.mutableUsers = false;
          users.users.root = {
            password = "root";
          };
          
          # TODO: should it be refactored in an NixOS module?
          users.users.nixuser = {
            password = "123";
            isNormalUser = true;
            # https://nixos.wiki/wiki/Libvirt
            extraGroups = [ "wheel" "nixgroup" "kvm" ];
          };
          
          users.extraUsers.nixuser = {
            shell = pkgs.zsh;
          };

          # https://github.com/NixOS/nixpkgs/blob/3a44e0112836b777b176870bb44155a2c1dbc226/nixos/modules/programs/zsh/oh-my-zsh.nix#L119 
          # https://discourse.nixos.org/t/nix-completions-for-zsh/5532
          # https://github.com/NixOS/nixpkgs/blob/09aa1b23bb5f04dfc0ac306a379a464584fc8de7/nixos/modules/programs/zsh/zsh.nix#L230-L231
          programs.zsh = {
            enable = true;
            shellAliases = {
              vim = "nvim";
              shebang = "echo '#!/usr/bin/env bash'"; # https://stackoverflow.com/questions/10376206/what-is-the-preferred-bash-shebang#comment72209991_10383546
              nfmt = "nix run nixpkgs#nixpkgs-fmt **/*.nix *.nix";
            };
            enableCompletion = true;
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
            interactiveShellInit = ''
              export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
              export ZSH_THEME="agnoster"
              export ZSH_CUSTOM=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
              plugins=( 
                        colored-man-pages
                        docker
                        git
                        #zsh-autosuggestions # Why this causes an warn?
                        #zsh-syntax-highlighting
                      )
        
              # git config --global user.email "example@gmail.com" 2> /dev/null
              # git config --global user.name "Foo Bar" 2> /dev/null
        
              source $ZSH/oh-my-zsh.sh
            '';
            ohMyZsh.custom = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
            promptInit = "";
          };

          # Probably solve many warns about fonts
          # https://gist.github.com/kendricktan/8c33019cf5786d666d0ad64c6a412526
          fonts = {
            fontDir.enable = true;
            fonts = with pkgs; [
              # corefonts           # Microsoft free fonts
              # fira                # Monospace
              inconsolata         # Monospace
              powerline-fonts
              ubuntu_font_family
              unifont             # International languages
            ];
          };
          
        })
      ];
    };
    # So that we can just run 'nix run' instead of
    # 'nix build ".#nixosConfigurations.vm.config.system.build.vm" && ./result/bin/run-nixos-vm'
    defaultPackage.x86_64-linux = self.nixosConfigurations.vm.config.system.build.vm;    
    defaultApp.x86_64-linux = {
      type = "app";
      program = "${self.defaultPackage.x86_64-linux}/bin/run-nixos-vm";
    };
  };
}
EOF

git init 
git add .
nix run
```
Refs.:
- https://nixos.wiki/wiki/Nixpkgs/Reviewing_changes#Vm_example
- https://nixos.wiki/wiki/Module


```bash
systemctl status hello
```


#### flutter


```bash
cat <<'EOF' > flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ self, nixpkgs }: {

    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ({ pkgs, ... }: {
          # disabledModules = [ "services/desktops/pipewire/pipewire.nix" ];
          imports = [

            # For virtualisation settings
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"

            # Provide an initial copy of the NixOS channel so that the user
            # doesn't need to run "nix-channel --update" first.
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          ];

          # https://nixos.wiki/wiki/Libvirt
          #
          boot.extraModprobeConfig = "options kvm_intel nested=1";
          boot.kernelModules = [
            "kvm-intel"
          ];

          # Documentation for these is in nixos/modules/virtualisation/qemu-vm.nix
          virtualisation = {
            memorySize = 1024 * 3;
            diskSize = 1024 * 3;
            cores = 4;
            msize = 104857600;
          };

          system.stateVersion = "22.05";

          # Enable the X11 windowing system.
          # services.xserver.enable = true;
          # services.xserver.layout = "us";          
          
          # Enable the KDE Desktop Environment.
          # services.xserver.displayManager.sddm.enable = true;
          # services.xserver.desktopManager.plasma5.enable = true;

          nixpkgs.config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };

          # List packages installed in system profile. To search, run:
          # $ nix search wget
          environment.systemPackages = with pkgs; [
             # hello

             oh-my-zsh
             zsh
             zsh-autosuggestions
             zsh-completions
             
             clang
             cmake
             flutter
             ninja
             pkg-config
             gtk3
             gtk3.dev
             util-linux.dev
             glib.dev
             
             # Helper script to print the IOMMU groups of PCI devices.
             (
               writeScriptBin "test-flutter" ''
                 #! ${pkgs.runtimeShell} -e
                 flutter config --enable-linux-desktop
        
                 flutter create my_app \
                 && cd my_app \
                 && flutter build linux         
               ''
             )
          ];
          
          environment.sessionVariables = { 
            PKG_CONFIG_PATH="${pkgs.gtk3.dev}/lib/pkgconfig";
          };
  
          users.mutableUsers = false;
          users.users.root = {
            password = "root";
          };
          
          # TODO: should it be refactored in an NixOS module?
          users.users.nixuser = {
            password = "123";
            isNormalUser = true;
            # https://nixos.wiki/wiki/Libvirt
            extraGroups = [ "wheel" "nixgroup" "kvm" ];
          };
          
          users.extraUsers.nixuser = {
            shell = pkgs.zsh;
          };

          # https://github.com/NixOS/nixpkgs/blob/3a44e0112836b777b176870bb44155a2c1dbc226/nixos/modules/programs/zsh/oh-my-zsh.nix#L119 
          # https://discourse.nixos.org/t/nix-completions-for-zsh/5532
          # https://github.com/NixOS/nixpkgs/blob/09aa1b23bb5f04dfc0ac306a379a464584fc8de7/nixos/modules/programs/zsh/zsh.nix#L230-L231
          programs.zsh = {
            enable = true;
            shellAliases = {
              vim = "nvim";
              shebang = "echo '#!/usr/bin/env bash'"; # https://stackoverflow.com/questions/10376206/what-is-the-preferred-bash-shebang#comment72209991_10383546
              nfmt = "nix run nixpkgs#nixpkgs-fmt **/*.nix *.nix";
            };
            enableCompletion = true;
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
            interactiveShellInit = ''
              export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
              export ZSH_THEME="agnoster"
              export ZSH_CUSTOM=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
              plugins=( 
                        colored-man-pages
                        docker
                        git
                        #zsh-autosuggestions # Why this causes an warn?
                        #zsh-syntax-highlighting
                      )
        
              # git config --global user.email "example@gmail.com" 2> /dev/null
              # git config --global user.name "Foo Bar" 2> /dev/null
        
              source $ZSH/oh-my-zsh.sh
            '';
            ohMyZsh.custom = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
            promptInit = "";
          };

          # Probably solve many warns about fonts
          # https://gist.github.com/kendricktan/8c33019cf5786d666d0ad64c6a412526
          fonts = {
            fontDir.enable = true;
            fonts = with pkgs; [
              # corefonts           # Microsoft free fonts
              # fira                # Monospace
              inconsolata         # Monospace
              powerline-fonts
              ubuntu_font_family
              unifont             # International languages
            ];
          };
          
        })
      ];
    };
    # So that we can just run 'nix run' instead of
    # 'nix build ".#nixosConfigurations.vm.config.system.build.vm" && ./result/bin/run-nixos-vm'
    defaultPackage.x86_64-linux = self.nixosConfigurations.vm.config.system.build.vm;    
    defaultApp.x86_64-linux = {
      type = "app";
      program = "${self.defaultPackage.x86_64-linux}/bin/run-nixos-vm";
    };
  };
}
EOF

git init 
git add .
nix run
```


#### k8s in NixOS QEMU VM

```nix 
cat <<'EOF' > flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ self, nixpkgs }: {

    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        (
        
        let 
          # https://github.com/NixOS/nixpkgs/issues/59364#issuecomment-723906760
          # https://discourse.nixos.org/t/use-nixos-as-single-node-kubernetes-cluster/8858/7
          kubeMasterIP = "10.1.1.2";
          kubeMasterHostname = "localhost";
          # kubeMasterHostname = "api.kube";
          kubeMasterAPIServerPort = 6443;
        in
        { pkgs, ... }: {
          #disabledModules = [ "services/desktops/pipewire/pipewire.nix" ];
          imports = [

            # For virtualisation settings
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"

            # Provide an initial copy of the NixOS channel so that the user
            # doesn't need to run "nix-channel --update" first.
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            
          ];

          # https://nixos.wiki/wiki/Libvirt
          #
          boot.extraModprobeConfig = "options kvm_intel nested=1";
          boot.kernelModules = [
            "kvm-intel"
          ];

          # Documentation for these is in nixos/modules/virtualisation/qemu-vm.nix
          virtualisation = {
            memorySize = 1024 * 3;
            diskSize = 1024 * 3;
            cores = 4;
            msize = 104857600;
          };

          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search, run:
          # $ nix search wget
          environment.systemPackages = with pkgs; [
             # hello

             oh-my-zsh
             zsh
             zsh-autosuggestions
             zsh-completions
             
            # Looks like kubernetes needs atleast all this
            kubectl
            kubernetes
            #
            cni
            cni-plugins
            conntrack-tools
            cri-o
            cri-tools
            docker
            ebtables
            ethtool
            flannel
            iptables
            socat
        
            # Debug helpers
            lsof
            ripgrep
            jq
            openssl
            dmidecode
            inetutils # old named as telnet
            file
          ];

          users.mutableUsers = false;
          users.users.root = {
            password = "root";
          };
          
          # TODO: should it be refactored in an NixOS module?
          users.users.nixuser = {
            password = "123";
            isNormalUser = true;
            # https://nixos.wiki/wiki/Libvirt
            extraGroups = [ "wheel" "nixgroup" "kvm" ];
          };
          
          users.extraUsers.nixuser = {
            shell = pkgs.zsh;
          };

          # From:
          # https://discourse.nixos.org/t/creating-directories-and-files-declararively/9349/2
          # https://discourse.nixos.org/t/adding-folders-and-scripts/5114/4
          # TODO: remove herdcoded user ang group names
          systemd.tmpfiles.rules = [
            "f /home/nixuser/.zshrc 0755 nixuser nixgroup"
          ];

          # https://github.com/NixOS/nixpkgs/blob/3a44e0112836b777b176870bb44155a2c1dbc226/nixos/modules/programs/zsh/oh-my-zsh.nix#L119 
          # https://discourse.nixos.org/t/nix-completions-for-zsh/5532
          # https://github.com/NixOS/nixpkgs/blob/09aa1b23bb5f04dfc0ac306a379a464584fc8de7/nixos/modules/programs/zsh/zsh.nix#L230-L231
          programs.zsh = {
            enable = true;
            shellAliases = {
              vim = "nvim";
              shebang = "echo '#!/usr/bin/env bash'"; # https://stackoverflow.com/questions/10376206/what-is-the-preferred-bash-shebang#comment72209991_10383546
              nfmt = "nix run nixpkgs#nixpkgs-fmt **/*.nix *.nix";
            };
            enableCompletion = true;
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
            interactiveShellInit = ''
              export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
              export ZSH_THEME="agnoster"
              export ZSH_CUSTOM=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
              plugins=( 
                        colored-man-pages
                        docker
                        git
                        #zsh-autosuggestions # Why this causes an warn?
                        #zsh-syntax-highlighting
                      )
        
              # git config --global user.email "example@gmail.com" 2> /dev/null
              # git config --global user.name "Foo Bar" 2> /dev/null
        
              source $ZSH/oh-my-zsh.sh
            '';
            ohMyZsh.custom = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
            promptInit = "";
          };

          # Probably solve many warns about fonts
          # https://gist.github.com/kendricktan/8c33019cf5786d666d0ad64c6a412526
          fonts = {
            fontDir.enable = true;
            fonts = with pkgs; [
              corefonts           # Microsoft free fonts
              fira                # Monospace
              inconsolata         # Monospace
              powerline-fonts
              ubuntu_font_family
              unifont             # International languages
            ];
          };
          
          # k8s
          environment.variables.KUBECONFIG = "/etc/kubernetes/cluster-admin.kubeconfig";
        
          virtualisation.docker.enable = true;
        
          environment.etc."containers/registries.conf" = {
            mode = "0644";
            text = ''
              [registries.search]
              registries = ['docker.io', 'localhost']
            '';
          };
        
          services.kubernetes.roles = [ "master" "node" ];
          services.kubernetes.masterAddress = "${kubeMasterHostname}";
          services.kubernetes = {
      
          # addonManager.enable = true;
      
          # addons = {
          #  # dashboard.enable = true;
          #  # dashboard.rbac.enable = true;
          #  dns.enable = true;
          # };
      
          # apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
          #
          #    apiserver = {
          #      advertiseAddress = kubeMasterIP;
          #      enable = true;
          #      securePort = kubeMasterAPIServerPort;
          #    };
          #
          #    controllerManager.enable = true;
          #    # flannel.enable = true;
          #    masterAddress = "${toString kubeMasterHostname}";
          #    # proxy.enable = true;
          #    roles = [ "master" ];
          #    # roles = [ "master" "node" ];
          #    # scheduler.enable = true;
          #    easyCerts = true;
          #
          #    kubelet.enable = true;
          #
          # # needed if you use swap
            kubelet.extraOpts = "--fail-swap-on=false";
          };          
        })
      ];
    };
    # So that we can just run 'nix run' instead of
    # 'nix build ".#nixosConfigurations.vm.config.system.build.vm" && ./result/bin/run-nixos-vm'
    defaultPackage.x86_64-linux = self.nixosConfigurations.vm.config.system.build.vm;    
    defaultApp.x86_64-linux = {
      type = "app";
      program = "${self.defaultPackage.x86_64-linux}/bin/run-nixos-vm";
    };
  };
}
EOF

git init 
git add .
nix run
```


#### 


```nix
    packages.tests = (import nixpkgs {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
      }).nixosTest rec {
                      name = "example-test";
                      nodes = {
                                machine = { pkgs, ... }: {
                                  environment.systemPackages = with pkgs; [ hello ];
                                };
                              };
                      testScript = ''
                        # run hello on machine and check for output
                        machine.succeed('hello | grep "Hello, world!"')
                        # test is a simple python script 
                      '';
                    };
```

###



### Nix overlays


```bash
mkdir foo
cd foo


cat <<'EOF' > overlay.nix
self: super:
{
  my_prefix = {
    abcdef = super.cowsay;
  };
}
EOF

cat <<'EOF' > flake.nix
{
  description = "example flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system: 
    let pkgs = import nixpkgs { inherit system; overlays = [ (import ./overlay.nix) ]; };
    in {
      defaultPackage = pkgs.my_prefix.abcdef;
      packages.cowsay-abcdef = pkgs.my_prefix.abcdef;

      devShell = pkgs.mkShell {
           buildInputs = with pkgs; [
             bashInteractive
             self.defaultPackage."${system}"
           ];
        };
     }
  );
}
EOF

git init 
git add .

nix build --refresh 'path:.#cowsay-abcdef'

nix develop --refresh 'path:.#' --command cowsay "Hi $USER"
```


```bash
rm -fr foo
```


####

```bash
cat <<'EOF' > overlay.nix
self: super:
{
  my_prefix = {
    vim = super.vim_configurable.customize {
      name = "my-vim";
      vimrcConfig.customRC = ''
        set colorcolumn=80
      '';
    };
    devShell = super.mkShell {
      buildInputs = [ super.jq ];
    };
  };
}
EOF

cat <<'EOF' > flake.nix
{
  description = "example flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system: 
    let pkgs = import nixpkgs { inherit system; overlays = [ (import ./overlay.nix) ]; };
    in {
      defaultPackage = pkgs.my_prefix.vim;
      packages.my-vim = pkgs.my_prefix.vim;
    
      devShell = pkgs.mkShell {
           buildInputs = with pkgs; [
             bashInteractive
             "${self.packages.my-vim}"
           ];
        };
     }
  );
}
EOF

git init 
git add .
nix develop --refresh 'path:.#my-vim'
nix build --refresh 'path:.#my-vim'
```


####

```bash
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
```



```bash
qemu-kvm \
-enable-kvm \
-m 8192 \
-boot d \
-cdrom nixos.iso \
-hda nixos.img
```
Adapted from:
- https://www.cs.fsu.edu/~langley/CNT4603/2019-Fall/assignment-nixos-2019-fall.html