_:
let
  lst = [
    1
    2
    3
    10
  ];
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      # enableInspect = true;
    };
    settings = {
      mainBar = {
        height = 30;
        spacing = 4;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "systemd-failed-units"
          "privacy"
          "idle_inhibitor"
          "wireplumber"
          "wireplumber#source"
          "network#wlan"
          "network#eth"
          "bluetooth"
          "power-profiles-daemon"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "keyboard-state"
          "hyprland/language"
          "battery"
          "clock"
          "tray"
        ];
        "hyprland/workspaces" = {
          all-outputs = true;
          active-only = false;
          on-click = "activate";
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

          persistent-workspaces = {
            eDP-1 = lst;
            DP-6 = lst;
            DP-9 = lst;
          };
        };
        keyboard-state = {
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          # "icon-size"= 21;
          spacing = 10;
          show-passive-items = true;
        };
        clock = {
          timezone = "Europe/Moscow";
          format = "{:%H:%M}  ";
          format-alt = "{:%A, %B %d, %Y (%R)}  ";
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
          tooltip = true;
        };
        memory = {
          format = "{percentage}%  {swapPercentage}%";
          tooltip = true;
          tooltip-format = "RAM: {used:0.1f}/{total:0.1f} GiB\nSwap: {swapUsed:0.1f}/{swapTotal:0.1f} GiB";
        };
        temperature = {
          # "thermal-zone"= 2,
          # "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input",
          warning-threshold = 60;
          critical-threshold = 80;
          # "format-critical"= "{temperatureC}°C {icon}",
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        backlight = {
          # "device"= "acpi_video1",
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
            min-length = 3;
            on-click = "blueman-manager";
            on-click-middle = "blueman-adapters";
            on-click-right = "blueman-services";
            format = "󰂯 {status}";
            format-no-controller = " {status}";
            format-disabled = " 󰂲";
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
            tooltip-format-disabled = "${about_controller}\nDisabled";
            tooltip-format-off = "${about_controller}\nOFF";
            tooltip-format-on = "${about_controller}\nNot connected";
            tooltip-format-connected = "${about_controller}\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-connected-battery = "${about_controller}\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "${about_device}";
            tooltip-format-enumerate-connected-battery = "${about_device}\t{device_battery_percentage}%";
          };
        battery = {
          states = {
            full = 95;
            warning = 30;
            critical = 15;
          };
          full-at = 95;
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon}󱐋";
          format-unknown = "{capacity}% {icon} ";
          format-plugged = "{capacity}% {icon} ";
          format-alt = "{time} {icon}";
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
            on-charging-full = "notify-send -u normal 'Battery Full!'";
          };
          tooltip = true;
          tooltip-format = "{time} to {timeTo}\nPower draw: {power}\nCycles: {cycles}\nHealth: {health}";
          tooltip-format-plugged = "{timeTo}\nPower draw: {power}\nCycles: {cycles}\nHealth: {health}";
          bat = "BATT";
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
          ];
        };
        "network#wlan" = {
          interface = "wlan*";
          format-wifi = "{essid} ({frequency} GHz, {signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰈁 {bandwidthUpBytes} vs {bandwidthDownBytes}";
          tooltip-format = "{ifname} via {gwaddr} \n{bandwidthUpBytes} vs {bandwidthDownBytes}";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ipaddr}/{cidr} {bandwidthUpBytes} vs {bandwidthDownBytes}";
          format-disabled = "";
        };
        "network#eth" = {
          interface = "eth*";
          format-wifi = "{essid} ({frequency} GHz, {signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰈁 {bandwidthUpBytes} vs {bandwidthDownBytes}";
          tooltip-format = "{ifname} via {gwaddr} 󰈁";
          format-linked = "{ifname} (No IP) 󰈁";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ipaddr}/{cidr} {bandwidthUpBytes} vs {bandwidthDownBytes}";
          format-disabled = "󰈂";
        };
        systemd-failed-units = {
          hide-on-ok = false;
          format = "{nr_failed_system}s ✗ {nr_failed_user}u";
          format-ok = "✓";
          system = true;
          user = true;
        };
        pulseaudio = {
          scroll-step = 1;
          format = "{volume}% {icon}   {format_source}";
          format-bluetooth = "{volume}% {icon}󰂯 {format_source}";
          format-bluetooth-muted = "󰖁 {icon}󰂯 {format_source}";
          format-muted = "󰖁 {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            phone-muted = "";
            portable = "";
            portable-muted = "";
            car = "";
            hdmi = "󰡁";
            default = [
              ""
              ""
              ""
            ];
            speaker = [
              ""
              ""
              ""
            ];

          };
          on-click = "pavucontrol";
        };
        wireplumber = {
          only-physical = true;
          scroll-step = 1;
          node-type = "Audio/Sink";
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}󰂯";
          format-bluetooth-muted = "󰖁 {icon}󰂯";
          format-muted = "󰖁";
          tooltip = true;
          tooltip-format = "Sink: {node_name}";
          format-icons = {
            headphone = "";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            phone-muted = "";
            portable = "";
            portable-muted = "";
            car = "";
            hdmi = "󰡁";
            default = [
              ""
              ""
              ""
            ];
            speaker = [
              ""
              ""
              ""
            ];

          };
          on-click = "qpwgraph";
        };
        "wireplumber#source" = {
          only-physical = true;
          scroll-step = 1;
          node-type = "Audio/Source";
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}󰂯";
          format-bluetooth-muted = " {icon}󰂯";
          format-muted = "";
          # format-source = "{source_volume}% ";
          # format-source-muted = "";
          tooltip = true;
          tooltip-format = "Source: {node_name}";
          format-icons = {
            headphone = "";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            phone-muted = "";
            portable = "";
            portable-muted = "";
            car = "";
            hdmi = "󰡁";
            default = [
              ""
              ""
              ""
            ];
            speaker = [
              ""
              ""
              ""
            ];

          };
          on-click = "qpwgraph";
        };
      };
      #     style =
      #     ''
      # #workspaces {
      #     margin-right: 8px;
      #     border-radius: 10px;
      #     transition: none;
      #     background: #383c4a;
      # }

      # #workspaces button {
      #     transition: none;
      #     color: #7c818c;
      #     background: transparent;
      #     padding: 5px;
      #     font-size: 18px;
      # }

      # #workspaces button.persistent {
      #     color: #7c818c;
      #     font-size: 12px;
      # }

      # /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      # #workspaces button:hover {
      #     transition: none;
      #     box-shadow: inherit;
      #     text-shadow: inherit;
      #     border-radius: inherit;
      #     color: #383c4a;
      #     background: #7c818c;
      # }

      # #workspaces button.active {
      #     background: #4e5263;
      #     color: white;
      #     border-radius: inherit;
      # }
      #     '';
    };
  };
}
