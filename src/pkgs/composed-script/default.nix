{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "composed-script";
  buildInputs = with pkgs; [ stdenv ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    (import ../hello-figlet { inherit pkgs;})
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

    rm -v $out/"${name}".sh

    patchShebangs $out/bin/"${name}"

    wrapProgram $out/bin/"${name}" \
      --prefix PATH : "${pkgs.lib.makeBinPath propagatedNativeBuildInputs }"
  '';

}