{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../system-modules
  ];

  time.timeZone = "Europe/Helsinki";

  services = {
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };
  };

  nix = {
    gc = {
      automatic = false;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "1m";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      netrc-file = config.age.secrets."nix-netrc".path;
      builders-use-substitutes = true;
      connect-timeout = 5;
      download-attempts = 2;
      stalled-download-timeout = 15; # instead of 300
    };
    extraOptions = ''
      !include ${config.age.secrets."nix-access-tokens.conf".path}
    '';
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };


  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
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
