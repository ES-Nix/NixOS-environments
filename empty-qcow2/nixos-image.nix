{ pkgs ? import <nixpkgs> { } }:
import (pkgs.path + "/nixos/lib/make-disk-image.nix") {
  config = (import (pkgs.path + "/nixos/lib/eval-config.nix") {
    inherit (pkgs) system;
    modules = [{
      imports = [ ./nixos-config.nix ];
    }];
  }).config;
  inherit pkgs;
  inherit (pkgs) lib;
  diskSize = 2048;
  partitionTableType = "none";
  # for a different format
  format = "qcow2";
}
