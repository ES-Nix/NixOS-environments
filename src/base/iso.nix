{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux", nixos }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  configuration = import ./base-configuration.nix { pkgs = pkgs; nixpkgs = nixpkgs;};

  iso-image = import "${nixpkgs}/nixos" { inherit system configuration; };
in
iso-image.config.system.build.isoImage
