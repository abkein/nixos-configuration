{
  pkgs,
  lib,
  cfg,
  ...
}:
{
  imports = [ ../../../../options/nixos/tuigreet.nix ];

  home-manager.users.${cfg.username}.wayland.windowManager.hyprland = {
    package = lib.mkForce null;
    portalPackage = lib.mkForce null;
    systemd.enable = lib.mkForce false;
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
    tuigreet = {
      enable = true;
      session.enable = true;
      greeting = "Hello!";
      time.enable = true;
      remember = "user+session";
      userMenu.enable = true;
      theme = {
        border="magenta";
        text="cyan";
        prompt="green";
        time="red";
        action="blue";
        button="yellow";
        container="black";
        input="red";
      };
      power = {
        shutdown = "${pkgs.systemd}/bin/poweroff";
        reboot = "${pkgs.systemd}/bin/reboot";
      };
    };
  };
}
