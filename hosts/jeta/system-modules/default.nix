{ ... }: {
  imports = [
    ./wayland
    ./disko.nix
    ./networking.nix
    ./xray
    ./proxychains.nix
    ./printing.nix
    ./fixes.nix
    # ./openssh.nix
    # ./syncthing.nix
    # ./flatpak.nix
  ];
}
