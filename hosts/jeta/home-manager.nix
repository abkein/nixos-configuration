{
  config,
  pkgs,
  ipkgs,
  cfg,
  ...
}:
let
  kdeconnectAutostartMask = pkgs.writeTextFile {
    name = "org.kde.kdeconnect.daemon.desktop";
    destination = "/share/applications/org.kde.kdeconnect.daemon.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=KDE Connect
      Hidden=true
    '';
  };
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
    secretsDir = "${cfg.xdg.runtimeDir}/agenix";
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
      entries = [ "${kdeconnectAutostartMask}/share/applications/org.kde.kdeconnect.daemon.desktop" ];
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

  dconf.settings."org/blueman/general".plugin-list = [
    "!GameControllerWakelock"
    "!PPPSupport"
    "!DhcpClient"
  ];

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
        # backintime-common
        # backintime-qt
        tesseract
        #chatbox
        chromium # configurable
        element-desktop # configurable
        tor-browser

        file-roller
        xdot
        graphviz

        nix-tree

        qpwgraph

        nixpkgs-review

        # text
        xed-editor
        obsidian # configurable
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

        # image/audio/video
        vlc
        gimp
        inkscape
        # -with-extensions
        # inkscape-extensions.textext

        zoom-us

        gucharmap
        networkmanagerapplet

        ipfetch
        cpufetch
        ramfetch

        qrencode
        libnotify

        p7zip # 7z

        veusz

        ffmpeg-full

        electrum

        papers

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
  };

  systemd.user.tmpfiles.rules = [
    "d ${config.programs.gpg.homedir} 0700 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/.ssh 0700 ${config.home.username} users - -"
  ];

  services = {
    ssh-agent.enable = true;
    kdeconnect = {
      enable = true;
      # indicator = true;
    };
  };

  programs = {
    codex = {
      enable = true;
      package = ipkgs.codex-cli;
    };
    # claude-code = {
    #   enable = true;
    #   package = ipkgs.claude-code;
    #   configDir = "${config.xdg.configHome}/claude";
    # };
    gh = {
      enable = true;
      hosts = {
        "github.com" = {
          user = "abkein";
        };
      };
      settings.git_protocol = "ssh";
    };
    git = {
      signing = {
        signByDefault = true;
        key = "17027FA2CDE289D5D1613C3994A84F22E630CA42";
        format = "openpgp";
      };
    };
    mcp = {
      enable = true;
      servers = {
        github = {
          command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
          args = [ "stdio" ];
        };
        # nixos = {
        #   command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        #   args = [ ];
        # };
      };
    };
    # texlive = {
    #   enable = true;
    #   packageSet = pkgs.;
    # };
    # java.enable = true;
    npm.settings = {
      prefix = "${config.xdg.cacheHome}/npm";
    };
    gradle.home = ".local/share/gradle";
  };
}
