{ ... }:
{
  imports = [
    ./wayland
    ./proxychains.nix
    ./networking.nix
    ./disko.nix
    ./xray.nix
    # ./openssh.nix
    # ./syncthing.nix
    # ./flatpak.nix
    ./printing.nix
  ];
}
