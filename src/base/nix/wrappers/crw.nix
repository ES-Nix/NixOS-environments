{ pkgs, system ? "x86_64-linux", name ? "crw" }:
let
  customScripts = rec {
    inherit name;
    scriptFullNixPath = "${ ../../../../src/base + "/${name}" + ".sh" }";
    customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
      pkgs = pkgs;
      system = system;
      propagatedNativeBuildInputs = with pkgs; [
        bash
        coreutils # readlink comes from coreutils
        which
      ];
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
