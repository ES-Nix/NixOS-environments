{ pkgs, system ? "x86_64-linux", name ? "install-nixos-gpt" }:
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

        (import ./install-nixos-with-parted-in-gpt.nix { inherit system pkgs;})
        (import ./prepare-git-stuff.nix { inherit system pkgs;})
        (import ./prepare-configuration-gpt.nix { inherit system pkgs;})

        # The broken...
        # (import ./copy-to-mnt.nix { inherit system pkgs;})

      ];
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
