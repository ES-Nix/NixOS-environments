{ pkgs, system ? "x86_64-linux", name ? "svissh" }:
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
        util-linux # https://serverfault.com/a/103366
        (import ./myssh.nix { inherit system pkgs;})
        (import ./retry.nix { inherit system pkgs;})
        (import ./start-qemu-vm-in-backround.nix { inherit system pkgs;})
      ];
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
