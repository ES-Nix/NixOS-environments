{ pkgs, system ? "x86_64-linux", name ? "my-install-nixos" }:
let
  customScripts = rec {
    inherit name;
    scriptFullNixPath = "${ ../../../../src/base + "/${name}" + ".sh" }";
    customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
      pkgs = pkgs;
      system = system;
        propagatedNativeBuildInputs = with pkgs; [
          bash

          (import ./install-nixos-gpt.nix { inherit system pkgs;})
          (import ./install-nixos-mbr.nix { inherit system pkgs;})

        ];
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
