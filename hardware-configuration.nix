{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-modules/pstate.nix
    ./hardware-modules/zenpower.nix
    ./hardware-modules/redmibook-wmi.nix
    ./hardware-modules/acpi-patch.nix
    # ./hardware-modules/amdgpu-patch.nix
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
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernel.sysctl."kernel.sysrq" = 1;
  };

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-uuid/d990af03-81ac-4527-bcba-81a575ffc5ce";
  #     fsType = "ext4";
  #   };

  #   "/boot" = {
  #     device = "/dev/disk/by-uuid/6F70-6DF3";
  #     fsType = "vfat";
  #     options = [
  #       "fmask=0077"
  #       "dmask=0077"
  #     ];
  #   };
  # };

  # swapDevices = [ { device = "/dev/disk/by-uuid/94513675-0e3a-4fc6-95f5-b28663fe1aa9"; } ];
  # boot.resumeDevice = "/dev/disk/by-uuid/94513675-0e3a-4fc6-95f5-b28663fe1aa9";
  systemd = {
    # sleep.extraConfig = ''
    #   HibernateDelaySec=1h
    #   SuspendState=mem
    # '';

    oomd = {
      enable = true;
      enableUserSlices = true;
      enableSystemSlice = true;
      enableRootSlice = false;
    };

    slices = {
      "-".sliceConfig = {
        ManagedOOMSwap = "kill";
      };

      "user".sliceConfig = {
        ManagedOOMMemoryPressureLimit = "50%";
        ManagedOOMMemoryPressureDurationSec = "10s";
      };
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
