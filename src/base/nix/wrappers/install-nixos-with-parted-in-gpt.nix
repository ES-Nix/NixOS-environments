{ pkgs, system ? "x86_64-linux" }:
let
  customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
        pkgs = pkgs;
        system = system;
        propagatedNativeBuildInputs = with pkgs; [
          e2fsprogs
          parted
          mount
          util-linux
        ];
        scriptFullNixPath = "${ ../../../../src/base/install-nixos-with-parted-in-gpt.sh}";
        scriptName = "install-nixos-with-parted-in-gpt";
      };
in
customScript
