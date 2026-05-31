{
  config,
  pkgs,
  cfg,
  ...
}:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  programs = {
    zsh.enable = true;
    traceroute.enable = true;
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

  environment.systemPackages = with pkgs; [
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

  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "1m";
    };
    settings = {
      netrc-file = config.age.secrets."nix-netrc".path;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # http2 = false;
      builders-use-substitutes = true;
      connect-timeout = 5;
      download-attempts = 2;
      stalled-download-timeout = 15; # instead of 300
    };
    extraOptions = ''
      !include ${config.age.secrets."nix-access-tokens.conf".path}
    '';
  };
}
