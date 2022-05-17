{ pkgs ? import <nixpkgs> { }, nixpkgs }:
let
  #
  # https://hoverbear.org/blog/nix-flake-live-media/
  # https://github.com/NixOS/nixpkgs/blob/39b851468af4156e260901c4fd88f88f29acc58e/nixos/release.nix#L147
  image = (import "${toString nixpkgs}/nixos/lib/eval-config.nix" {
    system = "x86_64-linux";
    modules = [
      # expression that exposes the configuration as vm image
      ({ config, lib, pkgs, ... }: {
        system.build.qcow2 = import "${toString nixpkgs}/nixos/lib/make-disk-image.nix" {
          inherit lib config pkgs;
          diskSize = 2500;
          format = "qcow2-compressed";
          configFile = ./configuration.nix;
        };
      })
      ./configuration.nix
    ];
  }).config.system.build.qcow;
in
{
  inherit image;
}
