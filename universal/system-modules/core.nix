{
  config,
  pkgs,
  lib,
  cfg,
  ...
}:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  programs = {
    bat.enable = true;
    htop.enable = true;
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    bash = {
      enable = true;
      vteIntegration = true;
      undistractMe = {
        enable = true;
        timeout = 20;
      };
    };
    zsh = {
      enable = true;
      histFile = "$HOME/.local/state/.zsh_history";
      histSize = 9999999;
      vteIntegration = true;
      enableCompletion = true;
      enableBashCompletion = true;
      enableGlobalCompInit = true;
      autosuggestions = {
        enable = true;
        async = true;
        highlightStyle = "fg=magenta";
        strategy = [
          "history"
          "completion"
        ];
      };
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "regexp"
          "cursor"
          "root"
          "line"
        ];
        styles = {
          alias = "fg=green,underline";
          builtin = "fg=blue";
          function = "fg=blue,underline";
          comment = "none";
        };
      };
      ohMyZsh = {
        enable = true;
        cacheDir = "$HOME/.cache/oh-my-zsh";
        plugins = [
          # "git"
          # "sudo"
          # "thefuck" # binary needs to be installed
          "extract"
          "universalarchive"
          "command-not-found"
          "gh"
          "ipfs"
        ];
        theme = "agnoster";
      };
    };
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs = {
        enable = true;
        enablePureSSHTransfer = true;
      };
    };
    nh = {
      enable = true;
      flake = cfg.flakepath;
    };
  };

  services = {
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      inetutils
      nmap
      dig
      openvpn
      wget
      iperf

      speedtest-cli
      ooniprobe-cli

      jq
      pstree
      killall
      file
      hw-probe
      zip
      unzip
      procs
      procfd

      nixfmt
      age
      git-agecrypt

      ripgrep
      ripgrep-all
    ];

    shellAliases = {
      delete-generations = "sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system";
      system-cleaning = "delete-generations && nix store gc && nix store optimise";

      _cat = "${pkgs.coreutils-full}/bin/cat";
      cat = "${config.programs.bat.package}/bin/bat";
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      dud = "du -h -d 1 ";
      grep = "grep --color=auto";
    };

    profiles = lib.mkForce [
      # "$HOME/.nix-profile"
      # "\${XDG_STATE_HOME}/nix/profile"
      "$HOME/.local/state/nix/profile"
      # "/etc/profiles/per-user/$USER"
      # "/nix/var/nix/profiles/default"  # ?????
      "/run/current-system/sw"
    ];
  };

  nix = {
    channel.enable = false;
    optimise = {
      automatic = true;
      dates = "weekly";
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
    settings = {
      auto-allocate-uids = true;
      auto-optimise-store = true;
      netrc-file = config.age.secrets."nix-netrc".path;
      use-xdg-base-directories = true;
      # pure-eval = true;  # breaks certain nix-related programs, that use e.g. nix-env -f <nixpkgs> --nix-path nixpkgs=/path/to/worktree ...
      fallback = true;
      builders-use-substitutes = true;
      always-allow-substitutes = true;
      # http2 = false;
      connect-timeout = 5;
      download-attempts = 2;
      stalled-download-timeout = 15; # instead of 300
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
      ];
    };
    extraOptions = ''
      !include ${config.age.secrets."nix-access-tokens.conf".path}
    '';
  };
}
