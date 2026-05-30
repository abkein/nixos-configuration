{ ... }:
{
  imports = [
    ./regreet.nix
    ./proxychains.nix
    ./wayland.nix
    ./etc.nix
    ./zram.nix
    ./networking.nix
    ./disko.nix
    ./xray.nix
    # ./openssh.nix
    # ./syncthing.nix
    # ./flatpak.nix
  ];
}