{
  config,
  lib,
  pkgs,
  cfg,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./system-modules
  ];

  age = {
    identityPaths = [ "/root/keys/actual_age_root.key" ];
    secrets = {
      "nix-access-tokens.conf" = {
        file = ../../${cfg.secrets}/nix-access-tokens.conf.age;
      };
      "nix-netrc" = {
        file = ../../${cfg.secrets}/nix-netrc.age;
      };
    };
    ageBin = "PATH=$PATH:${lib.makeBinPath [ pkgs.age-plugin-yubikey ]} ${pkgs.age}/bin/age";
  };

  time.timeZone = "Europe/Helsinki";

  services = {
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };
  };

  nix =
    let
      secrets = config.age.secrets;
    in
    {
      channel.enable = false;
      gc = {
        automatic = true;
        dates = "weekly";
        persistent = true;
        randomizedDelaySec = "1m";
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        netrc-file = secrets."nix-netrc".path;
        builders-use-substitutes = true;
        connect-timeout = 5;
        download-attempts = 2;
        stalled-download-timeout = 15; # instead of 300
      };
      extraOptions = ''
        !include ${secrets."nix-access-tokens.conf".path}
      '';
    };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    curl
    gitFull
    wget
    age
    age-plugin-yubikey
    git-agecrypt
  ];

  users.users = {
    kein = {
      uid = 1000;
      isNormalUser = true;
      description = "C2H5OH";
      createHome = true;
      hashedPassword = "$y$j9T$g95Qjm6uFhDpwt19Mc81D0$Et9NONGjndR21I5qopLLE2X/dqs6Ut4Hxw/VzI6GU24";
      extraGroups = [
        # "networkmanager"
        "wheel"
        "input"
        # "scanner"
        # "lp"
      ];
      # packages = with pkgs; [ ];
      # shell = pkgs.zsh;
      home = "/home/kein";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJF5/M+hRBcahbnuGK+iHB0obByeYzJxsKKRHpO7gxXP"
      ];
    };
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJF5/M+hRBcahbnuGK+iHB0obByeYzJxsKKRHpO7gxXP"
      ];
    };
  };

  system.stateVersion = "25.11";
}
