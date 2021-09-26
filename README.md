
# NixOS environments

```bash
nix \
develop \
github:ES-Nix/NixOS-environments/box#image.image
```

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
nix build github:ES-Nix/NixOS-environments#image.image \
&& cp result/nixos.qcow2 nixos.qcow2 \
&& chmod 0755 nixos.qcow2
```

TODO: wrap it in a scrip.
```bash
nix shell nixpkgs#qemu
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


### Trying ssh WIP


ssh-keygen -t rsa -f ssh-keys.nix

ssh nixuser@192.168.1.2


nmap -sn 192.168.1.0/24 --system-dns



echo '192.168.1.2 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbqkQxZD6I65C1cQ3A5N/LoTHR85x1k/tBbBymZsWw8' >> ~/.ssh/known_hosts

/etc/ssl/certs/ca-certificates.crt




### The cacerts, Done


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


### Alpine

- https://alpinelinux.org/downloads/
- https://wiki.alpinelinux.org/wiki/Install_Alpine_in_Qemu
- https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-alpine


wget https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-virt-3.14.2-x86_64.iso

```bash
qemu-img \
create \
-f qcow2 \
alpine.qcow2 \
8G
```

```bash
qemu-kvm \
-m 512 \
-nic user \
-boot d \
-cdrom alpine-virt-3.14.2-x86_64.iso \
-hda alpine.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```

```bash
setup-alpine
```

```bash
qemu-kvm \
-m 512 \
-nic user \
-hda alpine.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```

```bash
apk add --no-cache sudo

adduser \
-D \
-G wheel \
-s /bin/sh \
-h /home/nixuser \
-g "User" nixuser

echo 'nixuser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nixuser

passwd nixuser
```
Adapeted from: https://stackoverflow.com/a/54934781


```bash
sudo \
apk \
add \
curl \
tar \
xz \
ca-certificates \
openssl

cat <<WRAP > "$HOME"/.profile
# It was inserted by the get-nix installer
flake () {
    echo "Entering the nix + flake shell.";
    # Would it be usefull to have the "" to pass arguments?
    nix-shell -I nixpkgs=channel:nixos-21.05 --packages nixFlakes;
}
nd () {
   nix-collect-garbage --delete-old;
}
develop () {
    echo "Entering the nix + flake development shell.";
    nix-shell -I nixpkgs=channel:nixos-21.05 --packages nixFlakes --run 'nix develop';
}
export TMPDIR=/tmp
. "\$HOME"/.nix-profile/etc/profile.d/nix.sh
# End of inserted by the get-nix installer
WRAP

test -d /nix || sudo mkdir --mode=0755 /nix \
&& sudo chown "$USER": /nix \
&& SHA256=eccef9a426fd8d7fa4c7e4a8c1191ba1cd00a4f7 \
&& curl -fsSL https://raw.githubusercontent.com/ES-Nix/get-nix/"$SHA256"/get-nix.sh | sh \
&& . "$HOME"/.nix-profile/etc/profile.d/nix.sh \
&& . ~/.profile \
&& export TMPDIR=/tmp \
&& export OLD_NIX_PATH="$(readlink -f $(which nix))" \
&& nix-shell -I nixpkgs=channel:nixos-21.05 --keep OLD_NIX_PATH --packages nixFlakes --run 'nix-env --uninstall $OLD_NIX_PATH && nix-collect-garbage --delete-old && nix profile install nixpkgs#nixFlakes' \
&& sudo rm -frv /nix/store/*-nix-2.3.* \
&& unset OLD_NIX_PATH \
&& nix-collect-garbage --delete-old \
&& nix store gc \
&& nix flake --version


sudo \
apk \ 
remove \
tar \
xz \
ca-certificates \
openssl
```

export PATH="$HOME"/.nix-profile/bin:"$PATH"
nix-shell -I nixpkgs=channel:nixos-21.05 --packages nixFlakes

mkdir -m 7777 /home/nixuser/tmp
export TMPDIR="$HOME"/tmp

echo 'nixuser:1000000:65536' >> /etc/subuid \
&& echo 'nixgroup:1000000:65536' >> /etc/subgid


echo 'nixuser:100000:165535' > /etc/subuid \
&& echo 'nixuser:100000:165535' > /etc/subgid

export PATH="$HOME"/.nix-profile/bin:"$PATH"


podman --log-level=error run -it alpine >> logs.txt 2>&1



podman \
--log-level=error \
run \
--cgroup-manager=cgroupfs \
--cgroups=disabled \
-it \
alpine


nix build \
github:ES-Nix/poetry2nix-examples/d55b1d471dd3a7dba878352df465a23e22f60101#poetry2nixOCIImage \
--out-link \
poetry2nixOCIImage.tar.gz

podman load < poetry2nixOCIImage.tar.gz

podman \
run \
--interactive=true \
--rm=true \
--tty=true \
localhost/numtild-dockertools-poetry2nix:0.0.1 \
flask_minimal_example > logs.txt 2>&1

nix profile install nixpkgs#fuse-overlayfs


usermod --add-subuids 100000-165535 "$USER"
usermod --add-subgids 100000-165535 "$USER"


export PATH="$HOME"/.nix-profile/bin:"$PATH"
nix-shell -I nixpkgs=channel:nixos-21.05 --packages nixFlakes


### CentOS

- https://cloud.centos.org/centos/8/x86_64/images/


wget https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-ec2-8.4.2105-20210603.0.x86_64.qcow2


qemu-img info


```bash
qemu-kvm \
-m 512 \
-nic user \
-boot d \
-hda CentOS-8-ec2-8.4.2105-20210603.0.x86_64.qcow2 \
-nographic \
-enable-kvm \
-cpu host \
-smp $(nproc)
```

      
      if [ ! test -e /home/nixuser/.zshrc ]; then
            echo "Fixing a zsh warning"
      fi


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
