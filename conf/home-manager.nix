{ config, pkgs, inputs, ... }:
let
  ayugram-desktop = inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop;
  anyrun-pkgs = inputs.anyrun.packages.${pkgs.system};
in
{
  imports = [
    #./home-modules/vscode/vscode.nix
    ./home-modules/vscode/better-code.nix
    ./home-modules/vscode/workspaces.nix
    ./home-modules/gnupg.nix
    ./home-modules/syncthing.nix
    ./home-modules/dolphin.nix
    ./home-modules/firefox.nix
    # ./home-modules/thunderbird.nix
    ./home-modules/dot-config-files.nix
    ./home-modules/files.nix
    ./shadow/ssh.nix
  ];

  age = {
    identityPaths = [ "/home/kein/nixos-configuration/conf/secrets/keys/yubikey-identity.pub" ];
    secrets = {
      "syncthingPass" = {
        file = ./secrets/agenix/encrypted/syncthingPass.age;
      };
    };
    # ageBin = "PATH=$PATH:${lib.makeBinPath [ pkgs.age-plugin-yubikey ]} ${pkgs.age}/bin/age";
    secretsDir = "/run/user/1000/agenix";
  };

  wayland.windowManager.hyprland = import ./home-modules/hypr/hyprland.nix;

  xdg =
  {
    enable = true;
    # defaults:
    # cacheHome = "~/.cache";  # $XDG_CACHE_HOME
    # configHome = "~/.config";  # $XDG_CONFIG_HOME
    # dataHome = "~/.local/share";  # $XDG_DATA_HOME
    # stateHome = "~/.local/state";  # $XDG_STATE_HOME

    userDirs = {
      enable = true;
      createDirectories = true;
    };

    portal = {
      enable = true;
      # xdgOpenUsePortal = true;  # breaks Github authentication in vscode
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    # configFile = import ./home-modules/configFiles.nix;
  };

  home = {
    username = "kein";
    homeDirectory = "/home/kein";
    stateVersion = "24.11";
    packages = with pkgs; [
      ayugram-desktop
      ocrmypdf
      thunderbird-latest
      imagemagickBig
      poppler_utils
      # texliveFull
      texlive.combined.scheme-full
      tex-fmt
      ghostscript
      python312Packages.plotext
      backintime-common
      backintime-qt
      tesseract
      #chatbox
      chromium
      #cinny-desktop  # depends on vulnerable libsoup
      fractal
      vesktop
      pstree
      hyprpicker
      hyprsunset
      hyprsysteminfo
      hyprland-qt-support
      fastfetch
      speedtest-cli
      ooniprobe-cli
      iperf
      tor-browser
      quickemu
      adwaita-qt
      adwaita-qt6
      libsForQt5.qt5ct
      kdePackages.qt6ct
      file-roller
      xdot
      graphviz
      swappy
      wf-recorder
      jq

      remmina

      nix-tree
      dunst
      cliphist
      wev
      slurp
      grim
      grimblast
      waybar

      kitty
      networkmanager_dmenu
      networkmanagerapplet
      qpwgraph
      zotero

      # text
      nixfmt-rfc-style
      nixd
      nil
      # nixfmt
      libreoffice-fresh
      xed-editor
      obsidian
      aider-chat

      # security
      keepassxc
      gpgme
      gpgme.dev

      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk

      # image/audio/video
      vlc
      gimp
      swayimg
      inkscape-with-extensions
      inkscape-extensions.textext

      zoom-us
      qrencode
      libnotify

      tor-browser
      zip
      unzip
      veusz

      ffmpeg-full

      # unstable.gemini-cli
      # ugemini-cli
      # claude-code
    ];
    # file = import ./home-modules/files.nix;
    sessionVariables = {
      # QT_QPA_PLATFORMTHEME = "qt6ct";
      # QT_STYLE_OVERRIDE = "";
      # SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      # For apps to prevent spamming home directory with .trash
      SONARLINT_USER_HOME = "${config.xdg.dataHome}/sonarlint";
      JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
      IPYTHONDIR = "${config.xdg.configHome}/ipython";
      DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
    };
  };

  systemd.user.tmpfiles.rules = [
    "d ${config.programs.gpg.homedir} 0700 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/.ssh 0700 ${config.home.username} users - -"
  ];

  services = {
    # blueman-applet.enable = true;
    ssh-agent.enable = true;
    dunst = {
      enable = true;
      configFile = "${config.xdg.configHome}/dunst/dunstrc";
      settings = import ./home-modules/dunst.nix;
    };
    hyprpolkitagent.enable = true;
    hyprpaper = import ./home-modules/hypr/hyprpaper.nix;
    hypridle = import ./home-modules/hypr/hypridle.nix;
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
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
    direnv = {
      enable = true;
      silent = false;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      git = true;
      icons = "always";
    };
    hyprlock = import ./home-modules/hypr/hyprlock.nix;
    bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historyFile = "${config.xdg.stateHome}/bash/history";
      historySize = 999999;
    };
    zsh = import ./home-modules/zsh.nix config;
    waybar = import ./home-modules/waybar.nix;
    wofi = import ./home-modules/wofi.nix;
    java.enable = true;

    git = {
      enable = true;
      userName = "abkein";
      userEmail = "rickbatra0z@gmail.com";
      signing = {
        signByDefault = true;
        key = "17027FA2CDE289D5D1613C3994A84F22E630CA42";
        format = "openpgp";
      };
    };
    git-credential-oauth = { enable = false; };
    anyrun = {
      enable = true;
      config = {
        x = { fraction = 0.5; };
        y = { fraction = 0.3; };
        width = { fraction = 0.3; };
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
        plugins = with anyrun-pkgs; [
          # An array of all the plugins you want, which either can be paths to the .so files, or their packages
          applications  #
          dictionary    # :def
          shell         # :sh
          rink
          symbols
          websearch     # ?
        ];
      };
      extraConfigFiles =
      {
        "applications.ron".text = ''
          Config(
            // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
            desktop_actions: true,

            max_entries: 50,

            // A command to preprocess the command from the desktop file. The commands should take arguments in this order:
            // command_name <term|no-term> <command>
            // preprocess_exec_script: Some("/home/user/.local/share/anyrun/preprocess_application_command.sh")

            // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
            // to determine what terminal to use.
            terminal: Some(Terminal(
              // The main terminal command
              command: "kitty",
              // What arguments should be passed to the terminal process to run the command correctly
              // {} is replaced with the command in the desktop entry
              args: "--hold --app-id="kitty_quick" {}",
            )),
          )
        '';
      };
    };
    # texlive = {
    #   enable = true;
    #   package = pkgs.texlive.combine pkgs.texlive.combined.scheme-full;
    #   packageSet = pkgs.texlive.combined;
    # };
    gradle.home = ".local/share/gradle";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
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
