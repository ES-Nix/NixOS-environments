{ pkgs ? import <nixpkgs> { }, ... }:
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

      boot.loader.grub = {
        device = "/dev/sda";
        version = 2;
      };

      # https://nix.dev/tutorials/building-bootable-iso-image
      # Needed for https://github.com/NixOS/nixpkgs/issues/58959
      boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.nixuser = {
        isNormalUser = true;

        # It adds the user to the groups listed
        # I opted by adding the `nixgroup` only for be more clear when using the
        # coreutils `id` command
        # https://nixos.wiki/wiki/Libvirt
        # The "wheel" enable `sudo` for the user.
        extraGroups = [ "audio" "libvirtd" "wheel" "nixgroup" "networkmanager" "kvm" ];

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbqkQxZD6I65C1cQ3A5N/LoTHR85x1k/tBbBymZsWw8 nixuser@nixos"
        ];
      };

      users.extraUsers.nixuser = {
        shell = pkgs.zsh;
      };

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
    })
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes ca-references ca-derivations
      system-features = benchmark big-parallel kvm nixos-test
    '';
  };

  environment.systemPackages = with pkgs; [
    bashInteractive
    cacert # If it is not used, it is like not have internet! Really hard to figure out it!
    coreutils
    git

    # Must existe to ssh work
    openssl
    openssh

    # Some helper tools
    file
    neovim
    ripgrep
    which
  ];
}
