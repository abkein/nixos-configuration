# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./pstate.nix
    ./zenpower.nix
    # ./system-modules/flatpak.nix
    ./shadow/xray.nix
    ./system-modules/syncthing.nix
  ];

  age = {
    # rekey = {
    #   hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzMEb6MSQOJnLdf3EdsrsPuiRYJ3Weg00/HbJ+3JeVv";
    #   masterIdentities = [ ./secrets/keys/yubikey-identity.pub ];
    #   storageMode = "local";
    #   localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
    # };
    identityPaths = [ "/home/kein/nixos-configuration/conf/secrets/keys/yubikey-identity.pub" ];
    secrets = {
      "nix-access-tokens.conf" = {
        file = ./secrets/agenix/encrypted/nix-access-tokens.conf.age;
      };
      "nix-netrc" = {
        file = ./secrets/agenix/encrypted/nix-netrc.age;
      };
      "syncthingPass" = {
        file = ./secrets/agenix/encrypted/syncthingPass.age;
      };
    };
    ageBin = "PATH=$PATH:${lib.makeBinPath [ pkgs.age-plugin-yubikey ]} ${pkgs.age}/bin/age";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "jeta";
    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
        backend = "iwd";
      };
    };
    # modemmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services = {
    ipp-usb.enable=true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        hplipWithPlugin
      ];
    };
    blueman.enable = true;
    upower.enable = true;
    vnstat.enable = true;
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
      wireplumber = { enable = true; };
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };
    # xserver = {
    #   enable = true;
    #   xkb = {
    #     variant = "";
    #     layout = "us";
    #   };
    #   displayManager.gdm = {
    #     enable = true;
    #     wayland = true;
    #   };
    # };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${lib.getExe config.programs.hyprland.package} --config /etc/greetd/hyprland.conf";
          user = "greeter";
        };
      };
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
    regreet = {
      enable = true;
      settings = import ./system-modules/regreet-settings.nix;
    };
    # nix-ld = {
    #   enable = true;
    # };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    zsh.enable = true;
    proxychains = import ./system-modules/proxychains.nix pkgs;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
    evince.enable = true;
    firefox = import ./system-modules/firefox.nix {
      pkgs = pkgs;
      lib = lib;
    };
    ssh = { startAgent = false; };
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
      flake = "/home/kein/nixos-confiduration";
    };
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.kein = {
      isNormalUser = true;
      description = "C2H5OH";
      createHome = true;
      extraGroups =
        [ "networkmanager" "wheel" "input" "scanner" "lp" ];
      # packages = with pkgs; [ ];
      shell = pkgs.zsh;
      home = "/home/kein";
    };
  };

  security = {
    polkit.enable = true;
    pam.p11.enable = true;
    rtkit.enable = true;
  };

  xdg = {
    autostart.enable = true;
    menus.enable = true;
    portal = {
      enable = true;
      # xdgOpenUsePortal = true;  # breaks Github authentication in vscode
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
    mime = {
      enable = true;
      # defaultApplications = import ./confs/mimes.nix;
      # addedAssociations = import ./confs/mimes.nix;
      # removedAssociations = import ./confs/mimes.nix;

    };
    terminal-exec = {
      enable = true;
      settings = {
        GNOME =
          [ "org.gnome.Terminal.desktop" "com.raggesilver.BlackBox.desktop" ];
        default = [ "kitty.desktop" ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    etc = import ./system-modules/etc.nix { lib=lib; config=config; };
    systemPackages = with pkgs; [
      clinfo
      vulkan-tools

      p7zip # 7z
      cdrtools # mkisofs

      nix-prefetch
      nix-prefetch-git
      nix-prefetch-github

      pulseaudio

      # system
      polkit_gnome
      wlr-randr
      ydotool
      wl-clipboard
      hyprland-protocols
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-utils
      xdg-user-dirs
      xdg-ninja
      xdg-launch
      xdg-terminal-exec
      hyprland-workspaces
      hyprland-activewindow
      openvpn

      # syncthingtray

      # utilities
      killall
      wget
      file
      pinentry-all
      usbutils
      hw-probe

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
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs;
      [
        lmodern
        jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-lgc-plus
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        twemoji-color-font
        font-awesome
        powerline-fonts
        powerline-symbols
        corefonts
        vistafonts
        cm_unicode
      ] ++ builtins.filter lib.attrsets.isDerivation
      (builtins.attrValues pkgs.nerd-fonts);

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono" "Noto Color Emoji" ];
        sansSerif = [ "DejaVu Sans" "Noto Color Emoji" ];
        serif = [ "DejaVu Serif" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  nix = {
    gc = {
      automatic = false;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "1m";
    };
    settings = {
      netrc-file = config.age.secrets."nix-netrc".path;
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
      # substituters = [
      #  "https://cache.garnix.io"
      # ];
      # trusted-public-keys = [
      #  "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      # ];
      extra-substituters = [
         "https://anyrun.cachix.org"
      ];
      extra-trusted-public-keys = [
         "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
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
    enableRedistributableFirmware = true;
    sane = {
      enable = true;
      extraBackends = with pkgs; [ hplipWithPlugin sane-airscan ];
    };
    graphics = {
      extraPackages = [ pkgs.rocmPackages.clr.icd pkgs.amdvlk ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = true;
          # When enabled other devices can connect faster to us, however
          # the tradeoff is increased power consumption. Defaults to
          # 'false'.
          FastConnectable = true;
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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
