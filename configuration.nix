{ pkgs ? import <nixpkgs> {}, ... }:
let
  volumeMountHack = pkgs.writeShellScriptBin "volume-mount-hack" ''
    export VOLUME_MOUNT_PATH=/home/nixuser/code

    test -d "$VOLUME_MOUNT_PATH" || sudo mkdir -p "$VOLUME_MOUNT_PATH"

    sudo chmod 0700 /home/nixuser
    sudo chown nixuser:users -v /home/nixuser

    sudo mount -t 9p \
    -o trans=virtio,access=any,cache=none,version=9p2000.L,cache=none,msize=262144,rw \
    hostshare "$VOLUME_MOUNT_PATH"

    export OLD_UID=$(getent passwd "$(id -u nixuser)" | cut -f3 -d:)
    export NEW_UID=$(stat -c "%u" "$VOLUME_MOUNT_PATH")

    export OLD_GID=$(getent group "$(id -g nixuser)" | cut -f3 -d:)
    export NEW_GID=$(stat -c "%g" "$VOLUME_MOUNT_PATH")

    sudo chown nixuser:users -v /home/nixuser

    if [ "$OLD_UID" != "$NEW_UID" ]; then
        echo "Changing UID of $(id -u) from $OLD_UID to $NEW_UID"
        #sudo usermod -u "$NEW_UID" -o $(id -un $(id -u))
        sudo find / -xdev -uid "$OLD_UID" -exec chown -h "$NEW_UID" {} \;
    fi

    if [ "$OLD_GID" != "$NEW_GID" ]; then
        echo "Changing GID of $(id -g) from $OLD_GID to $NEW_GID"
        #sudo groupmod -g "$NEW_GID" -o $(id -gn $(id -u))
        sudo find / -xdev -group "$OLD_GID" -exec chgrp -h "$NEW_GID" {} \;
    fi

    # https://unix.stackexchange.com/a/560315
    if [[ "$OLD_UID" != "$NEW_UID" || "$OLD_GID" != "$NEW_GID" ]]; then
        echo "Changing /etc/passwd and/or /etc/group AND REBOOTING!"
        sudo su -c "sed -i -e \"s/^\(nixuser:[^:]\):[0-9]*:[0-9]*:/\1:''${NEW_UID}:''${NEW_GID}:/\" /etc/passwd && sed -i -e \"/^users/s/:[0-9]*:/:''${NEW_GID}:/g\" /etc/group && chown -v ''${NEW_UID}:''${NEW_GID} /home/nixuser && reboot"
    fi
  '';
in
{
  imports = [
    # configure the mountpoint of the root device
    ({
      fileSystems."/".device = "/dev/disk/by-label/nixos";
    })

    # configure the bootloader
    ({
      # TODO: how to test it?
      # https://gist.github.com/andir/88458b13c26a04752854608aacb15c8f#file-configuration-nix-L11-L12
      boot.loader.grub.extraConfig = ''
        serial --unit=0 --speed=115200
        terminal_output serial console; terminal_input serial console
      '';

      #
      boot.kernelParams = [
        # About the console=ttyS0
        # https://fadeevab.com/how-to-setup-qemu-output-to-console-and-automate-using-shell-script/
        "console=tty0"
        "console=ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100"
        # Set sensible kernel parameters
        # https://nixos.wiki/wiki/Bootloader
        # https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/commit/ddb4d96dacc52357e5eaec5870d9733a1ea63a5a?lang=pt-PT
        "boot.shell_on_fail"
        "panic=30"
        "boot.panic_on_fail" # reboot the machine upon fatal boot issues
      ];

      # TODO: test it!
      # boot.kernelPackages = pkgs.linuxPackages_latest;

      # TODO: document
      #boot.kernel.sysctl = { "net.netfilter.nf_conntrack_max" = 131072; };

      boot.loader.grub.device = "/dev/sda";
      boot.loader.grub.version = 2;

      # https://nix.dev/tutorials/building-bootable-iso-image
      # Needed for https://github.com/NixOS/nixpkgs/issues/58959
      boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

      # Define a user account.
      # Don't forget to set a password with `passwd`.
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
        hashedPassword = "$6$mjFTykvA04OgeQfm$lTo5uKI30VL816eBb.x11RErrBcLfyXsnaM2wKlQ41s14oZK27dVVy8McCCKYsaY4Byuqf3H6R8lFda.F/V3K1";

        # TODO: https://stackoverflow.com/a/67984113
        openssh.authorizedKeys.keyFiles = [
          ./vagrant.pub
          ];
      };

    # Disable sudo for the tests and play/hack up stuff
    security.sudo.wheelNeedsPassword = false;

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

    # TODO: do a NixOS test about this!
    # cat /etc/sudoers.d/nixuser | rg -w 'nixuser ALL=(ALL) NOPASSWD: ALL' || echo $?
    # rg -c -q -e 'nixuser ALL=\(ALL\) NOPASSWD: ALL' /etc/sudoers.d/nixuser || echo 'Error!'
    environment.etc."sudoers.d/nixuser" = {
      mode="0644";
      text=''
        nixuser ALL=(ALL) NOPASSWD:SETENV: ALL
      '';
    };

    environment.etc."ssh/sshd_config" = {
      mode="0644";
      text=''
        X11UseLocalHost no
      '';
    };

      users.extraUsers.nixuser = {
        shell = pkgs.zsh;
      };

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

      # ?
      # https://github.com/NixOS/nixpkgs/issues/19246#issuecomment-252206901
      services.openssh = {
        allowSFTP = true;
        challengeResponseAuthentication = false;
        enable = true;
        forwardX11 = true;
        passwordAuthentication = true;
        permitRootLogin = "yes";
#        What is the difference about this and the one in
#        users.extraUsers.nixuser.openssh.authorizedKeys.keyFiles ?
#        authorizedKeysFiles = [ "./vagrant.pub" ];
      };
      programs.ssh.forwardX11 = true;

      programs.ssh.setXAuthLocation = true;

      # Enable the X11 windowing system.
      services.xserver.enable = true;
      services.xserver.layout = "us";

      users.users."root".initialPassword = "r00t";

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

    # TODO: document it
    trustedUsers = ["@wheel"];
  };

  # Use this option to avoid issues on macOS version upgrade
  # https://github.com/execat/nix/blob/0d4db14db79e1e692306c769e685146e8c8810c9/nix/default.nix#L13
  #users.nix.configureBuildUsers = true;

  # Probably solve many warns about fonts
  # https://gist.github.com/kendricktan/8c33019cf5786d666d0ad64c6a412526
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

    volumeMountHack

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

        # Ohh eahh, it is a hack
        #echo 'volume-mount-hack' >> /home/nixuser/.zshrc

        # Ohh eahh, it is a hack
        echo 'sudo mount -t 9p \' >> /home/nixuser/.zshrc
        echo '-o trans=virtio,access=any,cache=none,version=9p2000.L,cache=none,msize=262144,rw \' >> /home/nixuser/.zshrc
        echo 'hostshare /home/nixuser/code' >> /home/nixuser/.zshrc

        echo 'sudo chown -R nixuser: /home/nixuser' >> /home/nixuser/.zshrc

        echo 'cd /home/nixuser/code' >> /home/nixuser/.zshrc

        chown nixuser: /home/nixuser/.zshrc
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
