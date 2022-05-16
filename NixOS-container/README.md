
## Only works in an NixOS system!


https://www.tweag.io/blog/2020-07-31-nixos-flakes/

```bash
cat << EOF > flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.11";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ({ pkgs, ... }: {
            boot.isContainer = true;

            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [ 80 ];

            # Enable a web server.
            services.httpd = {
              enable = true;
              adminAddr = "morty@example.org";
            };
          })
        ];
    };

  };
}
EOF
```

```bash
git init
git add .

nix build .#nixosConfigurations.container.config.system.build.toplevel
```

```bash
sudo su
```

```bash
nixos-container destroy flake-test
nixos-container create flake-test --flake .
nixos-container start flake-test
curl http://flake-test/
```


TODO: test it
https://github.com/corngood/portable-nixos-container
https://discourse.nixos.org/t/extra-container-run-declarative-containers-without-full-system-rebuilds/511/10
https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html


nix shell nixpkgs#nixos-shell
nixos-shell --flake github:Mic92/nixos-shell#vm-forward

nix-channel --add https://nixos.org/channels/nixos-20.11 nixos

nix flake metadata nixpkgs
nix run nixpkgs#neofetch -- --json
nix run nixpkgs#nix-info -- --markdown

nix-channel --list
sudo nix-channel --list

https://github.com/Mic92/nixos-shell/issues/36

```bash
cat << 'EOF' > flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.11";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ 
          #({ pkgs, ... }: {
          # boot.isContainer = false;
          #
          ## Let 'nixos-version --json' know about the Git revision
          ## of this flake.
          #system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          #
          ## Network configuration.
          #networking.useDHCP = false;
          #networking.firewall.allowedTCPPorts = [ 80 ];
          #
          ## Enable a web server.
          #services.httpd = {
          #  enable = true;
          #  adminAddr = "morty@example.org";
          #};
          #})
          "${toString (builtins.getFlake "github:NixOS/nixpkgs/b283b64580d1872333a99af2b4cef91bb84580cf")}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
           
          "${toString (builtins.getFlake "github:NixOS/nixpkgs/b283b64580d1872333a99af2b4cef91bb84580cf")}/nixos/modules/virtualisation/build-vm.nix" 
          
          # "${toString (builtins.getFlake "github:NixOS/nixpkgs/b283b64580d1872333a99af2b4cef91bb84580cf")}/nixos/modules/installer/cd-dvd/channel.nix"
        ];
    };
    # So that we can just run 'nix run' instead of
    # 'nix build ".#nixosConfigurations.vm.config.system.build.vm" && ./result/bin/run-nixos-vm'
    defaultPackage.x86_64-linux = self.nixosConfigurations.vm.config.system.build.toplevel;
    defaultApp.x86_64-linux = {
      type = "app";
      program = "${self.defaultPackage.x86_64-linux}/bin/run-nixos-vm";
    };
  };
}
EOF
```




