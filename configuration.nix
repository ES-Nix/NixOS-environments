{ pkgs ? import <nixpkgs> {}, ... }:
{
  imports = [
    # configure the mountpoint of the root device
    ({
      fileSystems."/".device = "/dev/disk/by-label/nixos";
    })

    # configure the bootloader
    ({
      boot.loader.grub.extraConfig = ''
        serial --unit=0 --speed=115200
        terminal_output serial console; terminal_input serial console
      '';
      boot.kernelParams = [
        "console=tty0"
        "console=ttyS0,115200n8"
        # Set sensible kernel parameters
        # https://nixos.wiki/wiki/Bootloader
        # https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/commit/ddb4d96dacc52357e5eaec5870d9733a1ea63a5a?lang=pt-PT
        "boot.shell_on_fail"
        "panic=30"
        "boot.panic_on_fail" # reboot the machine upon fatal boot issues
      ];

      # TODO: document
      #boot.kernel.sysctl = { "net.netfilter.nf_conntrack_max" = 131072; };

      boot.loader.grub.device = "/dev/sda";
      boot.loader.grub.version = 2;

      # https://nix.dev/tutorials/building-bootable-iso-image
      # Needed for https://github.com/NixOS/nixpkgs/issues/58959
      boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.nixuser = {
        isNormalUser = true;

        # https://nixos.wiki/wiki/Libvirt
        extraGroups = [ "audio" "libvirtd" "wheel" "nixgroup" "networkmanager" "docker" "kvm"]; # Enable sudo for the user.

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbqkQxZD6I65C1cQ3A5N/LoTHR85x1k/tBbBymZsWw8 nixuser@nixos"
        ];
      };

    # Sad, but for now...
    # Is it usefull for some other thing?
    virtualisation.docker.enable = true;

    virtualisation.podman = {
        enable = true;
        # Create a `docker` alias for podman, to use it as a drop-in replacement
        #dockerCompat = true;
      };

    environment.etc."containers/registries.conf" = {
      mode="0644";
      text=''
        [registries.search]
        registries = ['docker.io', 'localhost']
      '';
    };

#      users.users.alice = {
#        isNormalUser = true;
#        home = "/home/alice";
#        description = "Alice Foobar";
#        extraGroups = [ "wheel" "networkmanager" ];
#        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAC3NzaC1lZDI1NTE5AAAAIDbqkQxZD6I65C1cQ3A5N/LoTHR85x1k/tBbBymZsWw8 alice" ];
#      };

      users.extraUsers.nixuser = {
        shell = pkgs.zsh;
      };

#      users.users.nixuser.openssh.authorizedKeys.keys = ["AAAAC3NzaC1lZDI1NTE5AAAAIDbqkQxZD6I65C1cQ3A5N/LoTHR85x1k/tBbBymZsWw8"];

#      users.users.nixuser.openssh.authorizedKeys.keys = let
#        keys = import ./ssh-keys.nix;
#      in
#        [ keys.nixuser ];

      # Who depends on it?
      hardware.opengl = {
        enable = true;
        driSupport = true;
      };

      # https://nixos.wiki/wiki/Libvirt
      boot.extraModprobeConfig = "options kvm_intel nested=1";

      # https://github.com/NixOS/nixpkgs/issues/27930#issuecomment-417943781
      boot.kernelModules = [ "kvm-intel" ];
    })

    # openssh and user configuration
    ({
      services.openssh = {
        allowSFTP = true;
        challengeResponseAuthentication = false;
        enable = true;
        forwardX11 = true;
        passwordAuthentication = true;
        permitRootLogin = "yes";
      };

      users.users."root".initialPassword = "r00t";

#      users.users.root.openssh.authorizedKeys.keys = [
#        "ssh-rsa AAAAC3NzaC1lZDI1NTE5AAAAIDbqkQxZD6I65C1cQ3A5N/LoTHR85x1k/tBbBymZsWw8"
#      ];

      #services.openssh.authorizedKeysFiles = ["./ssh-keys.nix"];

#      networking.useDHCP = false; # Disable DHCP globally as we will not need it.
#      networking.interfaces.eth0.useDHCP = true;

#      networking = {
#        hostName = "nixosvm";
#        networkmanager.enable = true;
#        defaultGateway = "x.x.x.x";
#        # Use google's public DNS server
#        nameservers = [ "8.8.8.8" ];
#        interfaces.eth0 = {
#          ipv4.addresses =  [ {
#              address = "192.168.1.2";
#              prefixLength = 24;
#            }
#          ];
#        };
#      };

#      networking.interfaces.eth0.ipv4.addresses = [ {
#        address = "192.168.1.2";
#        prefixLength = 24;
#        }
#      ];

    })
  ];

  nixpkgs.config.allowUnfree = true;
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
    sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh"];
  };

  # Use this option to avoid issues on macOS version upgrade
  # https://github.com/execat/nix/blob/0d4db14db79e1e692306c769e685146e8c8810c9/nix/default.nix#L13
  #users.nix.configureBuildUsers = true;

  # Probably solve many warns about fonts
  # https://gist.github.com/kendricktan/8c33019cf5786d666d0ad64c6a412526
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      corefonts           # Microsoft free fonts
      fira                # Monospace
      fira-code
      font-awesome
      hack-font
      inconsolata         # Monospace
      iosevka
      powerline-fonts
      ubuntu_font_family
      unifont             # International languages
    ];
  };

  # TODO: fix it!
  #time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    bashInteractive
    cacert            # If it is not used, it is like not have internet! Really hard to figure out it!
    coreutils

    #
    binutils
    bottom  # the binary name is btm
    coreutils
    dnsutils
    file
    findutils
    fzf
    inetutils # TODO: it was causing a conflict, insvestigate it!
    lsof
    neovim
    netcat
    nixpkgs-fmt
    nmap
    oh-my-zsh
    openssh
    openssl
    ripgrep
    strace
    tree
    unzip
    util-linux
    which
    zsh
    zsh-autosuggestions
    zsh-completions

#    minikube
#    kubectl
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
#
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
##     jetbrains.pycharm-community
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
  security.sudo.extraConfig = ''
    %wheel      ALL=(root)      NOPASSWD:SETENV: /nix/store/h63yf7a2ccfimas30i0wn54fp8c8h3qf-podman-rootless-derivation/bin/podman
  '';

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

  # TODO: study about this
  # https://github.com/thiagokokada/dotfiles/blob/a221bf1186fd96adcb537a76a57d8c6a19592d0f/_nixos/etc/nixos/misc-configuration.nix#L124-L128
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };


}
