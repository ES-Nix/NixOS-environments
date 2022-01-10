{ pkgs, system ? "x86_64-linux" }:
let
  customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
        pkgs = pkgs;
        system = system;
        propagatedNativeBuildInputs = with pkgs; [
          bash
        ];
        scriptFullNixPath = "${ ../../../../src/base/my-install-nixos.sh}";
        scriptName = "my-install-nixos";
      };
in
customScript
