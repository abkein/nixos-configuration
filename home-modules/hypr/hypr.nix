{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
  services.hyprpolkitagent.enable = true;
  home.packages = with pkgs; [
    hyprpicker
    # hyprsunset
    hyprpwcenter
    # hyprlauncher
    hyprshutdown
    hyprsysteminfo
    hyprland-qt-support
  ];
}
