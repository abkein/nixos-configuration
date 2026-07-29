{ lib, ... }:
let
  hex2hypr = color: "rgba(${builtins.substring 1 (-1) color})";
  lua = lib.generators.mkLuaInline;

  mkBind = keys: dispatcher: options: {
    _args = [
      keys
      (lua dispatcher)
    ]
    ++ lib.optional (options != { }) options;
  };
  bind = keys: dispatcher: mkBind keys dispatcher { };
  bindExec = keys: command: bind keys "hl.dsp.exec_cmd(${builtins.toJSON command})";
  bindLockedExec =
    keys: command:
    mkBind keys "hl.dsp.exec_cmd(${builtins.toJSON command})" {
      locked = true;
    };
  bindLockedRepeatingExec =
    keys: command:
    mkBind keys "hl.dsp.exec_cmd(${builtins.toJSON command})" {
      locked = true;
      repeating = true;
    };
  bindMouse =
    keys: dispatcher:
    mkBind keys dispatcher {
      mouse = true;
    };

  bezier = name: x1: y1: x2: y2: {
    _args = [
      name
      {
        type = "bezier";
        points = [
          [
            x1
            y1
          ]
          [
            x2
            y2
          ]
        ];
      }
    ];
  };
  animation =
    leaf: speed: curve: style:
    {
      inherit leaf speed;
      enabled = true;
      bezier = curve;
    }
    // lib.optionalAttrs (style != null) { inherit style; };
  windowRule = match: effects: { inherit match; } // effects;
  layerRule =
    namespace: effects:
    {
      match = { inherit namespace; };
    }
    // effects;
