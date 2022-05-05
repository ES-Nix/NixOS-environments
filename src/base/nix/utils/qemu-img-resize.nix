{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "qemu-img-resize";
  buildInputs = with pkgs; [ stdenv ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    bash
    coreutils

    qemu
    yj
    (import ./create-img-size-1G.nix { inherit pkgs; })
  ]
  ++
  (if stdenv.isDarwin then [ ]
  else [ cloud-utils ]);

  src = builtins.path { path = ./.; name = "qemu-img-resize"; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin

    cp -r "${src}"/* $out

    cp --reflink=auto "${image}" disk.qcow2
    chmod +w disk.qcow2
    qemu-img resize disk.qcow2 +12G

    mkdir -p $out/bin

    touch $out/userdata
    mv disk.qcow2 $out/disk.qcow2

    {
      echo '#cloud-config'
      echo '${builtins.toJSON cloudInitWithVolume}' | yj -jy
    } > cloud-init.yaml
    cloud-localds userdata.raw cloud-init.yaml
    qemu-img convert -p -f raw userdata.raw -O qcow2 "$out"/userdata.qcow2

    substituteInPlace $out/qemu-img-resize.sh \
      --replace ":-store-disk-name}" ":-$out/disk.qcow2}" \
      --replace ":-store-userdata-name}" ":-$out/userdata.qcow2}"

    install \
    -m0755 \
    $out/qemu-img-resize.sh \
    -D \
    $out/bin/qemu-img-resize

    patchShebangs $out/bin/qemu-img-resize

    wrapProgram $out/bin/qemu-img-resize \
      --prefix PATH : "${pkgs.lib.makeBinPath propagatedNativeBuildInputs }"
  '';

}
