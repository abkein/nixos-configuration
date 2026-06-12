# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  lib,
  cfg,
  ...
}:
{
  system.stateVersion = "24.11";
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
    blueman.enable = true;
    gvfs.enable = true;
    homed.enable = true;
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
  };

  programs = {
    yubikey-touch-detector = {
      enable = true;
      # verbose = true;
    };
    yubikey-manager.enable = true;
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

  users = {
    groups.plugdev = { };
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
    # soteria.enable = true;
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
      drm_info
      v4l-utils # edid-decode
      rocmPackages.rocminfo

      # cdrtools # mkisofs

      nix-prefetch
      nix-prefetch-git
      nix-prefetch-github

      nix-output-monitor

      # syncthingtray

      # utilities
      pinentry-all
      usbutils

      evtest
      acpi
      acpid
      libinput
      brightnessctl

      age-plugin-yubikey

      # onlykey-cli  # insecure because of ecdsa package
      # onlykey-rebuilt
      # onlykey

      pcsc-tools
      opensc

      yubico-piv-tool
      yubioath-flutter
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts
      # noto-fonts-lgc-plus
      noto-fonts-cjk-sans
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
          "JetBrainsMono Nerd Font"
        ];
        emoji = [
          "Noto Color Emoji"
          "Symbols Nerd Font"
        ];
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
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          PairableTimeout = 30;
          FastConnectable = true;
          JustWorksRepairing = "confirm";
          Experimental = true;
          Testing = true;
          KernelExperimental = true;
        };
        Policy = {
          AutoEnable = false;
          ReconnectAttempts = 3;
        };
        LE = {
          # Work around BlueZ 5.86 logging an empty default-system-config request.
          EnableAdvMonInterleaveScan = 0;
        };
      };
    };
  };
}
