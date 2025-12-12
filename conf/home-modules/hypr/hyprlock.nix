{
  enable = true;
  settings =
  let
    text_color = "rgba(E2E2E2FF)";
    entry_background_color = "rgba(13131311)";
    entry_border_color = "rgba(91919155)";
    entry_color = "rgba(C6C6C6FF)";
    font_family = "Gabarito";
    font_family_clock = "Gabarito";
    # font_material_symbols = "Material Symbols Outlined";
    font_material_symbols = "Material Symbols Rounded";
    background_color = "rgba(13131377)";
    main_mon = "eDP-1";
  in
  {
    background = {
      color = background_color;
      # path = "{{ SWWW_WALL }}";
      # path = "~/Pictures/Wallpapers/oxvp59.png";
      path = "~/Pictures/Wallpapers/memorize.jpg";
      blur_size = 1; #5
      blur_passes = 1; #4
      brightness = 0.7;
      noise = 0.01;
    };
    input-field = {
      monitor = main_mon;
      size = "250, 50";
      outline_thickness = 2;
      dots_size = 0.1;
      dots_spacing = 0.3;
      outer_color = entry_border_color;
      inner_color = entry_background_color;
      font_color = entry_color;
      # fade_on_empty = true;

      position = "0, 20";
      halign = "center";
      valign = "center";
    };

    label = [
      { # Clock
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
      { # Info
        monitor = "";
        text = "cmd[update:1000] echo $(~/execs/hyprlock/label.sh \"$ATTEMPTS\" \"$FAIL\")";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = text_color;
        font_size = 14;
        font_family = font_family;

        position = "0, -40";
        halign = "center";
        valign = "center";
      }
      { # KB layout
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
      { # Greeting
        monitor = "";
        text = "cmd[update:0:true] echo $(cat ~/.config/hyprlock/te.markup)";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = text_color;
        #font_size = 20;
        #font_family = font_family;

        position = "0, 200";
        halign = "left";
        valign = "bottom";
      }
      { # lock icon
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
      { # "locked" text
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
      { # Status
        monitor = "";
        text = "cmd[update:5000] ~/execs/hyprlock/status.sh";
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
}