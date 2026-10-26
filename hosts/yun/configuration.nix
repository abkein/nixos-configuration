{ cfg, ... }: {
  imports = [
    ../../universal/system-modules/user.nix
    ../../universal/system-modules/core.nix
    ../../universal/system-modules/zram.nix
    ./hardware-configuration.nix
    ./system-modules
  ];

  age = {
    identityPaths = [ "/root/keys/actual_age_root.key" ];
    secrets = {
      "nix-access-tokens.conf" = {
        file = ../../${cfg.secrets}/nix-access-tokens.conf.age;
        owner = cfg.username;
        mode = "0400";
      };
      "nix-netrc" = {
        file = ../../${cfg.secrets}/nix-netrc.age;
        owner = cfg.username;
        mode = "0400";
      };
    };
  };

  time.timeZone = "Europe/Helsinki";

  # environment.systemPackages = with pkgs; [
  # ];

  users.users = {
    ${cfg.username} = {
      hashedPassword = "$y$j9T$g95Qjm6uFhDpwt19Mc81D0$Et9NONGjndR21I5qopLLE2X/dqs6Ut4Hxw/VzI6GU24";
      # packages = with pkgs; [ ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJF5/M+hRBcahbnuGK+iHB0obByeYzJxsKKRHpO7gxXP"
      ];
    };
  };

  # programs = {
  # };

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org?priority=50"
        "https://nix-community.cachix.org?priority=60"
        "https://cache.numtide.com?priority=70"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };

  system.stateVersion = "25.11";
}
