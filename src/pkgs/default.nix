# When you add custom packages, list them here
{ pkgs, nixpkgs }: {
  hello-figlet = pkgs.callPackage ./hello-figlet { };
  composed-script = pkgs.callPackage ./composed-script { };

  # retry = pkgs.callPackage ./retry { };

  # runVM = pkgs.callPackage ./runVM { };

  # nixos-qcow2 = (pkgs.callPackage ./nixos-qcow2 { nixpkgs = nixpkgs; }).image;

  nixos-iso = pkgs.callPackage ./nixos-iso { nixpkgs = nixpkgs; };
  run-nixos-iso = pkgs.callPackage ./nixos-iso/run-nixos-iso.nix { };
  # nixos-empty-qcow2 = pkgs.callPackage ./nixos-empty-qcow2 { };

  # run-vm-kvm = pkgs.callPackage ./run-vm-kvm { };
}