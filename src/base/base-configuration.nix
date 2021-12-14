{ pkgs, nixpkgs, ... }:
let
  JoaoKeys = pkgs.writeText "joao-keys.pub" ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqWdfY6g9gtETLFji9Sb60bcR1fQvS2ADdY9Ba0GtKhzjHNTmTgHxRoqLwOauDgxke9CJt5r9kolBHxGaMMJwcAwJlPgh0bodRm6LHsBatQYMyqYo2LvIGhT5WorlUp8zZWkZBP5CUuInQ48gieD62PMnU4rVmJdK8ZB48S4COz1IJx9ILr2unvVFJs7KT7WdNvbgfjKsTZrf/T/VMeQLodtdAIuWRuSUY5lJ3XwJCff2kCx5oAkZiz+3+a5z3LDqnwCeK8TkHnugmJHT09srlKSAA+bel+hxJtplsbYryeFVuYY8fILeOfNwI7Ht5ZZThIoLcUJfqKMPSlsBhEtFzqBA2ZE/NpStHKriIzLZbN2aUB0CWFPSa5g88H83qPyRInqR71O8WImQcH971BL41D+SHWhJEAbGZIaZwuYGaeiNe862SWrOv37Heh424b+RsEwVm0hUs9ZgdV3QqhMJlIEWyqIF4ueAlymqbtITYyI5kYuMo0yFW6dPYMSOUaHU=
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDgQUVq+Owq12TaW87tOlXnoTtUaYwe8OI36Ojk5naS7R47fJaZ7zfWRuaU20qznayhPcsn9kCW8eTUyMjsb89XHjLjdH84KzsIxKP1Wx2NXmsZIxV8iG8Mdd/58anNFBhH37G8TgCvYQmKtewLeoAYFFP7vmComLj2AtueI3Je0bITUq5p+zDUJhM7GDiS9xG71QjrBeMFO5HVO9oREEeHpSNqiXpSfFVN6i50gYHeIdM/nDzPVjStBr3c4v24t8C58yL8fNN0OrMNuQ2NxQF0ESdPWoeM3jGBC2xCy260QJnRS4S8NOXmMdfXpUYS3x0L0ODZOBdqGgIqxRJtqPLrNOiFjIXhWwZUgB10TnPTeHoQCQ8JOs85orbHmhUbm0GszS4/JztX0EFHYZvaHxfQJ8M+VVD90Hgz0V6o57ufSA5AWPulGJfQQvShhmLLmcMqT8QrgD6OH9m1yk/5N6xChzGGK9LpNIQnh8dNMnHMobXBjS2N0frPFMwUxKbzXGc=
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD5DqS+CTLOxyplRbtJG0dzSszJNw1901AHXdGdrXSXs/m6/OowevlceLZQXoEbWmgo8d05ngNiSAj61REEcbjXBLPzGVfilhevG1DLcBN64WIu+zRH4vYHO1VxxUcj2fYh22aX9IXWvPtsWIP/nzbPO+C8lxltaXwZZXai8Qo6nIZtik1tkC65abCr5Kqfpx2TJ9V6i8wOITmvcvK5jOK7vzpU0m3veDdwenMuTh5FSLcMgp9dAYFcYDIScif7z5rsBIk0q5gagt6d1y7OwGXKSKnV3rHIUvevcIvptx+mucHFUeXfAzRapIXTOTcaP+GEBNjETO8M5gtQlZOcqtZkScK04eh7kRYP5qBpmmyO9MuNEJ9AaXdV8lq52mSQ2JR1CS2wAVsSQMCjRJmndno7IUsYVzILzcMC48voZ5eZjCu3A1+a5BBSb8Hgf53V8Ly8CNNqUNqtjMZ3A3A6pNDBVurH1qO1PhgaPgFOFrY3nqggHDDlWRLg3Z1o1L3L3wM=
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuusNUPijbWxn5CatgqKIZ9EIarqcEOy2K+hydUXhXDJHvdbMQl/pfftyehm+dW/ydZ5FAo+szK3lAiRoQGprN43FZ0wYlJ9JzUcCr89TBThU+a7b3JBJFVGmXVgRCT03azgiskxjj1zg8RI5FMEU+KxOSLONagpVAmfdPb1YQxk7fLG7TWBZieGh6ZGMLQ9GO0LJUutn4fe8paOXFb/diVPbpPaxiC+pDKtD+cjUQ42qU/aOfRMNIdY/NSZxr1njCZ9vqtLTMJkWGLftL8VNDl29u2nVu13rsYiwGukR0f5LZa3BwzKrj3ZvX2Gz+mwwK3goNSfUYpfst/li/bKwQZT2xknslBlqniOyM02DV/dReV3XszO3pCdDKvsUhFNl+Rsfrw3EPrR38hM9AqmZL22IX8KXvtZb+8CyokQOZZbsZWctm8dCEDhUK/F/weg5gB6LVRIllhTxfC0rArMRm7QYBBAgBlypMdYileY/xjNm2QU9tRv064rn31W+68XU=
  '';

  PedroRegisPOARKeys = pkgs.writeText "pedro-regis-keys.pub" ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtmnCvUlP0tbWn7d9BvTqYWccTgDA2UEvTXMUdajDsoyLNaAqq/r+CiNuDepAgFsjRqI+vnDPvcUAogA2QbD9phJq1i5k57T6pnWBbxcoQ4CT7TPJPYk9jjkqIViANEM9P+XgVJo0XywChz9ryBngEGhNvIC+Muwln8NdKQBtH+4KvJHUInUh08m44dVom3G3uMcGEULabrRNxXM2SR+eJApoGwZsLlqIv91EZJmx2EjlAff423xoWcVrlqCERUNo7n++ywTeSDUx6criAfcIuvg65A6ybbbNNe4v8wk5Af2ig9FscPh23xV1Xo8hywM0+3XArIN8eaGltYPHKloEelOFnt/Jhberepu8T7NylOoOocBeBaOxvuTul+uvzPBfSgIBhyarfvr8vr8nl7RgnJIR83SoFh7Wc6KjvAAIfKpfyI60s4aPtUs8o9P+1qbGQu2yJMXod7KdO2qp4RMML6H5f+nIrNxOPGh5UTTJcFU84Yye3OdVD/Gr0ct4zBMU=
  '';

  RodrigoKeys = pkgs.writeText "rodrigo-keys.pub" ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8wXcAjwVJZ71MZkhFIfc1gCCTuZ8PRTKlUbqKdW68u0VToS35OYfYTmTRzFDrulXPX/HOZMtQ83UfY5igTtn0FMw1V16FNFmycGLIciCqYBdfB8Ex0xxbf8ZDAxgZ5BG+/lg+PXpNxX1fU7ltW47krYoWueJrGB2ACP53uhI/KcBVvpIW0XqPpYaoXseap89sOXZ0AkKUsC/YtB1bXz5p8oqXJfTyrQx+tHQ+zNg8QX6J84HkKXKoNEVTFjYP8VvKZAa32FkHrAvjRjqakemRxL7hnmoIvjAmFS3CfluYZRun/3AkQ4DsukxVLJxT1yL+WQQgNXc5Zbo5hYiPWXtSuFNQ5xE54qlJzkazp2ky9DNnwgDsvPEoILQwihYERpHQzgU6B4T3anvBQLKHDXkGFaVcA2eTf59D8GxGPeq9ylUZ9qDwjCIbX5biNw4InhockKmzhNsIq1tiqzpx5jR5BlrRxwtJDUnx+C1aX/GRKYedCQk1+yXHJ7WQIS3jSxk=
  '';

