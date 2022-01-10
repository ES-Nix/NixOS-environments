{ config, pkgs, nixpkgs ? <nixpkgs>, system ? "x86_64-linux", ... }:
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

  # https://github.com/NixOS/nixpkgs/issues/59364#issuecomment-723906760
  # https://discourse.nixos.org/t/use-nixos-as-single-node-kubernetes-cluster/8858/7
  kubeMasterIP = "10.1.1.2";
  kubeMasterHostname = "localhost";
  # kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;

  firstRebuildSwitchScriptDeps = with pkgs; [
    bash
    coreutils
    git
    # nix  #
    nixos-rebuild
  ];
  firstRebuildSwitchScript = pkgs.runCommandLocal "first-rebuild-switch"
    { nativeBuildInputs = [ pkgs.makeWrapper ]; }
    ''
      install -m755 ${./src/base/first-rebuild-switch.sh} -D $out/bin/first-rebuild-switch
      patchShebangs $out/bin/first-rebuild-switch
      wrapProgram "$out/bin/first-rebuild-switch" \
      --prefix PATH : ${pkgs.lib.makeBinPath firstRebuildSwitchScriptDeps}
    '';

  customKubeadmCertsRenewAllScriptDeps = with pkgs; [
    bash
    coreutils
    git
    # nix  #
    nixos-rebuild
  ];
  customKubeadmCertsRenewAllScript = pkgs.runCommandLocal "custom-kubeadm-certs-renew-all"
    { nativeBuildInputs = [ pkgs.makeWrapper ]; }
    ''
      install -m755 ${./src/base/custom-kubeadm-certs-renew-all.sh} -D $out/bin/custom-kubeadm-certs-renew-all
      patchShebangs $out/bin/custom-kubeadm-certs-renew-all
      wrapProgram "$out/bin/custom-kubeadm-certs-renew-all" \
      --prefix PATH : ${pkgs.lib.makeBinPath customKubeadmCertsRenewAllScriptDeps}
    '';

    nrt = pkgs.writeScriptBin "nixos-rebuild-test" ''
      nixos-rebuild test --flake '/etc/nixos'#"$(hostname)"
    '';

    part2 = pkgs.writeScriptBin "part2" ''
      nixos-rebuild test --flake '/etc/nixos'#"$(hostname)"
      first-rebuild-switch
      reboot
    '';    

    part3 = pkgs.writeScriptBin "part3" ''
      custom-kubeadm-certs-renew-all
      reboot
    '';

    pkgsAndSystem = {
      system = system;
      pkgs = pkgs;
    };

    myImportGeneric = pkgsAndSystem: fullFilePath:
      import fullFilePath pkgsAndSystem;

    myImport = myImportGeneric pkgsAndSystem;

#    utilsK8s-services-status-check = myImport ./src/base/nix/wrappers/utilsK8s-services-status-check.nix;
#
#    utilsK8s-services-restart-if-not-active = myImport ./src/base/nix/wrappers/utilsK8s-services-restart-if-not-active.nix;
#
#    utilsK8s-services-stop = myImport ./src/base/nix/wrappers/utilsK8s-services-stop.nix;

    test-hello-figlet-cowsay = myImport ./src/base/nix/wrappers/test-hello-figlet-cowsay.nix;

#    test-kubernetes-required-environment-roles-master-and-node = myImport ./src/base/nix/wrappers/test-kubernetes-required-environment-roles-master-and-node.nix;

