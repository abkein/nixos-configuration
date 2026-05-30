# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  cfg,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./system-modules
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
  i18n = {
    defaultLocale = "en_US.UTF-8";
    # inputMethod = {
    #   enable = true;
    #   enableGtk3 = true;
    #   type = "ibus";
    #   ibus = {
    #     engines = with pkgs.ibus-engines; [
    #       (typing-booster.override {
    #         langs = [
    #           "ru-ru"
    #           "en-us-large"
    #         ];
    #       })
    #     ];
    #     waylandFrontend = true;
    #   };
    # };
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services = {
    ipp-usb.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
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
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        hplipWithPlugin
      ];
    };
    acpid = {
      enable = true;
      logEvents = true;
    };
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
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };
  };

  programs = {
    yubikey-touch-detector = {
      enable = true;
      # verbose = true;
    };
    # nix-ld = {
    #   enable = true;
    # };
    zsh.enable = true;
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
    # firefox = import ./system-modules/firefox.nix {
    #   pkgs = pkgs;
    #   lib = lib;
    # };
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
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = cfg.flakepath;
    };
    traceroute.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      "${cfg.username}" = {
        uid = 1000;
        isNormalUser = true;
        description = "C2H5OH";
        createHome = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "input"
          "scanner"
          "lp"
        ];
        # packages = with pkgs; [ ];
        shell = pkgs.zsh;
        home = cfg.userhome;
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    pathsToLink = [ "/share/zsh" ]; # for ZSH autocompletion for system packages
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      clinfo
      vulkan-tools

      p7zip # 7z
      cdrtools # mkisofs

      nix-prefetch
      nix-prefetch-git
      nix-prefetch-github

      nix-output-monitor

      # system
      polkit_gnome
      wlr-randr
      ydotool
      wl-clipboard
      hyprland-protocols
      xdg-utils
      xdg-user-dirs
      xdg-ninja
      xdg-launch
      xdg-terminal-exec
      hyprland-workspaces
      hyprland-activewindow

      inetutils
      nmap
      dig
      openvpn
      # syncthingtray

      drm_info
      v4l-utils # edid-decode
      rocmPackages.rocminfo

      # utilities
      killall
      wget
      file
      pinentry-all
      usbutils
      hw-probe
      gucharmap

      evtest
      acpi
      acpid
      libinput
      brightnessctl

      # code
      git

      age
      age-plugin-yubikey
      git-agecrypt

      # onlykey-rebuilt
      # onlykey
      system-config-printer
      simple-scan

      pcsc-tools
      pcsclite
      opensc
      # onlykey-cli  # insecure because of ecdsa package
      yubikey-manager
      yubico-piv-tool
      yubioath-flutter
      # yubikey-personalization  # probably not needed, as `yubikey-personalization` is marked as deprecated and suggests using `yubioath-flutter`

      jq
      ripgrep
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      lmodern
      # noto-fonts
      # noto-fonts-color-emoji
      # noto-fonts-lgc-plus
      # noto-fonts-cjk-sans
      # noto-fonts-cjk-serif
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
        monospace = [
          "JetBrainsMono Nerd Font"
          "Symbols Nerd Font"
          # "DejaVu Sans Mono"
          # "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "Symbols Nerd Font"
          # "DejaVu Sans"
          # "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif"
          "Symbols Nerd Font"
          # "DejaVu Serif"
          # "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  nix = {
    channel.enable = false;
    gc = {
      automatic = false;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "1m";
    };
    settings = {
      netrc-file = config.age.secrets."nix-netrc".path;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # http2 = false;
      builders-use-substitutes = true;
      cores = 8;
      connect-timeout = 5;
      download-attempts = 2;
      stalled-download-timeout = 15; # instead of 300
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
    extraOptions = ''
      !include ${config.age.secrets."nix-access-tokens.conf".path}
    '';
  };

  hardware = {
    gpgSmartcards.enable = true;
    onlykey.enable = true;
    usb-modeswitch.enable = true;
    sane = {
      enable = true;
      extraBackends = with pkgs; [
        hplipWithPlugin
        sane-airscan
      ];
    };
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

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
