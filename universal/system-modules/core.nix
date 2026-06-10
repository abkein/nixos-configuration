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
    zsh.enable = true;
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

      nixfmt
      age
      git-agecrypt

      ripgrep
      ripgrep-all
    ];

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
      auto-optimise-store = true;
      netrc-file = config.age.secrets."nix-netrc".path;
      use-xdg-base-directories = true;
      pure-eval = true;
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
      ];
    };
    extraOptions = ''
      !include ${config.age.secrets."nix-access-tokens.conf".path}
    '';
  };
}
