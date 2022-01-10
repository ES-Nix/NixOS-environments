{ pkgs, system ? "x86_64-linux" }:
let
  # pkgs = nixpkgs.legacyPackages.${system};
  customScript = (import ../../../../src/base/nix/utils/custom-script-wrapper.nix) {
        pkgs = pkgs;
        system = system;
        propagatedNativeBuildInputs = with pkgs; [
          figlet
          hello
          cowsay
        ];
        scriptFullNixPath = "${ ../../../../src/base/test-hello-figlet-cowsay.sh}";
        scriptName = "test-hello-figlet-cowsay";
      };
in
customScript
