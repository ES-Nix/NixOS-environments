{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
        nixpkgs = nixpkgs;
        system = system;
        propagatedNativeBuildInputs = with pkgs; [
          ripgrep
        ];
        scriptFullNixPath = "${ ../../../../src/base/utils-k8s-services-status-check.sh}";
        scriptName = "utils-k8s-services-status-check";
      };
in
customScript
