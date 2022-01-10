{ pkgs, system ? "x86_64-linux", name ? "test-hello-figlet-cowsay" }:
let

  customScripts = rec {
    inherit name;
    scriptFullNixPath = "${ ../../../../src/base + "/${name}" + ".sh" }";
    customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
      pkgs = pkgs;
      system = system;
        propagatedNativeBuildInputs = with pkgs; [
          figlet
          hello
          cowsay
        ];
      scriptFullNixPath = scriptFullNixPath;
      scriptName = "${name}";
    };
  };
in
customScripts.customScript
