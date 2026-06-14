{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types optionals;
  cfg = config.programs.tuigreet;

  stateDir = "/var/cache/tuigreet";
  logDir = "/var/log/tuigreet";
  sessionsDir = "${config.services.displayManager.sessionData.desktops}/share";

  mkKVList = attrs: lib.mapAttrsToList (k: v: lib.optional (v != null) "${k}=${v}") attrs;

  theme = builtins.concatStringsSep ";" (lib.flatten (mkKVList cfg.theme));

  ifN = s: v: lib.optionals (v != null) ((lib.optional (s != null) s) ++ [ v ]);

  args =
    (lib.flatten (map (elem: [ "--env" ] ++ elem) (mkKVList cfg.env)))
    ++ (with cfg.debug; optionals enable ([ "--debug" ] ++ (ifN null file)))
    ++ (optionals cfg.session.enable (
      (ifN "--sessions" "${sessionsDir}/wayland-sessions")
      ++ (ifN "--session-wrapper" cfg.session.wrapper)
    ))
    ++ (optionals cfg.xsession.enable (
      (ifN "--xsessions" "${sessionsDir}/xsessions")
      ++ (optionals (!cfg.xsession.wrap) "--no-xsession-wrapper")
      ++ (optionals cfg.xsession.wrap (ifN "--xsession-wrapper" cfg.xsession.wrapper))
    ))
    ++ (ifN "--cmd" cfg.command)
    ++ (ifN "--width" cfg.width)
    ++ (ifN "--greeting" cfg.greeting)
    ++ (ifN "--greet-align" cfg.align)
    ++ (ifN "--kb-power" cfg.kb.power)
    ++ (ifN "--kb-command" cfg.kb.command)
    ++ (ifN "--kb-sessions" cfg.kb.sessions)
    ++ (ifN "--time-format" cfg.time.format)
    ++ (ifN "--power-reboot" cfg.power.reboot)
    ++ (ifN "--power-shutdown" cfg.power.shutdown)
    ++ (ifN "--asterisks-char" cfg.asterisks.char)
    ++ (ifN "--window-padding" cfg.padding.window)
    ++ (ifN "--prompt-padding" cfg.padding.prompt)
    ++ (ifN "--container-padding" cfg.padding.container)
    ++ (ifN "--user-menu-min-uid" cfg.userMenu.minUID)
    ++ (ifN "--user-menu-max-uid" cfg.userMenu.maxUID)
    ++ (ifN "--theme" (if (theme != "") then theme else null))
    ++ (lib.optional cfg.issue "--issue")
    ++ (lib.optional cfg.time.enable "--time")
    ++ (lib.optional cfg.userMenu.enable "--user-menu")
    ++ (lib.optional cfg.asterisks.enable "--asterisks")
    ++ (lib.optional cfg.power.noSetSid "--power-no-setsid")
    ++ (lib.optional (cfg.remember != null) "--remember")
    ++ (lib.optional (cfg.remember == "user+session") "--remember-session")
    ++ (lib.optional (cfg.remember == "session/user") "--remember-user-session");

  finalArgs = lib.escapeShellArgs args;
in
{
  options.programs.tuigreet = {
    enable = lib.mkEnableOption "tuigreet as a greetd greeter";

    package = lib.mkPackageOption pkgs "tuigreet" { };

    session = {
      enable = mkOption {
        type = types.bool;
        default = config.services.displayManager.enable;
        example = false;
        description = "Whether to use session files for non-X11 sessions.";
      };

      wrapper = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = lib.literalExpression ''
          ''${pkgs.dbus}/bin/dbus-run-session
        '';
        description = "Wapper command to initialize the non-X11 sessions.";
      };
    };

    xsession = {
      enable = mkOption {
        type = types.bool;
        default = with config.services; xserver.enable && displayManager.enable;
        example = false;
        description = "Whether to use session files for X11 sessions.";
      };

      wrap = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Whether to wrap commands for X11 sessions.";
      };

      wrapper = mkOption {
        type = types.nullOr types.str;
        default = config.services.displayManager.sessionData.wrapper;
        example = lib.literalExpression ''
          ''${pkgs.sx}/bin/startx /usr/bin/env
        '';
        description = ''
          Wrapper command to initialize X server and launch X11 sessions.
          tuigreet defaults to use `startx /usr/bin/env` if unset.
        '';
      };
    };

    debug = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to enable debug logging.";
      };

      file = mkOption {
        type = types.path;
        default = "${logDir}/tuigreet.log";
        example = "/var/log/tuigreet/tuigreet.log";
        description = "File to log into.";
      };
    };

    env = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Environment variables to run the default session with";
      example = lib.literalExpression ''
        {
          XDG_SESSION_TYPE="wayland";
        }
      '';
    };

    command = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to run";
      example = lib.literalExpression ''
        ''${pkgs.sway}/bin/sway
      '';
    };

    width = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 120;
      description = "Width of the main prompt. tuigreet's default will be used if unset.";
    };

    issue = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Whether to show the host's issue file";
    };

    greeting = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "Access is restricted to authorized personnel only.";
      description = "Show custom text above login prompt";
    };

    time = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to display the current date and time.";
      };

      format = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "";
        description = "Custom strftime format for displaying date and time.";
      };
    };

    remember = mkOption {
      type = types.nullOr (
        types.enum [
          "user"
          "user+session"
          "session/user"
        ]
      );
      default = null;
      example = "user+session";
      description = ''
        Whether to remember parameters of the last login:
        `user` — remember only the last logged-in user.
        `user+session` — remember last logged-in user and its session.
        `session/user` — remember last session for each user.
        Nothing is remembered if unset.
      '';
    };

    userMenu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to allow graphical selection of users from a menu.";
      };

      minUID = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 1000;
        description = "Minimum UID to display in the user selection menu.";
      };

      maxUID = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 1005;
        description = "Maximum UID to display in the user selection menu.";
      };
    };

    asterisks = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to display asterisks when a secret is typed.";
      };

      char = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "#";
        description = "Characters to be used to redact secrets. `*` will be used if unset.";
      };
    };

    padding = {
      window = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 10;
        description = "Padding inside the terminal area. Defaults to 0 if unset.";
      };

      container = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 10;
        description = "Padding inside the main prompt container. Defaults to 1 if unset.";
      };

      prompt = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 10;
        description = "Padding between prompt rows. Defaults to 1 if unset.";
      };
    };

    align = mkOption {
      type = types.nullOr (
        types.enum [
          "left"
          "center"
          "right"
        ]
      );
      default = null;
      example = "left";
      description = ''
        Alignment of the greeting text in the main prompt container.
        Defaults to `center` if unset.
      '';
    };

    power = {
      shutdown = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = lib.literalExpression ''
          ''${pkgs.systemd}/bin/poweroff
        '';
        description = "Command to run to shut down the system.";
      };

      reboot = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = lib.literalExpression ''
          ''${pkgs.systemd}/bin/reboot
        '';
        description = "Command to run to reboot the system.";
      };

      noSetSid = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Do not prefix power commands with setsid.";
      };
    };

    kb = {
      command = mkOption {
        type = types.nullOr (types.numbers.between 1 12);
        default = null;
        example = 1;
        description = "F-key to use to open the command menu.";
      };

      sessions = mkOption {
        type = types.nullOr (types.numbers.between 1 12);
        default = null;
        example = 2;
        description = "F-key to use to open the session menu.";
      };

      power = mkOption {
        type = types.nullOr (types.numbers.between 1 12);
        default = null;
        example = 3;
        description = "F-key to use to open the power menu.";
      };
    };

    theme = {
      text = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color to be used for base text color.
          Must be a valid ANSI color name.
        '';
      };
      time = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color of the date and time. If unspecified, falls back to `text`.
          Must be a valid ANSI color name.
        '';
      };
      container = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Background color for the centered containers used throughout the app.
          Must be a valid ANSI color name.
        '';
      };
      border = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color of the borders of containers.
          Must be a valid ANSI color name.
        '';
      };
      title = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color of the containers' titles. If unspecified, falls back to `border`.
          Must be a valid ANSI color name.
        '';
      };
      greet = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color of the issue of greeting message. If unspecified, falls back to `text`.
          Must be a valid ANSI color name.
        '';
      };
      prompt = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color of the prompt ("Username:", etc.).
          Must be a valid ANSI color name.
        '';
      };
      input = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color of user input feedback.
          Must be a valid ANSI color name.
        '';
      };
      action = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color of the actions displayed at the bottom of the screen.
          Must be a valid ANSI color name.
        '';
      };
      button = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "green";
        description = ''
          Color of the keybindings for actions. If unspecified, falls back to `action`.
          Must be a valid ANSI color name.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session.command = "${cfg.package}/bin/tuigreet ${finalArgs}";
    };

    environment.systemPackages = [ cfg.package ];

    systemd.tmpfiles.settings."10-tuigreet" =
      let
        userName = config.services.greetd.settings.default_session.user;
        defaultConfig = {
          user = userName;
          group = config.users.users.${userName}.group;
          mode = "0755";
        };
      in
      {
        ${stateDir}.d = defaultConfig;
        ${logDir}.d = defaultConfig;
      };
  };
}
