{ pkgs ? import <nixpkgs> {}, nixos }:
let
  #
  # https://hoverbear.org/blog/nix-flake-live-media/
  # https://github.com/NixOS/nixpkgs/blob/39b851468af4156e260901c4fd88f88f29acc58e/nixos/release.nix#L147
  image = (import "${nixos}/nixos/lib/eval-config.nix" {
    system = "x86_64-linux";
    modules = [
      # expression that exposes the configuration as vm image
      ({config, lib, pkgs, ...}: {
        system.build.qcow2 = import "${nixos}/nixos/lib/make-disk-image.nix" {
          inherit lib config pkgs;
          diskSize = 8192;
          format = "qcow2-compressed";
          configFile = ./configuration.nix;
        };
      })
      ./configuration.nix
    ];
  }).config.system.build.qcow2;
in
{
  inherit image;
}
