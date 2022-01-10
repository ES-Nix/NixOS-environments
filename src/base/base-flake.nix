{
  inputs = {
#    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
#    flake-utils.url = "github:numtide/flake-utils";

    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  #  nixpkgs.url = "github:NixOS/nixpkgs/27d2fe1e69deb1894f9113a1fe2ca43fb89c8ad1";
  };

  outputs = { self, nixpkgs, nixos }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
