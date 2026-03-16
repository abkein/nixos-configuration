{
  modulesPath,
  lib,
  pkgs,
  ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../shadow/xray_yun.nix
  ];
  boot.loader.grub = {
    # With an EF02 BIOS boot partition, disko adds the disk automatically.
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  networking = {
    hostName = "yun";
    useDHCP = false;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    interfaces.ens192 = {
      ipv6.addresses = [
        {
          address = "2a0d:6c2:24:8125::";
          prefixLength = 47;
        }
      ];
      ipv4.addresses = [
        {
          address = "194.124.210.24";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "194.124.210.1";
      interface = "ens192";
    };
    defaultGateway6 = {
      address = "2a0d:6c2:24::1";
      interface = "ens192";
    };
    nftables = {
      enable = true;
    };
    firewall = {
      enable = true;
    };
  };
  time.timeZone = "Europe/Helsinki";

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
    };
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };
    resolved.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
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
