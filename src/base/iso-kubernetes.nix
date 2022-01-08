{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux", nixos }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  configuration = import ./kubernetes-configuration.nix { pkgs = pkgs; nixpkgs = nixpkgs; system = system; };

  iso-image = import "${nixpkgs}/nixos" { inherit system configuration; };
in
iso-image.config.system.build.isoImage
