let 
  lst = [1 2 3 10];
in
{
  enable = true;
  settings = {
    mainBar = {
      height = 30;
      spacing = 4;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "mpd"
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "power-profiles-daemon"
        "cpu"
        "memory"
        "temperature"
        "backlight"
        "keyboard-state"
        "hyprland/language"
        "battery"
        "battery#bat2"
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
          DP-9 = lst;
          DP-6 = lst;
        };
      };
      keyboard-state = {
        numlock = true;
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
      };
      clock = {
        # "timezone"= "America/New_York",
        tooltip-format = "<big>{=%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{=%Y-%m-%d}";
      };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };
      memory = {
        format = "{}% ";
      };
      temperature = {
        # "thermal-zone"= 2,
        # "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input",
        critical-threshold = 80;
        # "format-critical"= "{temperatureC}°C {icon}",
        format = "{temperatureC}°C {icon}";
        format-icons = [""  ""  ""];
      };
      backlight = {
        # "device"= "acpi_video1",
        format = "{percent}% {icon}";
        format-icons = ["" "" "" "" "" "" "" "" ""];
      };
      battery = {
        states = {
          # "good"= 95,
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-full = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        # "format-good"= "", # An empty format will hide the module
        # "format-full"= "",
        format-icons = ["" "" "" "" ""];
      };
      "battery#bat2"= {
        bat= "BAT2";
      };
      power-profiles-daemon= {
      format = "{icon}";
        tooltip-format = "Power profile= {profile}\nDriver= {driver}";
        tooltip = true;
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };
      network = {
        # "interface"= "wlp2*", # (Optional) To force the use of this interface
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}= {ipaddr}/{cidr}";
      };
      pulseaudio = {
        # "scroll-step"= 1, # %, can be a float
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
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
}
