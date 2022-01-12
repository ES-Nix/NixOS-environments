#!/usr/bin/env bash



install-nixos-with-parted-in-mbr \
&& nixos-generate-config --root /mnt \
&& copy-to-mnt \
&& prepare-git-stuff \
&& prepare-configuration-mbr \
&& nixos-install --no-root-passwd \
&& shutdown --poweroff
