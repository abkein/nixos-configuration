{ config, lib, ... }:
let
regreetCfg = config.programs.regreet;
in
{
  users.users.greeter.home =
    if lib.versionAtLeast regreetCfg.package.version "0.2.0" then
      "/var/lib/regreet"
    else
      "/var/cache/regreet";

  programs.regreet = {
    enable = true;
    cageArgs = [
      "-s"
      "-d"
      "-m"
      "last"
    ];
    settings = {
      skip_selection = false;

      background = {
        path = ../../../../resources/rocket.png;

        # fit = "Contain";  # stylix
      };

      # env = {
      #   # ENV_VARIABLE = "value";
      # };

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
