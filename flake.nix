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

          sshVM = pkgsAllowUnfree.writeShellScriptBin "ssh-vm" ''
            sshKey=$(mktemp)
            trap 'rm $sshKey' EXIT
            cp ${./vagrant} "$sshKey"
            chmod 0600 "$sshKey"


# https://unix.stackexchange.com/a/326046
# https://stackoverflow.com/a/49572001
#              -X11Forwarding yes \
#
# https://unix.stackexchange.com/a/191065
#              -o X11UseLocalhost no \
#            until
               ${pkgsAllowUnfree.openssh}/bin/ssh \
                -X \
                -Y \
                -o GlobalKnownHostsFile=/dev/null \
                -o UserKnownHostsFile=/dev/null \
                -o StrictHostKeyChecking=no \
                -o LogLevel=ERROR \
                -i "$sshKey" ${user_name}@127.0.0.1 -p 10023 "$@"
#                ; do
#              ((c++)) && ((c==60)) && break
#              sleep 1
#            done
          '';

      runVM = pkgsAllowUnfree.writeShellScriptBin "run-vm" ''

        test -f result/nixos.qcow2 || nix build .#image.image
        nix build .#image.image
        cp -v result/nixos.qcow2 nixos.qcow2
        chmod -v 0755 nixos.qcow2

        #
        # Starts the VM 
        #
#        set -euo pipefail
#        image=$1
#        userdata=$2
#        shift 2
    
        args=(
          -cpu Haswell-noTSX-IBRS,vmx=on
          -cpu host
          -device "rtl8139,netdev=net0"
          -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
          -enable-kvm
          -fsdev local,security_model=passthrough,id=fsdev0,path="$(pwd)"
          -hda nixos.qcow2
          -m 18G
          -netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:22"
          -nic user
          -nographic
          -serial mon:stdio
          -smp $(nproc)
        )
    
        set -x
        exec ${pkgsAllowUnfree.qemu}/bin/qemu-kvm "''${args[@]}" "$@" # >/dev/null 2>&1
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

            sshVM
            runVM
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



