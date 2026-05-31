{ pkgs, cfg, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./system-modules
    ../../universal/system-modules/core.nix
    ../../universal/system-modules/zram.nix
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
  };

  time.timeZone = "Europe/Helsinki";

  # environment.systemPackages = with pkgs; [
  # ];

  users.users = {
    ${cfg.username} = {
      uid = 1000;
      isNormalUser = true;
      description = "C2H5OH";
      createHome = true;
      hashedPassword = "$y$j9T$g95Qjm6uFhDpwt19Mc81D0$Et9NONGjndR21I5qopLLE2X/dqs6Ut4Hxw/VzI6GU24";
      extraGroups = [
        "wheel"
        "input"
      ];
      # packages = with pkgs; [ ];
      shell = pkgs.zsh;
      home = cfg.userhome;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJF5/M+hRBcahbnuGK+iHB0obByeYzJxsKKRHpO7gxXP"
      ];
    };
  };

  # programs = {
  # };

  system.stateVersion = "25.11";
}
