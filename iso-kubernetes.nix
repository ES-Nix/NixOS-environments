{ nixpkgs ? <nixpkgs>, system ? "x86_64-linux" }:
let
  pkgs = nixpkgs.legacyPackages.${system};

  PedroRegisPOARKeys = pkgs.writeText "pedro-regis-keys.pub" ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtmnCvUlP0tbWn7d9BvTqYWccTgDA2UEvTXMUdajDsoyLNaAqq/r+CiNuDepAgFsjRqI+vnDPvcUAogA2QbD9phJq1i5k57T6pnWBbxcoQ4CT7TPJPYk9jjkqIViANEM9P+XgVJo0XywChz9ryBngEGhNvIC+Muwln8NdKQBtH+4KvJHUInUh08m44dVom3G3uMcGEULabrRNxXM2SR+eJApoGwZsLlqIv91EZJmx2EjlAff423xoWcVrlqCERUNo7n++ywTeSDUx6criAfcIuvg65A6ybbbNNe4v8wk5Af2ig9FscPh23xV1Xo8hywM0+3XArIN8eaGltYPHKloEelOFnt/Jhberepu8T7NylOoOocBeBaOxvuTul+uvzPBfSgIBhyarfvr8vr8nl7RgnJIR83SoFh7Wc6KjvAAIfKpfyI60s4aPtUs8o9P+1qbGQu2yJMXod7KdO2qp4RMML6H5f+nIrNxOPGh5UTTJcFU84Yye3OdVD/Gr0ct4zBMU=
  '';

  RodrigoKeys = pkgs.writeText "rodrigo-keys.pub" ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8wXcAjwVJZ71MZkhFIfc1gCCTuZ8PRTKlUbqKdW68u0VToS35OYfYTmTRzFDrulXPX/HOZMtQ83UfY5igTtn0FMw1V16FNFmycGLIciCqYBdfB8Ex0xxbf8ZDAxgZ5BG+/lg+PXpNxX1fU7ltW47krYoWueJrGB2ACP53uhI/KcBVvpIW0XqPpYaoXseap89sOXZ0AkKUsC/YtB1bXz5p8oqXJfTyrQx+tHQ+zNg8QX6J84HkKXKoNEVTFjYP8VvKZAa32FkHrAvjRjqakemRxL7hnmoIvjAmFS3CfluYZRun/3AkQ4DsukxVLJxT1yL+WQQgNXc5Zbo5hYiPWXtSuFNQ5xE54qlJzkazp2ky9DNnwgDsvPEoILQwihYERpHQzgU6B4T3anvBQLKHDXkGFaVcA2eTf59D8GxGPeq9ylUZ9qDwjCIbX5biNw4InhockKmzhNsIq1tiqzpx5jR5BlrRxwtJDUnx+C1aX/GRKYedCQk1+yXHJ7WQIS3jSxk=
  '';

  JoaoKeys = pkgs.writeText "joao-keys.pub" ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqWdfY6g9gtETLFji9Sb60bcR1fQvS2ADdY9Ba0GtKhzjHNTmTgHxRoqLwOauDgxke9CJt5r9kolBHxGaMMJwcAwJlPgh0bodRm6LHsBatQYMyqYo2LvIGhT5WorlUp8zZWkZBP5CUuInQ48gieD62PMnU4rVmJdK8ZB48S4COz1IJx9ILr2unvVFJs7KT7WdNvbgfjKsTZrf/T/VMeQLodtdAIuWRuSUY5lJ3XwJCff2kCx5oAkZiz+3+a5z3LDqnwCeK8TkHnugmJHT09srlKSAA+bel+hxJtplsbYryeFVuYY8fILeOfNwI7Ht5ZZThIoLcUJfqKMPSlsBhEtFzqBA2ZE/NpStHKriIzLZbN2aUB0CWFPSa5g88H83qPyRInqR71O8WImQcH971BL41D+SHWhJEAbGZIaZwuYGaeiNe862SWrOv37Heh424b+RsEwVm0hUs9ZgdV3QqhMJlIEWyqIF4ueAlymqbtITYyI5kYuMo0yFW6dPYMSOUaHU=
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDgQUVq+Owq12TaW87tOlXnoTtUaYwe8OI36Ojk5naS7R47fJaZ7zfWRuaU20qznayhPcsn9kCW8eTUyMjsb89XHjLjdH84KzsIxKP1Wx2NXmsZIxV8iG8Mdd/58anNFBhH37G8TgCvYQmKtewLeoAYFFP7vmComLj2AtueI3Je0bITUq5p+zDUJhM7GDiS9xG71QjrBeMFO5HVO9oREEeHpSNqiXpSfFVN6i50gYHeIdM/nDzPVjStBr3c4v24t8C58yL8fNN0OrMNuQ2NxQF0ESdPWoeM3jGBC2xCy260QJnRS4S8NOXmMdfXpUYS3x0L0ODZOBdqGgIqxRJtqPLrNOiFjIXhWwZUgB10TnPTeHoQCQ8JOs85orbHmhUbm0GszS4/JztX0EFHYZvaHxfQJ8M+VVD90Hgz0V6o57ufSA5AWPulGJfQQvShhmLLmcMqT8QrgD6OH9m1yk/5N6xChzGGK9LpNIQnh8dNMnHMobXBjS2N0frPFMwUxKbzXGc=
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD5DqS+CTLOxyplRbtJG0dzSszJNw1901AHXdGdrXSXs/m6/OowevlceLZQXoEbWmgo8d05ngNiSAj61REEcbjXBLPzGVfilhevG1DLcBN64WIu+zRH4vYHO1VxxUcj2fYh22aX9IXWvPtsWIP/nzbPO+C8lxltaXwZZXai8Qo6nIZtik1tkC65abCr5Kqfpx2TJ9V6i8wOITmvcvK5jOK7vzpU0m3veDdwenMuTh5FSLcMgp9dAYFcYDIScif7z5rsBIk0q5gagt6d1y7OwGXKSKnV3rHIUvevcIvptx+mucHFUeXfAzRapIXTOTcaP+GEBNjETO8M5gtQlZOcqtZkScK04eh7kRYP5qBpmmyO9MuNEJ9AaXdV8lq52mSQ2JR1CS2wAVsSQMCjRJmndno7IUsYVzILzcMC48voZ5eZjCu3A1+a5BBSb8Hgf53V8Ly8CNNqUNqtjMZ3A3A6pNDBVurH1qO1PhgaPgFOFrY3nqggHDDlWRLg3Z1o1L3L3wM=
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuusNUPijbWxn5CatgqKIZ9EIarqcEOy2K+hydUXhXDJHvdbMQl/pfftyehm+dW/ydZ5FAo+szK3lAiRoQGprN43FZ0wYlJ9JzUcCr89TBThU+a7b3JBJFVGmXVgRCT03azgiskxjj1zg8RI5FMEU+KxOSLONagpVAmfdPb1YQxk7fLG7TWBZieGh6ZGMLQ9GO0LJUutn4fe8paOXFb/diVPbpPaxiC+pDKtD+cjUQ42qU/aOfRMNIdY/NSZxr1njCZ9vqtLTMJkWGLftL8VNDl29u2nVu13rsYiwGukR0f5LZa3BwzKrj3ZvX2Gz+mwwK3goNSfUYpfst/li/bKwQZT2xknslBlqniOyM02DV/dReV3XszO3pCdDKvsUhFNl+Rsfrw3EPrR38hM9AqmZL22IX8KXvtZb+8CyokQOZZbsZWctm8dCEDhUK/F/weg5gB6LVRIllhTxfC0rArMRm7QYBBAgBlypMdYileY/xjNm2QU9tRv064rn31W+68XU=
  '';

  # The ideia was to cache all images pulled using
  # sudo kubeadm config images pull
  # sudo kubeadm config images list
  # but how to put it as it was loaded like using
  # docker load < images.tar.gz ?
  alpine = pkgs.dockerTools.pullImage {
    imageName = "alpine";
    imageDigest = "sha256:635f0aa53d99017b38d1a0aa5b2082f7812b03e3cdb299103fe77b5c8a07f1d2";
    sha256 = "F+9wfrolpzAWFPPDX16yRNdB6vq7A2XaTaw5H9JONX0=";
#    finalImageTag = "3.14.3";
#    finalImageName = "alpine";
  };

  # https://github.com/NixOS/nixpkgs/issues/59364#issuecomment-723906760
  kubeMasterIP = "10.1.1.2";
  kubeMasterHostname = "localhost";
  kubeMasterAPIServerPort = 6443;

  configuration =
      { pkgs, ... }:
      { imports = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

          # Provide an initial copy of the NixOS channel so that the user
          # doesn't need to run "nix-channel --update" first.
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        ];

        users.extraUsers.nixuser = {
          isNormalUser = true;

          # https://nixos.wiki/wiki/Libvirt
          extraGroups = [
                          "audio"
                          "docker"
                          "kvm"
                          "libvirtd"
                          "networkmanager"
                          "nixgroup"
                          "wheel"
                        ];

          # It can be turned off, it is here for debug help
          # To crete a new one:
          # mkpasswd -m sha-512
          # https://unix.stackexchange.com/a/187337
          hashedPassword = "$6$XiENMV7S4t/XfN$lIZjnuRdNZVcY3qUjur7m4jCIMZCGi3obx1.wHVoQKaNFmEJJN4r.MKdZIkpFpXwt0d/lqI.ZlLnfdwZyXj0e/";

          # TODO: https://stackoverflow.com/a/67984113
          # https://www.vultr.com/docs/how-to-install-nixos-on-a-vultr-vps
          openssh.authorizedKeys.keyFiles = [
              PedroRegisPOARKeys
              RodrigoKeys
              JoaoKeys
            ];
        };


        virtualisation.docker = {
          enable = true;
          # enableOnBoot = true;

          # Was this fixed?
          # extraOptions = ''--iptables=false --ip-masq=false -b cbr0'';
        };

        # https://t.me/nixosbrasil/26612
        # services.smartd.enable = true;

