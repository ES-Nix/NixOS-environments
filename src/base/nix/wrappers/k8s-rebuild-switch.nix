{ pkgs, system ? "x86_64-linux", name ? "k8s-rebuild-switch" }:
let
  customScripts = rec {
    inherit name;
    scriptFullNixPath = "${ ../../../../src/base + "/${name}" + ".sh" }";
    customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
      pkgs = pkgs;
      system = system;
      propagatedNativeBuildInputs = with pkgs; [
        bash
        (import ./nrt.nix { inherit system pkgs;})
        (import ./custom-rebuild-switch.nix { inherit system pkgs;})
      ];
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
