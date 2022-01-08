{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
        nixpkgs = nixpkgs;
        system = system;
        propagatedNativeBuildInputs = with pkgs; [
          coreutils
          gawk
          gnugrep
          kmod
          nettools
          procps-ng
          ripgrep
          telnet
          unixtools.netstat
        ];
        scriptFullNixPath = "${ ../../../../src/base/test-kubernetes-required-environment-roles-master-and-node.sh}";
        scriptName = "test-kubernetes-required-environment-rolemaster-and-node";
      };
in
customScript
