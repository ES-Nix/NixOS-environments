#!/usr/bin/env bash

nixos-rebuild test --flake '/etc/nixos'#"$(hostname)"

# Using only nix CLI:
# nix \
# build \
# /etc/nixos#nixosConfigurations."$(hostname)".config.system.build.toplevel
