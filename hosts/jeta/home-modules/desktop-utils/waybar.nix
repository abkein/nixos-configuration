{ ... }:
let
  lst = [
    1
    2
    3
    10
  ];
in
{
  stylix.targets.waybar.enable = false;
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      # enableInspect = true;
    };
    settings = {
      right = {
        name = "waybar-right";
        position = "right";
        width = 27;
        spacing = 0;
        modules-right = [
          "idle_inhibitor"
          "power-profiles-daemon"
          "group/group-power"
          "tray"
        ];
        idle_inhibitor = {
          # format = "{icon}\n{timeleft}";
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          timeout = 30;
          justify = "center";
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile= {profile}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
        "group/group-power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            children-class = "not-power";
            transition-left-to-right = false;
          };
          modules = [
            "custom/lock" # First element is the "group leader" and won't ever be hidden
            "custom/power"
            "custom/reboot"
            "custom/quit"
            "custom/suspend"
          ];
        };
        "custom/lock" = {
          format = "󰍁";
          tooltip = true;
          tooltip-format = "Lock";
          on-click = "loginctl lock-session";
        };
        "custom/suspend" = {
          format = "󰒲";
          tooltip = true;
          tooltip-format = "Suspend";
          on-click = "loginctl lock-session && systemctl suspend";
        };
        "custom/power" = {
          format = "⏻";
          tooltip = true;
          tooltip-format = "Shutdown";
          on-click = "hyprshutdown --post-cmd 'systemctl shutdown'";
        };
        "custom/reboot" = {
          format = "󰜉";
          tooltip = true;
          tooltip-format = "Reboot";
          on-click = "hyprshutdown --post-cmd 'systemctl reboot'";
        };
        "custom/quit" = {
          format = "󰗼";
          tooltip = true;
          tooltip-format = "Quit";
          on-click = "hyprshutdown"; # "hyprctl dispatch exit";
        };
        tray = {
          spacing = 20;
          show-passive-items = true;
        };
      };
      top = {
        name = "waybar-top";
        position = "top";
        height = 20;
        spacing = 0;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        # modules-center = [ "hyprland/window" ];
        modules-right = [
          "systemd-failed-units"
          "privacy"
          "wireplumber#sink"
          "wireplumber#source"
          "bluetooth"
          "network#wlan"
          "network#eth"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "hyprland/language"
          "keyboard-state"
          "battery"
          "clock"
        ];
        "hyprland/language" = {
          format = "{shortDescription}";
          # format-en = "EN";
          # format-ru = "RU";
          tooltip = true;
          tooltip-format = "{long}\n{shortDescription}-{short}-{variant}";
          keyboard-name = "at-translated-set-2-keyboard";
          on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
          on-click-right = "hyprctl switchxkblayout at-translated-set-2-keyboard prev";
        };
        "hyprland/workspaces" = {
          all-outputs = true;
          active-only = false;
          enable-bar-scroll = true;
          on-scroll-up = ''hyprctl dispatch "hl.dsp.focus({ workspace = 'r-1' })"'';
          on-scroll-down = ''hyprctl dispatch "hl.dsp.focus({ workspace = 'r+1' })"'';
          # on-click = "activate"; # doesn't work anymore
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "active" = "";
            # "default" = "";
          };

          tooltip = true;
          tooltips = {
            default = "{name}: {windows}";
            empty = "empty";
          };

          persistent-workspaces = {
            eDP-1 = lst;
            DP-6 = lst;
            DP-9 = lst;
          };
        };
        keyboard-state = {
          capslock = true;
          format = "{icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        clock = {
          timezone = "Europe/Moscow";
          format = "{:%H:%M} ";
          format-alt = "{:%A, %B %d, %Y (%R)} ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        cpu = {
          format = "{usage}%  {max_frequency} GHz";
          states = {
            high = 80;
            medium = 50;
            low = 15;
          };
          tooltip-format = "{icon0}{icon2}{icon4}{icon6}{icon8}{icon10}{icon12}{icon14}";
          format-icons = [
            "<span color='#69ff94'>▁</span>" # green
            "<span color='#2aa9ff'>▂</span>" # blue
            "<span color='#f8f8f2'>▃</span>" # white
            "<span color='#f8f8f2'>▄</span>" # white
            "<span color='#ffffa5'>▅</span>" # yellow
            "<span color='#ffffa5'>▆</span>" # yellow
            "<span color='#ff9977'>▇</span>" # orange
            "<span color='#dd532e'>█</span>" # red
          ];
          # "format-icons" = [
          #   "🁣" "🁤" "🁥" "🁦" "🁧" "🁨" "🁩"
          #   "🁪" "🁫" "🁬" "🁭" "🁮" "🁯" "🁰"
          #   "🁱" "🁲" "🁳" "🁴" "🁵" "🁶" "🁷"
          #   "🁸" "🁹" "🁺" "🁻" "🁼" "🁽" "🁾"
          #   "🁿" "🂀" "🂁" "🂂" "🂃" "🂄" "🂅"
          #   "🂆" "🂇" "🂈" "🂉" "🂊" "🂋" "🂌"
          #   "🂍" "🂎" "🂏" "🂐" "🂑" "🂒" "🂓" "🁢"
          # ];
          on-click = "ghostty -e btop";
        };
        memory = {
          format = "{percentage}% {icon} {swapPercentage}%"; # ""
          states = {
            high = 80;
            medium = 50;
            low = 15;
          };
          tooltip-format = "RAM: {used:0.1f}/{total:0.1f} GiB\nSwap: {swapUsed:0.1f}/{swapTotal:0.1f} GiB";
          format-icons = [
            "<span color='#69ff94'>▁</span>" # green
            "<span color='#2aa9ff'>▂</span>" # blue
            "<span color='#f8f8f2'>▃</span>" # white
            "<span color='#f8f8f2'>▄</span>" # white
            "<span color='#ffffa5'>▅</span>" # yellow
            "<span color='#ffffa5'>▆</span>" # yellow
            "<span color='#ff9977'>▇</span>" # orange
            "<span color='#dd532e'>█</span>" # red
          ];
        };
        temperature = {
          # "thermal-zone"= 2,
          # "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input",
          warning-threshold = 60;
          critical-threshold = 80;
          # format-critical = "{temperatureC}°C {icon} ";
          # format-warning = "{temperatureC}°C {icon} ";
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        backlight = {
          reverse-scrolling = true;
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        bluetooth =
          let
            about_controller = "State: {status}\n{controller_alias}\t{controller_address_type}\t{controller_address}";
            about_device = "{device_alias}\t{device_address_type}\t{device_address}";
          in
          {
            controller = "hci0";
            controller-alias = "jeta";
            # min-length = 3;
            on-click = "blueman-manager";
            on-click-middle = "blueman-adapters";
            on-click-right = "blueman-services";
            format = "󰂯 {status}";
            format-no-controller = " {status}";
            format-disabled = "󰂲";
            format-off = "󰂲";
            format-on = "󰂯";
            format-connected = "󰂱 {device_alias}";
            format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}% {icon}";
            format-icons = [
              "󰤾"
              "󰤿"
              "󰥀"
              "󰥁"
              "󰥂"
              "󰥃"
              "󰥄"
              "󰥅"
              "󰥆"
              "󰥈"
            ];
            tooltip-format = "${about_controller}\n{num_connections} connected";
            tooltip-format-disabled = "Disabled\n${about_controller}";
            tooltip-format-off = "OFF\n${about_controller}";
            tooltip-format-on = "Not connected\n${about_controller}";
            tooltip-format-connected = "${about_controller}\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-connected-battery = "${about_controller}\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "${about_device}";
            tooltip-format-enumerate-connected-battery = "${about_device}\t{device_battery_percentage}%";
          };
        battery = {
          states = {
            ok = 90;
            warning = 30;
            critical = 15;
          };
          full-at = 95;
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon}󱐋";
          format-unknown = "{capacity}% {icon} ";
          format-plugged = "{capacity}% {icon} ";
          format-ok = "{capacity}% {icon} ";
          format-full = "{capacity}% {icon} 󰓎";
          format-alt = "{timeTo} {icon}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          events = {
            on-discharging-warning = "notify-send -u normal 'Low Battery'";
            on-discharging-critical = "notify-send -u critical 'Very Low Battery'";
            on-discharging = "notify-send -u normal 'Discharging now...'";
            on-charging = "notify-send -u normal 'Charging now...'";
            on-charging-full = "notify-send -u normal 'Battery Full!'";
          };
          tooltip = true;
          tooltip-format = "{timeTo}\nPower draw: {power}\nCycles: {cycles}\nHealth: {health}";
          tooltip-format-plugged = "{timeTo}\nPower draw: {power}\nCycles: {cycles}\nHealth: {health}";
          bat = "BATT";
        };
        privacy = {
          icon-spacing = 4;
          icon-size = 18;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-out";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "location";
              icon = "location-services-active-symbolic";
            }
          ];
        };
        "network#wlan" =
          let
            fmt = "{essid} {frequency} GHz {icon} {signalStrength}%";
          in
          {
            interface = "wlan*";
            format-alt = "↑{bandwidthUpBits} {icon} ↓{bandwidthDownBits} ";
            format = fmt;
            format-wifi = fmt;
            format-linked = "{icon} (No IP)";
            format-disconnected = "󰤫 Disconnected";
            format-disabled = "󰤮"; # ""
            format-icons = {
              default = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
              linked = [
                "󰤫"
                "󰤠"
                "󰤣"
                "󰤦"
                "󰤩"
              ];
              disconnected = "󰤫";
              disabled = "󰤮";
            };
            tooltip-format-disconnected = "{ifname} is disconnected";
            tooltip-format-disabled = "{ifname} is down";
            tooltip-format = "{ifname} via {gwaddr}\nIP: {ipaddr}/{cidr}\nTotal: {bandwidthTotalBits}\nUp: {bandwidthUpBits}\nDown: {bandwidthDownBits}\n-------\n{essid} {frequency} GHz {icon}\nSignal: {signalStrength}% ({signaldBm} dBm)\n{signalStrengthApp}\nBSSID: {bssid}";
          };
        "network#eth" =
          let
            fmt = "󰈁 {ipaddr}/{cidr}";
          in
          {
            interface = "eth*";
            format-alt = "↑{bandwidthUpBits} 󰈁 ↓{bandwidthDownBits}";
            format = fmt;
            format-ethernet = fmt;
            format-linked = "󰈁 (No IP)";
            format-disconnected = "󰈂";
            tooltip-format-disconnected = "{ifname} is disconnected";
            tooltip-format = "{ifname} via {gwaddr}\nIP: {ipaddr}/{cidr}\nTotal: {bandwidthTotalBits}\nUp: {bandwidthUpBits}\nDown: {bandwidthDownBits}";
          };
        systemd-failed-units = {
          hide-on-ok = false;
          format = "{nr_failed_system}s ✗ {nr_failed_user}u";
          format-ok = "✓";
          system = true;
          user = true;
        };
        "wireplumber#sink" = {
          only-physical = true;
          reverse-scrolling = true;
          scroll-step = 1;
          node-type = "Audio/Sink";
          format = "󰕾 {volume}% {icon}";
          format-bluetooth = "󰕾 {volume}% {icon}󰂯";
          format-bluetooth-muted = "󰖁 {icon}󰂯";
          format-muted = "󰖁";
          tooltip = true;
          tooltip-format = "Sink: {node_name}";
          format-icons = {
            headphone = "󰋋";
            headphone-muted = "󰟎";
            headphones = "󰋋";
            headphones-muted = "󰟎";
            hands-free = "";
            hands-free-muted = "󰋐";
            headset = "";
            headset-muted = "󰋐";
            phone = "";
            phone-muted = "";
            portable = "";
            portable-muted = "";
            car = "";
            hdmi = "󰡁";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            speaker = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "qpwgraph";
        };
        "wireplumber#source" = {
          only-physical = true;
          reverse-scrolling = true;
          scroll-step = 1;
          node-type = "Audio/Source";
          format = " {volume}% {icon}";
          format-bluetooth = " {volume}% {icon}󰂯";
          format-bluetooth-muted = " {icon}󰂯";
          format-muted = "";
          # format-source = "{source_volume}% ";
          # format-source-muted = "";
          tooltip = true;
          tooltip-format = "Source: {node_name}";
          format-icons = {
            headphone = "󰋋";
            headphone-muted = "󰟎";
            headphones = "󰋋";
            headphones-muted = "󰟎";
            hands-free-muted = "󰋐";
            headset = "";
            headset-muted = "󰋐";
            phone = "";
            phone-muted = "";
            portable = "";
            portable-muted = "";
            car = "";
            hdmi = "󰡁";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            speaker = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-click-right = "qpwgraph";
        };
      };
    };
    style = builtins.readFile ./waybar.css;
  };
}
