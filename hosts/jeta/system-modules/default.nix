{ ... }:
{
  imports = [
    ./wayland
    ./disko.nix
    ./networking.nix
    ./xray.nix
    ./proxychains.nix
    ./printing.nix
    # ./openssh.nix
    # ./syncthing.nix
    # ./flatpak.nix
  ];
}
