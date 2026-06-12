{ cfg, ... }:
{
  programs.regreet = {
    enable = true;
    # TODO: remove "-D" (debug) after ensuring everything works correctly
    cageArgs = [
      "-s"
      "-d"
      "-m"
      "last"
      "-D"
    ];
    settings = {
      skip_selection = false;

      background = {
        # FIXME: seems the "greeter" user can't read files in /home/kein/
        path = "${cfg.userhome}/Pictures/Wallpapers/rocket.png";

        # fit = "Contain";  # stylix
      };

      # env = {
      #   # ENV_VARIABLE = "value";
      # };

      GTK = {
        application_prefer_dark_theme = true;
      };

      commands = {
        reboot = [
          "systemctl"
          "reboot"
        ];

        poweroff = [
          "systemctl"
          "poweroff"
        ];

        x11_prefix = [
          "startx"
          "/usr/bin/env"
        ];
      };

      appearance = {
        greeting_msg = "Welcome back!";
      };

      "widget.clock" = {
        format = "%a %H:%M";

        resolution = "500ms";

        label_width = 150;
      };
    };
  };
}
