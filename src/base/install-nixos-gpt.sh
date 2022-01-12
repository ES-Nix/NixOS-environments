#!/usr/bin/env bash



install-nixos-with-parted-in-gpt \
&& nixos-generate-config --root /mnt \
&& copy-to-mnt \
&& prepare-git-stuff \
&& prepare-configuration-gpt \
&& nixos-install --no-root-passwd \
&& shutdown --poweroff