#        virtualisation.podman = {
#            enable = true;
#            # Create a `docker` alias for podman, to use it as a drop-in replacement
#            #dockerCompat = true;
#          };

        environment.etc."containers/registries.conf" = {
          mode="0644";
          text=''
            [registries.search]
            registries = ['docker.io', 'localhost']
          '';
        };

#          sudo systemctl restart docker
#          sudo systemctl status docker
#        environment.etc."docker/daemon.json" = {
#          mode="0644";
#          # It was conflicting:
#          # "log-driver": "json-file",
#          # The CLI invocation that caused in the conflict:
#          # systemctl cat docker.service | grep 'log-driver=journald ' -A4 -B3
#          #
#          # "log-opts": {
#          #    "max-size": "100m"
#          # },
#          # "storage-driver": "overlay2"
#          text=''
#            {
#              "exec-opts": ["native.cgroupdriver=systemd"],
#            }
#          '';
#        };

        # Disable sudo for the tests and play/hack up stuff
        # Do NOT use it in PRODUCTION as false!
        security.sudo.wheelNeedsPassword = true;

        users.extraUsers.nixuser = {
          shell = pkgs.zsh;
        };

        environment.systemPackages = with pkgs; [

          #
          # https://discourse.nixos.org/t/ssl-peer-certificate-or-ssh-remote-key-was-not-ok-error-on-fresh-nix-install-on-macos/3582/4
          # If it is not used, it is like not have internet! Really hard to figure out it!
          cacert

          # Base minimal stuff
          bashInteractive
          coreutils
          git
          openssh # Is this needed?
          openssl # Is this needed?

          binutils
          bottom  # the binary name is btm
          dnsutils
          file
          findutils
          lsof
          neovim
          ripgrep
          strace
          tree
          unzip
          util-linux
          which

          oh-my-zsh
          zsh
          zsh-autosuggestions
          zsh-completions


          # Looks like kubernetes needs atleast all this
          kubectl
          kubernetes
          #
          cni
          cni-plugins
          conntrack-tools
          cri-o
          cri-tools
          docker
          ebtables
          ethtool
          flannel
          iptables
          socat

#          alpine
        ];

        environment.variables.KUBECONFIG = "/etc/kubernetes/cluster-admin.kubeconfig";

        # https://discourse.nixos.org/t/issues-using-nixos-container-to-set-up-an-etcd-cluster/8438/3
        # systemd.services.etcd.serviceConfig.Type = pkgs.lib.mkForce "exec";
        services.kubernetes = {
#          addonManager.enable = true;
#          addons = {
#            dashboard.enable = true;
#            dashboard.rbac.enable = true;
#            dns.enable = true;
#          };

          apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";

          apiserver = {
            advertiseAddress = kubeMasterIP;
#            enable = true;
            securePort = kubeMasterAPIServerPort;
          };
          controllerManager.enable = true;
#          flannel.enable = true;
          masterAddress = "${toString kubeMasterHostname}";
#          proxy.enable = true;
#          roles = [ "master" ];
          roles = [ "master" "node" ];
#          scheduler.enable = true;
          easyCerts = true;
#          kubelet.enable = true;

          # needed if you use swap
          # kubelet.extraOpts = "--fail-swap-on=false";
        };

