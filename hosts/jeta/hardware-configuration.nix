{ ... }:

{
  imports = [
    # (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-modules
  ];

  # services.udev = {
  #   extraHwdb = ''
  #     # Apply to AT keyboards (internal laptop keyboard via atkbd/i8042)
  #     evdev:atkbd:*
  #      KEYBOARD_KEY_e076=0x1d0  # KEY_FN  # FN key
  #      KEYBOARD_KEY_e072=226    # KEY_MEDIA  # XiaoAI
  #   '';
  #   #  KEYBOARD_KEY_e077=211    # KEY_HP  # WMI KEYS
  #   #  157    # KEY_COMPUTER
  # };

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [
        "dm-snapshot"
        "cryptd"
      ];
      # luks.devices."crypted".device = "/dev/nvme0n1p2";
      luks.devices."crypted".keyFileTimeout = 5;
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernel.sysctl."kernel.sysrq" = 1;
  };

  # systemd = {
  #   sleep.extraConfig = ''
  #     HibernateDelaySec=1h
  #     SuspendState=mem
  #   '';
  # };

  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware = {
    # enableAllFirmware = true;
    # enableAllHardware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };
}
