{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "runVM";
  buildInputs = with pkgs; [ stdenv ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    bash
    coreutils

    qemu
  ];

  src = builtins.path { path = ./.; name = "${name}"; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin

    cp -r "${src}"/"${name}".sh $out

    install \
    -m0755 \
    $out/"${name}".sh \
    -D \
    $out/bin/"${name}"

    patchShebangs $out/bin/"${name}"

    wrapProgram $out/bin/"${name}" \
      --prefix PATH : "${pkgs.lib.makeBinPath propagatedNativeBuildInputs }"
  '';

}