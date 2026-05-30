{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
  services.hyprpolkitagent.enable = true;
  home.packages = with pkgs; [
    kitty
    hyprpicker
    # hyprsunset
    hyprpwcenter
    # hyprlauncher
    hyprshutdown
    hyprsysteminfo
    hyprland-qt-support
  ];

  xdg.configFile = {
    hyprlock-te = {
      enable = true;
      executable = false;
      force = true;
      target = "hyprlock/te.markup";
      text = ''
        <markup>
          <span color="#E2E2E2" bgcolor="#2980B9" bgalpha="50%" face="Gabarito" size="20pt">
            Alles muss sich veraendern
          </span>
          <span color="#E2E2E2" bgcolor="#2980B9" bgalpha="50%" face="Gabarito" size="20pt">
            or no
          </span>
        </markup>
      '';
    };
  };

  #TODO: change shebangs with direct path to a system's bash executable
  home.file =
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
}
