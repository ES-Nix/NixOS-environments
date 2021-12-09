
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