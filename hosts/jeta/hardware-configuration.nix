{ pkgs, ... }:

{
  imports = [
    # (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-modules
  ];

  # doesn't quite work
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
    };
    kernelModules = [ "kvm-amd" ];
    kernel.sysctl."kernel.sysrq" = 1;
    extraModprobeConfig = ''
      options mt7921_common disable_clc=1
    '';
  };

  programs = {
    ryzen-monitor-ng.enable = true;
  };

  services = {
    upower = {
      enable = true; # Auto sleep at 5% battery left
      percentageCritical = 7;
      percentageAction = 5;
    };
    ### decided not to use it
    # lact = {
    #   enable = true;
    #   # settings = {};
    # };
    ### interesting, might have to configure
    # acpid = {
    #   # Register commands for events, e.g.
    #   # "button/power.*" "button/lid.*" "ac_adapter.*" "button/mute.*" "button/volumedown.*" "cd/play.*" "cd/next.*"
    #   enable = true;
    #   # logEvents = true;
    # };
    tlp = {
      enable = true;
      settings = {
        TLP_AUTO_SWITCH = 1;
        TLP_DEFAULT_MODE = "BAL";

        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
        RADEON_DPM_PERF_LEVEL_ON_SAV = "low";

        CPU_DRIVER_OPMODE_ON_AC = "active";
        CPU_DRIVER_OPMODE_ON_BAT = "active";
        CPU_DRIVER_OPMODE_ON_SAV = "active";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_SCALING_GOVERNOR_ON_SAV = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_SAV = "power";

        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth nfc wifi wwan";

        DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi wwan";
        DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
        DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";

        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersave";

      };
      pd.enable = true;
    };
  };

  # WirePlumber asks UPower for Bluetooth battery state during session startup.
  # Start it eagerly instead of waiting for DBus activation from a user service.
  systemd.services.upower.wantedBy = [ "multi-user.target" ];

  ### S3 sleep, kind of works with acpi-patch
  # systemd = {
  #   sleep.extraConfig = ''
  #     HibernateDelaySec=1h
  #     SuspendState=mem
  #   '';
  # };

  hardware = {
    amdgpu = {
      # initrd.enable = true;  # looks weird
      opencl.enable = true;
      ### Similar to LACT
      # overdrive = {
      #   enable = true;
      #   # ppfeaturemask = "";  # Default: "0xfffd7fff", example: "0xffffffff".
      # };
    };
    graphics = {
      enable = true; # actually enabled by other modules
      # enable32Bit = true;
      extraPackages = with pkgs; [ mesa.opencl ];
    };
    mcelog.enable = true;
    # enableAllFirmware = true;
    # enableAllHardware = true;
    enableRedistributableFirmware = true;
    cpu.amd = {
      updateMicrocode = true;
      ryzen-smu.enable = true;
    };
  };
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    RUSTICL_FEATURES = "fp64";
  };
}
