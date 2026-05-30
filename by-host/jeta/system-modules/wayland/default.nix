{ config, lib, cfg, ... }:
{
  imports = [
    ./hyprland-regreet-conf.nix
    ./regreet.nix
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
      # waylandCompositors = {

      # };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.hyprland.package}/bin/Hyprland --config /etc/${config.environment.etc.hyprland-regreet.target}";
        user = "greeter";
      };
    };
  };
}
