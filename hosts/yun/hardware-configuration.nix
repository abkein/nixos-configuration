{ modulesPath, ... }:

{
  imports = [
    # (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "vmw_pvscsi"
      "sd_mod"
      "sr_mod"
    ];

    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
  };
}
