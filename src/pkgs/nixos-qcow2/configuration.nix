{ pkgs ? import <nixpkgs> { }, ... }:
let

  volumeMountHack = pkgs.writeShellScriptBin "volume-mount-hack" ''
    export VOLUME_MOUNT_PATH=/home/nixuser/code

    test -d "$VOLUME_MOUNT_PATH" || sudo mkdir -p "$VOLUME_MOUNT_PATH"

    sudo chmod 0700 /home/nixuser
    sudo chown nixuser:users -v /home/nixuser

    # It looks like it is possible split in many -o pieces:
    # https://github.com/machyve/xhyve/issues/70#issuecomment-178641144
    sudo mount -t 9p \
    -o trans=virtio,access=any,cache=none,version=9p2000.L,cache=none,msize=262144,rw \
    hostshare "$VOLUME_MOUNT_PATH"

    export OLD_UID=$(getent passwd "$(id -u nixuser)" | cut -f3 -d:)
    export NEW_UID=$(stat -c "%u" "$VOLUME_MOUNT_PATH")

    export OLD_GID=$(getent group "$(id -g nixuser)" | cut -f3 -d:)
    export NEW_GID=$(stat -c "%g" "$VOLUME_MOUNT_PATH")

    sudo chown nixuser:users -v /home/nixuser

    # TODO: document it
    # https://askubuntu.com/a/16719
    if [ "$OLD_UID" != "$NEW_UID" ]; then
        echo "Changing UID of $(id -un) from $OLD_UID to $NEW_UID"
        #sudo usermod -u "$NEW_UID" -o $(id -un $(id -u))
        sudo find / -xdev -uid "$OLD_UID" -exec chown -h "$NEW_UID" {} \;
    fi

    if [ "$OLD_GID" != "$NEW_GID" ]; then
        echo "Changing GID of $(id -un) from $OLD_GID to $NEW_GID"
        #sudo groupmod -g "$NEW_GID" -o $(id -gn $(id -u))
        sudo find / -xdev -group "$OLD_GID" -exec chgrp -h "$NEW_GID" {} \;
    fi

    # https://unix.stackexchange.com/a/560315
    if [[ "$OLD_UID" != "$NEW_UID" || "$OLD_GID" != "$NEW_GID" ]]; then
        # TODO: document it better
        # https://github.com/NixOS/nixpkgs/pull/122420#issuecomment-846377016
        echo "Changing /etc/passwd and/or /etc/group AND REBOOTING!"
        sudo su -c "sed -i -e \"s/^\(nixuser:[^:]\):[0-9]*:[0-9]*:/\1:''${NEW_UID}:''${NEW_GID}:/\" /etc/passwd && sed -i -e \"/^users/s/:[0-9]*:/:''${NEW_GID}:/g\" /etc/group && chown -v ''${NEW_UID}:''${NEW_GID} /home/nixuser && reboot"
    fi
  '';

  # https://github.com/Xe/nixos-configs/blob/ffa57412d4f93018491308892b114c155ac9fd49/media/autoinstall-paranoid/configuration.nix#L4-L5
  #  PedroRegisPOARKeys = pkgs.fetchurl {
  #    url = "https://github.com/PedroRegisPOAR.keys";
  #    hash = "sha256-Z5/a6L9XtZYZ/+2AA0vqQzf3LRa/x0k3VHkJkHBWfYY=";
  #  };

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