#        services = {
#          flannel = {
#            enable = true;
#            etcd.endpoints = [ "http://127.0.0.1:2379" ];
#          };
#        };

        # TODO: Fix this!
        networking.firewall.enable = false;

        # https://nixos.wiki/wiki/Libvirt
        boot.extraModprobeConfig = "options kvm_intel nested=1";

        # https://github.com/NixOS/nixpkgs/issues/27930#issuecomment-417943781
        boot.kernelModules = [ "kvm-intel" ];

        # Is this ok to kubernetes?
        # Why free -h still show swap stuff but with 0?
        swapDevices = pkgs.lib.mkForce [ ];

        # https://github.com/NixOS/nixpkgs/issues/19246#issuecomment-252206901
        services.openssh = {
          allowSFTP = true;
          challengeResponseAuthentication = false;
          enable = true;
          forwardX11 = false;

          passwordAuthentication = true;
          ports = [29980];
          # TODO: hardening, is it dangerous? How much?
          # Do NOT use it in PRODUCTION as yes!
          permitRootLogin = "yes";
  #        What is the difference about this and the one in
  #        users.extraUsers.nixuser.openssh.authorizedKeys.keyFiles ?
          authorizedKeysFiles = [
                                  "${ toString PedroRegisPOARKeys}"
                                  "${ toString RodrigoKeys}"
                                  "${ toString JoaoKeys}"
                                ];
        };
        programs.ssh.forwardX11 = false;

        # What is it for?
        programs.ssh.setXAuthLocation = false;

        # Enable the X11 windowing system.
  #      services.xserver.enable = true;
  #      services.xserver.layout = "us";

        #
        # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235/7
        # users.users."root".initialPassword = "r00t";
        #
        # To crete a new one:
        # mkpasswd -m sha-512
        # https://unix.stackexchange.com/a/187337
        users.users."root".hashedPassword = "$6$gCCW9SQfMdwAmmAJ$fQDoVPYZerCi10z2wpjyk4ZxWrVrZkVcoPOTjFTZ5BJw9I9qsOAUCUPAouPsEMG.5Kk1rvFSwUB.NeUuPt/SC/";

        # https://www.linode.com/docs/guides/install-nixos-on-linode/
        # networking.usePredictableInterfaceNames = false;
        # networking.useDHCP = false; # Disable DHCP globally as we will not need it.
        ## required for ssh?
        #networking.interfaces.eth0.useDHCP = true;

        nixpkgs.config = {
          allowBroken = false;
          allowUnfree = true;
          # https://github.com/Pamplemousse/laptop/blob/f780c26bbef2fd0b681cac570fc016b4128de6ce/etc/nixos/packages.nix#L49

          # What is it for?
          # nativeOnly = true;
        };

        nix = {
          package = pkgs.nixFlakes;
          extraOptions =''
            keep-outputs = true
            keep-derivations = true
            experimental-features = nix-command flakes ca-references ca-derivations
            system-features = benchmark big-parallel kvm nixos-test
          '';

          # From:
          # https://github.com/sherubthakur/dotfiles/blob/be96fe7c74df706a8b1b925ca4e7748cab703697/system/configuration.nix#L44
          # pointted by: https://github.com/NixOS/nixpkgs/issues/124215
          sandboxPaths = [
                           "/bin/sh=${pkgs.bash}/bin/sh"
                           # TODO: test it!
                           # "/bin/sh=${pkgs.busybox-sandbox-shell}/bin/sh"
                         ];

          # TODO: document it
          trustedUsers = ["@wheel" "nixuser"];
          autoOptimiseStore = true;

          optimise.automatic = true;

          gc = {
            automatic = true;
            options = "--delete-older-than 1d";
          };

          buildCores = 4;
          maxJobs = 4;

          # Can be a hardening thing
          # https://github.com/sarahhodne/nix-system/blob/98dcfced5ff3bf08ccbd44a1d3619f1730f6fd71/modules/nixpkgs.nix#L16-L22
          readOnlyStore = true;
          # https://discourse.nixos.org/t/how-to-use-binary-cache-in-nixos/5202/4
          # https://www.reddit.com/r/NixOS/comments/p67ju0/cachix_configuration_in_configurationnix/h9b76fs/?utm_source=reddit&utm_medium=web2x&context=3
          binaryCaches = [
            "https://nix-community.cachix.org"
            "https://cache.nixos.org"
          ];
          binaryCachePublicKeys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
        };

        # https://github.com/NixOS/nixpkgs/blob/3a44e0112836b777b176870bb44155a2c1dbc226/nixos/modules/programs/zsh/oh-my-zsh.nix#L119
        # https://discourse.nixos.org/t/nix-completions-for-zsh/5532
        # https://github.com/NixOS/nixpkgs/blob/09aa1b23bb5f04dfc0ac306a379a464584fc8de7/nixos/modules/programs/zsh/zsh.nix#L230-L231
        programs.zsh = {
          enable = true;
          shellAliases = {
            vim = "nvim";
  #          podman = "sudo podman";
  #          kind = "sudo kind";
          };
          enableCompletion = true;
          autosuggestions.enable = true;
          interactiveShellInit = ''
            export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
            # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
            export ZSH_THEME="agnoster"
            export ZSH_CUSTOM=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
            plugins=(
                      colored-man-pages
                      docker
                      git
                      #zsh-autosuggestions # Why this causes an warn?
                      #zsh-syntax-highlighting
                    )
            source $ZSH/oh-my-zsh.sh
          '';
          ohMyZsh.custom = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
          promptInit = "";
        };



      };

    iso-image = import "${nixpkgs}/nixos" { inherit system configuration; };
in
iso-image.config.system.build.isoImage
