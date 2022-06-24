# { nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
{ nixpkgs ? <nixpkgs> }:
let
  pkgs = nixpkgs.legacyPackages."x86_64-linux";

  configuration = import ./configuration.nix { pkgs = pkgs; nixpkgs = nixpkgs; };

  iso-image = import "${nixpkgs}/nixos" { inherit configuration; system = "x86_64-linux"; };
in
iso-image.config.system.build.isoImage

