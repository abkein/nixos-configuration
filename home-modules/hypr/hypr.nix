{...}:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];
  services.hyprpolkitagent.enable = true;
}