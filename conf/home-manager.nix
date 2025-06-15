{ config, pkgs, lib, inputs, ... }@args:
let
  declare_workspace = { name, folder, settings, prerun ? "", postrun ? "", preinit ? true }: rec {
    configFile.${name} = {
      enable = true;
      executable = false;
      force = true;
      target = "vscode_workspaces/${name}.code-workspace";
      text = builtins.toJSON {
        folders = [{ path = folder; }];
        settings = settings;
      };
    };
    desktopEntries."CodeWSpaceSelector".actions.${name} =
    let
      init_cmd = "nix-shell ${folder}/shell.nix --command \"exit\"";
      init_wrap_cmd = "kitty --app-id=\"kitty_info\" ${init_cmd}";
      prefix = if (prerun == "") then (if preinit then "${init_wrap_cmd} &&" else "") else "${prerun} && ";
      postfix = if (postrun == "") then "" else " && ${postrun}";
      codecmd = "${pkgs.vscode-fhs}/bin/code --password-store=gnome-libsecret --ozone-platform=wayland ${config.xdg.configHome}/${configFile.${name}.target}";
      cmd = "${prefix}${codecmd}${postfix}";
    in
    {
      name = "${name}";
      exec = "bash -c \"${cmd}\"";
    };
  };
  nixai = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/olafkfreund/nix-ai-help.git";
    ref = "main";
  } + "/package.nix") {};
in {
  imports = [

  ];

  wayland.windowManager.hyprland = import ./home-modules/hyprland.nix;

  xdg = lib.mkMerge [
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

      desktopEntries."CodeWSpaceSelector" = {
        name = "Space Selector";
        genericName = "Visual Studio Workspace Selector";
        exec = ''
          hyprctl notify 2 3000 0 "fontsize:35 CodeWSpaceSelector does nothing itself, select an action"'';
        icon = "vscode";
        type = "Application";
        categories = [ "Development" "IDE" "TextTools" ];
        actions = { };
      };
    }
    (declare_workspace {
      name = "configuration";
      folder = "${config.home.homeDirectory}/nixos-configuration";
      settings = { "nixEnvSelector.suggestion" = false; };
      preinit = false;
    })
    (declare_workspace {
      name = "lmptest";
      folder = "${config.home.homeDirectory}/Documents/nucleation/lmptest";
      settings = {
        "nixEnvSelector.suggestion" = false;
        "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
      };
    })
    (declare_workspace {
      name = "Quicknotebook";
      folder = "${config.xdg.dataHome}/quicknotebook";
      settings = {
        "nixEnvSelector.suggestion" = false;
        "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
      };
      # prerun = "${config.home.homeDirectory}/execs/quicknotebook_wrapper.sh";
      prerun = "kitty --app-id=\"kitty_info\" ${config.home.homeDirectory}/execs/quicknotebook.sh";
      preinit = false;
    })
    (declare_workspace {
      name = "lmp";
      folder = "${config.home.homeDirectory}/Documents/nucleation/lmp";
      settings = {
        "licenser.license" = "MIT";
        "nixEnvSelector.suggestion" = false;
        "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
      };
    })
    (declare_workspace {
      name = "magdiss";
      folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/";
      settings = {
        "nixEnvSelector.suggestion" = false;
        "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
      };
    })
    (declare_workspace {
      name = "magdiss-pres";
      folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/presentation/";
      settings = {
        "nixEnvSelector.suggestion" = false;
        "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
      };
    })
    (declare_workspace {
      name = "LAMMPS";
      folder = "${config.home.homeDirectory}/repos/mylammps";
      settings = {
        "nixEnvSelector.suggestion" = false;
        "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
      };
    })
  ];

  home = {
    username = "kein";
    homeDirectory = "/home/kein";
    stateVersion = "24.11";
    packages = with pkgs; [
      inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
      element-desktop
      thunderbird-latest
      imagemagickBig
      poppler_utils
      texliveFull
      tex-fmt
      python312Packages.plotext
      backintime-common
      backintime-qt
      tesseract
      chatbox
      chromium
      nixai
    ];
    file = import ./home-modules/files.nix;
    sessionVariables = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };

  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/.gnupg 0700 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/.ssh 0700 ${config.home.username} users - -"
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.keys/sops-nix.txt";
    # It's also possible to use a ssh key, but only when it has no password:
    #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
    defaultSopsFile = ./secrets/sops-nix/secrets.yaml.enc;
    # secrets.test = {
    #   # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

    #   # %r gets replaced with a runtime directory, use %% to specify a '%'
    #   # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
    #   # DARWIN_USER_TEMP_DIR) on darwin.
    #   path = "%r/test.txt";
    # };
    secrets = {
      example-secret = { };
    };
  };

  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableSshSupport = true;
      grabKeyboardAndMouse = true;
      pinentry = {
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
    bash.enable = true;
    vscode = import ./home-modules/vscode.nix {
      pkgs = pkgs;
      lib = lib;
    };
    zsh = import ./home-modules/zsh.nix { inherit config; };
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
    gpg.enable = true;
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
        plugins = [
          # An array of all the plugins you want, which either can be paths to the .so files, or their packages
          inputs.anyrun.packages.${pkgs.system}.applications
          inputs.anyrun.packages.${pkgs.system}.dictionary
          inputs.anyrun.packages.${pkgs.system}.shell
          inputs.anyrun.packages.${pkgs.system}.rink
          inputs.anyrun.packages.${pkgs.system}.symbols
          inputs.anyrun.packages.${pkgs.system}.websearch
        ];
      };
    };
    # texlive = {
    #   enable = true;
    #   package = pkgs.texlive.combine pkgs.texlive.combined.scheme-full;
    #   packageSet = pkgs.texlive.combined;
    # };
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
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
    };
    platformTheme = {
      name = "gtk3";
    };
  };
}
