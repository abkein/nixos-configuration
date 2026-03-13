{ ... }:
let
  hex2hypr = color: "rgba(${builtins.substring 1 (-1) color})";
in
{
  wayland.systemd.target = "graphical-session.target";
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # --- system module integration
    package = null;
    portalPackage = null;
    systemd.enable = false;
    # --- system module integration
    settings = {
      "$SLURP_COMMAND" = "\"$(slurp -d -c f8daeeBB -b 55405044 -s 00000000)\"";

      monitor = [
        "eDP-1,    3200x2000@120,   0x0, 1.6, bitdepth, 10, cm, srgb, vrr, 1"
        "desc:Acer Technologies SA240Y 0x0480DAE1, 1920x1080@74.97, 2000x0, 1, bitdepth, 10, cm, srgb"#, bitdepth, 10, cm, wide"
        "desc:Xiaomi Corporation Mi monitor 5323110031874, 3440x1440@180.00, 0x-1440, 1, bitdepth, 10, cm, srgb, vrr, 1"
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

      general = {
        # Gaps and border
        border_size = 1;
        gaps_in = 2;
        gaps_out = 2;
        float_gaps = 5;
        gaps_workspaces = 50;

        "col.active_border" = hex2hypr "#0DB7D4FF"; # hex2hypr "#eae0e445"
        "col.inactive_border" = hex2hypr "#00000000"; # hex2hypr "#9a8d9533";

        layout = "dwindle";
        no_focus_fallback = true;
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        inactive_opacity = 0.9;
        dim_modal = true;
        dim_inactive = true;
        dim_strength = 0.05;
        dim_special = 0.2;
        dim_around = 0.2;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          noise = 0.01;
          contrast = 1;
          brightness = 1;
          popups = true;
          popups_ignorealpha = 0.6;
        };

        shadow = {
          enabled = true;
          range = 15;
          render_power = 3;
          color = hex2hypr "#0DB7D4FF"; # hex2hypr "#ee1a1a1a";
          color_inactive = hex2hypr "#0000001A";
          offset = "0 2";
        };
      };

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle, compose:ralt, lv3:menu_switch"; # , lv5:menu_switch
        numlock_by_default = true;
        repeat_rate = 30;
        repeat_delay = 300;
        follow_mouse = 1;
        focus_on_close = 1;
        special_fallthrough = true;

        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          scroll_factor = 0.5;
          clickfinger_behavior = true;
        };
      };

      # weird thing, IDK
      gestures = {
        workspace_swipe_distance = 700;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_create_new = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        # vrr = 1;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        # enable_swallow = false;
        # swallow_regex = "(foot|kitty|allacritty|Alacritty)";
        focus_on_activate = true;
        middle_click_paste = false;
      };

      # binds = {
      #   scroll_event_delay = 0;
      # };

      # xwayland = {
      #   # force_zero_scaling = true;
      # };

      ecosystem = {
        enforce_permissions = false;
      };

      permission = [
        ",screencopy,allow"
        ",plugin,ask"
        ",keyboard,allow"
      ];

      # debug = {
      #   disable_logs = false;
      #   enable_stdout_logs = true;
      # };

      dwindle = {
        preserve_split = true;
        smart_split = false;
        smart_resizing = false;
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
        # "waybar"
        # "keepassxc"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        # Cursor
        # "hyprctl setcursor Bibata-Modern-Classic 24"
      ];

      bind = [
        # ################################### System ###################################
        "Super, XF86MyComputer, exec, hyprshutdown --post-cmd 'systemctl shutdown'"
        "Alt, XF86MyComputer, exec, hyprshutdown --post-cmd 'systemctl reboot'"
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
        "Super,Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "Super, S, exec, grimblast --freeze --notify -e 1500 --openparentdir copysave area"
        "Super+Shift, S, exec, grimblast --freeze --notify -e 1500 --openparentdir copysave output"
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
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "Alt, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "Alt, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 5%+"
        "Alt, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"
        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl --device=amdgpu_bl1 set '+1%'"
        ", XF86MonBrightnessDown, exec, brightnessctl --device=amdgpu_bl1 set '1%-'"

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
        "3,monitor:desc:Acer Technologies SA240Y 0x0480DAE1"
        "9,monitor:desc:Acer Technologies SA240Y 0x0480DAE1"
        "10,monitor:eDP-1"
      ];

      windowrule = [
        {
          name = "KeePassXC prompt float";
          "match:class" = ''^org\.keepassxc\.KeePassXC$'';
          "match:title" = ''^KeePassXC\s+-\s+Access\s+Request$'';
          float = true;
          center = true;
          stay_focused = true;
        }
        # previously: bordercolor ...,pinned:1
        "match:pin true, border_color rgba(ffabf1AA) rgba(ffabf177)"

        # floats
        "match:class system-config-printer, float on"
        "match:class com.ayugram, float on"
        "match:class org.gnome.SimpleScan, float on"
        ''match:title \s+Rename\s+\".*\"\s+, float on''
        ''match:title "Extension: (Zotero Connector) - Zotero Item Selector — Mozilla Firefox", float on''
        "match:class kitty_info, float on"
        "match:class .*blueman-manager-wrapped.*, float on"
        ''match:class thunderbird, match:initial_title "Calendar Reminders", float on''
        ''match:class thunderbird, match:title "An error has occurred", float on''
        ''match:class thunderbird, match:title "Alert", float on''
        ''match:class thunderbird, match:title "Check Spelling", float on''
        ''match:title "SVG Input", float on''

        # inkscape: float everything, but keep the main window tiled
        "match:class org.inkscape.Inkscape, float on"
        ''match:title ^(.*?\s+-\s+Inkscape)$, tile on''
        ''match:title "Extensions", float on''

        ''match:title "Password Required - Betterbird", float on''
        ''match:title "Progress", float on''
        ''match:title "Plugins Manager", float on''
        "match:class org.gnome.font-viewer, float on"
        "match:class latexclip, float on"
        ''match:title " png bitmap image import", float on''
        "match:title ^Password Required - Mozilla Firefox$, float on"

        ''match:title "EPS Input", float on''
        ''match:title "KeePassXC -  Access Request", float on''
        "match:class evince, float on"
        "match:class org.pipewire.Helvum, float on"
        "match:class com.github.wwmm.easyeffects, float on"
        "match:class org.rncbc.qpwgraph, float on"
        ''match:title "File Operation Progress", float on''
        "match:class swayimg, float on"
        ''match:title "KeePassXC - Passkey credentials", float on''
        "match:class org.telegram.desktop$, float on"
        "match:class yubico.org.ykman-gui$, float on"
        "match:title .+[Pp]references$, float on"
        "match:title [Pp]roperties$, float on"
        "match:title Extract$, float on"
        "match:title File Roller$, float on"
        "match:title nwg-look, float on"
        "match:class ^timeshift-gtk$, float on"
        "match:class (wps), tile on"
        "match:class (dev.warp.Warp), tile on"
        "match:class ^([Pp]avucontrol), float on"

        # sizes (static)
        "match:class evince, size 980 890"
        "match:class swayimg, size 800 800"

        # opacities (dynamic)
        "match:class obsidian, opacity 0.9 0.8"
        "match:class ^(firefox)$, opacity 0.9 0.8"
        "match:class thunar, opacity 0.9 0.8"
        "match:class ^(foot)$, opacity 0.8 0.7"
        "match:class ^(kitty)$, opacity 0.7 0.7"
        "match:class ^(com.mitchellh.ghostty)$, opacity 0.8 0.6"
        "match:class ^([Dd]iscord), opacity 0.7 0.6"
        "match:class ^([Cc]ode), opacity 0.95 0.8"
        "match:class ^([Nn]emo), opacity 0.9 0.8"
        "match:title ^Extract$, opacity 0.9 0.7"
        "match:title ^Authenticate$, opacity 0.9 0.7"
        "match:class ^([Pp]avucontrol), opacity 0.9 0.9"

        # workspace assignment
        "match:class ^(firefox)$, workspace 2"
        "match:class ^org.keepassxc.KeePassXC$, workspace 10"

        # your old windowrule (v1) dialog floats
        "match:title ^(Open File)(.*)$, float on"
        "match:title ^(Select a File)(.*)$, float on"
        "match:title ^(Choose wallpaper)(.*)$, float on"
        "match:title ^(Open Folder)(.*)$, float on"
        "match:title ^(Save As)(.*)$, float on"
        "match:title ^(Library)(.*)$, float on"
      ];

      layerrule = [
        "match:namespace .*, xray 1"

        # no animations
        "match:namespace walker, no_anim on"
        "match:namespace selection, no_anim on"
        "match:namespace overview, no_anim on"
        "match:namespace anyrun, no_anim on"
        "match:namespace sideleft, no_anim on"
        "match:namespace sideright, no_anim on"
        "match:namespace indicator.*, no_anim on"
        "match:namespace osk, no_anim on"
        "match:namespace noanim, no_anim on"

        # generic layer-shell
        "match:namespace gtk-layer-shell, blur on"
        "match:namespace gtk-layer-shell, ignore_alpha 0"

        "match:namespace launcher, blur on"
        "match:namespace launcher, ignore_alpha 0.5"

        "match:namespace notifications, blur on"
        "match:namespace notifications, ignore_alpha 0.69"

        # ags
        "match:namespace session, blur on"

        "match:namespace bar, blur on"
        "match:namespace bar, ignore_alpha 0.6"

        "match:namespace corner.*, blur on"
        "match:namespace corner.*, ignore_alpha 0.6"

        "match:namespace dock, blur on"
        "match:namespace dock, ignore_alpha 0.6"

        "match:namespace indicator.*, blur on"
        "match:namespace indicator.*, ignore_alpha 0.6"

        "match:namespace overview, blur on"
        "match:namespace overview, ignore_alpha 0.6"

        "match:namespace cheatsheet, blur on"
        "match:namespace cheatsheet, ignore_alpha 0.6"

        "match:namespace sideright, blur on"
        "match:namespace sideright, ignore_alpha 0.6"

        "match:namespace sideleft, blur on"
        "match:namespace sideleft, ignore_alpha 0.6"

        "match:namespace indicator*, blur on"
        "match:namespace indicator*, ignore_alpha 0.6"

        "match:namespace osk, blur on"
        "match:namespace osk, ignore_alpha 0.6"
      ];
    };
  };
}
