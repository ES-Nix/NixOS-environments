{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  customScriptWrapper = import ./custom-script-wrapper.nix;
in
  customScriptWrapper {
    nixpkgs = nixpkgs;
    system = system;
    propagatedNativeBuildInputs = with nixpkgs.legacyPackages.${system}; [
      figlet
      hello
      cowsay
    ];
    scriptFullNixPath = "${ ./base/test-hello-figlet-cowsay.sh}";
    scriptName = "test-hello-figlet-cowsay";
  }