in
{
  imports =
    [
      # It errors with infinite recursion encoutered :/
      # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

      # Provide an initial copy of the NixOS channel so that the user
      # doesn't need to run "nix-channel --update" first.
      # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"

      # TODO: Is it good?
      # https://discourse.nixos.org/t/whats-the-rationale-behind-not-detected-nix/5403
      # "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Do we need it?
  # https://www.linode.com/docs/guides/install-nixos-on-linode/
  # boot.loader.grub.forceInstall = true;

  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  fileSystems."/".device = "/dev/disk/by-label/nixos";

  # Is this ok to kubernetes?
  # Why free -h still show swap stuff but with 0?
  swapDevices = pkgs.lib.mkForce [ ];

  # Is it a must for k8s?
  # Take a look into:
  # https://github.com/NixOS/nixpkgs/blob/9559834db0df7bb274062121cf5696b46e31bc8c/nixos/modules/services/cluster/kubernetes/kubelet.nix#L255-L259
  boot.kernel.sysctl = {
    # If it is enabled it conflict with what kubelet is doing
    # "net.bridge.bridge-nf-call-ip6tables" = 1;
    # "net.bridge.bridge-nf-call-iptables" = 1;
    "vm.swappiness" = 0;
  };

  # https://github.com/NixOS/nixpkgs/issues/29095#issuecomment-368463984
  #systemd.extraConfig = ''
  #  DefaultCPUAccounting=yes
  #  DefaultIOAccounting=yes
  #  DefaultBlockIOAccounting=yes
  #  DefaultMemoryAccounting=yes
  #  DefaultTasksAccounting=yes
  #'';

  # "cgroup_enable=memory"
  boot.kernelParams = [ "swapaccount=0" ];

  #  # TODO: how to test it?
  #  # TODO: hardening
  #  # https://gist.github.com/andir/88458b13c26a04752854608aacb15c8f#file-configuration-nix-L11-L12
  #  boot.loader.grub.extraConfig = ''
  #    serial --unit=0 --speed=115200
  #    terminal_output serial console; terminal_input serial console
  #  '';

  #  # TODO: hardening
  #  boot.kernelParams = [
  #    # About the console=ttyS0
  #    # https://fadeevab.com/how-to-setup-qemu-output-to-console-and-automate-using-shell-script/
  #    # https://www.linode.com/docs/guides/install-nixos-on-linode/
  #    "console=tty0"
  #    "console=ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100"
  #    # Set sensible kernel parameters
  #    # https://nixos.wiki/wiki/Bootloader
  #    # https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/commit/ddb4d96dacc52357e5eaec5870d9733a1ea63a5a?lang=pt-PT
  #    "boot.shell_on_fail"
  #    "panic=30"
  #    "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  #  ];

  # DEBUG: it may be hard to debug it with zero time to access grub and hit some key.
  # Set it to, for example, the default value 10
  # boot.loader.timeout = 0;

  # https://nixos.wiki/wiki/Libvirt
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # https://github.com/NixOS/nixpkgs/issues/27930#issuecomment-417943781
  boot.kernelModules = [ "kvm-intel" ];

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
  users.groups.nixgroup.members = [ "nixuser" ];
  users.users.nixuser = {

    # TODO:
    # hardening
    # mutableUsers = false;
    isNormalUser = true;

    # https://nixos.wiki/wiki/Libvirt
    extraGroups = [
      # "audio"
      "docker" # TODO: hardening
      "kubernetes" # TODO: hardening
      "kvm"
      "libvirtd"
      "nixgroup"
      "wheel"
    ];

    # It can be turned off, it is here for debug help
    # To crete a new one:
    # mkpasswd -m sha-512
    # https://unix.stackexchange.com/a/187337
    # hashedPassword = "$6$XiENMV7S4t/XfN$lIZjnuRdNZVcY3qUjur7m4jCIMZCGi3obx1.wHVoQKaNFmEJJN4r.MKdZIkpFpXwt0d/lqI.ZlLnfdwZyXj0e/";
    hashedPassword = "$6$kRN5UwTB5XN22u9Z$oYFLbpRLo4wWi6zQ/oi5lqhYG3qJvlfTodOvgSiCJcJPO/rnjbbi7XYXPqcliYPyt2DScMUGhqRzxy9QQ63Jr0";

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
      # "/bin/sh=${pkgs.bash}/bin/sh"
      "/bin/sh=${pkgs.busybox-sandbox-shell}/bin/sh"
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
      k = "kubectl";
      ka = "kubectl get pods --all-namespaces -o wide";
      wka = "watch -n 1 kubectl get pods --all-namespaces -o wide";
      kdall = "kubectl delete all --all -n kube-system";
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

    # If used pkgs.lib.mkForce?
    # nix
    neovim

    fzf
    zsh
    zsh-autosuggestions
    zsh-completions

    firstRebuildSwitchScript
    customKubeadmCertsRenewAllScript

    test-hello-figlet-cowsay

#    utilsK8s-services-status-check
#    utilsK8s-services-restart-if-not-active
#    utilsK8s-services-stop
#    test-kubernetes-required-environment-roles-master-and-node

    nrt
    part2
    part3

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

    # Debug helpers
    lsof
    ripgrep
    jq
    openssl
    dmidecode
    telnet
    file
  ];

  environment.variables.KUBECONFIG = "/etc/kubernetes/cluster-admin.kubeconfig";

  virtualisation.docker.enable = true;

  environment.etc."containers/registries.conf" = {
    mode = "0644";
    text = ''
      [registries.search]
      registries = ['docker.io', 'localhost']
    '';
  };

  services.kubernetes.roles = [ "master" "node" ];
  services.kubernetes.masterAddress = "${kubeMasterHostname}";
  #  services.kubernetes = {
  #
  #    # addonManager.enable = true;
  #
  #    addons = {
  #      # dashboard.enable = true;
  #      # dashboard.rbac.enable = true;
  #      dns.enable = true;
  #    };
  #
  #    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
  #
  #    apiserver = {
  #      advertiseAddress = kubeMasterIP;
  #      enable = true;
  #      securePort = kubeMasterAPIServerPort;
  #    };
  #
  #    controllerManager.enable = true;
  #    # flannel.enable = true;
  #    masterAddress = "${toString kubeMasterHostname}";
  #    # proxy.enable = true;
  #    roles = [ "master" ];
  #    # roles = [ "master" "node" ];
  #    # scheduler.enable = true;
  #    easyCerts = true;
  #
  #    kubelet.enable = true;
  #
  #    # needed if you use swap
  #    kubelet.extraOpts = "--fail-swap-on=false";
  #  };

  #  services = {
  #    flannel = {
  #      enable = true;
  #      etcd.endpoints = [ "http://127.0.0.1:2379" ];
  #    };
  #  };

  # TODO:
  #systemd.services.selfinstall = {
  #  script = ''
  #    shutdown --poweroff
  #  '';
  #  wantedBy = [ "multi-user.target" ];
  #};

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
