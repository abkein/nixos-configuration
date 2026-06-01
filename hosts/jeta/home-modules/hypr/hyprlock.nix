{ pkgs, cfg, ... }:
let
  hex2hypr = color: "rgba(${builtins.substring 1 (-1) color})";
  te-markup = pkgs.writeText "hyprlock-te.markup" ''
    <markup>
      <span color="#E2E2E2" bgcolor="#2980B9" bgalpha="50%" face="Gabarito" size="20pt">
        Alles muss sich veraendern
      </span>
      <span color="#E2E2E2" bgcolor="#2980B9" bgalpha="50%" face="Gabarito" size="20pt">
        or no
      </span>
    </markup>
  '';
  hyprlock-battery-status = pkgs.writeShellScript "hyprlock-battery-status.sh" ''
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
  hyprlock-label = pkgs.writeShellScript "hyprlabel.sh" ''
    if [ "$1" -eq 0 ]; then
      echo ""
    else
      echo "There were failed attempts: $1"
      printf "\n"
      echo "Last fail reason: $2"
    fi
  '';
in
{
  programs.hyprlock = {
    enable = true;
    settings =
      let
        text_color = hex2hypr "#E2E2E2FF";
        # entry_background_color = hex2hypr "#13131311";
        # entry_border_color = hex2hypr "#91919155";
        # entry_color = hex2hypr "#C6C6C6FF";
        # background_color = hex2hypr "#13131377";
        font_family = "Gabarito";
        font_family_clock = "Gabarito";
        # font_material_symbols = "Material Symbols Outlined";
        font_material_symbols = "Material Symbols Rounded";

        main_mon = "eDP-1";
      in
      {
        background = {
          # path = "{{ SWWW_WALL }}";
          # path = "${cfg.userhome}/Pictures/Wallpapers/oxvp59.png";

          # color = background_color; # stylix
          path = "${cfg.userhome}/Pictures/Wallpapers/memorize.jpg";
          blur_size = 1; # 5
          blur_passes = 1; # 4
          brightness = 0.7;
          noise = 0.01;
        };
        input-field = {
          monitor = main_mon;
          size = "250, 50";
          outline_thickness = 2;
          dots_size = 0.1;
          dots_spacing = 0.3;
          # fade_on_empty = true;

          # stylix
          # outer_color = entry_border_color;
          # inner_color = entry_background_color;
          # font_color = entry_color;
          # fail_color
          # check_color

          position = "0, 20";
          halign = "center";
          valign = "center";
        };

        label = [
          {
            # Clock
            monitor = "";
            text = "$TIME";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = text_color;
            font_size = 65;
            font_family = font_family_clock;

            position = "0, 300";
            halign = "center";
            valign = "center";
          }
          {
            # Info
            monitor = "";
            text = "cmd[update:1000] echo $(${hyprlock-label} \"$ATTEMPTS\" \"$FAIL\")";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = text_color;
            font_size = 14;
            font_family = font_family;

            position = "0, -40";
            halign = "center";
            valign = "center";
          }
          {
            # KB layout
            monitor = "";
            text = "$LAYOUT";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = text_color;
            font_size = 14;
            font_family = font_family;

            position = "0, 60";
            halign = "center";
            valign = "center";
          }
          {
            # Greeting
            monitor = "";
            text = "cmd[update:0:true] echo $(cat ${te-markup})";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = text_color;
            #font_size = 20;
            #font_family = font_family;

            position = "0, 200";
            halign = "left";
            valign = "bottom";
          }
          {
            # lock icon
            monitor = "";
            text = "lock";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = text_color;
            font_size = 42;
            font_family = font_material_symbols;

            position = "0, 65";
            halign = "center";
            valign = "bottom";
          }
          {
            # "locked" text
            monitor = "";
            text = "locked";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = text_color;
            #font_size = 42;
            font_size = 14;
            font_family = font_family;

            position = "0, 0";
            # position = 0, 50;
            halign = "center";
            valign = "bottom";
          }
          {
            # Status
            monitor = "";
            text = "cmd[update:5000] ${hyprlock-battery-status}";
            shadow_passes = 1;
            shadow_boost = 0.5;
            color = text_color;
            font_size = 14;
            font_family = font_family;

            position = "30, -30";
            halign = "left";
            valign = "top";
          }
        ];
      };
  };
}
