
# NixOS environments

```bash
nix \
develop \
--refresh \
github:ES-Nix/NixOS-environments/troubleshooting-poetry2nix-yaml \
--command \
nixos-box-volume
```

```bash
nix \
develop \
--refresh \
github:ES-Nix/NixOS-environments/troubleshooting-poetry2nix-yaml \
--command \
build \
&& refresh-vm
```
build


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
'build && refresh-vm && nixos-box'
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
qemu-kvm \
-m 18G \
-nic user \
-hda nixos-vm-volume.qcow2 \
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



## Refs

- [Custom live media with Nix flakes](https://hoverbear.org/blog/nix-flake-live-media/)
- [Mein kleines aber feines Cheatsheet für NixOS.](https://noqqe.de/sammelsurium/nixos/)


