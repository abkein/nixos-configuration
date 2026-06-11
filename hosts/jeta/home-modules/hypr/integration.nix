{ config, pkgs, ... }:
{
  services.hyprpolkitagent.enable = true;

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  home = {
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # QT_STYLE_OVERRIDE = "";

      GDK_BACKEND = "wayland,x11,*";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };
    packages = with pkgs; [
      kitty
      hyprpicker
      # hyprsunset
      hyprpwcenter
      # hyprlauncher
      hyprshutdown
      hyprsysteminfo
      hyprland-qt-support

      hyprland-protocols
      hyprland-workspaces
      hyprland-activewindow
    ];
  };
}
