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

        user_name="nixuser";

          sshClient = pkgsAllowUnfree.writeShellScriptBin "sshVM" ''
            sshKey=$(mktemp)
            trap 'rm $sshKey' EXIT
            cp ${./vagrant} "$sshKey"
            chmod 0600 "$sshKey"

            until ${pkgsAllowUnfree.openssh}/bin/ssh \
              -X \
              -o GlobalKnownHostsFile=/dev/null \
              -o UserKnownHostsFile=/dev/null \
              -o StrictHostKeyChecking=no \
              -o LogLevel=ERROR \
              -i "$sshKey" ${user_name}@127.0.0.1 -p 10023 "$@"; do
              ((c++)) && ((c==60)) && break
              sleep 1
            done
          '';

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
            nixpkgs-fmt
            nmap
            qemu
            which
            sshClient
          ];

          shellHook = ''
            export TMPDIR=/tmp

            # TODO
            #nix run nixpkgs#nixpkgs-fmt **/*.nix *.nix
          '';
        };
      }
    );
}



