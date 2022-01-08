{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
        nixpkgs = nixpkgs;
        system = system;
        propagatedNativeBuildInputs = with pkgs; [
          e2fsprogs
          parted
          mount
          util-linux
        ];
        scriptFullNixPath = "${ ../../../../src/base/install-nixos-with-parted-in-mbr.sh}";
        scriptName = "install-nixos-with-parted-in-mbr";
      };
in
customScript
