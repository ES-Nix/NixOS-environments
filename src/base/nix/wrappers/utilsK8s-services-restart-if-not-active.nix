{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
        nixpkgs = nixpkgs;
        system = system;
        propagatedNativeBuildInputs = with pkgs; [
          ripgrep
        ];
        scriptFullNixPath = "${ ../../../../src/base/utilsK8s-services-restart-if-not-active.sh}";
        scriptName = "utilsK8s-services-restart-if-not-active";
      };
in
customScript
