{ pkgs, lib, cfg, ... }:
{
  home-manager.users.${cfg.username}.wayland.windowManager.hyprland = {
    package = lib.mkForce null;
    portalPackage = lib.mkForce null;
    systemd.enable = lib.mkForce false;
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
    uwsm = {
      enable = true;
      # waylandCompositors = { };
    };
  };

  environment = {
    # From https://wiki.hypr.land/Nix/
    # Optional, hint electron apps to use wayland:
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [ kitty ];
  };

  # Pre-select the "right" entry
  services.displayManager = {
    enable = true;
    defaultSession = "hyprland-uwsm";
  };
}
