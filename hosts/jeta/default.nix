# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  lib,
  pkgs,
  cfg,
  ...
}:
{
  imports = [
    ../../universal/system-modules/user.nix
    ./hardware-configuration.nix
    ./system-modules
    ../../universal/system-modules/core.nix
    ../../universal/system-modules/zram.nix
  ];

  age = {
    identityPaths = [
      "/root/keys/actual_age_root.key"
      "${cfg.flakepath}/secrets/keys/yubikey-identity.pub"
    ];
    secrets = {
      "nix-access-tokens.conf" = {
        file = ../../${cfg.secrets}/nix-access-tokens.conf.age;
      };
      "nix-netrc" = {
        file = ../../${cfg.secrets}/nix-netrc.age;
      };
      # "syncthingPass" = {
      #   file = ../../${cfg.secrets}/syncthingPass.age;
      # };
    };
    ageBin = "PATH=$PATH:${lib.makeBinPath [ pkgs.age-plugin-yubikey ]} ${pkgs.age}/bin/age";
  };

  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  # i18n = {
  #   inputMethod = {
  #     enable = true;
  #     enableGtk3 = true;
  #     type = "ibus";
  #     ibus = {
  #       engines = with pkgs.ibus-engines; [
  #         (typing-booster.override {
  #           langs = [
  #             "ru-ru"
  #             "en-us-large"
  #           ];
  #         })
  #       ];
  #       waylandFrontend = true;
  #     };
  #   };
  # };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services = {
    avahi = {
      # For printing, but it's here because it's network-related
      # and putting it in networking module would've been amigious
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      allowInterfaces = [ "eth0" ];
      publish = {
        addresses = true;
        domain = true;
        enable = true;
        hinfo = false;
        userServices = true;
        workstation = true;
      };
    };
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
    # acpid = {
    #   # Register commands for events, e.g.
    #   # "button/power.*" "button/lid.*" "ac_adapter.*" "button/mute.*" "button/volumedown.*" "cd/play.*" "cd/next.*"
    #   enable = true;
    #   # logEvents = true;
    # };
    blueman.enable = true;
    upower.enable = true;
    thermald.enable = true;
    udev = {
      enable = true;
      packages = with pkgs; [
        yubikey-personalization
        # onlykey-cli  # insecure because of ecdsa package
        sane-airscan
      ];
      extraRules = ''
        ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", ENV{ID_MM_DEVICE_IGNORE}="1"
        ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", ENV{MTP_NO_PROBE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", MODE:="0666"
        KERNEL=="ttyACM*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", MODE:="0666"
      '';
    };
    pcscd = {
      enable = true;
      # plugins = [ pkgs.ccid ];
    };
    libinput.enable = true;
    pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber = {
        enable = true;
      };
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };

    dbus = {
      enable = true;
      packages = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };
    gvfs.enable = true;
  };

  programs = {
    yubikey-touch-detector = {
      enable = true;
      # verbose = true;
    };
    # nix-ld = {
    #   enable = true;
    # };
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-volman
        thunar-vcs-plugin
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
    evince.enable = true;
    ssh = {
      startAgent = false;
    };
    gnupg = {
      agent = {
        enable = false;
        pinentryPackage = pkgs.wayprompt;
        enableSSHSupport = false;
        # enableExtraSocket =
        enableBrowserSocket = true;
        # settings
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      "${cfg.username}" = {
        extraGroups = [
          "networkmanager"
          "scanner"
          "lp"
        ];
        # packages = with pkgs; [ ];
      };
    };
  };

  security = {
    virtualisation.flushL1DataCache = "always";
    soteria.enable = true;
    # protectKernelImage = true; # test

    rtkit.enable = true; # At least needed by PipeWire
    polkit.enable = true;
    pam.p11.enable = true;
  };

  systemd = {
    enableStrictShellChecks = true;
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

  environment = {
    systemPackages = with pkgs; [
      clinfo
      vulkan-tools

      p7zip # 7z
      cdrtools # mkisofs

      nix-prefetch
      nix-prefetch-git
      nix-prefetch-github

      nix-output-monitor

      # syncthingtray

      drm_info
      v4l-utils # edid-decode
      rocmPackages.rocminfo

      # utilities
      pinentry-all
      usbutils
      gucharmap

      evtest
      acpi
      acpid
      libinput
      brightnessctl

      age-plugin-yubikey

      # onlykey-rebuilt
      # onlykey
      simple-scan

      pcsc-tools
      pcsclite
      opensc
      # onlykey-cli  # insecure because of ecdsa package
      yubikey-manager
      yubico-piv-tool
      yubioath-flutter
      # yubikey-personalization  # probably not needed, as `yubikey-personalization` is marked as deprecated and suggests using `yubioath-flutter`
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-lgc-plus
      # noto-fonts-cjk-sans
      # noto-fonts-cjk-sans
      # noto-fonts-cjk-serif
      noto-fonts-color-emoji
      lmodern
      # powerline-fonts
      # powerline-symbols
      corefonts
      # vista-fonts
      cm_unicode
    ];
    # ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Symbols Nerd Font"
          # "DejaVu Serif"
        ];
        sansSerif = [
          "Noto Sans"
          "Symbols Nerd Font"
          # "DejaVu Sans"
        ];
        monospace = [
          "Noto Sans Mono"
          "Symbols Nerd Font"
          # "DejaVu Sans Mono"
          # "JetBrainsMono Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  nix = {
    settings = {
      substituters = [
        "https://mirror.yandex.ru/nixos?priority=30"
        "https://cache.nixos.org?priority=50"
        # "https://cache.garnix.io?priority=200"
        # "https://ayugram-desktop.cachix.org?priority=201"
        # "https://anyrun.cachix.org"
      ];
      trusted-public-keys = [
        # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        # "ayugram-desktop.cachix.org:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA="
        # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
  };

  hardware = {
    gpgSmartcards.enable = true;
    onlykey.enable = true;
    usb-modeswitch.enable = true;
    graphics = {
      extraPackages = [ pkgs.rocmPackages.clr.icd ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          # Specify the policy to the JUST-WORKS repairing initiated by peer
          # Possible values: "never", "confirm", "always"
          # Defaults to "never"
          JustWorksRepairing = "confirm";
          # Shows battery charge of connected devices on supported
          # Bluetooth adapters.
          # Enables D-Bus experimental interfaces. Defaults to 'false'.
          Experimental = true;
          # When enabled other devices can connect faster to us, however
          # the tradeoff is increased power consumption. Defaults to
          # 'false'.
          FastConnectable = true;
        };
        Policy = {
          # AutoEnable defines option to enable all controllers when they are found.
          # This includes adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
