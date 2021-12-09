{ pkgs ? import <nixpkgs> { }, ... }:
let
  kubeMasterIP = "10.1.1.2";
  kubeMasterHostname = "localhost";
  kubeMasterAPIServerPort = 6443;
in
{
  imports = [
    # configure the mountpoint of the root device
    ({
      fileSystems."/".device = "/dev/disk/by-label/nixos";
    })

    # configure the bootloader
    ({
      # https://gist.github.com/andir/88458b13c26a04752854608aacb15c8f#file-configuration-nix-L11-L12
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
      boot.loader.grub.device = "/dev/sda";
      boot.loader.grub.version = 2;

      # https://nix.dev/tutorials/building-bootable-iso-image
      # Needed for https://github.com/NixOS/nixpkgs/issues/58959
      boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.nixuser = {
        isNormalUser = true;

        # https://nixos.wiki/wiki/Libvirt
        extraGroups = [ "audio" "libvirtd" "wheel" "nixgroup" "networkmanager" "docker" "kvm" ]; # Enable sudo for the user.

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbqkQxZD6I65C1cQ3A5N/LoTHR85x1k/tBbBymZsWw8 nixuser@nixos"
        ];
      };

      # Sad, but for now...
      # Is it usefull for some other thing?
      virtualisation.docker.enable = true;

      #      virtualisation.podman = {
      #          enable = true;
      #          # Create a `docker` alias for podman, to use it as a drop-in replacement
      #          #dockerCompat = true;
      #        };

      environment.etc."containers/registries.conf" = {
        mode = "0644";
        text = ''
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

    })
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes ca-references ca-derivations
      system-features = benchmark big-parallel kvm nixos-test
    '';
  };

  # TODO: fix it!
  #time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    bashInteractive
    cacert # If it is not used, it is like not have internet! Really hard to figure out it!
    coreutils
    file
    inetutils
    lsof
    netcat
    nmap
    #minikube
    #kubectl
    neovim
    openssl
    openssh
    ripgrep
    which

    kompose
    kubectl
    kubernetes
  ];

  environment.variables.KUBECONFIG = "/etc/kubernetes/cluster-admin.kubeconfig";

  services.kubernetes = {
    addonManager.enable = true;
    addons = {
      dashboard.enable = true;
      dashboard.rbac.enable = true;
      dns.enable = true;
    };

    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";

    apiserver = {
      advertiseAddress = kubeMasterIP;
      enable = true;
      securePort = kubeMasterAPIServerPort;
    };
    controllerManager.enable = true;
    flannel.enable = true;
    masterAddress = "${toString kubeMasterHostname}";
    proxy.enable = true;
    roles = [ "master" "node" ];
    scheduler.enable = true;
    easyCerts = true;
    kubelet.enable = true;

    #      # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };

  services = {
    flannel = {
      enable = true;
      etcd.endpoints = [ "http://127.0.0.1:2379" ];
    };
  };

  # TODO: Fix this!
  networking.firewall.enable = false;
}
