{lib, config}:
{
  hyprland-regreet = {
    enable = true;
    # source = ./confs/Hyprland-regreet.conf;
    text = ''
    exec-once = ${lib.getExe config.programs.regreet.package}; hyprctl dispatch exit

    monitor = eDP-1,    3200x2000@120,   0x0, 1.6
    monitor = DP-6, 1920x1080@74.97, 2000x0, 1
    monitor = DP-9, 3440x1440@180.00, 0x-1440, 1

    debug {
      disable_logs = false
      enable_stdout_logs = true
    }

    input {
        kb_layout = us,ru
        kb_options = grp:alt_shift_toggle, compose:ralt
        numlock_by_default = true
        repeat_delay = 250
        repeat_rate = 35

        touchpad {
            natural_scroll = yes
            disable_while_typing = true
            clickfinger_behavior = true
            scroll_factor = 0.5
        }
        special_fallthrough = true
        follow_mouse = 1
    }

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        disable_hyprland_qtutils_check = true
    }
    '';
    target = "greetd/hyprland.conf";
  };
}