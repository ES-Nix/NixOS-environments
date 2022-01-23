#!/usr/bin/env bash


# nix build '/etc/nixos'#nixosConfigurations."$(hostname)".config.system.build.toplevel

nixos-rebuild test --flake '/etc/nixos'#"$(hostname)" \
&& nixos-rebuild switch --flake '/etc/nixos'#"$(hostname)"

# \
#&& cd /etc/nixos \
#&& echo 'result' > .gitignore \
#&& git add . \
#&& git config --global init.defaultBranch main \
#&& git config --global user.email "you@example.com" \
#&& git config --global user.name "Your Name" \
#&& git commit -m 'Second commit'


# https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-profile-wipe-history.html
# nix profile wipe-history --profile /nix/var/nix/profiles/system ?
nix-env --profile /nix/var/nix/profiles/system --list-generations \
&& nix-env --profile /nix/var/nix/profiles/system --delete-generations old \
&& nix store gc --verbose \
&& nix-collect-garbage --delete-old \
&& nix store optimise --verbose \
&& df -h /