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

        apps.composed-script = flake-utils.lib.mkApp {
          name = "composed-script";
          drv = packages.composed-script;
        };

        apps.retry = flake-utils.lib.mkApp {
          name = "retry";
          drv = packages.retry;
        };

        apps.runVM = flake-utils.lib.mkApp {
          name = "runVM";
          drv = packages.runVM;
        };

        apps.run-vm-kvm = flake-utils.lib.mkApp {
          name = "run-vm-kvm";
          drv = packages.run-vm-kvm;
        };

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree;
                        with self.packages.${system}; [
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

              hello-figlet
              composed-script

              retry

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



