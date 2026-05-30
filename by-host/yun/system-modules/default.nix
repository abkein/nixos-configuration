{ ... }:
{
  imports = [
    ./xray.nix
    ./disko.nix
    ./networking.nix
    ./zram.nix
    ./facter
  ];
}