#  helperConfiguration = pkgs.fetchurl {
#      url = "https://raw.githubusercontent.com/ES-Nix/NixOS-environments/6f0eb51a328158067750b504de6c0aed713965dc/src/base/base-configuration.nix";
##      url = "https://raw.githubusercontent.com/ES-Nix/NixOS-environments/box/src/base/base-configuration.nix";
#      sha256 = "ELI7UWfW0CtG4moCVrH1IHGXRj4eq6Zi5Z8vFrzV//k=";
#  };

  exampleConfigurationScript = pkgs.writeScriptBin "example-configuration" ''
    cp -v ${./example-configuration.nix} /mnt/etc/nixos/configuration.nix
  '';

  exampleConfiguration = pkgs.stdenv.mkDerivation {
    name = "example-configuration";
    installPhase = ''
      mkdir -p $out/bin
      install -t $out/bin ${exampleConfigurationScript}/bin/example-configuration
    '';
    phases = [ "buildPhase" "installPhase" "fixupPhase" ];
  };

  examplePartitionScript = pkgs.writeScriptBin "example-partition" ''
    # TODO: Add an check that only root can run this script!
    parted -s /dev/sda -- mklabel msdos
    parted -s /dev/sda -- mkpart primary 1MiB -2GiB
    parted -s /dev/sda -- mkpart primary linux-swap -1GiB 100%

    mkfs.ext4 -L nixos /dev/sda1
    mkswap -L swap /dev/sda2

    # this is magic/hardcoded too in fileSystems."/".device = "/dev/disk/by-label/nixos";?
    mount /dev/disk/by-label/nixos /mnt
    swapon /dev/sda2

    # Is it needed?
    # mkdir -p /mnt/boot
    # mount /dev/disk/by-label/boot /mnt/boot

    nixos-generate-config --root /mnt

    # hello | figlet
  '';

  examplePartition = pkgs.stdenv.mkDerivation {
    name = "example-partition";

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      install -t $out/bin ${examplePartitionScript}/bin/example-partition
    '';

    phases = [ "buildPhase" "installPhase" "fixupPhase" ];

    # TODO: it is not working :[
    # Why hello and figlet does not get into PATH?
    # https://discourse.nixos.org/t/can-i-package-a-shell-script-without-rewriting-it/8420/8
    # https://discourse.nixos.org/t/how-to-create-a-script-with-dependencies/7970/6
    # buildInputs = with pkgs; [
    #  e2fsprogs
    #  figlet
    #  hello
    #  parted
    #  nixos-install-tools
    #  mount
    #  util-linux
    # ];
    #
    # propagatedBuildInputs = with pkgs; [ e2fsprogs figlet hello parted nixos-install-tools mount util-linux ];
  };

  exampleFlakeScript = pkgs.writeScriptBin "example-flake" ''
    cp -v ${./base-flake.nix} /mnt/etc/nixos/flake.nix

    cd /mnt/etc/nixos
    git init
    git add .
  '';

  exampleFlake = pkgs.stdenv.mkDerivation {
    name = "example-flake";
    installPhase = ''
      mkdir -p $out/bin
      install -t $out/bin ${exampleFlakeScript}/bin/example-flake
    '';
    phases = [ "buildPhase" "installPhase" "fixupPhase" ];
  };


  myInstallScript = pkgs.writeScriptBin "my-install" ''

    ${examplePartition}/bin/example-partition \
    && ${exampleFlake}/bin/example-flake \
    && ${exampleConfiguration}/bin/example-configuration \
    && nixos-install --no-root-passwd

    # poweroff
  '';

  myInstall = pkgs.stdenv.mkDerivation {
    name = "my-install";
    installPhase = ''
      mkdir -p $out/bin
      install -t $out/bin ${myInstallScript}/bin/my-install
    '';
    phases = [ "buildPhase" "installPhase" "fixupPhase" ];
  };

