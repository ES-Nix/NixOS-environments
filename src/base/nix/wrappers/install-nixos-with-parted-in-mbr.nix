{ pkgs, system ? "x86_64-linux", name ? "install-nixos-with-parted-in-mbr" }:
let
  customScripts = rec {
    inherit name;
    scriptFullNixPath = "${ ../../../../src/base + "/${name}" + ".sh" }";
    customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
      pkgs = pkgs;
      system = system;
        propagatedNativeBuildInputs = with pkgs; [
          e2fsprogs
          parted
          mount
          util-linux
        ];
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
