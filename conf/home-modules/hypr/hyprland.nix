{
  enable = true;
  xwayland.enable = true;
  settings = {
    "$SLURP_COMMAND"="\"$(slurp -d -c f8daeeBB -b 55405044 -s 00000000)\"";

    # source= [
    #   /home/kein/.config/hypr/hyprland/env.conf
    #   /home/kein/.config/hypr/hyprland/execs.conf
    #   /home/kein/.config/hypr/hyprland/general.conf
    #   /home/kein/.config/hypr/hyprland/rules.conf
    #   /home/kein/.config/hypr/hyprland/colors.conf
    #   /home/kein/.config/hypr/hyprland/keybinds.conf
    # ];

    monitor = [
      "eDP-1,    3200x2000@120,   0x0, 1.6"
      "desc:Acer Technologies SA240Y 0x0480DAE1, 1920x1080@74.97, 2000x0, 1"
      "desc:Xiaomi Corporation Mi monitor 5323110031874, 3440x1440@180.00, 0x-1440, 1"
      ", preferred, auto, 1"
    ];

    env = [
      "QT_QPA_PLATFORM, wayland"
      "GLFW_IM_MODULE, ibus"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      #"SSH_AUTH_SOCK, $XDG_RUNTIME_DIR/ssh-agent"
      # "MOZ_ENABLE_WAYLAND, 1"
      "SDL_VIDEODRIVER, wayland"
      # "_JAVA_AWT_WM_NONREPARENTING,1"
      # "XDG_SCREENSHOTS_DIR,~/screens"
    ];

    debug = {
      disable_logs = false;
      enable_stdout_logs = true;
    };

    input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle, compose:ralt";
        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;

        touchpad = {
            natural_scroll = "yes";
            disable_while_typing = true;
            clickfinger_behavior = true;
            scroll_factor = 0.5;
        };
        special_fallthrough = true;
        follow_mouse = 1;
    };

    binds = {
      scroll_event_delay = 0;
    };

    gestures = {
      # workspace_swipe = true;
      workspace_swipe_distance = 700;
      # workspace_swipe_fingers = 4;
      workspace_swipe_cancel_ratio = 0.2;
      workspace_swipe_min_speed_to_force = 5;
      workspace_swipe_direction_lock = true;
      workspace_swipe_direction_lock_threshold = 10;
      workspace_swipe_create_new = true;
    };

    general = {
      # Gaps and border
      gaps_in = 2;
      gaps_out = 2;
      gaps_workspaces = 50;
      border_size = 1;

      # Fallback colors
      "col.active_border" = "rgba(0DB7D4FF)";
      "col.inactive_border" = "rgba(31313600)";
      # "col.active_border" = "rgba(eae0e445)"
      # "col.inactive_border" = "rgba(9a8d9533)"

      resize_on_border = true;
      no_focus_fallback = true;
      layout = "dwindle";

      allow_tearing = false;
    };

    dwindle = {
      preserve_split = true;
      smart_split = false;
      smart_resizing = false;
    };

    decoration = {
      rounding = 10;

      blur = {
          enabled = true;
          xray = true;
          special = false;
          new_optimizations = true;
          size = 7;
          passes = 4;
          brightness = 1;
          noise = 0.01;
          contrast = 1;
          popups = true;
          popups_ignorealpha = 0.6;
      };

      shadow = {
          range = 20;
          offset = "0 2";
          render_power = 3;
          color = "rgba(0000001A)";
      };

      dim_inactive = false;
      dim_strength = 0.1;
      dim_special = 0;
    };

    animations = {
      enabled = true;

      # Animation curves
      bezier = [
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "crazyshot, 0.1, 1.5, 0.76, 0.92 "
        "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
        "fluent_decel, 0.1, 1, 0, 1"
        "easeInOutCirc, 0.85, 0, 0.15, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"
        "softAcDecel, 0.26, 0.26, 0.15, 1"
        "md2, 0.4, 0, 0.2, 1"
      ];
      # Animation configs
      animation = [
        "windows, 1, 3, md3_decel, popin 60%"
        "border, 1, 10, default"
        "fade, 1, 3, md3_decel"
        "layers, 1, 2, md3_decel, slide"
        "workspaces, 1, 7, fluent_decel, slide"
        #workspaces, 1, 2.5, softAcDecel, slide
        #workspaces, 1, 7, fluent_decel, slidefade 15%
        #specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
        "specialWorkspace, 1, 3, md3_decel, slidevert"
      ];
    };

    misc = {
      vfr = 1;
      vrr = 0;
      # layers_hog_mouse_focus = true
      focus_on_activate = true;
      animate_manual_resizes = false;
      animate_mouse_windowdragging = false;
      enable_swallow = false;
      swallow_regex = "(foot|kitty|allacritty|Alacritty)";

      disable_hyprland_logo = true;
      force_default_wallpaper = 0;
      new_window_takes_over_fullscreen = 2;
      # enable_hyprcursor = true

      background_color = "rgba(1f1a1dFF)";
    };

    xwayland = {
      force_zero_scaling = true;
    };

    plugin = {
      hyprbars = {
          # Honestly idk if it works like css, but well, why not
          bar_text_font = "Rubik, Geist, AR One Sans, Reddit Sans, Inter, Roboto, Ubuntu, Noto Sans, sans-serif";
          bar_height = 30;
          bar_padding = 10;
          bar_button_padding = 5;
          bar_precedence_over_border = true;
          bar_part_of_window = true;

          bar_color = "rgba(120F11FF)";
          "col.text" = "rgba(eae0e4FF)";

          # example buttons (R -> L)
          hyprbars-button = [
            # "color, size, on-click"
            "rgb(eae0e4), 13, 󰖭, hyprctl dispatch killactive"
            "rgb(eae0e4), 13, 󰖯, hyprctl dispatch fullscreen 1"
            "rgb(eae0e4), 13, 󰖰, hyprctl dispatch movetoworkspacesilent special"
          ];
      };
    };

    exec-once = [
      # Bar, wallpaper
      #"ags"
      "waybar"
      # "hyprpaper"
      # Core components (authentication, lock screen, notification daemon)
      # "dunst -conf $XDG_CONFIG_HOME/dunst/dunstrc"
      # "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
      # "hypridle"
      # "dbus-update-activation-environment --all"
      # "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "keepassxc"
      # Clipboard: history
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      # Cursor
      # "hyprctl setcursor Bibata-Modern-Classic 24"
    ];

    bind = [
      "Super, Super_L, exec, pgrep wofi >/dev/null 2>&1 && pkill wofi || wofi"
      "Super, P, togglefloating,"
      # ################################### Applications ###################################
      # Apps: just normal apps
      # "Super, C, exec, code --password-store=gnome-libsecret --ozone-platform=wayland"
      "Super, T, exec, ghostty"
      # "Super, E, exec, hyprctl dispatch exit"
      "Super, E, exec, thunar"
      "Super, X, exec, xed"
      "Super+Shift, W, exec, wps"
      "Super, F, exec, firefox"
      # Apps: Settings and config
      #"Super, I, exec, XDG_CURRENT_DESKTOP="gnome" gnome-control-center"
      #"Control+Super, V, exec, pavucontrol"
      "Control+Super+Shift, V, exec, easyeffects"
      "Control+Shift, Escape, exec, gnome-system-monitor"
      # Actions
      # "Super, Period, exec, pkill fuzzel || ~/.local/bin/fuzzel-emoji"
      "Super, Q, killactive,"
      # "Super+Alt, Space, togglefloating,"
      "Shift+Super+Alt, Q, exec, hyprctl kill"
      "Control+Shift+Alt, Delete, exec, pkill wlogout || wlogout -p layer-shell"
      "Control+Shift+Alt+Super, Delete, exec, systemctl poweroff || loginctl poweroff"
      # Screenshot, Record, OCR, Color picker, Clipboard history
      #screenshot
      ",Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
      "Super, S, exec, grimblast --freeze --notify --openfile copysave area"
      "Super+Shift, S, exec, grimblast --freeze --notify --openfile copysave output"
      "Control+Alt, O, exec, grim -g \"$(slurp)\" - | tesseract - - | wl-copy"
      "Control+Alt, I, exec, grim -g \"$(slurp)\" - | tesseract -l rus - - | wl-copy"
      # "Super+Shift+Ctrl, S, exec, ~/.config/ags/scripts/grimblast.sh --freeze copy screen"
      "Super, R, exec, ~/execs/record-script.sh"
      "Super+Shift, R, exec, ~/execs/record-script.sh --sound"
      "Super+Shift+Ctrl, R, exec, ~/execs/record-script.sh --fullscreen"
      "Super+Shift+Alt, R, exec, ~/execs/record-script.sh --fullscreen-sound"
      "Super+Shift, C, exec, hyprpicker -a"
      # "Super, V, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy"
      # Text-to-image
      # Normal
      "Control+Super+Shift,S,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract \"tmp.png\" - | wl-copy && rm \"tmp.png\""
      # English
      "Super+Shift,T,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract -l eng \"tmp.png\" - | wl-copy && rm \"tmp.png\""
      # Japanese
      "Super+Shift,J,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract -l jpn \"tmp.png\" - | wl-copy && rm \"tmp.png\""
      # Media
      "Super+Shift+Alt, mouse:275, exec, playerctl previous"
      "Super+Shift+Alt, mouse:276, exec, playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"
      # Lock screen
      "Super, L, exec, loginctl lock-session && hyprlock"
      "Super+Shift, L, exec, loginctl lock-session && hyprlock"

      # App launcher
      "Control+Super, Slash, exec, pkill anyrun || anyrun"
      # ##################################### AGS keybinds #####################################
      # "Control+Super, T, exec, ~/.config/ags/scripts/color_generation/switchwall.sh"
      # "Control+Alt, Slash, exec, ags run-js 'cycleMode();'"
      # "Super, Tab, exec, ags -t 'overview'"
      # "Super, Slash, exec, for ((i=0; i<$(xrandr --listmonitors | grep -c 'Monitor'); i++)); do ags -t \"cheatsheet\"\"$i\"; done"
      # "Super, B, exec, ags -t 'sideleft'"
      # "Super, A, exec, ags -t 'sideleft'"
      # "Super, O, exec, ags -t 'sideleft'"
      # "Super, N, exec, ags -t 'sideright'"
      # "Super, M, exec, ags run-js 'openMusicControls.value = (!mpris.getPlayer() ? false : !openMusicControls.value);'"
      # "Super, Comma, exec, ags run-js 'openColorScheme.value = true; Utils.timeout(2000, () => openColorScheme.value = false);'"
      # "Super, K, exec, for ((i=0; i<$(xrandr --listmonitors | grep -c 'Monitor'); i++)); do ags -t \"osk\"\"$i\"; done"
      # "Control+Alt, Delete, exec, ags -t 'session'"
      # ##################################### Plugins #########################################
      # "Control+Super, P, exec, hyprctl plugin load \"~/.config/hypr/plugins/droidbars.so\""
      # "Control+Super, O, exec, hyprctl plugin unload \"~/.config/hypr/plugins/droidbars.so\""
      # Testing
      # "SuperAlt, f12, exec, notify-send "Hyprland version: $(hyprctl version | head -2 | tail -1 | cut -f2 -d ' ')" "owo" -a 'Hyprland keybind'"
      # "Super+Alt, f12, exec, notify-send "Millis since epoch" "$(date +%s%N | cut -b1-13)" -a 'Hyprland keybind'"
      # "Super+Alt, f12, exec, notify-send 'Test notification' \"Here's a really long message to test truncation and wrapping\\nYou can middle click or flick this notification to dismiss it!\" -a 'Shell' -A \"Test1=I got it!\" -A \"Test2=Another action\" -t 5000"
      # "Super+Alt, Equal, exec, notify-send \"Urgent notification\" \"Ah hell no\" -u critical -a 'Hyprland keybind'"
      # ########################### Keybinds for Hyprland ############################
      # Swap windows
      "Super+Shift, left, movewindow, l"
      "Super+Shift, right, movewindow, r"
      "Super+Shift, up, movewindow, u"
      "Super+Shift, down, movewindow, d"
      "Super, P, pin"
      # Move focus
      "Super, left, movefocus, l"
      "Super, right, movefocus, r"
      "Super, up, movefocus, u"
      "Super, down, movefocus, d"

      # Workspace, window, tab switch with keyboard

      "Control+Super, Next, workspace, +1"
      "Control+Super, Prior, workspace, -1"
      "Super+Alt, Next, movetoworkspace, +1"
      "Super+Alt, Prior, movetoworkspace, -1"
      "Super+Shift, Next, movetoworkspace, +1"
      "Super+Shift, Prior, movetoworkspace, -1"
      "Control+Super+Shift, Right, movetoworkspace, +1"
      "Control+Super+Shift, Left, movetoworkspace, -1"
      "Control+Alt,Prior, movecurrentworkspacetomonitor, l"
      "Control+Alt,Next, movecurrentworkspacetomonitor, r"

      "Super+Alt, mouse_down, movetoworkspace, -1"
      "Super+Alt, mouse_up, movetoworkspace, +1"

      # Fullscreen
      "Super, G, fullscreen, 0"
      "Super, H, fullscreen, 1"
      #"Super_Alt, F, fakefullscreen, 0"
      # Switching
      "Super, 1, workspace, 1"
      "Super, 2, workspace, 2"
      "Super, 3, workspace, 3"
      "Super, 4, workspace, 4"
      "Super, 5, workspace, 5"
      "Super, 6, workspace, 6"
      "Super, 7, workspace, 7"
      "Super, 8, workspace, 8"
      "Super, 9, workspace, 9"
      "Super, 0, workspace, 10"
      # "Super, S, togglespecialworkspace,"
      # "Control+Super, S, togglespecialworkspace,"
      "Alt, Tab, cyclenext"
      "Alt, Tab, bringactivetotop,"
      # Move window to workspace Super + Alt + [0-9]
      "Super+Alt, 1, movetoworkspace, 1"
      "Super+Alt, 2, movetoworkspace, 2"
      "Super+Alt, 3, movetoworkspace, 3"
      "Super+Alt, 4, movetoworkspace, 4"
      "Super+Alt, 5, movetoworkspace, 5"
      "Super+Alt, 6, movetoworkspace, 6"
      "Super+Alt, 7, movetoworkspace, 7"
      "Super+Alt, 8, movetoworkspace, 8"
      "Super+Alt, 9, movetoworkspace, 9"
      "Super+Alt, 0, movetoworkspace, 10"
      "Control+Shift+Super, Up, movetoworkspacesilent, special"
      "Super+Alt, S, movetoworkspacesilent, special"

      "Super+Ctrl, 1, movecurrentworkspacetomonitor, eDP-1"
      "Super+Ctrl, 2, movecurrentworkspacetomonitor, desc:Xiaomi Corporation Mi monitor 5323110031874"
      "Super+Ctrl, 3, movecurrentworkspacetomonitor, desc:Acer Technologies SA240Y 0x0480DAE1"

      # Scroll through existing workspaces with (Control) + Super + scroll
      "Super, mouse_up, workspace, +1"
      "Super, mouse_down, workspace, -1"

      # Move/resize windows with Super + LMB/RMB and dragging
      "Control+Super, Backslash, resizeactive, exact 640 480"

      # Control + Side mouse btn for switching tabs (Ctrl+PgUp/PgDn)
      #"Control, mouse:275, exec, ydotool key 29:1 104:1 104:0 29:0"
      #"Control, mouse:276, exec, ydotool key 29:1 109:1 109:0 29:0"
    ];

    bindl = [
      # ################### It just works™ keybinds ###################
      # Volume
      "Super ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
      "Alt ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
      ",XF86AudioMute, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
      "Super+Shift,M, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
      # Screenshot, Record, OCR, Color picker, Clipboard history
      #screenshot
      "Super,Print,exec,grim - | wl-copy"
      # Media
      "Super+Shift, N, exec, playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"
      ",XF86AudioNext, exec, playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"
      "Super+Shift, B, exec, playerctl previous"
      "Super+Shift, P, exec, playerctl play-pause"
      ",XF86AudioPlay, exec, playerctl play-pause"
      # Lockscreen
      "Super+Shift, L, exec, sleep 0.1 && systemctl suspend || loginctl suspend"
      # ##################################### AGS keybinds #####################################
      # ", XF86AudioMute, exec, ags run-js 'indicator.popup(1);'"
      # "Super+Shift,M,   exec, ags run-js 'indicator.popup(1);'"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      # Brightness
      # Uncomment these if you can't get AGS to work
      #", XF86MonBrightnessUp, exec, brightnessctl set '12.75+'"
      #", XF86MonBrightnessDown, exec, brightnessctl set '12.75-'"
      #", XF86MonBrightnessDown, exec, brightnessctl set '12.75-'"
      # ##################################### AGS keybinds #####################################
      ", XF86AudioRaiseVolume, exec, ags run-js 'indicator.popup(1);'"
      ", XF86AudioLowerVolume, exec, ags run-js 'indicator.popup(1);'"
      ", XF86MonBrightnessUp, exec, ags run-js 'brightness.screen_value += 0.05; indicator.popup(1);'"
      ", XF86MonBrightnessDown, exec, ags run-js 'brightness.screen_value -= 0.05; indicator.popup(1);'"

      # Arrow keys with IJKL
      "Alt, I, exec, ydotool key 103:1 103:0"
      "Alt, K, exec, ydotool key 108:1 108:0"
      "Alt, J, exec, ydotool key 105:1 105:0"
      "Alt, L, exec, ydotool key 106:1 106:0"
    ];


    binde = [
    # Window split ratio
    "Super, Minus, splitratio, -0.1"
    "Super, Equal, splitratio, 0.1"
    ];

    bindm = [
      # Move/resize windows with Super + LMB/RMB and dragging
      "Super, mouse:272, movewindow"
      "Super, mouse:273, resizewindow"
      #"Super, mouse:274, movewindow"
      "Super, Z, movewindow"
    ];

    workspace = [
      "1,monitor:eDP-1"
      "2,monitor:desc:Xiaomi Corporation Mi monitor 5323110031874"
      "9,monitor:desc:Acer Technologies SA240Y 0x0480DAE1"
      "10,monitor:eDP-1"
    ];

    windowrulev2 = [
      "bordercolor rgba(ffabf1AA) rgba(ffabf177),pinned:1"
      # ######## Window rules ########
      "float, class:system-config-printer"
      "float, class:com.ayugram"
      "float, class:org.gnome.SimpleScan"
      # "float, title:^Rename\s\".*\"$"
      "float, title:\s+Rename\s+\".*\"\s+"
      "float, title:Extension: (Zotero Connector) - Zotero Item Selector — Mozilla Firefox"
      "float, class:kitty_info"
      "float, class:.blueman-manager-wrapped"
      "float, class:thunderbird,initialTitle:Calendar Reminders"
      "float, class:thunderbird,title:An error has occurred"
      "float, title:SVG Input"
      "float, class:org.inkscape.Inkscape"  # Float all inkscape windows
      "tile, title:^(.*?\s+-\s+Inkscape)$"  # But keep main window tiled
      "float, title:Extensions"
      "float, title:Password Required - Betterbird"
      "float, title:Progress"
      "float, title:Plugins Manager"
      "float, class:org.gnome.font-viewer"
      "float, class:latexclip"
      "float, title: png bitmap image import"
      "opacity 0.9 0.8, class:obsidian"
      "opacity 0.9 0.8, class:^(firefox)$"
      "opacity 0.9 0.8, class:thunar"
      "float, title:^Password Required - Mozilla Firefox$"
      "workspace 2, class:^(firefox)$"
      "workspace 10, class:^org.keepassxc.KeePassXC$"
      "opacity 0.8 0.7, class:^(foot)$"
      "opacity 0.7 0.7, class:^(kitty)$"
      "opacity 0.8 0.6, class:^(com.mitchellh.ghostty)$"
      "opacity 0.7 0.6, class:^([Dd]iscord)"
      "opacity 0.95 0.8, class:^([Cc]ode)"
      "opacity 0.9 0.8, class:^([Nn]emo)"
      "opacity 0.9 0.7, title:^Extract$"
      "opacity 0.9 0.7, title:^Authenticate$"
      "float, title:EPS Input"
      "float, title:KeePassXC -  Access Request"
      "float, class:evince"
      "float, class:org.pipewire.Helvum"
      "float, class:com.github.wwmm.easyeffects"
      "float, class:org.rncbc.qpwgraph"
      "float, title:File Operation Progress"
      "float, class:thunderbird, title:Alert"
      "size 980 890, class:evince"
      #"move 2900 70, class:evince"
      "size 800 800, class:swayimg"
      "float, class:swayimg"
      "float, title:KeePassXC - Passkey credentials"
      "float, class:org.telegram.desktop$"
      "float, class:yubico.org.ykman-gui$"
      "float, title:.+[Pp]references$"
      "float, title:.+[Pp]references$"
      "float, title:[Pp]roperties$"
      "float, title:Extract$"
      "float, title:File Roller$"
      "float, title:nwg-look"
      "float, class:^timeshift-gtk$"
      "tile,class:(wps)"
      "tile,class:(dev.warp.Warp)"
      "float, class:^([Pp]avucontrol)"
      "opacity 0.9 0.9, class:^([Pp]avucontrol)"

    ];

    windowrule = [
      # "noblur,.*"
      # "float, ^(blueberry.py)$"
      # "float, ^(steam)$"
      # "float, ^(guifetch)$ # FlafyDev/guifetch"
      # Dialogs
      "float,title:^(Open File)(.*)$"
      "float,title:^(Select a File)(.*)$"
      "float,title:^(Choose wallpaper)(.*)$"
      "float,title:^(Open Folder)(.*)$"
      "float,title:^(Save As)(.*)$"
      "float,title:^(Library)(.*)$"

    ];

    layerrule = [
      # ######## Layer rules ########
      "xray 1, .*"
      #"= noanim, .*"
      "noanim, walker"
      "noanim, selection"
      "noanim, overview"
      "noanim, anyrun"
      "noanim, sideleft"
      "noanim, sideright"
      "noanim, indicator.*"
      "noanim, osk"
      "noanim, noanim"
      "blur, gtk-layer-shell"
      "ignorezero, gtk-layer-shell"
      "blur, launcher"
      "ignorealpha 0.5, launcher"
      "blur, notifications"
      "ignorealpha 0.69, notifications"

      # ags
      "blur, session"
      "blur, bar"
      "ignorealpha 0.6, bar"
      "blur, corner.*"
      "ignorealpha 0.6, corner.*"
      "blur, dock"
      "ignorealpha 0.6, dock"
      "blur, indicator.*"
      "ignorealpha 0.6, indicator.*"
      "blur, overview"
      "ignorealpha 0.6, overview"
      "blur, cheatsheet"
      "ignorealpha 0.6, cheatsheet"
      "blur, sideright"
      "ignorealpha 0.6, sideright"
      "blur, sideleft"
      "ignorealpha 0.6, sideleft"
      "blur, indicator*"
      "ignorealpha 0.6, indicator*"
      "blur, osk"
      "ignorealpha 0.6, osk"
    ];

  };
}
