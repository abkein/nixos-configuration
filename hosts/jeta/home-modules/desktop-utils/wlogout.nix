{ ... }: {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        action = "hyprshutdown --post-cmd 'poweroff'";
        keybind = "s";
        label = "shutdown";
        text = "Shutdown";
      }
      {
        action = "hyprshutdown --post-cmd 'reboot'";
        keybind = "r";
        label = "reboot";
        text = "reboot";
      }
      {
        action = "systemctl suspend";
        # keybind = "";
        label = "sleep";
        text = "sleep";
      }
      {
        action = "loginctl lock-session";
        keybind = "l";
        label = "lock";
        text = "lock";
      }
      {
        action = "hyprshutdown";
        # keybind = "";
        label = "logout";
        text = "logout";
      }
    ];
  };
}
