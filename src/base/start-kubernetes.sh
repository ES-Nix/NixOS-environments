#!/usr/bin/env bash

nixos-rebuild test --flake '/etc/nixos'#"$(hostname)"
