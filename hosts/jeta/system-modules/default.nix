{ ... }: {
  imports = [
    ./wayland
    ./disko.nix
    ./networking.nix
    ./xray
    ./proxychains.nix
    ./printing.nix
    ./fixes.nix
    ./immich.nix
    # ./openssh.nix
    # ./syncthing.nix
    # ./flatpak.nix
  ];
}
