{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "create-img-size-1G";
  buildInputs = with pkgs; [ stdenv ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    bash
    coreutils

    qemu
  ];

  #src = builtins.path { path = ./.; name = "create-img-size-1G"; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out

    qemu-img create nixos.img 1G
    mv nixos.img $out/nixos.img

    # Get some info
    # qemu-img info $out/nixos.img
  '';

}
