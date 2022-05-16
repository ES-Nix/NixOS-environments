{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "create-img-size-1G";
  buildInputs = with pkgs; [ stdenv qemu ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    bash
    coreutils


    # qemu
  ];

  #src = builtins.path { path = ./.; name = "create-img-size-1G"; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out

    qemu-img create image.img 1G
    mv image.img $out/image.img

    # Get some info
    # qemu-img info $out/image.img
  '';

}
