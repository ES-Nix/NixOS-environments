{ pkgs ? import <nixpkgs> { }, nixos }:
let
  #
  # https://hoverbear.org/blog/nix-flake-live-media/
  # https://github.com/NixOS/nixpkgs/blob/39b851468af4156e260901c4fd88f88f29acc58e/nixos/release.nix#L147
  image = (import "${nixos}/nixos/lib/eval-config.nix" {
    system = "x86_64-linux";
    modules = [
      # expression that exposes the configuration as vm image
      ({ config, lib, pkgs, ... }: {
        system.build.qcow2 = import "${nixos}/nixos/lib/make-disk-image.nix" {
          inherit lib config pkgs;
          diskSize = 2500;
          format = "qcow2-compressed";
          configFile = ./base-configuration.nix;
        };
      })
          # configure the mountpoint of the root device
      ({
        fileSystems."/".device = "/dev/disk/by-label/nixos";
        boot.loader.grub.device = "/dev/sda";
        boot.loader.grub.version = 2;
      })
      # ./base-configuration.nix
    ];

  }).config.system.build.qcow2;
in
{
  inherit image;
}
