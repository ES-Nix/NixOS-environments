{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux", nixos }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  configuration = import ./qcow2-compressed { pkgs = pkgs; nixpkgs = nixpkgs; };

  iso-image = import "${nixpkgs}/nixos" { inherit system configuration; };
in
iso-image.config.system.build.qcow2