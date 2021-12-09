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

        user_name = "nixuser";

        sshVM = pkgsAllowUnfree.writeShellScriptBin "ssh-vm" ''
                      sshKey=$(mktemp)
                      trap 'rm $sshKey' EXIT
                      cp ${./vagrant} "$sshKey"
                      chmod 0600 "$sshKey"

                      # TODO; decouple the kvm hardcoded dependency
                      # https://stackoverflow.com/a/19295632
                      qemu_process_id=$(pidof qemu-system-x86_64)
                      if [[ -z $qemu_process_id ]]; then
                          (run-vm-kvm < /dev/null &)
                      fi

          # https://unix.stackexchange.com/a/508856
          #
          # ssh -Q protocol-version localhost
          # https://askubuntu.com/a/1112242
          # https://serverfault.com/a/1040559
          #
          # Compression yes
          # https://unix.stackexchange.com/a/626033
          #
          # https://unix.stackexchange.com/a/326046
          # https://stackoverflow.com/a/49572001
          # https://stackoverflow.com/a/39339317
          #              -X11Forwarding yes \
          #
          # https://unix.stackexchange.com/a/191065
          #              -o X11UseLocalhost no \
          #
          # https://github.com/bitnami/minideb/blob/master/qemu_build#L11
          # https://askubuntu.com/questions/35512/what-is-the-difference-between-ssh-y-trusted-x11-forwarding-and-ssh-x-u/35518#35518

                      until
                         ${pkgsAllowUnfree.openssh}/bin/ssh \
                          -X \
                          -Y \
                          -o GlobalKnownHostsFile=/dev/null \
                          -o UserKnownHostsFile=/dev/null \
                          -o StrictHostKeyChecking=no \
                          -o LogLevel=ERROR \
                          -i "$sshKey" ${user_name}@127.0.0.1 -p 10023 "$@"; do
                        ((c++)) && ((c==60)) && break
                        sleep 1
                      done
        '';

        VMKill = pkgsAllowUnfree.writeShellScriptBin "vm-kill" ''
          kill -9 $(pidof qemu-system-x86_64)
        '';

        runVMKVM = pkgsAllowUnfree.writeShellScriptBin "run-vm-kvm" ''
                  #
                  # Starts the VM 
                  #
          #        set -euo pipefail
          #        image=$1
          #        userdata=$2
          #        shift 2

                  # TODO: document it, many magic stuff here!
                  # https://www.linux-kvm.org/page/9p_virtio
                  # https://superuser.com/a/1565275
                  # https://www.kernel.org/doc/Documentation/filesystems/9p.txt
                  # https://unix.stackexchange.com/questions/596646/is-it-okay-to-run-off-a-writable-9pfs-share-when-cache-loose
                  # https://askubuntu.com/questions/548208/sharing-folder-with-vm-through-libvirt-9p-permission-denied/1259833#1259833
                  # https://github.com/zimbatm/nix-experiments/blob/68c56e8b77b72f5d38d3bdb21c7a83b66d613e26/ubuntu-vm/default.nix#L36
                  # https://github.com/NixOS/nixpkgs/pull/127933#issuecomment-922325089
                  # https://github.com/lima-vm/lima/issues/20#issuecomment-917432296
                  args=(
                    -cpu Haswell-noTSX-IBRS,vmx=on
                    -cpu host
                    -device "rtl8139,netdev=net0"
                    -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
                    -enable-kvm
                    -fsdev local,security_model=passthrough,id=fsdev0,path="$(pwd)"
                    -hda nixos-vm-volume.qcow2
                    -m 18G
                    -netdev "user,id=net0,hostfwd=tcp:127.0.0.1:10023-:22"
                    -nic user
                    -nographic
                    -serial mon:stdio
                    -smp $(nproc)
                  )
    
                  set -x
                  exec ${pkgsAllowUnfree.qemu}/bin/qemu-kvm "''${args[@]}" "$@" >/dev/null 2>&1
        '';


        build = pkgsAllowUnfree.writeShellScriptBin "build" ''
          nix build --refresh github:ES-Nix/NixOS-environments/box#image.image
        '';

        buildDev = pkgsAllowUnfree.writeShellScriptBin "build-dev" ''
          nix build .#image.image
        '';

        refreshVM = pkgsAllowUnfree.writeShellScriptBin "refresh-vm" ''
          kill -9 $(pidof qemu-system-x86_64) || true
          test -f result/nixos.qcow2 || nix build github:ES-Nix/NixOS-environments/box#image.image
          cp -v result/nixos.qcow2 nixos-vm-volume.qcow2
          chmod -v 0755 nixos-vm-volume.qcow2
        '';

        refreshVMDev = pkgsAllowUnfree.writeShellScriptBin "refresh-vm-dev" ''
          kill -9 $(pidof qemu-system-x86_64) || true
          test -f result/nixos.qcow2 || nix build .#image.image
          cp -v result/nixos.qcow2 nixos-vm-volume.qcow2
          chmod -v 0755 nixos-vm-volume.qcow2
        '';

        NixOSBoxVolumeTest = pkgsAllowUnfree.writeShellScriptBin "nixos-box-test" ''
          build \
          && refresh-vm \
          && (run-vm-kvm < /dev/null &) \
          && { ssh-vm << COMMANDS
            volume-mount-hack
          COMMANDS
          } && { ssh-vm << COMMANDS
            ls -al /home/nixuser/code | rg result
          COMMANDS
          } && { ssh-vm << COMMANDS
            uname --all
          COMMANDS
          } && { ssh-vm << COMMANDS
            timeout 100 nix run nixpkgs#xorg.xclock
          COMMANDS
          } && { ssh-vm << COMMANDS
            timeout 100 pycharm-community
          COMMANDS
          } && ssh-vm
        '';

        NixOSBoxVolume = pkgsAllowUnfree.writeShellScriptBin "nixos-box-volume" ''
          build \
          && refresh-vm \
          && (run-vm-kvm < /dev/null &) \
          && { ssh-vm << COMMANDS
            volume-mount-hack
          COMMANDS
          } && ssh-vm
        '';

        NixOSBox = pkgsAllowUnfree.writeShellScriptBin "nixos-box" ''
          build \
          && refresh-vm \
          && (run-vm-kvm < /dev/null &) \
          && ssh-vm
        '';

      in
      {
        packages.image = import ./default.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          nixos = nixos;
        };

        packages.empty-qcow2 = import ./empty-qcow2/nixos-image.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.iso = import ./iso.nix {
          nixpkgs = nixpkgs;
          system = system;
        };

        packages.iso-kubernetes = import ./iso-kubernetes.nix {
          nixpkgs = nixpkgs;
          system = system;
          nixos = nixos;
        };

        packages.iso-base = import ./src/iso-base/iso-base.nix {
          nixpkgs = nixpkgs;
          system = system;
          nixos = nixos;
        };

        # TODO
        # https://github.com/NixOS/nix/issues/2854
        defaultPackage = self.packages.${system}.image.image;

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            bashInteractive
            cloud-utils
            coreutils
            file
            inetutils
            # libguestfs  # https://serverfault.com/a/432342
            #            libguestfs-with-appliance  # https://github.com/NixOS/nixpkgs/issues/112920#issuecomment-912494811
            lsof
            neovim
            netcat
            nixpkgs-fmt
            nmap
            qemu
            which

            NixOSBox
            NixOSBoxVolumeTest
            NixOSBoxVolume
            build
            buildDev
            refreshVM
            refreshVMDev
            runVMKVM
            sshVM
            VMKill

            # It slows a lot the nix develop
            #            self.packages.${system}.image.image
          ];

          shellHook = ''
            export TMPDIR=/tmp

            # TODO
            #nix run nixpkgs#nixpkgs-fmt **/*.nix *.nix

            alias nbv='nixos-box-volume'
            alias nb='nixos-box'
          '';
        };
      }
    );
}