in
{
  imports = [
    # configure the mountpoint of the root device
    ({
      fileSystems."/".device = "/dev/disk/by-label/nixos";

      # How much of the universe would break?!
      # https://christine.website/blog/paranoid-nixos-2021-07-18
      #      fileSystems."/".options = [ "noexec" ];
      #      fileSystems."/etc/nixos".options = [ "noexec" ];
      #      fileSystems."/srv".options = [ "noexec" ];
      #      fileSystems."/var/log".options = [ "noexec" ];
    })

    # configure the bootloader
    ({
      # TODO: how to test it?
      # https://gist.github.com/andir/88458b13c26a04752854608aacb15c8f#file-configuration-nix-L11-L12
      boot.loader.grub.extraConfig = ''
        serial --unit=0 --speed=115200
        terminal_output serial console; terminal_input serial console
      '';

      #      #
      #      boot.kernelParams = [
      #        # About the console=ttyS0
      #        # https://fadeevab.com/how-to-setup-qemu-output-to-console-and-automate-using-shell-script/
      #        # https://www.linode.com/docs/guides/install-nixos-on-linode/
      #        "console=tty0"
      #        "console=ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100"
      #        # Set sensible kernel parameters
      #        # https://nixos.wiki/wiki/Bootloader
      #        # https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/commit/ddb4d96dacc52357e5eaec5870d9733a1ea63a5a?lang=pt-PT
      #        "boot.shell_on_fail"
      #        "panic=30"
      #        "boot.panic_on_fail" # reboot the machine upon fatal boot issues
      #      ];

      # TODO: test it!
      # boot.kernelPackages = pkgs.linuxPackages_latest;
      # boot.kernelPackages = pkgs.linux_5_15;
      # boot.kernelPackages = pkgs.linuxKernel.kernels.linux_5_15_hardened;

      # TODO: document
      # https://github.com/freifunkMUC/infra/blob/2e6b341b047532b202b365edc3c01d5177fd2075/modules/gateway.nix#L239
      # Hardening ralated?
      # https://github.com/NixOS/nixpkgs/issues/12987
      #boot.kernel.sysctl = { "net.netfilter.nf_conntrack_max" = 131072; };

      boot.loader.grub.device = "/dev/sda";
      boot.loader.grub.version = 2;

      # https://nix.dev/tutorials/building-bootable-iso-image
      # Needed for https://github.com/NixOS/nixpkgs/issues/58959
      # https://www.reddit.com/r/NixOS/comments/ni79b8/list_of_all_nixos_supported_file_systems/
      # boot.supportedFilesystems = [ "btrfs" "ext2" "ext3" "ext4" "exfat" "f2fs" "fat8" "fat16" "fat32" "ntfs" "xfs" "zfs" ];
      # boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

      # Define a user account.
      # Don't forget to set a password with `passwd`.
      users.extraUsers.nixuser = {
        isNormalUser = true;

        # https://nixos.wiki/wiki/Libvirt
        extraGroups = [
          # "audio"
          # "docker"
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
        hashedPassword = "$6$mjFTykvA04OgeQfm$lTo5uKI30VL816eBb.x11RErrBcLfyXsnaM2wKlQ41s14oZK27dVVy8McCCKYsaY4Byuqf3H6R8lFda.F/V3K1";

        # TODO: https://stackoverflow.com/a/67984113
        # https://www.vultr.com/docs/how-to-install-nixos-on-a-vultr-vps
        openssh.authorizedKeys.keyFiles = [
          #          ./vagrant.pub
          PedroRegisPOARKeys
          RodrigoKeys
          JoaoKeys
        ];
      };

      # Disable sudo for the tests and play/hack up stuff
      # Do NOT use it in PRODUCTION as false!
      security.sudo.wheelNeedsPassword = true;

      # Is it usefull for some other thing?
      #virtualisation.docker.enable = true;

      virtualisation.podman = {
        enable = true;
        # Create a `docker` alias for podman, to use it as a drop-in replacement
        #dockerCompat = true;
      };

      #      environment.etc."containers/registries.conf" = {
      #        mode = "0644";
      #        text = ''
      #          [registries.search]
      #          registries = ['docker.io', 'localhost']
      #        '';
      #      };

      # TODO: do a NixOS test about this!
      # cat /etc/sudoers.d/nixuser | rg -w 'nixuser ALL=(ALL) NOPASSWD: ALL' || echo $?
      # rg -c -q -e 'nixuser ALL=\(ALL\) NOPASSWD: ALL' /etc/sudoers.d/nixuser || echo 'Error!'
      # https://unix.stackexchange.com/a/377385
      environment.etc."sudoers.d/nixuser" = {
        mode = "0644";
        text = ''
          nixuser ALL=(ALL) NOPASSWD:SETENV: ALL
        '';
      };

      #    environment.etc."ssh/sshd_config" = {
      #      mode="0644";
      #      text=''
      #        X11UseLocalHost no
      #      '';
      #    };

      users.extraUsers.nixuser = {
        shell = pkgs.zsh;
      };

      # Who depends on it?
      # https://github.com/dguibert/dotfiles/blob/f530a82ff250b857495b7684a9bfe6e77ec25b5d/admin/nixops/flake.nix#L638-L642
      #      hardware.opengl = {
      #        enable = true;
      #        driSupport = true;
      #      };

      # https://nixos.wiki/wiki/Libvirt
      boot.extraModprobeConfig = "options kvm_intel nested=1";

      # https://github.com/NixOS/nixpkgs/issues/27930#issuecomment-417943781
      boot.kernelModules = [ "kvm-intel" ];
    })

    # openssh and user configuration
    ({

      # ?
      # https://github.com/NixOS/nixpkgs/issues/19246#issuecomment-252206901
      services.openssh = {
        allowSFTP = true;
        kbdInteractiveAuthentication = false;
        enable = true;
        forwardX11 = false;

        passwordAuthentication = true;
        ports = [ 29980 ];
        # TODO: hardening, is it dangerous? How much?
        # Do NOT use it in PRODUCTION as yes!
        permitRootLogin = "yes";
        #        What is the difference about this and the one in
        #        users.extraUsers.nixuser.openssh.authorizedKeys.keyFiles ?
        authorizedKeysFiles = [
          #                                "./vagrant.pub"
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
    })
  ];

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
    # https://github.com/Pamplemousse/laptop/blob/f780c26bbef2fd0b681cac570fc016b4128de6ce/etc/nixos/packages.nix#L49
    # TODO: test if it work
    # config.pulseaudio = true;

    # TODO: Test it
    #config.firefox.enablePlasmaBrowserIntegration = true;

    # TODO: Test it
    #config.oraclejdk.accept_license = true;

    #https://github.com/zyansheep/nixos-conf/blob/7b932af1b87bbe6cdf7bff1a8b7546d9b17f1720/nixos/development/platforms/android.nix#L13-L17
    #    config.allowUnfreePackages = [ "android-studio" ];
    #    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #      "android-studio-stable"
    #    ];

    # What is it for?
    # nativeOnly = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
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
    trustedUsers = [ "@wheel" "nixuser" ];
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

  # Use this option to avoid issues on macOS version upgrade
  # https://github.com/execat/nix/blob/0d4db14db79e1e692306c769e685146e8c8810c9/nix/default.nix#L13
  #users.nix.configureBuildUsers = true;

  # Probably solve many warns about fonts
  # https://gist.github.com/kendricktan/8c33019cf5786d666d0ad64c6a412526
  # The nixpkgs#xorg.xclock need some of them or not:
  # Warning: Missing charsets in String to FontSet conversion
  #  fonts = {
  #    fontDir.enable = true;
  #    fonts = with pkgs; [
  #      corefonts           # Microsoft free fonts
  #      fira                # Monospace
  #      fira-code
  #      font-awesome
  #      hack-font
  #      inconsolata         # Monospace
  #      iosevka
  #      powerline-fonts
  #      ubuntu_font_family
  #      unifont             # International languages
  #    ];
  #  };

  # TODO: fix it!
  #time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    bashInteractive
    #
    # https://discourse.nixos.org/t/ssl-peer-certificate-or-ssh-remote-key-was-not-ok-error-on-fresh-nix-install-on-macos/3582/4
    cacert # If it is not used, it is like not have internet! Really hard to figure out it!
    coreutils

    #
    #    binutils
    #bottom  # the binary name is btm
    git
    #    dnsutils
    file
    #    findutils
    #    fzf
    #    inetutils
    #    lsof
    neovim
    #    netcat
    #    nixpkgs-fmt
    #    nmap
    #    mtr
    #    sysstat
    oh-my-zsh
    openssh
    openssl
    #    ripgrep
    #    strace
    #    tree
    #    unzip
    #    util-linux
    which
    zsh
    zsh-autosuggestions
    zsh-completions

    #    volumeMountHack

    #    minikube
    kind
    kubectl
    #     # shell stuff
    #     direnv
    #     fzf
    #     neovim
    #     oh-my-zsh
    #     zsh
    #     zsh-autosuggestions
    #     zsh-completions
    #     bottom  # the binary name is btm
    #
    #     # Some utils
    #     binutils
    #     coreutils
    #     dnsutils
    #     file
    #     findutils
    #     # inetutils # TODO: it was causing a conflict, insvestigate it!
    #     nixpkgs-fmt
    #     ripgrep
    #     strace
    #     util-linux
    #     unzip
    #     tree
    #
    #     gzip
    #     unrar
    #     unzip
    #
    #     curl
    #     wget
    #
    #     graphviz # dot command comes from here
    #     jq
    #     unixtools.xxd

    #     # Caching compilers
    #     gcc
    #     gcc6
    #
    ##     anydesk
    ##     discord
    ##     firefox
    ##     freeoffice
    ##     gitkraken
    ##     klavaro
    ##     spectacle
    #     vlc
    #     xorg.xkill
    #
    ##     amazon-ecs-cli
    ##     awscli
    ##     docker
    ##     docker-compose
    ##     git
    ##     gnumake
    ##     gnupg
    ##     gparted
    #
    ##     youtube-dl
    ##     htop
    #     jetbrains.pycharm-community
    ##     keepassxc
    ##     okular
    ##     # libreoffice
    ##     python39Full
    ##     peek
    ##     insomnia

  ];


  # It is a hack, minkube only works if calling `sudo -k -n podman` does NOT ask for password.
  # The hardcoded path is because i am not using the podman installed in the system, but the one
  # in a flake that i am using at work. For now let it be hardcoded :|
  #
  # It looks like there is a bug too:
  # https://unix.stackexchange.com/questions/377362/in-nixos-how-to-add-a-user-to-the-sudoers-file
  # https://www.reddit.com/r/NixOS/comments/nzks7u/running_sudo_without_password/
  # https://github.com/NixOS/nixpkgs/issues/58276
  # https://github.com/NixOS/nixpkgs/pull/58396#issuecomment-574623527
  # https://unix.stackexchange.com/a/377385
  # https://unix.stackexchange.com/a/416646
  # https://unix.stackexchange.com/a/531762
  #
  # Related:
  # https://discourse.nixos.org/t/dont-prompt-a-user-for-the-sudo-password/9163/2
  #
  # About hardenig https://www.reddit.com/r/NixOS/comments/l95gm4/goodbye_sudo/
  #
  # TODO: use a more nix like way, do not use the hardcoded path
  # https://github.com/nixvital/vital-modules/blob/b99ee921b54428dbf7997f429fb35977eafe1491/foundations/container.nix#L39-L44
  #  security.sudo.extraConfig = ''
  #    %wheel      ALL=(root)      NOPASSWD:SETENV: /nix/store/h63yf7a2ccfimas30i0wn54fp8c8h3qf-podman-rootless-derivation/bin/podman
  #  '';

  # https://github.com/NixOS/nixpkgs/blob/3a44e0112836b777b176870bb44155a2c1dbc226/nixos/modules/programs/zsh/oh-my-zsh.nix#L119
  # https://discourse.nixos.org/t/nix-completions-for-zsh/5532
  # https://github.com/NixOS/nixpkgs/blob/09aa1b23bb5f04dfc0ac306a379a464584fc8de7/nixos/modules/programs/zsh/zsh.nix#L230-L231
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
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

  # Hack to fix annoying zsh warning, yes a hack...
  # https://www.reddit.com/r/NixOS/comments/cg102t/how_to_run_a_shell_command_upon_startup/eudvtz1/?utm_source=reddit&utm_medium=web2x&context=3
  #
  # https://www.linuxquestions.org/questions/debian-26/how-can-i-change-a-user%27s-uid-and-gid-328241/
  systemd.services.fix-zsh-warning = {
    script = ''
            echo "Fixing a zsh warning"

            # https://stackoverflow.com/questions/638975/how-do-i-tell-if-a-regular-file-does-not-exist-in-bash#comment25226870_638985
            if [ ! -f /home/nixuser/.zshrc ]; then
              touch /home/nixuser/.zshrc

      #        echo 'sudo umount /home/nixuser/code' >> /home/nixuser/.zshrc
      #
      #        # Ohh eahh, it is a hack
      #        #echo 'volume-mount-hack' >> /home/nixuser/.zshrc
      #
      #        # Ohh eahh, it is a hack
      #        # Convert it to a heredocument
      #
      #        echo 'sudo mount -t 9p \' >> /home/nixuser/.zshrc
      #        echo '-o trans=virtio,access=any,cache=none,version=9p2000.L,cache=none,msize=262144,rw \' >> /home/nixuser/.zshrc
      #        echo 'hostshare /home/nixuser/code' >> /home/nixuser/.zshrc
      #
      #        echo '! test -w /home/nixuser || sudo chown nixuser: /home/nixuser' >> /home/nixuser/.zshrc
      #
      #        echo 'cd /home/nixuser/code' >> /home/nixuser/.zshrc
      #
      #        chown nixuser: /home/nixuser/.zshrc
            fi

            if [ ! -f /home/nixuser/.Xauthority ]; then
              touch /home/nixuser/.Xauthority
              chown nixuser: /home/nixuser/.Xauthority
            fi

            if [ ! -f /home/nixuser/code ]; then
              mkdir -p /home/nixuser/code
              chown nixuser: /home/nixuser
            fi
    '';
    wantedBy = [ "multi-user.target" ];
  };

  # TODO: study about this
  # https://github.com/thiagokokada/dotfiles/blob/a221bf1186fd96adcb537a76a57d8c6a19592d0f/_nixos/etc/nixos/misc-configuration.nix#L124-L128
  #  zramSwap = {
  #    enable = true;
  #    algorithm = "zstd";
  #  };


}
