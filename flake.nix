{
  description = "Flake...";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixos, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgsAllowUnfree = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
      in
      {
        packages.image = import ./default.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          nixos = nixos;
        };

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            bashInteractive
            coreutils
            file
            inetutils
            lsof
            neovim
            netcat
            nmap
            qemu
            which
          ];

          shellHook = ''
            export TMPDIR=/tmp
          '';
        };
      }
    );
}



