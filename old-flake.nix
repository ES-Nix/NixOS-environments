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
          inherit system;
          config = { allowUnfree = true; };
        };

        user_name = "nixuser";

        packages = (import ./src/pkgs { pkgs = pkgsAllowUnfree; nixpkgs = nixpkgs; });


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
          nix build --refresh github:ES-Nix/NixOS-environments/box#image
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

        NixOSBox = pkgsAllowUnfree.writeShellScriptBin "nixos-box" ''
          build \
          && refresh-vm \
          && (run-vm-kvm < /dev/null &) \
          && ssh-vm
        '';

        my-script-deps = with pkgsAllowUnfree; [ figlet hello ];
        test-hello-figlet = pkgsAllowUnfree.runCommandLocal "test-hello-figlet.sh"
          { nativeBuildInputs = [ pkgsAllowUnfree.makeWrapper ]; }
          ''
            install -m755 ${./test-hello-figlet.sh} -D $out/bin/test-hello-figlet.sh
            patchShebangs $out/bin/test-hello-figlet.sh
            wrapProgram "$out/bin/test-hello-figlet.sh" \
            --prefix PATH : ${pkgsAllowUnfree.lib.makeBinPath my-script-deps}
          '';

        wrapp-iso-kubernetes-qemu-kvm-mrb-deps = with pkgsAllowUnfree; [
          stdenv
          qemu
        ];
        wrapp-iso-kubernetes-qemu-kvm-mrb = pkgsAllowUnfree.runCommandLocal "wrapp-iso-kubernetes-qemu-kvm-mrb"
          { nativeBuildInputs = [ pkgsAllowUnfree.makeWrapper ]; }
          ''
            install -m755 ${./src/base/wrapp-iso-kubernetes-qemu-kvm-mrb.sh} -D $out/bin/wrapp-iso-kubernetes-qemu-kvm-mrb
            patchShebangs $out/bin/wrapp-iso-kubernetes-qemu-kvm-mrb
            wrapProgram "$out/bin/wrapp-iso-kubernetes-qemu-kvm-mrb" \
            --prefix PATH : ${pkgsAllowUnfree.lib.makeBinPath wrapp-iso-kubernetes-qemu-kvm-mrb-deps}
          '';

        pkgsAndSystem = {
           pkgs = pkgsAllowUnfree;
           inherit system;
        };

