{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  boot.loader.grub = {
    # With an EF02 BIOS boot partition, disko adds the disk automatically.
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  networking.hostName = "yun";
  networking.useDHCP = false;
  networking.interfaces.ens192.ipv4.addresses = [
    {
      address = "194.124.210.24";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = {
    address = "194.124.210.1";
    interface = "ens192";
  };
  time.timeZone = "Europe/Helsinki";
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.initialPassword = "root";
  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJF5/M+hRBcahbnuGK+iHB0obByeYzJxsKKRHpO7gxXP"
  ];

  system.stateVersion = "25.11";
}
