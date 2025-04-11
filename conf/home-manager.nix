{ config, pkgs, lib, inputs, ... }@args:
let
  declare_workspace = { name, folder, settings, }: rec {
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
    desktopEntries."CodeWSpaceSelector".actions.${name} = {
      name = "${name}";
      exec =
        "${pkgs.vscode-fhs}/bin/code --password-store=gnome-libsecret --ozone-platform=wayland ${config.xdg.configHome}/${
          configFile.${name}.target
        }";
    };
  };
  # readSecret = name: builtins.readFile age.secrets.${name}.path;
in {
  imports = [

  ];

  wayland.windowManager.hyprland = import ./confs/hyprland.nix;

  age = let mksec = name: { ${name} = { file = ./secrets/${name}.age; }; };
  in {
    identityPaths = [ "/root/keys/user_key" ];
    secrets = lib.mkMerge [
      { }
      (mksec "ssh_fisher_hostname")
      (mksec "ssh_weasel_hostname")
      (mksec "ssh_yun_hostname")
    ];
  };

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

      configFile = let
        generic = {
          enable = true;
          executable = false;
          force = true;
        };
      in {
        networkmanager_dmenu = generic // {
          source = ./confs/networkmanager_dmenu.ini;
          target = "networkmanager-dmenu/config.ini";
        };
      };

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
      folder = "${config.home.homeDirectory}/nixos-configuration/conf";
      settings = { "nixEnvSelector.suggestion" = false; };
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
      name = "lmp";
      folder = "${config.home.homeDirectory}/Documents/nucleation/lmp";
      settings = {
        "licenser.license" = "MIT";
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
    ];
    file = import ./confs/files.nix;
  };

  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/.gnupg 0700 ${config.home.username} users - -"
  ];

  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableSshSupport = true;
      grabKeyboardAndMouse = true;
      pinentryPackage = pkgs.pinentry-all;
    };
    dunst = {
      enable = true;
      configFile = "${config.xdg.configHome}/dunst/dunstrc";
      settings = import ./confs/dunst.nix;
    };
  };

  programs = {
    bash.enable = true;
    vscode = import ./confs/vscode.nix {
      pkgs = pkgs;
      lib = lib;
    };
    zsh = import ./confs/zsh.nix { inherit config; };
    waybar = import ./confs/waybar.nix;
    wofi = import ./confs/wofi.nix;
    firefox = { enable = true; };
    java.enable = true;
    ssh = {
      enable = true;
      # $HOME/execs/keepassxc_ssh_prompt %h %p
      matchBlocks = {
        "fisher" = {
          hostname = "ssh_fisher_hostname";
          user = "perevoshchikyy";
          port = 22;
          proxyCommand =
            "$HOME/execs/keepassxc_ssh_prompt %${config.age.secrets.ssh_fisher_hostname.path} %p";
        };
        "weasel" = {
          hostname = "ssh_weasel_hostname";
          user = "kein";
          port = 22;
          proxyCommand =
            "$HOME/execs/keepassxc_ssh_prompt %${config.age.secrets.ssh_weasel_hostname.path} %p";
        };
        "yun" = {
          hostname = "ssh_yun_hostname";
          user = "kein";
          port = 22;
          proxyCommand =
            "$HOME/execs/keepassxc_ssh_prompt %${config.age.secrets.ssh_yun_hostname.path} %p";
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
    git-credential-oauth = { enable = true; };
  };
}
