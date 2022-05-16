# When you add custom packages, list them here
{ pkgs }: {
  hello-figlet = pkgs.callPackage ./hello-figlet { };
}