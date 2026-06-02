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
    ../../universal/home-modules/home.nix
    ../../universal/home-modules/shell.nix
    ../../universal/home-modules/fix-python-history.nix
    ./home-modules
    ../../options/home-manager/zotero
    ../../options/home-manager/better-code
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
      extraConfig = {
        SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
        WALLPAPERS = "${config.xdg.userDirs.pictures}/Wallpapers";
      };
    };
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

        file-roller
        xdot
        graphviz
        wf-recorder

        nix-tree
        wev
        slurp
        grim
        grimblast

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
        inkscape
        # -with-extensions
        # inkscape-extensions.textext

        zoom-us
        qrencode
        libnotify

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
      # "GLFW_IM_MODULE, ibus"

      # For apps to prevent spamming home directory with .trash
      SONARLINT_USER_HOME = "${config.xdg.dataHome}/sonarlint";
      DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      NPM_CONFIG_TMP = "${runtimeDir}/npm";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      ELECTRUMDIR = "${config.xdg.dataHome}/electrum";
      # export TEXMFVAR="${root}/.texmf-var"
            # export TEXMFCONFIG="${root}/.texmf-config"
      TEXMFCACHE = "${config.xdg.cacheHome}/texmf-var";
      TEXMFVAR = "${config.xdg.cacheHome}/texmf-var";
      TEXMFCONFIG = "${config.xdg.configHome}/texmf-config";
      TEXMFHOME = "${config.xdg.dataHome}/texmf";
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
  };

  programs = {
    npm.settings = {
      prefix = "${config.xdg.cacheHome}/npm";
    };
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
    gradle.home = ".local/share/gradle";
    # texlive = {
    #   enable = true;
    #   packageSet = pkgs.;
    # };
  };
}
