{ pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  #  boot.loader.grub.enable = true;
  #  boot.loader.grub.device = "/dev/sda";

  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      enable = true;
      efiInstallAsRemovable = true;
      efiSupport = true;
      #       device = "/dev/sda";
      devices = [ "nodev" ];
    };
  };

  fileSystems."/" = {
    device = "/dev/sda";
    autoResize = false;
    # Why it has to be this one filesystem?
    fsType = "fat32";
  };

  boot.initrd.enable = true;
  boot.isContainer = false;
  boot.loader.initScript.enable = true;
  ## login with empty password
  users.extraUsers.root.initialHashedPassword = "";

  networking.firewall.enable = false;

  services.getty.helpLine = ''
    Log in as "root" with an empty password.
    If you are connect via serial console:
    Type Ctrl-a c to switch to the qemu console
    and `quit` to stop the VM.
  '';

  services.getty.autologinUser = lib.mkDefault "root";

  documentation.doc.enable = false;
  documentation.man.enable = false;
  documentation.nixos.enable = false;
  documentation.info.enable = false;
  programs.bash.enableCompletion = false;
  programs.command-not-found.enable = false;
}
