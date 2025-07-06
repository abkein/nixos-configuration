{ config, pkgs, lib, inputs, ... }@args:
let
  ayugram-desktop = inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop;
  anyrun-pkgs = inputs.anyrun.packages.${pkgs.system};
in
{
  imports = [
    #./home-modules/vscode/vscode.nix
    ./home-modules/vscode/better-code.nix
    ./home-modules/vscode/workspaces.nix
  ];

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

    configFile = import ./home-modules/configFiles.nix;
  };

  home = {
    username = "kein";
    homeDirectory = "/home/kein";
    stateVersion = "24.11";
    packages = with pkgs; [
      ayugram-desktop
      thunderbird-latest
      imagemagickBig
      poppler_utils
      texliveFull
      tex-fmt
      ghostscript
      python312Packages.plotext
      backintime-common
      backintime-qt
      tesseract
      chatbox
      chromium
      cinny-desktop
      fractal
      vesktop
      htop
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

      remmina
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.konsole

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
      direnv

      # nixfmt-rfc-style
      nixfmt-classic
      libreoffice-fresh
      xed-editor
      obsidian
      aider-chat

      # security
      keepassxc
      onlykey
      yubikey-manager
      yubioath-flutter
      yubikey-personalization

      # image/audio/video
      vlc
      gimp
      inkscape
      swayimg
    ];
    file = import ./home-modules/files.nix;
    sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
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

  # sops = {
  #   # age.keyFile = "${config.home.homeDirectory}/.keys/sops-nix.txt";
  #   # It's also possible to use a ssh key, but only when it has no password:
  #   #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
  #   # defaultSopsFile = ./secrets/sops-nix/syncthing.yaml.enc;
  #   # secrets.test = {
  #   #   # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

  #   #   # %r gets replaced with a runtime directory, use %% to specify a '%'
  #   #   # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
  #   #   # DARWIN_USER_TEMP_DIR) on darwin.
  #   #   path = "%r/test.txt";
  #   # };
  #   secrets = {
  #     syncthing = {
  #       sopsFile = ./secrets/sops-nix/syncthing.yaml.enc;
  #       # example-secret = { };
  #     };
  #   };
  # };

  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableSshSupport = true;
      grabKeyboardAndMouse = true;
      pinentry = {
        # TODO: tweak programs.wayprompt
        # package = pkgs.pinentry-all;
        package = pkgs.wayprompt;
        program = "pinentry-wayprompt";
      };
    };
    dunst = {
      enable = true;
      configFile = "${config.xdg.configHome}/dunst/dunstrc";
      settings = import ./home-modules/dunst.nix;
    };
    hyprpolkitagent.enable = true;
    hyprpaper = import ./home-modules/hypr/hyprpaper.nix;
    hypridle = import ./home-modules/hypr/hypridle.nix;
    # syncthing = {
    #   enable = true;
    #   openDefaultPorts = true;
    #   devices = {
    #     "phone-A63" = { id = "GIABTJN-E7JIDLE-XP7HU37-HDNAVYG-FI4XKTN-ARMJG3J-32WHYTM-ZFP2MQJ"; };
    #   };
    #   folders = {
    #     "Documents" = {
    #       path = "${config.home.homeDirectory}/Documents";
    #       devices = [ "phone-A63" ];
    #     };
    #   };
    #   environment.STNODEFAULTFOLDER = "true";
    # };
  };

  programs = {
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
    firefox = { enable = true; };
    java.enable = true;
    ssh = {
      enable = true;
      # $HOME/execs/keepassxc_ssh_prompt %h %p
      matchBlocks = {
        "fisher" = {
          hostname = "fisher.jiht.ru";
          user = "perevoshchikyy";
          port = 22;
          proxyCommand = "$HOME/execs/keepassxc_ssh_prompt %h %p";
          serverAliveInterval = 1;
        };
        "weasel" = {
          hostname = "89.169.15.114";
          user = "kein";
          port = 22;
          proxyCommand = "$HOME/execs/keepassxc_ssh_prompt %h %p";
          serverAliveInterval = 1;
        };
        "yun" = {
          hostname = "185.250.180.233";
          user = "kein";
          port = 22;
          proxyCommand = "$HOME/execs/keepassxc_ssh_prompt %h %p";
          serverAliveInterval = 1;
        };
      };
    };
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
    git = {
      enable = true;
      userName = "abkein";
      userEmail = "rickbatra0z@gmail.com";
      signing = {
        signByDefault = true;
        key = "1CFA 42F3 97BC 8A6E 2222  BC2E 40AE 43A9 E44D 11FD";
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
    style = {
      name = "adwaita-dark";
    };
    platformTheme = {
      name = "gtk3";
      # name = "qt5ct";
    };
  };
}
