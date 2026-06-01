{ config, pkgs, ... }:
let
  cursor = {
    theme = "Vimix-cursors";
    # theme = "Adwaita";
    size = 48;
    pkg = pkgs.vimix-cursors;
  };
in
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

  # qt = {
  #   enable = true;
  #   # style = {
  #   #   name = "adwaita-dark";
  #   # };
  #   platformTheme = {
  #     # name = "gtk3";
  #     name = "qt6ct";
  #   };
  # };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # "hyprctl setcursor Bibata-Modern-Classic 24"
      "hyprctl setcursor ${cursor.theme} ${builtins.toJSON cursor.size}"
    ];
  };

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
      # HYPRCURSOR_THEME = cursor.theme;
      # HYPRCURSOR_SIZE = cursor.size;
      # XCURSOR_THEME = cursor.theme;
      # XCURSOR_SIZE = cursor.size;

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
      polkit_gnome  # exclusively here
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
    #TODO: change shebangs with direct path to a system's bash executable
    file =
      let
        generic = {
          enable = true;
          executable = true;
          force = true;
        };
      in
      {
        hyprlock-status = generic // {
          target = "./execs/hyprlock/status.sh";
          text = ''
            #!/usr/bin/env bash

            ############ Variables ############
            enable_battery=false
            battery_charging=false

            ####### Check availability ########
            for battery in /sys/class/power_supply/*BAT*; do
              if [[ -f "$battery/uevent" ]]; then
                enable_battery=true
                if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
                  battery_charging=true
                fi
                break
              fi
            done

            ############# Output #############
            if [[ $enable_battery == true ]]; then
              if [[ $battery_charging == true ]]; then
                echo -n "(+) "
              fi
              echo -n "$(cat /sys/class/power_supply/*/capacity | head -1)"%
              if [[ $battery_charging == false ]]; then
                echo -n " remaining"
              fi
            fi

            echo \'\'
          '';
        };
        hyprlock-label = generic // {
          target = "./execs/hyprlock/label.sh";
          text = ''
            #!/usr/bin/env bash

            if [ "$1" -eq 0 ]; then
              echo ""
            else
              echo "There were failed attempts: $1"
              printf "\n"
              echo "Last fail reason: $2"
            fi
          '';
        };
      };
  };
}
