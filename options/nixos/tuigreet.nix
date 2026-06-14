{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types optionals;
  cfg = config.programs.tuigreet;

  theme = builtins.concatStringsSep ";" (
    lib.flatten (
      lib.mapAttrsToList (
        name: value: lib.optional (value != null) "${name}=${value}"
      ) cfg.theme
    )
  );

  sessionsDir = "${config.services.displayManager.sessionData.desktops}/share";

  ifNotNull = flag: value: optionals (value != null) [ flag value ];
  ifTrue = flag: value: optionals value [ flag ];
  # (lib.flatten (
  #   lib.mapAttrsToList (name: value: [ "--env" "${name}=${value}" ]) cfg.env
  # ))
  args =
    (optionals cfg.debug.enable (
      [ "--debug" ]
      ++ (optionals (cfg.debug.file != null) [ cfg.debug.file ])
    ))
    ++ (optionals cfg.session.enable (
      [ "--sessions" "${sessionsDir}/wayland-sessions" ]
      ++ (ifNotNull "--session-wrapper" cfg.session.wrapper)
    ))
    ++ (optionals cfg.xsession.enable (
      [ "--xsessions" "${sessionsDir}/xsessions" ]
      ++ (
        if (!cfg.xsession.wrap) then
          [ "--no-xsession-wrapper" ]
        else
          ifNotNull "--xsession-wrapper" cfg.xsession.wrapper
      )
    ))
    ++ (ifNotNull "--cmd" cfg.command)
    ++ (ifNotNull "--width" cfg.width)
    ++ (ifNotNull "--greeting" cfg.greeting)
    ++ (ifNotNull "--time-format" cfg.time.format)
    ++ (ifNotNull "--user-menu-min-uid" cfg.userMenu.minUID)
    ++ (ifNotNull "--user-menu-max-uid" cfg.userMenu.maxUID)
    ++ (ifNotNull "--asterisks-char" cfg.asterisks.char)
    ++ (ifNotNull "--window-padding" cfg.padding.window)
    ++ (ifNotNull "--container-padding" cfg.padding.container)
    ++ (ifNotNull "--prompt-padding" cfg.padding.prompt)
    ++ (ifNotNull "--greet-align" cfg.align)
    ++ (ifNotNull "--power-shutdown" cfg.power.shutdown)
    ++ (ifNotNull "--power-reboot" cfg.power.reboot)
    ++ (ifNotNull "--kb-command" cfg.kb.command)
    ++ (ifNotNull "--kb-sessions" cfg.kb.sessions)
    ++ (ifNotNull "--kb-power" cfg.kb.power)
    ++ (ifTrue "--issue" cfg.issue)
    ++ (ifTrue "--time" cfg.time.enable)
    ++ (ifTrue "--remember" cfg.remember.user)
    ++ (ifTrue "--remember-session" cfg.remember.session)
    ++ (ifTrue "--remember-user-session" cfg.remember.userSession)
    ++ (ifTrue "--user-menu" cfg.userMenu.enable)
    ++ (ifTrue "--asterisks" cfg.asterisks.enable)
    ++ (ifTrue "--power-no-setsid" cfg.power.noSetSid)
    ++ (optionals (theme != "") ["--theme" theme]);

  finalArgs = lib.escapeShellArgs args;

  stateDir = "/var/cache/tuigreet";
  logDir = "/var/log/tuigreet";
in
{
  options.programs.tuigreet = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable tuigreet as your greeter.
        Homepage: https://github.com/apognu/tuigreet
      '';
    };

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

    # env = mkOption {
    #   type = types.attrsOf types.str;
    #   default = { };
    #   description = "Environment variables to run the default session with";
    #   example = lib.literalExpression ''
    #     {
    #       XDG_SESSION_TYPE="wayland";
    #     }
    #   '';
    # };

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

    remember = {
      user = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to remember last logged-in username.";
      };

      session = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to remember last selected session.";
      };

      userSession = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to  remember last selected session for each user.";
      };
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
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet ${finalArgs}";
    };

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
