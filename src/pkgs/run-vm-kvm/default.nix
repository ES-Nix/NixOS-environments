{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "run-vm-kvm";
  buildInputs = with pkgs; [ stdenv ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    bash
    coreutils

    qemu
    yj
    (import ./runVM.nix { inherit pkgs; })
  ]
  ++
  (if stdenv.isDarwin then [ ]
  else [ cloud-utils ]);

  src = builtins.path { path = ./.; name = "${name}".sh; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin

    cp -r "${src}"/"${name}".sh $out

    qemu-img create disk.qcow2 +12G

    mkdir -p $out/bin

    touch $out/userdata
    mv disk.qcow2 $out/disk.qcow2

    {
      echo '#cloud-config'
      echo '${builtins.toJSON cloudInitWithVolume}' | yj -jy
    } > cloud-init.yaml
    cloud-localds userdata.raw cloud-init.yaml
    qemu-img convert -p -f raw userdata.raw -O qcow2 "$out"/userdata.qcow2

    substituteInPlace $out/"${name}".sh \
      --replace ":-store-disk-name}" ":-$out/disk.qcow2}" \
      --replace ":-store-userdata-name}" ":-$out/userdata.qcow2}"

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
