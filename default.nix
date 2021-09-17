{ pkgs ? import <nixpkgs> {}, nixos }:
let
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
