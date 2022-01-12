#!/usr/bin/env bash


rm -fv /mnt/etc/nixos/configuration.nix
cp -fv /mnt/etc/nixos/src/base/kubernetes-configuration-gpt.nix /mnt/etc/nixos/configuration.nix

cp -fv /mnt/etc/nixos/src/base/base-flake.nix /mnt/etc/nixos/flake.nix

#
cd /mnt/etc/nixos || echo 'The cd /mnt/etc/nixos failed!'
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

git add .
git commit -m 'Second commit'