{ config, pkgs, ... }:
let
  cursor = {
    theme = "Vanilla-DMZ";
    size = 24;
  };
in
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
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

  gtk =
    let
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
    in
    {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      theme = theme;
      gtk4.theme = theme;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

  qt = {
    enable = true;
    # style = {
    #   name = "adwaita-dark";
    # };
    platformTheme = {
      # name = "gtk3";
      name = "qt6ct";
    };
  };

  home = {
    pointerCursor = {
      enable = true;
      dotIcons.enable = true;
      gtk = {
        enable = true;
        size = cursor.size;
      };
      hyprcursor = {
        enable = true;
        size = cursor.size;
      };
      package = pkgs.vanilla-dmz;
      name = cursor.theme;
      size = cursor.size;
    };
    sessionVariables = {
      HYPRCURSOR_THEME = cursor.theme;
      HYPRCURSOR_SIZE = cursor.size;
      XCURSOR_THEME = cursor.theme;
      XCURSOR_SIZE = cursor.size;

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
