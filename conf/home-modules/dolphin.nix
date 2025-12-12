{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.konsole
    kdePackages.kio
    kdePackages.kdf
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.qtwayland
    kdePackages.plasma-integration
    kdePackages.kdegraphics-thumbnailers
    kdePackages.breeze-icons
    kdePackages.qtsvg #https://www.reddit.com/r/hyprland/comments/18ecoo3/dolphin_doesnt_work_properly_in_nixos_hyprland/
    kdePackages.kservice
    shared-mime-info
  ];
}