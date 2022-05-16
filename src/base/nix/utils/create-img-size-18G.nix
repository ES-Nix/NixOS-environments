{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "create-img-size-18G";
  buildInputs = with pkgs; [ stdenv qemu ];
  nativeBuildInputs = with pkgs; [ makeWrapper cloud-utils ];
  propagatedNativeBuildInputs = with pkgs; [
    bash
    coreutils
    cloud-utils
  ];

  #src = builtins.path { path = ./.; name = "create-img-size-1G"; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out

    qemu-img create image.img 18G
    mv image.img $out/image.img

    # substituteInPlace $out/run-vm-kvm.sh \
    #   --replace "image.img" "$out/image.img"
  '';

}
