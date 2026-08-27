{ config, pkgs, ... }:
let
  makeExt = id: {
    name = id;
    value = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      installation_mode = "normal_installed";
      default_area = "menupanel";
    };
  };
  makeExtNav = id: {
    name = id;
    value = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      installation_mode = "normal_installed";
      default_area = "navbar";
    };
  };
  L2A = func: lst: builtins.listToAttrs (map func lst);

in
{
  imports = [ (import ./firefox-policies-module.nix "zen-browser") ];
  stylix.targets.zen-browser = {
    enable = true;
    profileNames = [ "default" ];
  };
  # home.sessionVariables.MOZ_HOME = moz_home;
  programs.zen-browser = {
    enable = false;
    # package = ipkgs.zen-browser.override (old: {
    #   nativeMessagingHosts = with pkgs; [
    #     keepassxc
    #     # (pkgs.writeTextFile {
    #     #   name = "gpgme-mozilla-native-messaging";
    #     #   text = ''
    #     #     {
    #     #       "name": "gpgmejson",
    #     #       "description": "JavaScript binding for GnuPG",
    #     #       "path": "${pkgs.gpgme}/bin/gpgme-jsona",
    #     #       "type": "stdio",
    #     #       "allowed_extensions": ["jid1-AQqSMBYb0a8ADg@jetpack"]
    #     #     }
    #     #   '';
    #     #   destination = "/lib/mozilla/native-messaging-hosts/gpgme.json";
    #     # })
    #   ];
    # });
    # configPath = "${moz_home}/firefox";
    # preferences = {
    #   "security.sandbox.content.read_path_whitelist" = "/nix/store/";
    #   "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
    # };
    nativeMessagingHosts = with pkgs; [
      keepassxc
      #   # gpgme
      #   # gpgme.dev
      #   # gpgme.info
    ];
    languagePacks = [
      "en-US"
      "ru"
      "de"
    ];
    profiles = {
      cleanProf = {
        id = 1;
        # name = "cleanProf";
        # path = "a8wjwc3u.cleanProf";
        # settings."browser.ml.chat.enabled" = true;
      };
      default = {
        isDefault = true;
        id = 0;
        # name = "default";
        # path = "m8wjwc3u.default";
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
            auto-tab-discard
          ];
        };
      };
    };
    # https://mozilla.github.io/policy-templates/ — DEPRECATED
    # https://firefox-admin-docs.mozilla.org/reference/policies/sync/
    _policies = {
      # Quite interesting, yet currently done via Xray
      # AccessConnector = {
      #   Host = "documents.company.com";
      #   Port = 443;
      #   MatchPatterns = [
      #     "/finance*"
      #     "/hr*"
      #   ];
      #   Locked = true;
      # };
      AIChatbot = {
        Providers = {
          Builtin = {
            "Anthropic Claude" = false;
            "ChatGPT" = true;
            "Copilot" = false;
            "Google Gemini" = true;
            "HuggingChat" = true;
            "Le Chat Mistral" = true;
            "localhost" = false;
          };
        };
      };
      AIControls =
        let
          mkLockedValue = value: {
            Value = value;
            Locked = true;
          };
        in
        {
          Default = mkLockedValue "available";
          Translations = mkLockedValue "available";
          PDFAltText = mkLockedValue "available";
          SmartTabGroups = mkLockedValue "available";
          LinkPreviewKeyPoints = mkLockedValue "available";
          SidebarChatbot = mkLockedValue "available";
          SmartWindow = mkLockedValue "available";
        };
      AllowFileSelectionDialogs = true;
      AppAutoUpdate = false;
      AppUpdateURL = "";
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundAppUpdate = false;
      BlockAboutAddons = false;
      BlockAboutConfig = false;
      BlockAboutProfiles = false;
      BlockAboutSupport = false;
      BrowserDataBackup = {
        AllowBackup = true;
        AllowRestore = true;
      };
      CaptivePortal = true;
      CNSA2KeyAgreementEnabled = true;
      Cookies = {
        Locked = false;
        Behavior = "reject-tracker";
        BehaviorPrivateBrowsing = "partition-foreign";
      };
      CrashReportsSubmit = {
        Enabled = true;
      };
      DefaultBrowserSettingEnabled = true;
      DefaultDownloadDirectory = config.xdg.userDirs.download;
      DefaultSerialGuardSetting = 3;
      DisableAccounts = false;
      DisableAppUpdate = true;
      DisableBuiltinPDFViewer = true;
      # DisabledCiphers = {
      # TLS_DHE_RSA_WITH_AES_128_CBC_SHA
      # TLS_DHE_RSA_WITH_AES_256_CBC_SHA
      # TLS_RSA_WITH_AES_128_CBC_SHA
      # TLS_RSA_WITH_AES_256_CBC_SHA
      # TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
      # TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
      # TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
      # TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
      # TLS_RSA_WITH_3DES_EDE_CBC_SHA
      # TLS_RSA_WITH_AES_128_GCM_SHA256
      # TLS_RSA_WITH_AES_256_GCM_SHA384
      # TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
      # TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
      # TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
      # TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
      # TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
      # TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
      # TLS_CHACHA20_POLY1305_SHA256
      # TLS_AES_128_GCM_SHA256
      # TLS_AES_256_GCM_SHA384
      # };
      DisableDeveloperTools = false;
      DisableEncryptedClientHello = false;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = false;
      DisableFirefoxScreenshots = false;
      DisableFirefoxStudies = false;
      DisableForgetButton = false;
      DisableFormHistory = false;
      DisableLocalPolicies = false;
      DisableMasterPasswordCreation = false;
      DisablePasswordReveal = false;
      DisablePrivateBrowsing = false;
      DisableProfileImport = false;
      DisableProfileRefresh = false;
      DisableRemoteImprovements = false;
      DisableRemoteSettingsAndAcceptSecurityConsequences = false;
      DisableSafeMode = false;
      DisableSecurityBypass = {
        InvalidCertificate = false;
        SafeBrowsing = false;
      };
      DisableSetDesktopBackground = true;
      DisableSystemAddonUpdate = false;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "always";
      DisplayMenuBar = "default-on";
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://127.0.0.1:3000/dns-query";
        # ProviderURL = "https://8.8.8.8/dns-query"; # 8.8.8.8, 8.8.4.4, goo.gle
        # ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";  # 162.159.61.4 172.64.41.4
        # ProviderURL = "https://dns.cloudflare.com/dns-query";  # 162.159.61.4 172.64.41.4
        # ProviderURL = "https://dns.quad9.net/dns-query";  # 9.9.9.9, 149.112.112.112
        Locked = false;
        ExcludedDomains = [ ];
        Fallback = false;
      };
      DontCheckDefaultBrowser = true;
      # DownloadDirectory = config.xdg.userDirs.download;
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
      EncryptedMediaExtensions = {
        Enabled = true;
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
        "{6c00218c-707a-4977-84cf-36df1cef310f}" # Port Authority
        "{a8cf72f7-09b7-4cd4-9aaa-7a023bf09916}" # Time Tracker
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
      GenerativeAI = {
        Enabled = true;
        Chatbot = true;
        LinkPreviews = true;
        TabGroups = true;
        Locked = true;
      };
      # GoToIntranetSiteForSingleWordEntryInAddressBar = true;
      HardwareAcceleration = true;
      Homepage = {
        URL = "about:home";
        Locked = true;
        Additional = [
          "about:newtab"
          "https://google.com"
        ];
        StartPage = "previous-session";
      };
      HttpsOnlyMode = "force_enabled";
      IPProtectionAvailable = true;
      LocalNetworkAccess = {
        Enabled = true;
        BlockTrackers = true;
        EnablePrompting = true;
        # SkipDomains = [];
        Locked = true;
      };
      ManualAppUpdateOnly = true;
      NetworkPrediction = true;
      NewTabPage = true;
      OfferToSaveLogins = false;
      # OfferToSaveLoginsDefault = false;  # Errors if non-default is present
      PasswordManagerEnabled = false;
      PDFjs = {
        Enabled = true;
        EnablePermissions = false;
      };
      Permissions = {
        Autoplay = {
          Default = "block-audio-video";
          Locked = true;
        };
        Notifications = {
          BlockNewRequests = true;
          Locked = true;
        };
      };
      PictureInPicture = {
        Enabled = true;
        Locked = true;
      };
      PopupBlocking = {
        Allow = [ "https://github.com/" ];
        Default = true;
        Locked = false;
      };
      PostQuantumKeyAgreementEnabled = true;
      Preferences =
        let
          mkValue = value: status: {
            Value = value;
            Status = status;
          };
        in
        {
          # Disable titlebar
          "browser.tabs.inTitlebar" = mkValue 1 "default";
          # Tab unload
          "browser.tabs.unloadOnLowMemory" = mkValue true "locked";
          "browser.tabs.min_inactive_duration_before_unload" = mkValue 600000 "default"; # 10m
          "browser.low_commit_space_threshold_percent" = mkValue 50 "default"; # % of free RAM to start unloading tabs
          # Preview tab contents on hover
          "browser.tabs.hoverPreview.enabled" = mkValue true "locked";
          "browser.tabs.hoverPreview.showThumbnails" = mkValue true "locked";
          # Translation pop-up
          "browser.translations.automaticallyPopup" = mkValue true "default";
          # "browser.tabs.loadInBackground" = mkValue true "defalt";
          "browser.tabs.opentabfor.middleclick" = mkValue true "locked";

          # write session status in 1m interval, instead of 15s default
          "browser.sessionstore.interval" = mkValue 60000 "default";

          "browser.cache.disk.enable" = mkValue true "locked";
          "browser.cache.disk.encryption.enabled" = mkValue true "locked";
          "browser.cache.disk.smart_size.enabled" = mkValue true "locked";
          "browser.cache.memory.enable" = mkValue true "locked";
          "browser.cache.memory.capacity" = mkValue (-1) "default"; # automatic

          "network.dns.disableIPv6" = mkValue false "locked";
          "network.dns.skip_ipv6_when_no_addresses" = mkValue false "locked";
          "network.dns.preferIPv6" = mkValue true "default";

          # Additional privacy
          "browser.safebrowsing.malware.enabled" = mkValue true "locked";
          "browser.safebrowsing.phishing.enabled" = mkValue true "locked";
          "browser.safebrowsing.blockedURIs.enabled" = mkValue true "locked";
          "browser.safebrowsing.downloads.enabled" = mkValue true "locked";
          "browser.safebrowsing.downloads.remote.enabled" = mkValue true "locked";
          "browser.safebrowsing.downloads.remote.block_dangerous" = mkValue true "locked";
          "browser.safebrowsing.downloads.remote.block_dangerous_host" = mkValue true "locked";
          "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = mkValue true "locked";
          "browser.safebrowsing.downloads.remote.block_uncommon" = mkValue true "locked";

          "privacy.resistFingerprinting" = mkValue true "locked";
          "privacy.resistFingerprinting.pbmode" = mkValue true "locked";
          "privacy.partition.network_state.connection_with_proxy" = mkValue true "default";


          "browser.search.region" = mkValue "US" "locked";
          "doh-rollout.home-region" = mkValue "US" "locked";

          "media.hardware-video-decoding.enabled" = mkValue true "locked";
          "media.hardware-video-encoding.enabled" = mkValue true "locked";
          "media.hardware-video-decoding.force-enabled" = mkValue true "user";
          "media.hardware-video-encoding.force-enabled" = mkValue true "user";
          "svg.context-properties.content.enabled" = mkValue true "user";

          "security.insecure_connection_text.enabled" = mkValue true "locked";
          "security.insecure_connection_text.pbmode.enabled" = mkValue true "locked";
          "security.warn_submit_secure_to_insecure" = mkValue true "locked";

          # Testing
          "browser.display.show_focus_rings" = mkValue true "default";
          "browser.display.always_show_rings_after_key_focus" = mkValue true "default";

          "extensions.blocklist.enabled" = mkValue true "default";
          "extensions.htmlaboutaddons.recommendations.enabled" = mkValue true "default";

          "extensions.ui.dictionary.hidden" = mkValue false "locked";
          "extensions.ui.extension.hidden" = mkValue false "locked";
          "extensions.ui.locale.hidden" = mkValue false "locked";
          "extensions.ui.mlmodel.hidden" = mkValue false "locked";
          "extensions.ui.sitepermission.hidden" = mkValue false "locked";
          "extensions.ui.theme.hidden" = mkValue false "locked";

          # WebRTC
          "media.peerconnection.ice.proxy_only_if_behind_proxy" = mkValue true "default";

          "media.webspeech.recognition.enable" = mkValue true "user";

          # Zen-browser
          "zen.glance.enabled" = mkValue true "locked";
          "zen.glance.activation-method" = mkValue "ctrl" "locked";
          "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = mkValue true "locked";
          "zen.tabs.ctrl-tab.ignore-essential-tabs" = mkValue true "locked";
          "zen.tabs.ctrl-tab.show-pending-tabs" = mkValue true "locked";
          "zen.tabs.close-on-back-with-no-history" = mkValue false "locked";
          "zen.workspaces.hide-default-container-indicator" = mkValue false "locked";
          "zen.tabs.vertical.right-side" = mkValue true "default";
          "zen.urlbar.behavior" = mkValue "float" "locked";
          "zen.urlbar.show-pip-button" = mkValue true "locked";
          "zen.urlbar.replace-newtab" = mkValue false "locked";
          "zen.folders.owned-tabs-in-folder"= mkValue true "locked";
          "zen.view.compact.enable-at-startup" = mkValue false "default";
        };
      PrimaryPassword = true;
      PrintingEnabled = true;
      PrivateBrowsingModeAvailability = 0;
      PromptForDownloadLocation = false;
      Proxy = {
        Mode = "manual";
        Locked = false;
        HTTPProxy = "127.0.0.1:1080";
        UseHTTPProxyForAllProtocols = false;
        # SSLProxy = "example.com";
        # FTPProxy = "example.com";
        SOCKSProxy = "127.0.0.1:1080";
        SOCKSVersion = 5;
        Passthrough = "localhost,127.0.0.0/8,::1,<local>,192.168.0.0/16";
        # AutoConfigURL = "https://example.com/proxy";
        # AutoLogin = true;
        UseProxyForDNS = true;
      };
      RequestedLocales = [
        "en-US"
        "ru"
        "de"
      ];
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = false;
        FormData = false;
        History = false;
        Sessions = false;
        SiteSettings = false;
        Locked = false;
      };
      SearchBar = "unified";
      # SearchEngines = {
      #   Default = "Example1";
      #   Add = [
      #     {
      #       Name = "Example1";
      #       URLTemplate = "https://www.example.org/q={searchTerms}";
      #       Method = "GET";
      #       IconURL = "https://www.example.org/favicon.ico";
      #       Alias = "example";
      #       Description = "Description";
      #       SuggestURLTemplate = "https://www.example.org/suggestions/q={searchTerms}";
      #     }
      #   ];
      #   PreventInstalls = true;
      # };
      SearchSuggestEnabled = true;
      # SecurityDevices = {
      #   Add = {
      #     "OpenSC PKCS#11 Module" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      #   };
      # };
      # ShowHomeButton = true;
      SkipTermsOfUse = true;
      SSLVersionMax = "tls1.3";
      SSLVersionMin = "tls1.2";
      StartDownloadsInTempDirectory = false;
      # SupportMenu = {
      #   Title = "Custom Support";
      #   URL = "http://example.com/support";
      #   AccessKey = "S";
      # };
      Sync = {
        Addons = false;
        Addresses = true;
        Bookmarks = true;
        Enabled = true;
        History = true;
        Locked = true;
        OpenTabs = true;
        Passwords = false;
        PaymentMethods = false;
        Settings = false;
      };
      TranslateEnabled = true;
      UserMessaging = {
        ExtensionRecommendations = true;
        FeatureRecommendations = true;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = true;
        FirefoxLabs = true;
        Locked = true;
      };
      UseSystemPrintDialog = false;
      VisualSearchEnabled = true;
      XSLTEnabled = true;

    };
  };
}
