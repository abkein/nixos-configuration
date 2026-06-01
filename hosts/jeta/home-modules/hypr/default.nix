{ config, pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./etc.nix
  ];

  services = {
    hyprpolkitagent.enable = true;
    cliphist = {
      enable = true;
      allowImages = true;
    };
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  gtk = {
    enable = true;
    # iconTheme = {
    #   name = "Adwaita";
    #   package = pkgs.adwaita-icon-theme;
    # };
    # theme = {
    #   name = "adw-gtk3-dark";
    #   package = pkgs.adw-gtk3;
    # };
    gtk2 = with config.gtk; {
      enable = true;
      cursorTheme = cursorTheme;
      font = font;
      iconTheme = iconTheme;
      theme = theme;
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      # extraConfig = ''
      #   gtk-can-change-accels = 1
      # '';
      # force = true;
    };
    gtk3 = with config.gtk; {
      enable = true;
      colorScheme = colorScheme;
      cursorTheme = cursorTheme;
      font = font;
      iconTheme = iconTheme;
      theme = theme;
      # bookmarks = [
      #   "file:///home/jane/Documents"
      # ];
      # extraConfig = {
      #   gtk-cursor-blink = false;
      #   gtk-recent-files-limit = 20;
      # };
      # extraCss = "";
    };
    gtk4 = with config.gtk; {
      enable = true;
      colorScheme = colorScheme;
      cursorTheme = cursorTheme;
      font = font;
      iconTheme = iconTheme;
      theme = theme;
      # extraConfig = {
      #   gtk-cursor-blink = false;
      #   gtk-recent-files-limit = 20;
      # };
      # extraCss = "";
    };
  };

  qt.enable = true;

  home = {
    pointerCursor = {
      enable = true;
      dotIcons.enable = true;
      gtk = {
        enable = true;
        # size = config.home.pointerCursor.size;
      };
      hyprcursor = {
        enable = true;
        # size = config.home.pointerCursor.size;
      };
      # package = cursor.pkg; # stylix
      # name = cursor.theme; # stylix
      # size = cursor.size; # stylix
    };
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
      dmenu
      polkit_gnome # exclusively here
      wlr-randr
      ydotool
      wl-clipboard
      hyprland-protocols
      xdg-utils
      xdg-user-dirs
      xdg-launch
      xdg-terminal-exec
      hyprland-workspaces
      hyprland-activewindow

      xdg-ninja

      kitty
      hyprpicker
      # hyprsunset
      hyprpwcenter
      # hyprlauncher
      hyprshutdown
      hyprsysteminfo
      hyprland-qt-support
    ];
  };
}