in
{
  imports =
    [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

        # Provide an initial copy of the NixOS channel so that the user
        # doesn't need to run "nix-channel --update" first.
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"

        # TODO: Is it good?
        # https://discourse.nixos.org/t/whats-the-rationale-behind-not-detected-nix/5403
        # "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
    ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;

  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # DEBUG: it may be hard to debug it with zero time to access grub and hit some key.
  # Set it to, for example, the default value 10
  # boot.loader.timeout = 0;

  # https://nixos.wiki/wiki/Libvirt
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # https://github.com/NixOS/nixpkgs/issues/27930#issuecomment-417943781
  boot.kernelModules = [ "kvm-intel" ];

#  # TODO: how to test it?
#  # TODO: hardening
#  # https://gist.github.com/andir/88458b13c26a04752854608aacb15c8f#file-configuration-nix-L11-L12
#  boot.loader.grub.extraConfig = ''
#    serial --unit=0 --speed=115200
#    terminal_output serial console; terminal_input serial console
#  '';

#  # TODO: hardening
  boot.kernelParams = [
#    # About the console=ttyS0
#    # https://fadeevab.com/how-to-setup-qemu-output-to-console-and-automate-using-shell-script/
#    # https://www.linode.com/docs/guides/install-nixos-on-linode/
#    "console=tty0"
#    "console=ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100"
#    # Set sensible kernel parameters
#    # https://nixos.wiki/wiki/Bootloader
#    # https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/commit/ddb4d96dacc52357e5eaec5870d9733a1ea63a5a?lang=pt-PT
    "boot.shell_on_fail"
    "panic=30"
    "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];

  # TODO: hardening
  # boot.blacklistedKernelModules = [ ];

  # TODO: test it!
  # For some reason it was triggering a big build, so not using it now
  # boot.kernelPackages = pkgs.linuxPackages_5_15;
  # boot.kernelPackages = pkgs.linuxKernel.kernels.linux_5_15_hardened;

  users.extraUsers.root.initialHashedPassword = "";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # To it work on proxmox the interface's name has to be this
  networking.interfaces.eth0.useDHCP = true;

  # TODO: Fix this!
  #networking.firewall.enable = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  users.extraUsers.nixuser = {

    # TODO:
    # hardening
    # mutableUsers = false;
    isNormalUser = true;

    # https://nixos.wiki/wiki/Libvirt
    extraGroups = [
      # "audio"
      # "docker"
      "kvm"
      "libvirtd"
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
      JoaoKeys
      PedroRegisPOARKeys
      RodrigoKeys
    ];

    shell = pkgs.zsh;
  };


  # TODO: hardning
  # https://nixos.wiki/wiki/Kernel_Debugging_with_QEMU
  #
  # users.extraUsers.root.initialHashedPassword = "";
  #
  # networking.firewall.enable = false;
  #
  # services.getty.helpLine = ''
  #  Log in as "root" with an empty password.
  #  If you are connect via serial console:
  #  Type Ctrl-a c to switch to the qemu console
  #  and `quit` to stop the VM.
  # '';
  #
  # services.getty.autologinUser = lib.mkDefault "root";

  # https://github.com/NixOS/nixpkgs/issues/19246#issuecomment-252206901
  services.openssh = {
    allowSFTP = true;
    challengeResponseAuthentication = false;
    enable = true;
    forwardX11 = false;

    # hardening?
    passwordAuthentication = true;
    ports = [ 29980 ];

    # TODO: hardening, is it dangerous? How much?
    # Do NOT use it in PRODUCTION as yes!
    permitRootLogin = "yes";

    # What is the difference about this and the one in
    # users.extraUsers.nixuser.openssh.authorizedKeys.keyFiles ?
    authorizedKeysFiles = [
      "${toString JoaoKeys}"
      "${toString PedroRegisPOARKeys}"
      "${toString RodrigoKeys}"
    ];
  };
  programs.ssh.forwardX11 = false;

  # What is it for?
  programs.ssh.setXAuthLocation = false;

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
    # https://github.com/Pamplemousse/laptop/blob/f780c26bbef2fd0b681cac570fc016b4128de6ce/etc/nixos/packages.nix#L49

    # What is it for?
    # nativeOnly = true;
  };

  nix = {
    # TODO: after nix 2.4 it should be possible to use pkgs.nix
    #
    # What about github:NixOS/nix#nix-static can it be injected here? What would break?
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes ca-references ca-derivations
      system-features = benchmark big-parallel kvm nixos-test
    '';

    # TODO: study this
    # https://search.nixos.org/options?channel=21.11&show=nix.nixPath&from=0&size=50&sort=relevance&type=packages&query=nix
    # https://www.youtube.com/embed/DK_iLg2Ekwk?start=1927&end=2099&version=3
    # https://github.com/pinpox/nixos/blob/12b49379107d210dc87bef995d7880e7a9c2721f/flake.nix#L95-L102
    # nixPath

    # From:
    # https://github.com/sherubthakur/dotfiles/blob/be96fe7c74df706a8b1b925ca4e7748cab703697/system/configuration.nix#L44
    # pointted by: https://github.com/NixOS/nixpkgs/issues/124215
    sandboxPaths = [
      "/bin/sh=${pkgs.bash}/bin/sh"
      # TODO: test it! hardening
      # "/bin/sh=${pkgs.busybox-sandbox-shell}/bin/sh"
    ];

    # TODO: document it hardening
    trustedUsers = [ "@wheel" "nixuser" ];
    autoOptimiseStore = true;

    optimise.automatic = true;

    gc = {
      automatic = true;
      options = "--delete-older-than 1d";
    };

    # If not explicit declared here it uses what the machine has.
    # buildCores = 4;
    # maxJobs = 4;

    # Can be a hardening thing
    # https://github.com/sarahhodne/nix-system/blob/98dcfced5ff3bf08ccbd44a1d3619f1730f6fd71/modules/nixpkgs.nix#L16-L22
    readOnlyStore = false;
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
      # podman = "sudo podman";
      # kind = "sudo kind";
    };

    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # This works! Could be a way to hack/inject some things.
    # loginShellInit = ''
    #  ${pkgs.hello}/bin/hello | ${pkgs.figlet}/bin/figlet
    # '';

    # TODO: is it needed?
    # https://discourse.nixos.org/t/fzf-keybinding-getting-erased-by-oh-my-zsh/13338
    # export FZF_BASE=$(fzf-share)
    # source "$(fzf-share)/completion.zsh"
    # source "$(fzf-share)/key-bindings.zsh"
    interactiveShellInit = ''
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh

      # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
      export ZSH_THEME="agnoster"
      # export ZSH_THEME="powerlevel10k"

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

    ohMyZsh = {
      enable = true;
      custom = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
      plugins = [
        "fzf"
        "git"
        "sudo"
        "docker"
        "kubectl"
      ];
    };

    # Let it as is, it breaks colors, really weird.
    promptInit = "";
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
  # https://github.com/NixOS/nixpkgs/issues/32405#issuecomment-350931777
  # environment.systemPackages = lib.mkForce (lib.subtractLists [ pkgs.foo ] config.environment.systemPackages);
  #
  # https://github.com/NixOS/nixpkgs/issues/32405#issuecomment-678659550
  #
  environment.systemPackages = with pkgs; [
    # If cacert is not used, it is like not have internet! Really hard to figure out it!
    # https://discourse.nixos.org/t/ssl-peer-certificate-or-ssh-remote-key-was-not-ok-error-on-fresh-nix-install-on-macos/3582/4
    bashInteractive
    cacert
    coreutils
    git

    # If used pkgs.lib.mkForce
    nix
    neovim

    fzf
    zsh
    zsh-autosuggestions
    zsh-completions

    # hello

    myInstall
  ];

  # Broken now, it needs the config somehow
  # https://www.reddit.com/r/NixOS/comments/fsummx/how_to_list_all_installed_packages_on_nixos/
  # https://discourse.nixos.org/t/can-i-inspect-the-installed-versions-of-system-packages/2763/15
#  environment.etc."current-system-packages".text =
#    let
#      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
#      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.unique packages);
#      formatted = builtins.concatStringsSep "\n" sortedUnique;
#    in
#    formatted;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Broken?
  # From:
  # https://discourse.nixos.org/t/creating-directories-and-files-declararively/9349/2
  # https://discourse.nixos.org/t/adding-folders-and-scripts/5114/4
  # TODO: remove herdcoded user ang group names
  systemd.tmpfiles.rules = [
    "f /home/nixuser/.zshrc 0755 nixuser nixgroup"
  ];

  # TODO: minimal
  # https://nixos.wiki/wiki/Kernel_Debugging_with_QEMU
  #
  # documentation.doc.enable = false;
  # documentation.man.enable = false;
  # documentation.nixos.enable = false;
  # documentation.info.enable = false;
  # programs.bash.enableCompletion = false;
  # programs.command-not-found.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  # TODO: make it work
  # Really cool explanation
  # https://www.tweag.io/blog/2020-07-31-nixos-flakes/
  # https://discourse.nixos.org/t/what-to-show-in-list-of-nixos-generations/11216/11
  # system.configurationRevision = if self ? rev then self.rev else "dirty";
}
