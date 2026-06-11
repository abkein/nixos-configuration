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
    blueman.enable = true;
    udev = {
      enable = true;
      packages = with pkgs; [
        sane-airscan
      ];
    }; # hardware.glasgow — plugdev
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
      (runCommand "blueman-icon-fix" { } ''
        mkdir -p $out/share/icons/hicolor/scalable/apps
        ln -s ${blueman}/share/icons/hicolor/scalable/devices/blueman-device.svg \
          $out/share/icons/hicolor/scalable/apps/blueman-device.svg

        mkdir -p $out/share/icons/hicolor/16x16/apps
        ln -s ${blueman}/share/icons/hicolor/16x16/devices/blueman-device.png \
          $out/share/icons/hicolor/16x16/apps/blueman-device.png
      '')
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
      pcsclite
      opensc
      yubikey-manager
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
