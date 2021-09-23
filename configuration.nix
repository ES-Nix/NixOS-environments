{ pkgs ? import <nixpkgs> {}, ... }:
{
  imports = [
    # configure the mountpoint of the root device
    ({
      fileSystems."/".device = "/dev/disk/by-label/nixos";
    })

    # configure the bootloader
    ({
#      boot.loader.grub.extraConfig = ''
#        serial --unit=0 --speed=115200
#        terminal_output serial console; terminal_input serial console
#      '';
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
      #boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

#      # Define a user account. Don't forget to set a password with ‘passwd’.
#      users.users.nixuser = {
#        isNormalUser = true;
#
#        # https://nixos.wiki/wiki/Libvirt
#        extraGroups = [ "wheel" "nixgroup" "kvm"]; # Enable sudo for the user.
#      };
#
#      # https://nixos.wiki/wiki/Libvirt
#      boot.extraModprobeConfig = "options kvm_intel nested=1";
#
#      # https://github.com/NixOS/nixpkgs/issues/27930#issuecomment-417943781
#      boot.kernelModules = [ "kvm-intel" ];
    })

    ({
#      users.extraUsers.nixuser = {
#        shell = pkgs.bash;
#      };
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
  };

  # Use this option to avoid issues on macOS version upgrade
  # https://github.com/execat/nix/blob/0d4db14db79e1e692306c769e685146e8c8810c9/nix/default.nix#L13
  #users.nix.configureBuildUsers = true;

  # TODO: fix it!
  #time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
#    bashInteractive
    cacert            # If it is not used, it is like not have internet! Really hard to figure out it!
#    coreutils
  ];
}
