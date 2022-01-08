{ nixpkgs ? <nixpkgs>,
system ? "x86_64-linux",
buildInputs ? with nixpkgs.legacyPackages.${system}; [ stdenv ],
nativeBuildInputs ? with nixpkgs.legacyPackages.${system}; [ makeWrapper ],
propagatedNativeBuildInputs ? with nixpkgs.legacyPackages.${system}; [ bash ],
scriptFullNixPath,
scriptName
 }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  customScriptWrapper = pkgs.stdenv.mkDerivation {
        name = scriptName;
        inherit buildInputs;
        inherit nativeBuildInputs;
        inherit propagatedNativeBuildInputs;

        installPhase = ''
          mkdir -p $out/bin

          install \
          -m0755 \
          ${scriptFullNixPath} \
          -D \
          $out/bin/${scriptName}

          patchShebangs $out/bin/${scriptName}

          wrapProgram "$out/bin/${scriptName}" \
            --prefix PATH : ${pkgs.lib.makeBinPath propagatedNativeBuildInputs }
        '';
        phases = [ "buildPhase" "installPhase" "fixupPhase" ];
      };
in
customScriptWrapper
