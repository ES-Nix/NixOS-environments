
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
and [this](https://github.com/NixOS/nix/issues/3781#issuecomment-716440620)

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
- https://mudrii.medium.com/nixos-native-flake-deployment-with-luks-drive-encryption-and-lvm-b7f3738b71ca
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
- [NixOs Native Flake Deployment With LUKS Drive Encryption and LVM](https://dzone.com/articles/nixos-native-flake-deployment-with-luks-and-lvm)
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


echo 'net.ipv4.ip_forward=1' > /etc/sysctl.con


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


