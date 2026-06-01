{
  # config,
  pkgs,
  lib,
  cfg,
  ...
}:
{
  imports = [
    # ./hyprland-regreet-conf.nix
    ./regreet.nix
    ./stylix.nix
  ];

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

  services = {
    # Pre-select the "right" entry
    displayManager.defaultSession = "hyprland-uwsm";
    # greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "${config.programs.hyprland.package}/bin/Hyprland --config /etc/${config.environment.etc.hyprland-regreet.target}";
    #       user = "greeter";
    #     };
    #   };
    # };
  };
}