in
{
  wayland.systemd.target = "graphical-session.target";
  wayland.windowManager.hyprland = {
    enable = true;
    # xwayland.enable = true;
    configType = "lua";
    # --- system module integration
    # package = null;
    # portalPackage = null;
    systemd = {
      enable = lib.mkDefault true;
      enableXdgAutostart = true;
    };
    # --- system module integration
    settings = {
      monitor = [
        {
          output = "eDP-1";
          mode = "3200x2000@120";
          position = "0x0";
          scale = 1.6;
          bitdepth = 10;
          cm = "srgb";
          vrr = 1;
        }
        {
          output = "desc:Acer Technologies SA240Y 0x0480DAE1";
          mode = "1920x1080@74.97";
          position = "2000x0";
          scale = 1;
          bitdepth = 10;
          cm = "srgb";
        }
        {
          output = "desc:Xiaomi Corporation Mi monitor 5323110031874";
          mode = "3440x1440@180.00";
          position = "0x-1440";
          scale = 1;
          bitdepth = 10;
          cm = "srgb";
          vrr = 1;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      config = {
        general = {
          # Gaps and border
          border_size = 1;
          gaps_in = 2;
          gaps_out = 2;
          float_gaps = 5;
          gaps_workspaces = 50;

          # col.active_border = hex2hypr "#0DB7D4FF"; # stylix
          # col.inactive_border = hex2hypr "#00000000"; # stylix

          layout = "dwindle";
          no_focus_fallback = true;
          resize_on_border = true;
          extend_border_grab_area = 2;
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
            range = 10;
            render_power = 3;
            # color = hex2hypr "#0DB7D4FF"; # stylix
            color_inactive = hex2hypr "#0000001A";
            offset = "0 2";
          };
        };

        input = {
          kb_layout = "us,ru";
          kb_options = "grp:alt_shift_toggle, compose:ralt, lv3:menu_switch";
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

        ecosystem.enforce_permissions = false;

        dwindle = {
          preserve_split = true;
          smart_split = false;
          smart_resizing = false;
        };

        animations.enabled = true;

      };

      permission = [
        {
          binary = ".*";
          type = "screencopy";
          mode = "allow";
        }
        {
          binary = ".*";
          type = "plugin";
          mode = "ask";
        }
        {
          binary = ".*";
          type = "keyboard";
          mode = "allow";
        }
      ];

      curve = [
        (bezier "linear" 0 0 1 1)
        (bezier "md3_standard" 0.2 0 0 1)
        (bezier "md3_decel" 0.05 0.7 0.1 1)
        (bezier "md3_accel" 0.3 0 0.8 0.15)
        (bezier "overshot" 0.05 0.9 0.1 1.1)
        (bezier "crazyshot" 0.1 1.5 0.76 0.92)
        (bezier "hyprnostretch" 0.05 0.9 0.1 1)
        (bezier "fluent_decel" 0.1 1 0 1)
        (bezier "easeInOutCirc" 0.85 0 0.15 1)
        (bezier "easeOutCirc" 0 0.55 0.45 1)
        (bezier "easeOutExpo" 0.16 1 0.3 1)
        (bezier "softAcDecel" 0.26 0.26 0.15 1)
        (bezier "md2" 0.4 0 0.2 1)
      ];

      animation = [
        (animation "windows" 3 "md3_decel" "popin 60%")
        (animation "border" 10 "default" null)
        (animation "fade" 3 "md3_decel" null)
        (animation "layers" 2 "md3_decel" "slide")
        (animation "workspaces" 7 "fluent_decel" "slide")
        # (animation "workspaces" 2.5 "softAcDecel" "slide")
        # (animation "workspaces" 7 "fluent_decel" "slidefade 15%")
        # (animation "specialWorkspace" 3 "md3_decel" "slidefadevert 15%")
        (animation "specialWorkspace" 3 "md3_decel" "slidevert")
      ];

      bind = [
        # System
        (bindExec "SUPER + XF86MyComputer" "hyprshutdown --post-cmd 'systemctl shutdown'")
        (bindExec "ALT + XF86MyComputer" "hyprshutdown --post-cmd 'systemctl reboot'")
        (bindExec "SUPER + SUPER_L" "pgrep fuzzel >/dev/null 2>&1 && pkill fuzzel || fuzzel")
        (bind "SUPER + P" "hl.dsp.window.float()")

        # Applications
        (bindExec "SUPER + T" "ghostty")
        (bindExec "SUPER + E" "thunar")
        (bindExec "SUPER + X" "xed")
        (bindExec "SUPER + SHIFT + W" "wps")
        (bindExec "SUPER + F" "firefox")
        (bindExec "CTRL + SUPER + SHIFT + V" "easyeffects")
        (bindExec "CTRL + SHIFT + Escape" "gnome-system-monitor")

        # Actions
        (bind "SUPER + Q" "hl.dsp.window.close()")
        (bindExec "SHIFT + SUPER + ALT + Q" "hyprctl kill")
        (bindExec "CTRL + SHIFT + ALT + Delete" "pkill wlogout || wlogout -p layer-shell")
        (bindExec "CTRL + SHIFT + ALT + SUPER + Delete" "systemctl poweroff || loginctl poweroff")

        # Screenshot, record, OCR, color picker, and clipboard history
        (bindExec "SUPER + Print" ''grim -g "$(slurp)" - | swappy -f -'')
        (bindExec "SUPER + S" "grimblast --freeze --notify -e 1500 --openparentdir copysave area")
        (bindExec "SUPER + SHIFT + S" "grimblast --freeze --notify -e 1500 --openparentdir copysave output")
        (bindExec "CTRL + ALT + O" ''grim -g "$(slurp)" - | tesseract - - | wl-copy'')
        (bindExec "CTRL + ALT + I" ''grim -g "$(slurp)" - | tesseract -l rus - - | wl-copy'')
        (bindExec "SUPER + R" "~/execs/record-script.sh")
        (bindExec "SUPER + SHIFT + R" "~/execs/record-script.sh --sound")
        (bindExec "SUPER + SHIFT + CTRL + R" "~/execs/record-script.sh --fullscreen")
        (bindExec "SUPER + SHIFT + ALT + R" "~/execs/record-script.sh --fullscreen-sound")
        (bindExec "SUPER + SHIFT + C" "hyprpicker -a")
        (bindExec "SUPER + V" "pkill fuzzel || cliphist list | fuzzel --dmenu | cliphist decode | wl-copy")

        # Text-to-image: default, English, and Japanese
        (bindExec "CTRL + SUPER + SHIFT + S" ''grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract "tmp.png" - | wl-copy && rm "tmp.png"'')
        (bindExec "SUPER + SHIFT + T" ''grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"'')
        (bindExec "SUPER + SHIFT + J" ''grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l jpn "tmp.png" - | wl-copy && rm "tmp.png"'')

        # Media
        (bindExec "SUPER + SHIFT + ALT + mouse:275" "playerctl previous")
        (bindExec "SUPER + SHIFT + ALT + mouse:276" ''playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`'')

        # Lock screen and launcher
        (bindExec "SUPER + L" "loginctl lock-session && hyprlock")
        (bindExec "SUPER + SHIFT + L" "loginctl lock-session && hyprlock")
        (bindExec "CTRL + SUPER + Slash" "pkill anyrun || anyrun")

        # Swap windows
        (bind "SUPER + SHIFT + left" ''hl.dsp.window.move({ direction = "l" })'')
        (bind "SUPER + SHIFT + right" ''hl.dsp.window.move({ direction = "r" })'')
        (bind "SUPER + SHIFT + up" ''hl.dsp.window.move({ direction = "u" })'')
        (bind "SUPER + SHIFT + down" ''hl.dsp.window.move({ direction = "d" })'')
        (bind "SUPER + P" "hl.dsp.window.pin()")

        # Move focus
        (bind "SUPER + left" ''hl.dsp.focus({ direction = "l" })'')
        (bind "SUPER + right" ''hl.dsp.focus({ direction = "r" })'')
        (bind "SUPER + up" ''hl.dsp.focus({ direction = "u" })'')
        (bind "SUPER + down" ''hl.dsp.focus({ direction = "d" })'')

        # Workspace and window switching
        (bind "CTRL + SUPER + Next" ''hl.dsp.focus({ workspace = "+1" })'')
        (bind "CTRL + SUPER + Prior" ''hl.dsp.focus({ workspace = "-1" })'')
        (bind "SUPER + ALT + Next" ''hl.dsp.window.move({ workspace = "+1", follow = true })'')
        (bind "SUPER + ALT + Prior" ''hl.dsp.window.move({ workspace = "-1", follow = true })'')
        (bind "SUPER + SHIFT + Next" ''hl.dsp.window.move({ workspace = "+1", follow = true })'')
        (bind "SUPER + SHIFT + Prior" ''hl.dsp.window.move({ workspace = "-1", follow = true })'')
        (bind "CTRL + SUPER + SHIFT + Right" ''hl.dsp.window.move({ workspace = "+1", follow = true })'')
        (bind "CTRL + SUPER + SHIFT + Left" ''hl.dsp.window.move({ workspace = "-1", follow = true })'')
        (bind "CTRL + ALT + Prior" ''hl.dsp.workspace.move({ monitor = "l" })'')
        (bind "CTRL + ALT + Next" ''hl.dsp.workspace.move({ monitor = "r" })'')
        (bind "SUPER + ALT + mouse_down" ''hl.dsp.window.move({ workspace = "-1", follow = true })'')
        (bind "SUPER + ALT + mouse_up" ''hl.dsp.window.move({ workspace = "+1", follow = true })'')

        # Fullscreen
        (bind "SUPER + G" ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')
        (bind "SUPER + H" ''hl.dsp.window.fullscreen({ mode = "maximized" })'')

        # Switch workspaces
        (bind "SUPER + 1" ''hl.dsp.focus({ workspace = "1" })'')
        (bind "SUPER + 2" ''hl.dsp.focus({ workspace = "2" })'')
        (bind "SUPER + 3" ''hl.dsp.focus({ workspace = "3" })'')
        (bind "SUPER + 4" ''hl.dsp.focus({ workspace = "4" })'')
        (bind "SUPER + 5" ''hl.dsp.focus({ workspace = "5" })'')
        (bind "SUPER + 6" ''hl.dsp.focus({ workspace = "6" })'')
        (bind "SUPER + 7" ''hl.dsp.focus({ workspace = "7" })'')
        (bind "SUPER + 8" ''hl.dsp.focus({ workspace = "8" })'')
        (bind "SUPER + 9" ''hl.dsp.focus({ workspace = "9" })'')
        (bind "SUPER + 0" ''hl.dsp.focus({ workspace = "10" })'')
        (bind "ALT + Tab" "hl.dsp.window.cycle_next()")
        (bind "ALT + Tab" "hl.dsp.window.bring_to_top()")

        # Move a window to a workspace
        (bind "SUPER + ALT + 1" ''hl.dsp.window.move({ workspace = "1", follow = true })'')
        (bind "SUPER + ALT + 2" ''hl.dsp.window.move({ workspace = "2", follow = true })'')
        (bind "SUPER + ALT + 3" ''hl.dsp.window.move({ workspace = "3", follow = true })'')
        (bind "SUPER + ALT + 4" ''hl.dsp.window.move({ workspace = "4", follow = true })'')
        (bind "SUPER + ALT + 5" ''hl.dsp.window.move({ workspace = "5", follow = true })'')
        (bind "SUPER + ALT + 6" ''hl.dsp.window.move({ workspace = "6", follow = true })'')
        (bind "SUPER + ALT + 7" ''hl.dsp.window.move({ workspace = "7", follow = true })'')
        (bind "SUPER + ALT + 8" ''hl.dsp.window.move({ workspace = "8", follow = true })'')
        (bind "SUPER + ALT + 9" ''hl.dsp.window.move({ workspace = "9", follow = true })'')
        (bind "SUPER + ALT + 0" ''hl.dsp.window.move({ workspace = "10", follow = true })'')
        (bind "CTRL + SHIFT + SUPER + Up" ''hl.dsp.window.move({ workspace = "special", follow = false })'')
        (bind "SUPER + ALT + S" ''hl.dsp.window.move({ workspace = "special", follow = false })'')

        # Move the current workspace to a monitor
        (bind "SUPER + CTRL + 1" ''hl.dsp.workspace.move({ monitor = "eDP-1" })'')
        (bind "SUPER + CTRL + 2" ''hl.dsp.workspace.move({ monitor = "desc:Xiaomi Corporation Mi monitor 5323110031874" })'')
        (bind "SUPER + CTRL + 3" ''hl.dsp.workspace.move({ monitor = "desc:Acer Technologies SA240Y 0x0480DAE1" })'')

        # Scroll through workspaces
        (bind "SUPER + mouse_up" ''hl.dsp.focus({ workspace = "+1" })'')
        (bind "SUPER + mouse_down" ''hl.dsp.focus({ workspace = "-1" })'')

        # Resize to a fixed size
        (bind "CTRL + SUPER + Backslash" "hl.dsp.window.resize({ x = 640, y = 480 })")

        # Locked binds
        (bindLockedExec "SUPER + Print" "grim - | wl-copy")
        (bindLockedExec "SUPER + SHIFT + N" ''playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`'')
        (bindLockedExec "XF86AudioNext" ''playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`'')
        (bindLockedExec "SUPER + SHIFT + B" "playerctl previous")
        (bindLockedExec "SUPER + SHIFT + P" "playerctl play-pause")
        (bindLockedExec "XF86AudioPlay" "playerctl play-pause")
        (bindLockedExec "SUPER + SHIFT + L" "sleep 0.1 && systemctl suspend || loginctl suspend")

        # Locked, repeating binds
        (bindLockedRepeatingExec "XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        (bindLockedRepeatingExec "XF86AudioRaiseVolume" "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")
        (bindLockedRepeatingExec "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
        (bindLockedRepeatingExec "ALT + XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
        (bindLockedRepeatingExec "ALT + XF86AudioRaiseVolume" "wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 5%+")
        (bindLockedRepeatingExec "ALT + XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-")
        (bindLockedRepeatingExec "XF86MonBrightnessUp" "brightnessctl --device=amdgpu_bl1 set '+1%'")
        (bindLockedRepeatingExec "XF86MonBrightnessDown" "brightnessctl --device=amdgpu_bl1 set '1%-'")

        # Arrow keys with IJKL
        (bindLockedRepeatingExec "ALT + I" "ydotool key 103:1 103:0")
        (bindLockedRepeatingExec "ALT + K" "ydotool key 108:1 108:0")
        (bindLockedRepeatingExec "ALT + J" "ydotool key 105:1 105:0")
        (bindLockedRepeatingExec "ALT + L" "ydotool key 106:1 106:0")

        # Move/resize windows with SUPER + LMB/RMB and dragging
        (bindMouse "SUPER + mouse:272" "hl.dsp.window.drag()")
        (bindMouse "SUPER + mouse:273" "hl.dsp.window.resize()")
        (bindMouse "SUPER + Z" "hl.dsp.window.drag()")
      ];

      workspace_rule = [
        {
          workspace = "1";
          monitor = "eDP-1";
        }
        {
          workspace = "2";
          monitor = "desc:Xiaomi Corporation Mi monitor 5323110031874";
        }
        {
          workspace = "3";
          monitor = "desc:Acer Technologies SA240Y 0x0480DAE1";
        }
        {
          workspace = "9";
          monitor = "desc:Acer Technologies SA240Y 0x0480DAE1";
        }
        {
          workspace = "10";
          monitor = "eDP-1";
        }
      ];

      window_rule = [
        {
          name = "KeePassXC prompt float";
          match = {
            class = ''^org\.keepassxc\.KeePassXC$'';
            title = ''^KeePassXC\s+-\s+Access\s+Request$'';
          };
          float = true;
          center = true;
          stay_focused = true;
        }
        {
          name = "Zotero main window tile";
          match = {
            class = "^Zotero$";
            title = "^Zotero$";
            initial_title = "^Zotero$";
          };
          tile = true;
        }
        {
          name = "Zotero secondary windows float";
          match = {
            class = "^Zotero$";
            initial_title = "negative:^Zotero$";
          };
          float = true;
          center = true;
        }

        # Pinned border
        (windowRule { pin = true; } {
          border_color = "rgba(ffabf1AA) rgba(ffabf177)";
        })

        # Floats
        (windowRule { class = "system-config-printer"; } { float = true; })
        (windowRule { class = "com.ayugram"; } { float = true; })
        (windowRule { class = "org.gnome.SimpleScan"; } { float = true; })
        (windowRule { title = ''\s+Rename\s+\".*\"\s+''; } { float = true; })
        (windowRule { title = "Extension: (Zotero Connector) - Zotero Item Selector — Mozilla Firefox"; } {
          float = true;
        })
        (windowRule { class = "kitty_info"; } { float = true; })
        (windowRule { class = ".*blueman-manager-wrapped.*"; } { float = true; })
        (windowRule {
          class = "thunderbird";
          initial_title = "Calendar Reminders";
        } { float = true; })
        (windowRule {
          class = "thunderbird";
          title = "An error has occurred";
        } { float = true; })
        (windowRule {
          class = "thunderbird";
          title = "Alert";
        } { float = true; })
        (windowRule {
          class = "thunderbird";
          title = "Check Spelling";
        } { float = true; })
        (windowRule { title = "SVG Input"; } { float = true; })

        # Inkscape: float everything, but keep the main window tiled
        (windowRule { class = "org.inkscape.Inkscape"; } { float = true; })
        (windowRule { title = ''^(.*?\s+-\s+Inkscape)$''; } { tile = true; })
        (windowRule { title = "Extensions"; } { float = true; })

        (windowRule { title = "Password Required - Betterbird"; } { float = true; })
        (windowRule { title = "Progress"; } { float = true; })
        (windowRule { title = "Plugins Manager"; } { float = true; })
        (windowRule { class = "org.gnome.font-viewer"; } { float = true; })
        (windowRule { class = "latexclip"; } { float = true; })
        (windowRule { title = " png bitmap image import"; } { float = true; })
        (windowRule { title = "^Password Required - Mozilla Firefox$"; } { float = true; })
        (windowRule { title = "EPS Input"; } { float = true; })
        (windowRule { class = "evince"; } { float = true; })
        (windowRule { class = "org.pipewire.Helvum"; } { float = true; })
        (windowRule { class = "com.github.wwmm.easyeffects"; } { float = true; })
        (windowRule { class = "org.rncbc.qpwgraph"; } { float = true; })
        (windowRule { title = "File Operation Progress"; } { float = true; })
        (windowRule { class = "swayimg"; } { float = true; })
        (windowRule { title = "KeePassXC - Passkey credentials"; } { float = true; })
        (windowRule { class = "org.telegram.desktop$"; } { float = true; })
        (windowRule { class = "yubico.org.ykman-gui$"; } { float = true; })
        (windowRule { title = ".+[Pp]references$"; } { float = true; })
        (windowRule { title = "[Pp]roperties$"; } { float = true; })
        (windowRule { title = "Extract$"; } { float = true; })
        (windowRule { title = "File Roller$"; } { float = true; })
        (windowRule { title = "nwg-look"; } { float = true; })
        (windowRule { class = "^timeshift-gtk$"; } { float = true; })
        (windowRule { class = "(wps)"; } { tile = true; })
        (windowRule { class = "(dev.warp.Warp)"; } { tile = true; })
        (windowRule { class = "^([Pp]avucontrol)"; } { float = true; })

        # Sizes
        (windowRule { class = "evince"; } { size = "980 890"; })
        (windowRule { class = "swayimg"; } { size = "800 800"; })

        # Opacities
        (windowRule { class = "obsidian"; } { opacity = "0.9 0.8"; })
        (windowRule { class = "^(firefox)$"; } { opacity = "0.9 0.8"; })
        (windowRule { class = "thunar"; } { opacity = "0.9 0.8"; })
        (windowRule { class = "^(foot)$"; } { opacity = "0.8 0.7"; })
        (windowRule { class = "^(kitty)$"; } { opacity = "0.7 0.7"; })
        (windowRule { class = "^(com.mitchellh.ghostty)$"; } { opacity = "0.8 0.6"; })
        (windowRule { class = "^([Dd]iscord)"; } { opacity = "0.7 0.6"; })
        (windowRule { class = "^([Cc]ode)"; } { opacity = "0.95 0.8"; })
        (windowRule { class = "^([Nn]emo)"; } { opacity = "0.9 0.8"; })
        (windowRule { title = "^Extract$"; } { opacity = "0.9 0.7"; })
        (windowRule { title = "^Authenticate$"; } { opacity = "0.9 0.7"; })
        (windowRule { class = "^([Pp]avucontrol)"; } { opacity = "0.9 0.9"; })

        # Workspace assignment
        (windowRule { class = "^(firefox)$"; } { workspace = "2"; })
        (windowRule { class = "^org.keepassxc.KeePassXC$"; } { workspace = "10"; })

        # Dialogs
        (windowRule { title = "^(Open File)(.*)$"; } { float = true; })
        (windowRule { title = "^(Select a File)(.*)$"; } { float = true; })
        (windowRule { title = "^(Choose wallpaper)(.*)$"; } { float = true; })
        (windowRule { title = "^(Open Folder)(.*)$"; } { float = true; })
        (windowRule { title = "^(Save As)(.*)$"; } { float = true; })
        (windowRule { title = "^(Library)(.*)$"; } { float = true; })
      ];

      layer_rule = [
        (layerRule ".*" { xray = true; })

        # No animations
        (layerRule "walker" { no_anim = true; })
        (layerRule "selection" { no_anim = true; })
        (layerRule "overview" { no_anim = true; })
        (layerRule "anyrun" { no_anim = true; })
        (layerRule "sideleft" { no_anim = true; })
        (layerRule "sideright" { no_anim = true; })
        (layerRule "indicator.*" { no_anim = true; })
        (layerRule "osk" { no_anim = true; })
        (layerRule "noanim" { no_anim = true; })

        # Generic layer-shell
        (layerRule "gtk-layer-shell" { blur = true; })
        (layerRule "gtk-layer-shell" { ignore_alpha = 0; })
        (layerRule "launcher" { blur = true; })
        (layerRule "launcher" { ignore_alpha = 0.5; })
        (layerRule "notifications" { blur = true; })
        (layerRule "notifications" { ignore_alpha = 0.69; })

        # AGS
        (layerRule "session" { blur = true; })
        (layerRule "bar" { blur = true; })
        (layerRule "bar" { ignore_alpha = 0.6; })
        (layerRule "corner.*" { blur = true; })
        (layerRule "corner.*" { ignore_alpha = 0.6; })
        (layerRule "dock" { blur = true; })
        (layerRule "dock" { ignore_alpha = 0.6; })
        (layerRule "indicator.*" { blur = true; })
        (layerRule "indicator.*" { ignore_alpha = 0.6; })
        (layerRule "overview" { blur = true; })
        (layerRule "overview" { ignore_alpha = 0.6; })
        (layerRule "cheatsheet" { blur = true; })
        (layerRule "cheatsheet" { ignore_alpha = 0.6; })
        (layerRule "sideright" { blur = true; })
        (layerRule "sideright" { ignore_alpha = 0.6; })
        (layerRule "sideleft" { blur = true; })
        (layerRule "sideleft" { ignore_alpha = 0.6; })
        (layerRule "indicator*" { blur = true; })
        (layerRule "indicator*" { ignore_alpha = 0.6; })
        (layerRule "osk" { blur = true; })
        (layerRule "osk" { ignore_alpha = 0.6; })
      ];
    };

    # hyprbars registers its button API only when the plugin is loaded.
    extraConfig = ''
      if hl.plugin.hyprbars then
        hl.config({
          plugin = {
            hyprbars = {
              bar_text_font = "Rubik, Geist, AR One Sans, Reddit Sans, Inter, Roboto, Ubuntu, Noto Sans, sans-serif",
              bar_height = 30,
              bar_padding = 10,
              bar_button_padding = 5,
              bar_precedence_over_border = true,
              bar_part_of_window = true,
              bar_color = "rgba(120F11FF)",
              col = {
                text = "rgba(eae0e4FF)",
              },
            },
          },
        })
        hl.plugin.hyprbars.add_button({
          bg_color = "rgb(eae0e4)",
          size = 13,
          icon = "󰖭",
          action = "hyprctl dispatch killactive",
        })
        hl.plugin.hyprbars.add_button({
          bg_color = "rgb(eae0e4)",
          size = 13,
          icon = "󰖯",
          action = "hyprctl dispatch fullscreen 1",
        })
        hl.plugin.hyprbars.add_button({
          bg_color = "rgb(eae0e4)",
          size = 13,
          icon = "󰖰",
          action = "hyprctl dispatch movetoworkspacesilent special",
        })
      end
    '';
  };
}
