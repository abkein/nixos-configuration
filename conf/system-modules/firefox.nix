{ pkgs, lib }: {
  enable = true;
  preferences = {
    "security.sandbox.content.read_path_whitelist" = "/nix/store/";
    "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
  };
  languagePacks = [ "en-US" "ru" "de" ];
  # https://mozilla.github.io/policy-templates/
  policies = let
    makeExt = id: {
      ${id} = {
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
        installation_mode = "force_installed";
        default_area = "menupanel";
      };
    };
    makeExtNav = id: {
      ${id} = {
        install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
        installation_mode = "force_installed";
        default_area = "navbar";
      };
    };
  in {
    AutofillCreditCardEnabled = false;
    CaptivePortal = true;
    DNSOverHTTPS = {
      Enabled = true;
      ProviderURL = "https://dns.google/dns-query";
      #ProviderURL = "https://dns.cloudflare.com/dns-query";
      Locked = true;
      ExcludedDomains = [ ];
      Fallback = false;
    };
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    ExtensionUpdate = true;
    # ---- EXTENSIONS ----
    # Check about:support for extension/add-on ID strings.
    ExtensionSettings = lib.mkMerge [
      {
        # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
      }
      (makeExtNav "easyscreenshot@mozillaonline.com") # Easy Screenshot
      (makeExtNav "simple-tab-groups@drive4ik") # Simple Tab Groups
      (makeExtNav "@testpilot-containers") # Firefox Multi-Account Containers
      (makeExtNav "keepassxc-browser@keepassxc.org") # KeePassXC-Browser
      (makeExtNav "addon@darkreader.org") # Dark Reader
      (makeExtNav "zotero@chnm.gmu.edu") # Zotero Connector

      (makeExt "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}") # Auto Tab Discard
      (makeExt "jid1-BoFifL9Vbdl2zQ@jetpack") # Decentraleyes
      (makeExt
        "firefox.container-shortcuts@strategery.io") # Easy Container Shortcuts
      (makeExt "{1018e4d6-728f-4b20-ad56-37578a4de76b}") # Flagfox
      (makeExt "jid1-AQqSMBYb0a8ADg@jetpack") # Mailvelope
      (makeExt "jid1-MnnxcxisBPnSXQ@jetpack") # Privacy Badger
      (makeExt "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}") # Search by Image
      (makeExt "uBlock0@raymondhill.net") # uBlock Origin
      (makeExt "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}") # Video DownloadHelper
      (makeExt "rto@rto.rto") # РуТрекер - официальный плагин (доступ и пр.)
      # (makeExt "{73a6fe31-595d-460b-a920-fcc0f8843232}") # NoScript
      # (makeExt "suziwen1@gmail.com") # Proxy SwitchyOmega 3 (ZeroOmega)
      # (makeExt "{cb08faed-9460-474a-ba0b-d98b13b5e001}") # Regex Search
      # (makeExt "{e662576a-2f73-4069-bcca-ddf440fea62b}") # Web Apps by 123apps
    ];
    HardwareAcceleration = true;
    HttpsOnlyMode = "force_enabled";
    OfferToSaveLoginsDefault = false;
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;
    PostQuantumKeyAgreementEnabled = true;
    Permissions = {
      Autoplay = {
        Default = "block-audio-video";
        Locked = true;
      };
    };
    PrimaryPassword = true;
    # Proxy = {
    #   Mode = "manual";
    #   Locked = true;
    #   SOCKSProxy = "127.0.0.1:1080";
    #   SOCKSVersion = 5;
    #   UseProxyForDNS = true;
    # };
    SecurityDevices = {
      Add = {
        "OpenSC PKCS#11 Module" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      };
    };
    TranslateEnabled = true;
    ShowHomeButton = true;
    SearchSuggestEnabled = true;
    SearchBar = "unified";
    SupportMenu = {
      Title = "Custom Support";
      URL = "http://example.com/support";
      AccessKey = "S";
    };
    SanitizeOnShutdown = {
      Cache = true;
      Locked = false;
    };
    PrintingEnabled = true;
    PopupBlocking = {
      Allow = [ "https://github.com/" ];
      Default = true;
      Locked = false;
    };
    NetworkPrediction = false;
    NewTabPage = true;
    Preferences = {
      "browser.contentblocking.category" = {
        Value = "strict";
        Status = "locked";
      };
      "security.insecure_connection_text.enabled" = {
        Value = true;
        Status = "locked";
      };
      "security.insecure_connection_text.pbmode.enabled" = {
        Value = true;
        Status = "locked";
      };
      "network.proxy.socks_remote_dns" = {  # for flagfox
        Value = true;
        Status = "user";
      };
    };
  };
}
