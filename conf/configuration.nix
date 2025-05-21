# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }@args:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # inputs.nur.modules.nixos.default
  ];

  # age = let mksec = name: {
  #   ${name} = {
  #     file = ./secrets/${name}.age;
  #   };
  # };
  # in {
  #   identityPaths = [ "/root/keys/system_key" ];
  #   secrets = lib.mkMerge [
  #     { }
  #     (mksec "xray_generic_address")
  #     (mksec "xray_generic_ID")
  #     (mksec "xray_generic_ServerName")
  #     (mksec "xray_yun_address")
  #     (mksec "xray_yun_ID")
  #     (mksec "xray_yun_ShortID")
  #     # (mksec "ssh_fisher_hostname")
  #     # (mksec "ssh_weasel_hostname")
  #     # (mksec "ssh_yun_hostname")
  #   ];
  # };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jeta";
  networking.networkmanager = {
    enable = true;
    wifi = {
      powersave = true;
      backend = "iwd";
    };
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

  hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd pkgs.amdvlk ];
  hardware.graphics.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];

  services = {
    libinput = { enable = true; };
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
    xserver = {
      enable = true;
      xkb = {
        variant = "";
        layout = "us";
      };
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    dbus.enable = true;
    gvfs.enable = true;
    xray = {
      enable = true;
      settings = import ./system-modules/xray.nix config.age;
    };
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };
  };

  programs = {
    # nix-ld = {
    #   enable = true;
    # };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    zsh.enable = true;
    ssh = { startAgent = true; };
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
        [ "networkmanager" "wheel" "input" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ ];
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
  environment =
  # let
  #   spacefm-thermitegod = pkgs.callPackage ./spacefm-package.nix { };
  # in
  {
    variables.QT_QPA_PLATFORMTHEME = "qt5ct";
    systemPackages = with pkgs; [
      inputs.agenix.packages.${pkgs.system}.default
      clinfo
      vulkan-tools
      quickemu
      p7zip # 7z
      cdrtools # mkisofs
      adwaita-qt
      adwaita-qt6
      libsForQt5.qt5ct
      kdePackages.qt6ct
      file-roller
      nix-prefetch
      nix-prefetch-git
      nix-prefetch-github
      xdot
      graphviz
      swappy
      wf-recorder
      pulseaudio
      # spacefm-thermitegod

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

      # utilities
      nix-tree
      dunst
      cliphist
      wev
      slurp
      grim
      grimblast
      waybar
      killall
      wget
      kitty
      file
      pinentry-all
      networkmanager_dmenu
      networkmanagerapplet
      qpwgraph
      zotero
      speedtest-cli
      iperf
      tor-browser
      direnv
      libnotify

      # code
      vim
      git
      # nixfmt-rfc-style
      nixfmt-classic

      # text
      libreoffice-fresh
      xed-editor
      obsidian
      aider-chat

      # security
      keepassxc
      onlykey
      yubikey-manager
      yubioath-flutter
      yubikey-personalization
      yubikey-personalization-gui
      opensc

      # image/audio/video
      vlc
      gimp
      inkscape
      swayimg
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

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      # inputs.nix-vscode-extensions.overlays.default
      inputs.nix4vscode.overlays.forVscode
      inputs.nur.overlays.default
      # (import ./spacefm-fork.nix)
    ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "1m";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
      extra-substituters = [
          "https://anyrun.cachix.org"
      ];

      extra-trusted-public-keys = [
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
