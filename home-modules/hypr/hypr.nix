{...}:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
  ];
  services.hyprpolkitagent.enable = true;
  programs.hyprlock = import ./hypr/hyprlock.nix;
}