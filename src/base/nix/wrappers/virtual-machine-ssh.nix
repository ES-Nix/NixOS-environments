{ pkgs, system ? "x86_64-linux", name ? "virtual-machine-ssh" }:
let
  customScripts = rec {
    inherit name;
    scriptFullNixPath = "${ ../../../../src/base + "/${name}" + ".sh" }";
    customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
      pkgs = pkgs;
      system = system;
      propagatedNativeBuildInputs = with pkgs; [
        bash
        coreutils
      ];
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
