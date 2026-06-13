{
  config,
  pkgs,
  lib,
  cfg,
  ...
}:
let
  regreetCfg = config.programs.regreet;

  # cageRegreetLogged = pkgs.writeShellScript "cage-regreet-logged" ''
  #   log=/var/log/regreet/cage-regreet.log
  #   {
  #     exec ${pkgs.dbus}/bin/dbus-run-session \
  #       ${lib.getExe pkgs.cage} ${lib.escapeShellArgs regreetCfg.cageArgs} \
  #       -- ${lib.getExe regreetCfg.package}
  #   } > "$log" 2>&1
  # '';

  # Ensure proper portal detection to avoid
  # xdg-desktop-portal-WARNING ... Choosing gtk.portal for org.freedesktop.impl.portal.<Name>
  # Also let ReGreet output its logs to stdout (the `-v` flag)
  # (it still would write them into `/var/log/regreet`)
  # Let logs from both Cage and ReGreet to appear in journald (systemd-cat)
  cageRegreet = pkgs.writeShellScript "cage-regreet-logged" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=cage
    export XDG_CURRENT_DESKTOP=cage
    exec ${pkgs.systemd}/bin/systemd-cat --identifier='cage' \
      ${pkgs.dbus}/bin/dbus-run-session \
      ${lib.getExe pkgs.cage} ${lib.escapeShellArgs regreetCfg.cageArgs} \
      -- ${lib.getExe regreetCfg.package} -v
  '';
in
{
  ### --- Hyprland — the actual compositor --- ###
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

  ### --- Greetd + cage setup --- ###
  services.greetd.settings.default_session.command = lib.mkForce cageRegreet;
  # Force set the user so we won't accidentally change anything, because
  # both: greetd and regreet and their fixes depend on it.
  services.greetd.settings.default_session.user = lib.mkForce "greeter";

  xdg.portal = {
    config.cage = {
      default = [ "gtk" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal # Not added by anything
      xdg-desktop-portal-gtk # Added by Hyprland, but let it be also here
    ];
  };

  # Use `seatd` (IDK why, why not).
  # P.S.: Cage initially wants to use `seatd` and
  # then fallsback to using `logind`.
  services.seatd.enable = true;
  users.users.greeter.extraGroups = [ config.services.seatd.group ];
}
