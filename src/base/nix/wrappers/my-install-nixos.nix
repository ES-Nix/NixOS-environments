{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
        nixpkgs = nixpkgs;
        system = system;
        propagatedNativeBuildInputs = with pkgs; [
          bash
        ];
        scriptFullNixPath = "${ ../../../../src/base/my-install-nixos.sh}";
        scriptName = "my-install";
      };
in
customScript
