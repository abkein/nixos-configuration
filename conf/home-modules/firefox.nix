{ pkgs, lib, ... }:
{
  programs.firefox = {
    enable = true;
    # preferences = {
    #   "security.sandbox.content.read_path_whitelist" = "/nix/store/";
    #   "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
    # };
    languagePacks = [ "en-US" "ru" "de" ];
    profiles.default = {
      id = 0;
      name = "default";
      path = "m8wjwc3u.default";
      search = {
        default = "google";
        privateDefault = "duckduckgo";
      };
      containers = {
        Personal = {
          id = 1;
          name = "Personal";
          color = "blue";
          icon = "fingerprint";
        };
        Work = {
          id = 2;
          name = "Work";
          color = "orange";
          icon = "briefcase";
        };
        Linux = {
          id = 6;
          name = "Linux";
          color = "turquoise";
          icon = "circle";
        };
        PAM = {
          id = 7;
          name = "PAM";
          color = "yellow";
          icon = "circle";
        };
        ann = {
          id = 8;
          name = "ann";
          color = "blue";
          icon = "vacation";
        };
        Study = {
          id = 9;
          name = "Study";
          color = "green";
          icon = "chill";
        };
        OpenWRT = {
          id = 10;
          name = "OpenWRT";
          color = "purple";
          icon = "circle";
        };
      };
    };
    # https://mozilla.github.io/policy-templates/
    policies = let
      makeExt = id: {
        name = id;
        value = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
      };
      makeExtNav = id: {
        name = id;
        value = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
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
      ExtensionSettings =
        {
          # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        }
        // builtins.listToAttrs (builtins.map makeExtNav
        [
          "easyscreenshot@mozillaonline.com" # Easy Screenshot
          "simple-tab-groups@drive4ik" # Simple Tab Groups
          "@testpilot-containers" # Firefox Multi-Account Containers
          "keepassxc-browser@keepassxc.org" # KeePassXC-Browser
          "addon@darkreader.org" # Dark Reader
          "zotero@chnm.gmu.edu" # Zotero Connector
          "button@scholar.google.com"  # Google Scholar Button
          "{6031c27b-5ae2-4449-a7fd-ac7feabb4ef3}"  # Sci-Hub
          "{0e10f3d7-07f6-4f12-97b9-9b27e07139a5}"  # Netcraft Extension
        ]
        ) // builtins.listToAttrs (builtins.map makeExt
        [
          "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" # Auto Tab Discard
          "jid1-BoFifL9Vbdl2zQ@jetpack" # Decentraleyes
          "firefox.container-shortcuts@strategery.io" # Easy Container Shortcuts
          "{1018e4d6-728f-4b20-ad56-37578a4de76b}" # Flagfox
          "jid1-AQqSMBYb0a8ADg@jetpack" # Mailvelope
          "jid1-MnnxcxisBPnSXQ@jetpack" # Privacy Badger
          "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" # Search by Image
          "uBlock0@raymondhill.net" # uBlock Origin
          "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" # Video DownloadHelper
          "rto@rto.rto" # РуТрекер - официальный плагин (доступ и пр.)
          "@amiunique-extension"  # AmIUnique
          "{96ef5869-e3ba-4d21-b86e-21b163096400}"  #Font Fingerprint Defender
          "queryamoid@kaply.com"  # Query AMO Addon ID
          "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}"  # User-Agent Switcher and Manager
          # "{2cf5dbed-78fe-4bd5-9524-38fdf837be98}"  # WebGL Fingerprint Defender
          # "{55f61747-c3d3-4425-97f9-dfc19a0be23c}"  # Spoof Timezone
          # "CanvasBlocker@kkapsner.de"  # CanvasBlocker  # Breaks certain websites
          # "2.0@disconnect.me"  # Disconnect  # Breaks certain websites
          # "jid1-ZAdIEUB7XOzOJw@jetpack"  # DuckDuckGo Privacy Essentials  # Breaks certain websites
          # "{73a6fe31-595d-460b-a920-fcc0f8843232}" # NoScript
          # "suziwen1@gmail.com" # Proxy SwitchyOmega 3 (ZeroOmega)
          # "{cb08faed-9460-474a-ba0b-d98b13b5e001}" # Regex Search
          # "{e662576a-2f73-4069-bcca-ddf440fea62b}" # Web Apps by 123apps
        ]
        );
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
  };
}