#        myImportGeneric = pkgsAndSystem: fullFilePath:
#          import fullFilePath pkgsAndSystem;
#
##
#
#        myImport = myImportGeneric pkgsAndSystem;
#
#        test-hello-figlet-cowsay = myImport ./src/base/nix/wrappers/test-hello-figlet-cowsay.nix;
#        test-composed-script = myImport ./src/base/nix/wrappers/test-composed-script.nix;
#        retry = myImport ./src/base/nix/wrappers/retry.nix;
#        myssh = myImport ./src/base/nix/wrappers/myssh.nix;
#        start-qemu-vm-in-backround = myImport ./src/base/nix/wrappers/start-qemu-vm-in-backround.nix;
#        my-script = myImport ./src/base/nix/wrappers/my-script.nix;
#        virtual-machine-ssh = myImport ./src/base/nix/wrappers/virtual-machine-ssh.nix;
#        svssh = myImport ./src/base/nix/wrappers/svssh.nix;
#        svissh = myImport ./src/base/nix/wrappers/svissh.nix;
#        prepare-clean-old-stuff-and-create-iso-and-disk = myImport ./src/base/nix/wrappers/prepare-clean-old-stuff-and-create-iso-and-disk.nix;

      in
      {

#        packages.test-hello-figlet-cowsay = test-hello-figlet-cowsay;
#        packages.test-composed-script = test-composed-script;
#
#        packages.retry = retry;
#        packages.myssh = myssh;
#        packages.start-qemu-vm-in-backround = start-qemu-vm-in-backround;
#        packages.test-hello-figlet = test-hello-figlet;
#        packages.my-script = my-script;
#        packages.virtual-machine-ssh = virtual-machine-ssh;
#        packages.svssh = svssh;
#        packages.svissh = svissh;
#        packages.prepare-clean-old-stuff-and-create-iso-and-disk = prepare-clean-old-stuff-and-create-iso-and-disk;
#
#
#        packages.create-img-size-1G  = import ./src/base/nix/utils/create-img-size-1G.nix { pkgs = pkgsAllowUnfree; };
#        packages.create-img-size-9G  = import ./src/base/nix/utils/create-img-size-9G.nix { pkgs = pkgsAllowUnfree; };
#        packages.create-img-size-18G  = import ./src/base/nix/utils/create-img-size-18G.nix { pkgs = pkgsAllowUnfree; };

        # If ( ... ).image is not used most things like
        # nix flake check and others fail
#        packages.image = (import ./default.nix {
#          # pkgs = nixpkgs.legacyPackages."(if pkgs.stdenv.isDarwin then "" else ${system})";
#          pkgs = nixpkgs.legacyPackages.x86_64-linux;
#          nixos = nixos;
#        }).image;

#        packages.empty-qcow2 = import ./empty-qcow2/nixos-image.nix {
#          # TODO: why it only works on linux?
#          pkgs = nixpkgs.legacyPackages.x86_64-linux;
#        };
#
#       packages.iso = import ./iso.nix {
#         nixpkgs = nixpkgs;
#         system = system;
#       };
#
#        packages.iso-kubernetes = import ./src/base/iso-kubernetes.nix {
#          nixpkgs = nixpkgs;
#          # Yeah, it is hardcoded
#          system = "x86_64-linux";
#          nixos = nixos;
#        };
#
#        packages.iso-kubernetes-qemu-kvm-mrb = wrapp-iso-kubernetes-qemu-kvm-mrb;
#
#        packages.iso-base = import ./src/base/iso.nix {
#          nixpkgs = nixpkgs;
#          system = system;
#          nixos = nixos;
#        };

        # packages.qcow2-base = (import ./src/base/qcow2-compressed.nix {
        #   pkgs = nixpkgs.legacyPackages.${system};
        #   nixos = nixos;
        # }).image;

        #packages.createImage = pkgsAllowUnfree.runCommand "create-image"
        #  {
        #    buildInputs = with pkgsAllowUnfree; [
        #      coreutils # nproc comes from here
        #      iputils
        #      qemu
        #      self.packages.${system}.iso-kubernetes
        #    ];
        #    ISO_KUBERNETES_PATH = "''${self.packages.${system}.iso-kubernetes}/iso/nixos-21.11pre-git-x86_64-linux.iso";
        #  } ''
        #
        #  # echo $ISO_KUBERNETES_PATH
        #  # echo $(nproc)
        #
        #  mkdir $out
        #
        #  # ping -c 5 www.google.com
        #  #qemu-img create $out/nixos.img 10G
        #  #
        #  #qemu-kvm \
        #  #-boot d \
        #  #-drive format=raw,file=$out/nixos.img \
        #  #-cdrom "$ISO_KUBERNETES_PATH" \
        #  #-m 12G \
        #  #-enable-kvm \
        #  #-cpu host \
        #  #-smp $(nproc) \
        #  #-nographic
        #  #
        #  #qemu-img info $out/nixos.img
        #'';

#        packages.iso-minimal = import ./src/base/iso-minimal.nix {
#          nixpkgs = nixpkgs;
#        };

#        packages.testCacheInFlakeCheck = pkgsAllowUnfree.runCommand "test-cache-in-flake-check"
#          {
#            buildInputs = with pkgsAllowUnfree; [
#              coreutils
#              self.packages.${system}.iso-minimal
#            ];
#            ISO_PATH = "${self.packages.${system}.iso-minimal}/iso/nixos-21.11pre-git-x86_64-linux.iso";
#            QCOW2_PATH = "${self.packages.${system}.empty-qcow2}/nixos.qcow2";
#          } ''
#
#          # sha256sum "$ISO_PATH"
#          echo '66d7c39ebf2f92549c5ca7a01dcee2ea4787d628ba6bdaa72822ada22afe8a09'  "$ISO_PATH" | sha256sum -c
#
#          # sha256sum "$QCOW2_PATH"
#          echo '4f9e5251960c098805723bd9d357e6d7934f1fd9a0681111b6488bbedc3c1277'  "$QCOW2_PATH" | sha256sum -c
#
#          mkdir $out #sucess
#        '';


        # TODO
        # https://github.com/NixOS/nix/issues/2854
        # defaultPackage = self.packages.${system}.iso-minimal;

        checks = {
          # nixpkgs-fmt = self.packages.${system}.checkNixFormat;
          # iso = self.packages.${system}.iso;
          # iso-base = self.packages.${system}.iso-base;
          # iso-kubernetes = self.packages.${system}.iso-kubernetes;
          # empty-qcow2 = self.packages.${system}.empty-qcow2;
          # qcow2-base = self.packages.${system}.qcow2-base;
          # testCacheInFlakeCheck = self.packages.${system}.testCacheInFlakeCheck;
          # iso-minimal = self.defaultPackage.${system};
        };

        # The outer `rec` makes this possible
        inherit packages;

        # nix run .#hello-figlet
        # nix path-info -rsSh .#hello-figlet
        # nix run .#hello-figlet -- --greeting 'Abcde'
        apps.hello-figlet = flake-utils.lib.mkApp {
          name = "hello-figlet";
          drv = packages.hello-figlet;
        };

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree;
                        with packages; [
            bashInteractive
            coreutils
            file
            inetutils
            # libguestfs  # https://serverfault.com/a/432342
            # libguestfs-with-appliance  # https://github.com/NixOS/nixpkgs/issues/112920#issuecomment-912494811
            lsof
            neovim
            netcat
            nixpkgs-fmt
            nmap
            qemu
            which

            #NixOSBox
            #NixOSBoxVolumeTest
            #NixOSBoxVolume
            #build
            #buildDev
            #refreshVM
            #refreshVMDev
            #runVMKVM
            #sshVM
            #VMKill

#            OVMFFull

#            my-script
#            wrapp-iso-kubernetes-qemu-kvm-mrb
#            # prepare-clean-old-stuff-and-create-iso-and-disk
#
#            self.packages.${system}.test-hello-figlet-cowsay
#            self.packages.${system}.test-composed-script
#
#            self.packages.${system}.myssh
#            self.packages.${system}.retry
#            self.packages.${system}.start-qemu-vm-in-backround
#            self.packages.${system}.my-script
#            self.packages.${system}.virtual-machine-ssh
#            self.packages.${system}.svssh
#            self.packages.${system}.svissh
#            self.packages.${system}.create-img-size-1G
#            self.packages.${system}.create-img-size-9G
#            self.packages.${system}.create-img-size-18G
#            self.packages.${system}.prepare-clean-old-stuff-and-create-iso-and-disk

              # hello-figlet
              # composed-script

              # retry

              # runVM
              # run-vm-kvm

            # It slows a lot the nix develop
            # self.packages.${system}.image.image

            kubectl
          ]++
  (if stdenv.isDarwin then [ ]
  else [ cloud-utils ]);

          shellHook = ''
            export TMPDIR=/tmp
          '';
        };
      }
    );
}


