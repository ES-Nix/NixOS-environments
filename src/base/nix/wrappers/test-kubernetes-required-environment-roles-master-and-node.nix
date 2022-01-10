{ pkgs, system ? "x86_64-linux", name ? "test-kubernetes-required-environment-roles-master-and-node" }:
let
  customScripts = rec {
    inherit name;
    scriptFullNixPath = "${ ../../../../src/base + "/${name}" + ".sh" }";
    customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
      pkgs = pkgs;
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
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
