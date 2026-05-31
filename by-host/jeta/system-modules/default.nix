{ ... }:
{
  imports = [
    ./wayland
    ./proxychains.nix
    ./zram.nix
    ./networking.nix
    ./disko.nix
    ./xray.nix
    # ./openssh.nix
    # ./syncthing.nix
    # ./flatpak.nix
    ./printing.nix
  ];
}
