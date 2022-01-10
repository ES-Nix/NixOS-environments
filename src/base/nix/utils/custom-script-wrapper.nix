{ pkgs,
system ? "x86_64-linux",
buildInputs ? [ ],
nativeBuildInputs ? [ ],
propagatedNativeBuildInputs ? [ ],
scriptFullNixPath,
scriptName
 }:
let
  #pkgs = nixpkgs.legacyPackages.${system};
  customScriptWrapper = pkgs.stdenv.mkDerivation {
        name = scriptName;
        buildInputs = with pkgs; [ stdenv ] ++ buildInputs;
        nativeBuildInputs = with pkgs; [ makeWrapper ] ++ nativeBuildInputs;
        propagatedNativeBuildInputs = with pkgs; [ bash ] ++ propagatedNativeBuildInputs;

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
