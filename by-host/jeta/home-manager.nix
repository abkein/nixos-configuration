{
  config,
  pkgs,
  ipkgs,
  cfg,
  ...
}:
let
  runtimeDir = "/run/user/1000";
in
{
  imports = [
    ../../universal/home-modules/shell.nix
    ../../universal/home-modules/fix-python-history.nix
    ./home-modules
    ../../hm-modules/zotero
    ../../hm-modules/better-code
  ];

  age = {
    identityPaths = [ "${config.home.homeDirectory}/Documents/private/actual_age.key" ];
    secrets = {
      "syncthingPass" = {
        file = ../../${cfg.secrets}/syncthingPass.age;
      };
    };
    # ageBin = "PATH=$PATH:${lib.makeBinPath [ pkgs.age-plugin-yubikey ]} ${pkgs.age}/bin/age";
    secretsDir = "${runtimeDir}/agenix";
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    # portal = {
    #   enable = true;
    #   # xdgOpenUsePortal = true;  # breaks Github authentication in vscode
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal
    #     # pkgs.xdg-desktop-portal-gtk  # auto by hyprland
    #     # pkgs.xdg-desktop-portal-hyprland  # auto by hyprland
    #   ];
    # };
    mime = {
      enable = true;
    };
    autostart = {
      enable = true;
      readOnly = true;
      # entries = [ ];
    };
    terminal-exec = {
      enable = true;
      settings = {
        # GNOME = [
        #   "org.gnome.Terminal.desktop"
        #   "com.raggesilver.BlackBox.desktop"
        # ];
        default = [ "ghostty.desktop" ];
      };
    };
  };

  home = {
    username = cfg.username;
    homeDirectory = cfg.userhome;
    enableNixpkgsReleaseCheck = false;
    preferXdgDirectories = true;
    stateVersion = "24.11";
    packages =
      (with ipkgs; [ ayugram-desktop ])
      ++ (with pkgs; [
        ocrmypdf
        thunderbird-latest
        imagemagickBig
        poppler-utils
        texlive.combined.scheme-full
        ghostscript
        backintime-common
        backintime-qt
        tesseract
        #chatbox
        chromium
        element-desktop
        tor-browser
        # quickemu
        adwaita-qt
        adwaita-qt6
        libsForQt5.qt5ct
        kdePackages.qt6ct
        file-roller
        xdot
        graphviz
        swappy
        wf-recorder

        nix-tree
        wev
        slurp
        grim
        grimblast

        networkmanager_dmenu
        networkmanagerapplet
        qpwgraph

        # text
        xed-editor
        obsidian
        prettier
        # aider-chat

        libreoffice-fresh
        # crow-translate

        (hunspell.withDicts (
          d: with d; [
            ru-ru
            en-us-large
          ]
        ))

        baobab
        bleachbit

        # security
        gpgme
        gpgme.dev

        # image/audio/video
        vlc
        gimp
        swayimg
        inkscape
        # -with-extensions
        # inkscape-extensions.textext

        zoom-us
        qrencode
        libnotify

        tor-browser
        veusz

        ffmpeg-full

        electrum

        (python3.withPackages (
          ps: with ps; [
            bash-kernel
            ipython
            ipykernel
            isort
            numpy
            pandas
            scipy
            requests
            matplotlib

            plotext
          ]
        ))
      ]);
    sessionVariables = {
      # QT_QPA_PLATFORMTHEME = "qt6ct";
      # QT_STYLE_OVERRIDE = "";
      # SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
      NIXOS_OZONE_WL = "1";
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      # For apps to prevent spamming home directory with .trash
      SONARLINT_USER_HOME = "${config.xdg.dataHome}/sonarlint";

      DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      NPM_CONFIG_TMP = "${runtimeDir}/npm";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      ELECTRUMDIR = "${config.xdg.dataHome}/electrum";
    };
  };

  systemd.user.tmpfiles.rules = [
    "d ${config.programs.gpg.homedir} 0700 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/.ssh 0700 ${config.home.username} users - -"
  ];

  services = {
    # blueman-applet.enable = true;
    ssh-agent.enable = true;
    kdeconnect = {
      enable = true;
      # indicator = true;
    };
    cliphist = {
      enable = true;
      allowImages = true;
    };
  };

  programs = {
    keepassxc = {
      enable = true;
      autostart = true;
    };
    codex = {
      enable = true;
      package = ipkgs.codex-cli;
    };
    claude-code = {
      enable = true;
      package = ipkgs.claude-code;
      configDir = "${config.xdg.configHome}/claude";
    };
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      installBatSyntax = true;
      settings = {
        font-size = 10;
        term = "xterm";
        clipboard-trim-trailing-spaces = true;
      };
    };
    java.enable = true;

    git = {
      signing = {
        signByDefault = true;
        key = "17027FA2CDE289D5D1613C3994A84F22E630CA42";
        format = "openpgp";
      };
    };
    git-credential-oauth = {
      enable = false;
    };
    mcp = {
      enable = true;
      servers = {
        # Start the MCP client with GITHUB_PERSONAL_ACCESS_TOKEN set.
        github = {
          command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
          args = [ "stdio" ];
        };
        nixos = {
          command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
          args = [ ];
        };
      };
    };
    # anyrun = {
    #   enable = true;
    #   config = {
    #     x = { fraction = 0.5; };
    #     y = { fraction = 0.3; };
    #     width = { fraction = 0.3; };
    #     hideIcons = false;
    #     ignoreExclusiveZones = false;
    #     layer = "overlay";
    #     hidePluginInfo = false;
    #     closeOnClick = false;
    #     showResultsImmediately = false;
    #     maxEntries = null;
    #     plugins = with anyrun-pkgs; [
    #       # An array of all the plugins you want, which either can be paths to the .so files, or their packages
    #       applications  #
    #       dictionary    # :def
    #       shell         # :sh
    #       rink
    #       symbols
    #       websearch     # ?
    #     ];
    #   };
    #   extraConfigFiles =
    #   {
    #     "applications.ron".text = ''
    #       Config(
    #         // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
    #         desktop_actions: true,

    #         max_entries: 50,

    #         // A command to preprocess the command from the desktop file. The commands should take arguments in this order:
    #         // command_name <term|no-term> <command>
    #         // preprocess_exec_script: Some("/home/user/.local/share/anyrun/preprocess_application_command.sh")

    #         // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
    #         // to determine what terminal to use.
    #         terminal: Some(Terminal(
    #           // The main terminal command
    #           command: "kitty",
    #           // What arguments should be passed to the terminal process to run the command correctly
    #           // {} is replaced with the command in the desktop entry
    #           args: "--hold --app-id="kitty_quick" {}",
    #         )),
    #       )
    #     '';
    #   };
    # };
    fuzzel = {
      enable = true;
      settings = {
        main = {
          show-actions = true;
          terminal = "${pkgs.ghostty}/bin/ghostty";
          keyboard-focus = "on-demand"; # exclusive
          auto-select = true;
        };
        colors = {
          background = "282a36fa";
          selection = "3d4474fa";
          border = "fffffffa";
        };

        border = {
          radius = 20;
        };
      };
    };
    swappy = {
      enable = true;
      settings.Default = {
        save_dir = "${config.xdg.userDirs.pictures}/Screenshots";
        save_filename_format = "swappy-%Y%m%d-%H%M%S.png";
        show_panel = false;
        line_size = 5;
        text_size = 20;
        text_font = "sans-serif";
        paint_mode = "brush";
        early_exit = true;
        fill_shape = false;
        auto_save = true;
        custom_color = "rgba(193,125,17,1)";
      };
    };
    gradle.home = ".local/share/gradle";
  };

  gtk =
    let
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
    in
    {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      theme = theme;
      gtk4.theme = theme;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

  qt = {
    enable = true;
    # style = {
    #   name = "adwaita-dark";
    # };
    platformTheme = {
      # name = "gtk3";
      name = "qt6ct";
    };
  };
}
