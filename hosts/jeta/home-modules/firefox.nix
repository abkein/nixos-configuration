{ config, pkgs, ... }:
let
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
  L2A = func: lst: builtins.listToAttrs (map func lst);
  moz_home = "${config.xdg.configHome}/mozilla";
in
{
  stylix.targets.firefox.profileNames = [ "default" ];
  home.sessionVariables.MOZ_HOME = moz_home;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override (old: {
      nativeMessagingHosts = with pkgs; [
        keepassxc
        (pkgs.writeTextFile {
          name = "gpgme-mozilla-native-messaging";
          text = ''
            {
              "name": "gpgmejson",
              "description": "JavaScript binding for GnuPG",
              "path": "${pkgs.gpgme}/bin/gpgme-jsona",
              "type": "stdio",
              "allowed_extensions": ["jid1-AQqSMBYb0a8ADg@jetpack"]
            }
          '';
          destination = "/lib/mozilla/native-messaging-hosts/gpgme.json";
        })
      ];
    });
    configPath = "${moz_home}/firefox";
    # preferences = {
    #   "security.sandbox.content.read_path_whitelist" = "/nix/store/";
    #   "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
    # };
    # nativeMessagingHosts = with pkgs; [
    #   # gpgme
    #   # gpgme.dev
    #   # gpgme.info
    # ];
    languagePacks = [
      "en-US"
      "ru"
      "de"
    ];
    profiles = {
      cleanProf = {
        id = 1;
        name = "cleanProf";
        path = "a8wjwc3u.cleanProf";
      };
      default = {
        isDefault = true;
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
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            zotero-connector
            zeroomega
          ];
        };
      };
    };
    # https://mozilla.github.io/policy-templates/
    policies = {
      AutofillCreditCardEnabled = false;
      CaptivePortal = true;
      # DNSOverHTTPS = {
      #   Enabled = true;
      #   ProviderURL = "https://8.8.8.8/dns-query"; # 8.8.8.8, 8.8.4.4
      #   # ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";  # 162.159.61.4 172.64.41.4
      #   # ProviderURL = "https://dns.cloudflare.com/dns-query";  # 162.159.61.4 172.64.41.4
      #   # ProviderURL = "https://dns.quad9.net/dns-query";  # 9.9.9.9, 149.112.112.112
      #   Locked = true;
      #   ExcludedDomains = [ ];
      #   Fallback = false;
      # };
      DisableAppUpdate = true;
      DisableSetDesktopBackground = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        SuspectedFingerprinting = true;
        Category = "strict";
        Exceptions = [ ];
        BaselineExceptions = true;
        ConvenienceExceptions = true;
      };
      FirefoxHome = {
        Search = true;
        TopSites = true;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = true;
        Stories = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        Snippets = true;
        Locked = true;
      };
      ExtensionUpdate = true;
      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      ExtensionSettings = {
        # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
      }
      // L2A makeExtNav [
        "easyscreenshot@mozillaonline.com" # Easy Screenshot
        "@testpilot-containers" # Firefox Multi-Account Containers
        "keepassxc-browser@keepassxc.org" # KeePassXC-Browser
        "addon@darkreader.org" # Dark Reader
        # "zotero@chnm.gmu.edu" # Zotero Connector (unavaillable at addons.mozilla.org)
        "button@scholar.google.com" # Google Scholar Button
        "{6031c27b-5ae2-4449-a7fd-ac7feabb4ef3}" # Sci-Hub
        "{0e10f3d7-07f6-4f12-97b9-9b27e07139a5}" # Netcraft Extension
      ]
      // L2A makeExt [
        "{74145f27-f039-47ce-a470-a662b129930a}" # CleanURLs
        "en-US-Extended@averymiller.org" # English (US) Dictionary Extended
        "ruspell-wiktionary-eyo@addons.mozilla.org" # Словарь русской орфогр. из Викисловаря (ё,е)
        "ruspell-wiktionary@addons.mozilla.org" # Словарь русской орфографии из Викисловаря
        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" # Auto Tab Discard
        "jid1-BoFifL9Vbdl2zQ@jetpack" # Decentraleyes
        # "firefox.container-shortcuts@strategery.io" # Easy Container Shortcuts
        # "{1018e4d6-728f-4b20-ad56-37578a4de76b}" # Flagfox
        "jid1-AQqSMBYb0a8ADg@jetpack" # Mailvelope
        "jid1-MnnxcxisBPnSXQ@jetpack" # Privacy Badger
        "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" # Search by Image
        "uBlock0@raymondhill.net" # uBlock Origin
        "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" # Video DownloadHelper
        "rto@rto.rto" # РуТрекер - официальный плагин (доступ и пр.)
        # "@amiunique-extension" # AmIUnique  # Constantly consumes too much CPU
        "{96ef5869-e3ba-4d21-b86e-21b163096400}" # Font Fingerprint Defender
        # "queryamoid@kaply.com" # Query AMO Addon ID
        "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" # User-Agent Switcher and Manager
        # "{2cf5dbed-78fe-4bd5-9524-38fdf837be98}"  # WebGL Fingerprint Defender
        "{55f61747-c3d3-4425-97f9-dfc19a0be23c}" # Spoof Timezone
        # "CanvasBlocker@kkapsner.de"  # CanvasBlocker  # Breaks certain websites
        # "2.0@disconnect.me"  # Disconnect  # Breaks certain websites
        # "jid1-ZAdIEUB7XOzOJw@jetpack"  # DuckDuckGo Privacy Essentials  # Breaks certain websites
        # "{73a6fe31-595d-460b-a920-fcc0f8843232}" # NoScript
        "suziwen1@gmail.com" # Proxy SwitchyOmega 3 (ZeroOmega)
        "{cb08faed-9460-474a-ba0b-d98b13b5e001}" # Regex Search
        # "{e662576a-2f73-4069-bcca-ddf440fea62b}" # Web Apps by 123apps
      ];
      HardwareAcceleration = true;
      HttpsOnlyMode = "force_enabled";
      OfferToSaveLogins = false;
      # OfferToSaveLoginsDefault = false;  # Errors is non-default is present
      PasswordManagerEnabled = false;
      PostQuantumKeyAgreementEnabled = true;
      Permissions = {
        Autoplay = {
          Default = "block-audio-video";
          Locked = true;
        };
      };
      Homepage = {
        URL = "about:newtab";
        Locked = true;
        StartPage = "previous-session";
      };
      ManualAppUpdateOnly = true;
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
      PDFjs = {
        Enabled = false;
      };
      Permissions = {
        Notifications = {
          BlockNewRequests = true;
          Locked = true;
        };
      };
      Preferences = {
        "app.shield.optoutstudies.enabled" = {
          Value = false;
          Status = "locked";
        };
        "experiments.supported" = {
          Value = false;
          Status = "locked";
        };
        "experiments.enabled" = {
          Value = false;
          Status = "locked";
        };
        "experiments.manifest.uri" = {
          Value = "";
          Status = "locked";
        };
        "app.normandy.enabled" = {
          Value = false;
          Status = "locked";
        };
        "app.normandy.api_url" = {
          Value = "";
          Status = "locked";
        };
        "datareporting.healthreport.uploadEnabled" = {
          Value = false;
          Status = "locked";
        };
        "datareporting.healthreport.service.enabled" = {
          Value = false;
          Status = "locked";
        };
        "datareporting.policy.dataSubmissionEnabled" = {
          Value = false;
          Status = "locked";
        };
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = {
          Value = 2;
          Status = "locked";
        };
        "toolkit.telemetry.enabled" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.unified" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.server" = {
          Value = "data:,";
          Status = "locked";
        };
        "toolkit.telemetry.archive.enabled" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.newProfilePing.enabled" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.shutdownPingSender.enabled" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.updatePing.enabled" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.bhrPing.enabled" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.firstShutdownPing.enabled" = {
          Value = false;
          Status = "locked";
        };
        "toolkit.telemetry.coverage.opt-out" = {
          Value = true;
          Status = "locked";
        };
        "toolkit.coverage.opt-out" = {
          Value = true;
          Status = "locked";
        };
        "toolkit.coverage.endpoint.base" = {
          Value = "";
          Status = "locked";
        };
        "browser.newtabpage.activity-stream.telemetry" = {
          Value = false;
          Status = "locked";
        };
        "browser.ping-centre.telemetry" = {
          Value = false;
          Status = "locked";
        };
        "breakpad.reportURL" = {
          Value = "";
          Status = "locked";
        };
        "browser.tabs.crashReporting.sendReport" = {
          Value = false;
          Status = "locked";
        };
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = {
          Value = false;
          Status = "locked";
        };

        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "svg.context-properties.content.enabled" = {
          Value = true;
          Status = "user";
        };
        "security.insecure_connection_text.enabled" = {
          Value = true;
          Status = "locked";
        };
        "security.insecure_connection_text.pbmode.enabled" = {
          Value = true;
          Status = "locked";
        };
        "network.proxy.socks_remote_dns" = {
          # for flagfox
          Value = true;
          Status = "user";
        };
        "security.csp.reporting.enabled" = {
          Value = false;
          Status = "locked";
        };
      };
    };
  };
}
