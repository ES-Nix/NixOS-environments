{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "create-img-size-1G";
  buildInputs = with pkgs; [ stdenv ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    bash
    coreutils
  ]
  ++
  (if stdenv.isDarwin then [ ]
  else [ cloud-utils ]);

  #src = builtins.path { path = ./.; name = "create-img-size-1G"; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out

    qemu-img create nixos.img 9G
    mv nixos.img $out/nixos.img
  '';

}
