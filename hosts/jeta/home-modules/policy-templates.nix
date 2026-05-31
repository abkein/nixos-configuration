{
  "3rdparty" = {
    Description = ''
      Allow WebExtensions to configure policy. For more information, see [Adding policy support to your extension](https://extensionworkshop.com/documentation/enterprise/enterprise-development/#how-to-add-policy).

      For GPO and Intune, the extension developer should provide an ADMX file.

      **Compatibility:** Firefox 68
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 68" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "3rdparty": {
            "Extensions": {
              "uBlock0@raymondhill.net": {
                "adminSettings": {
                  "selectedFilterLists": [
                    "ublock-privacy",
                    "ublock-badware",
                    "ublock-filters",
                    "user-filters"
                  ]
                }
              }
            }
          }
        }
      }
    '';
  };
  AIControls = {
    Description = ''
      Configure AI controls.
      For more information, see [Block generative AI features with Firefox AI controls](https://support.mozilla.org/en-US/kb/firefox-ai-controls) on support.mozilla.org.

      Each key controls the availability of a specific AI feature. The following AI feature keys are available:

      - `Default`: Controls the default state for AI features listed below, unless they are explicitly configured in the policy.
      - `Translations`: Controls AI-powered page translations.
      - `PDFAltText`: Controls AI-generated alt text for images in PDF documents.
      - `SmartTabGroups`: Controls AI-powered tab grouping suggestions.
      - `LinkPreviewKeyPoints`: Controls AI-generated key point summaries shown in link previews.
      - `SidebarChatbot`: Controls the AI chatbot panel in the Firefox sidebar.
      - `SmartWindow`: Controls AI-powered window arrangement features. (Firefox 150)

      All keys accept the following sub-keys:

      - `Value`:
      - `available` makes the feature accessible to users and it can be enabled or disabled.
      - `blocked` disables the feature and users won't see it. For on-device AI, any models already downloaded are removed.
      - `Locked`: if `true`, the user cannot change the setting.

      **Compatibility:** Firefox 149.0.2 (SmartWindow: Firefox 150)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.ml.chat.enabled`, `browser.ml.chat.page`, `browser.ai.control.sidebarChatbot`, `browser.translations.enable`, `browser.ai.control.translations`, `pdfjs.enableAltText`, `browser.ai.control.pdfjsAltText`, `browser.ml.linkPreview.enabled`, `browser.ai.control.linkPreviewKeyPoints`, `browser.tabs.groups.smart.userEnabled`, `browser.ai.control.smartTabGroups`, `browser.ai.control.smartWindow`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 149.0.2 (SmartWindow: Firefox 150)" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.ml.chat.enabled"
      "browser.ml.chat.page"
      "browser.ai.control.sidebarChatbot"
      "browser.translations.enable"
      "browser.ai.control.translations"
      "pdfjs.enableAltText"
      "browser.ai.control.pdfjsAltText"
      "browser.ml.linkPreview.enabled"
      "browser.ai.control.linkPreviewKeyPoints"
      "browser.tabs.groups.smart.userEnabled"
      "browser.ai.control.smartTabGroups"
      "browser.ai.control.smartWindow"
    ];
    Example = ''
      {
        "policies": {
          "AIControls": {
            "Default": {
              "Value": "available" | "blocked",
              "Locked": true | false
            },
            "Translations": {
              "Value": "available" | "blocked",
              "Locked": true | false
            },
            "PDFAltText": {
              "Value": "available" | "blocked",
              "Locked": true | false
            },
            "SmartTabGroups": {
              "Value": "available" | "blocked",
              "Locked": true | false
            },
            "LinkPreviewKeyPoints": {
              "Value": "available" | "blocked",
              "Locked": true | false
            },
            "SidebarChatbot": {
              "Value": "available" | "blocked",
              "Locked": true | false
            },
            "SmartWindow": {
              "Value": "available" | "blocked",
              "Locked": true | false
            }
          }
        }
      }
    '';
  };
  AllowedDomainsForApps = {
    Description = ''
      Define domains allowed to access Google Workspace.

      This policy is based on the [Chrome policy](https://chromeenterprise.google/policies/#AllowedDomainsForApps) of the same name.

      If this policy is enabled, users can only access Google Workspace using accounts from the specified domains. If you want to allow Gmail, you can add ```consumer_accounts``` to the list.

      **Compatibility:** Firefox 89, Firefox ESR 78.11
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 89"
      "Firefox ESR 78.11"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "AllowedDomainsForApps": "managedfirefox.com,example.com"
        }
      }
    '';
  };
  AllowFileSelectionDialogs = {
    Description = ''
      Enable or disable file selection dialogs.

      **Compatibility:** Firefox 124
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `widget.disable_file_pickers`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 124" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "widget.disable_file_pickers" ];
    Example = ''
      {
        "policies": {
          "AllowFileSelectionDialogs": true | false
        }
      }
    '';
  };
  AppAutoUpdate = {
    Description = ''
      Enable or disable **automatic** application update.

      If set to true, application updates are installed without user approval within Firefox. The operating system might still require approval.

      If set to false, application updates are downloaded but the user can choose when to install the update.

      If you have disabled updates via `DisableAppUpdate`, this policy has no effect.

      **Compatibility:** Firefox 75, Firefox ESR 68.7
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `app.update.auto`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 75"
      "Firefox ESR 68.7"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "app.update.auto" ];
    Example = ''
      {
        "policies": {
          "AppAutoUpdate": true | false
        }
      }
    '';
  };
  AppUpdatePin = {
    Description = ''
      Prevent Firefox from being updated beyond the specified version.

      You can specify the version as ```xx.``` and Firefox will be updated with all minor versions, but will not be updated beyond the major version.

      You can also specify the version as ```xx.xx.``` and Firefox will be updated with all patch versions, but will not be updated beyond the minor version.

      Note: The value MUST end in a dot(.).

      You should specify a version that exists or is guaranteed to exist. If you specify a version that doesn't end up existing, Firefox will update beyond that version.

      **Compatibility:** Firefox 102,
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 102" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "AppUpdatePin": "106."
        }
      }
    '';
  };
  AppUpdateURL = {
    Description = ''
      Change the URL for application update if you are providing Firefox updates from a custom update server.

      **Compatibility:** Firefox 62, Firefox ESR 60.2
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `app.update.url`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 62"
      "Firefox ESR 60.2"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "app.update.url" ];
    Example = ''
      {
        "policies": {
          "AppUpdateURL": "https://yoursite.com"
        }
      }
    '';
  };
  Authentication = {
    Description = ''
      Configure sites that support integrated authentication.

      See [Integrated authentication](https://htmlpreview.github.io/?https://github.com/mdn/archived-content/blob/main/files/en-us/mozilla/integrated_authentication/raw.html) for more information.

      `PrivateBrowsing` enables integrated authentication in private browsing.

      **Compatibility:** Firefox 60, Firefox ESR 60 (AllowNonFQDN added in 62/60.2, AllowProxies added in 70/68.2, Locked added in 71/68.3, PrivateBrowsing added in 77/68.9)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.negotiate-auth.trusted-uris`,`network.negotiate-auth.delegation-uris`,`network.automatic-ntlm-auth.trusted-uris`,`network.automatic-ntlm-auth.allow-non-fqdn`,`network.negotiate-auth.allow-non-fqdn`,`network.automatic-ntlm-auth.allow-proxies`,`network.negotiate-auth.allow-proxies`,`network.auth.private-browsing-sso`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60 (AllowNonFQDN added in 62/60.2"
      "AllowProxies added in 70/68.2"
      "Locked added in 71/68.3"
      "PrivateBrowsing added in 77/68.9)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "network.negotiate-auth.trusted-uris"
      "network.negotiate-auth.delegation-uris"
      "network.automatic-ntlm-auth.trusted-uris"
      "network.automatic-ntlm-auth.allow-non-fqdn"
      "network.negotiate-auth.allow-non-fqdn"
      "network.automatic-ntlm-auth.allow-proxies"
      "network.negotiate-auth.allow-proxies"
      "network.auth.private-browsing-sso"
    ];
    Example = ''
      {
        "policies": {
          "Authentication": {
            "SPNEGO": [
              "mydomain.com",
              "https://myotherdomain.com"
            ],
            "Delegated": [
              "mydomain.com",
              "https://myotherdomain.com"
            ],
            "NTLM": [
              "mydomain.com",
              "https://myotherdomain.com"
            ],
            "AllowNonFQDN": {
              "SPNEGO": true | false,
              "NTLM": true | false
            },
            "AllowProxies": {
              "SPNEGO": true | false,
              "NTLM": true | false
            },
            "Locked": true | false,
            "PrivateBrowsing": true | false
          }
        }
      }
    '';
  };
  AutofillAddressEnabled = {
    Description = ''
      Enables or disables autofill for addresses.

      This only applies when address autofill is enabled for a particular Firefox version or region. See [this page](https://support.mozilla.org/kb/automatically-fill-your-address-web-forms) for more information.

      **Compatibility:** Firefox 125, Firefox ESR 115.10
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `extensions.formautofill.addresses.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 125"
      "Firefox ESR 115.10"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "extensions.formautofill.addresses.enabled" ];
    Example = ''
      {
        "policies": {
          "AutofillAddressEnabled": true | false
        }
      }
    '';
  };
  AutofillCreditCardEnabled = {
    Description = ''
      Enables or disables autofill for payment methods.

      This only applies when payment method autofill is enabled for a particular Firefox version or region. See [this page](https://support.mozilla.org/kb/credit-card-autofill) for more information.

      **Compatibility:** Firefox 125, Firefox ESR 115.10
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `extensions.formautofill.creditCards.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 125"
      "Firefox ESR 115.10"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "extensions.formautofill.creditCards.enabled" ];
    Example = ''
      {
        "policies": {
          "AutofillCreditCardEnabled": true | false
        }
      }
    '';
  };
  AutoLaunchProtocolsFromOrigins = {
    Description = ''
      Define a list of external protocols that can be used from listed origins without prompting the user. The origin is the scheme plus the hostname.

      The syntax of this policy is exactly the same as the [Chrome AutoLaunchProtocolsFromOrigins policy](https://chromeenterprise.google/policies/#AutoLaunchProtocolsFromOrigins) except that you can only use valid origins (not just hostnames). This also means that you cannot specify an asterisk for all origins.

      The schema is:
      ```
      {
      "items": {
      "properties": {
      "allowed_origins": {
      "items": {
      "type": "string"
      },
      "type": "array"
      },
      "protocol": {
      "type": "string"
      }
      },
      "required": [
      "protocol",
      "allowed_origins"
      ],
      "type": "object"
      },
      "type": "array"
      }
      ```
      **Compatibility:** Firefox 90, Firefox ESR 78.12
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 90"
      "Firefox ESR 78.12"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "AutoLaunchProtocolsFromOrigins": [
            {
              "protocol": "zoommtg",
              "allowed_origins": [
                "https://somesite.zoom.us"
              ]
            }
          ]
        }
      }
    '';
  };
  BackgroundAppUpdate = {
    Description = ''
      Enable or disable **automatic** application update **in the background**, when the application is not running.

      If set to true, application updates may be installed (without user approval) in the background, even when the application is not running. The operating system might still require approval.

      If set to false, the application will not try to install updates when the application is not running.

      If you have disabled updates via `DisableAppUpdate` or disabled automatic updates via `AppAutoUpdate`, this policy has no effect.

      If you are having trouble getting the background task to run, verify your configuration with the ["Requirements to run" section in this support document](https://support.mozilla.org/en-US/kb/enable-background-updates-firefox-windows).

      **Compatibility:** Firefox 90 (Windows only)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `app.update.background.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 90 (Windows only)" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "app.update.background.enabled" ];
    Example = ''
      {
        "policies": {
          "BackgroundAppUpdate": true | false
        }
      }
    '';
  };
  BlockAboutAddons = {
    Description = ''
      Block access to the Add-ons Manager (about:addons).

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableAddonsManager`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableAddonsManager" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "BlockAboutAddons": true | false
        }
      }
    '';
  };
  BlockAboutConfig = {
    Description = ''
      Block access to about:config.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableAboutConfig`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableAboutConfig" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "BlockAboutConfig": true | false
        }
      }
    '';
  };
  BlockAboutProfiles = {
    Description = ''
      Block access to About Profiles (about:profiles).

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableAboutProfiles`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableAboutProfiles" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "BlockAboutProfiles": true | false
        }
      }
    '';
  };
  BlockAboutSupport = {
    Description = ''
      Block access to Troubleshooting Information (about:support).

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableAboutSupport`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableAboutSupport" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "BlockAboutSupport": true | false
        }
      }
    '';
  };
  Bookmarks = {
    Description = ''
      Note: [`ManagedBookmarks`](#managedbookmarks) is the new recommended way to add bookmarks. This policy will continue to be supported.

      Add bookmarks in either the bookmarks toolbar or menu. Only `Title` and `URL` are required. If `Placement` is not specified, the bookmark will be placed on the toolbar. If `Folder` is specified, it is automatically created and bookmarks with the same folder name are grouped together.

      If you want to clear all bookmarks set with this policy, you can set the value to an empty array (```[]```). This can be on Windows via the new Bookmarks (JSON) policy available with GPO and Intune.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `bookmarks.toolbar`,`bookmarks.menu`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [
      "bookmarks.toolbar"
      "bookmarks.menu"
    ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "Bookmarks": [
            {
              "Title": "Example",
              "URL": "https://example.com",
              "Favicon": "https://example.com/favicon.ico",
              "Placement": "toolbar" | "menu",
              "Folder": "FolderName"
            }
          ]
        }
      }
    '';
  };
  BrowserDataBackup = {
    Description = ''
      Disable backup or restore of profile data. Backup and restore can be disabled individually.

      Note: The policy can be used to disable backup and restore if it would otherwise be enabled, but cannot be used to force backup or restore to be enabled under conditions where it would not otherwise be (such as a platform on which backup or restore are not yet supported).

      **Compatibility:** Firefox 146
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A\
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 146" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "BrowserDataBackup": {
            "AllowBackup": true | false,
            "AllowRestore": true | false
          }
        }
      }
    '';
  };
  CaptivePortal = {
    Description = ''
      Enable or disable the detection of captive portals.

      **Compatibility:** Firefox 67, Firefox ESR 60.7
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.captive-portal-service.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 67"
      "Firefox ESR 60.7"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "network.captive-portal-service.enabled" ];
    Example = ''
      {
        "policies": {
          "CaptivePortal": true | false
        }
      }
    '';
  };
  Certificates = {
    Description = ''

    '';
    Deprecated = false;
    Children = [
      "ImportEnterpriseRoots"
      "Install"
    ];
    ImportEnterpriseRoots = {
      Description = ''
        Trust certificates that have been added to the operating system certificate store by a user or administrator.

        Note: This policy only works on Windows and macOS. For Linux discussion, see [bug 1600509](https://bugzilla.mozilla.org/show_bug.cgi?id=1600509).

        See https://support.mozilla.org/kb/setting-certificate-authorities-firefox for more detail.

        **Compatibility:** Firefox 60, Firefox ESR 60 (macOS support in Firefox 63, Firefox ESR 68)
        **CCK2 Equivalent:** N/A
        **Preferences Affected:** `security.enterprise_roots.enabled`
      '';
      Deprecated = false;
      Children = [ ];
      Compatibility = [
        "Firefox 60"
        "Firefox ESR 60 (macOS support in Firefox 63"
        "Firefox ESR 68)"
      ];
      "CCK2-Equivalent" = [ ];
      "Preferences-Affected" = [ "security.enterprise_roots.enabled" ];
      Example = ''
        {
          "policies": {
            "Certificates": {
              "ImportEnterpriseRoots": true | false
            }
          }
        }
      '';
    };
    Install = {
      Description = ''
        Install certificates into the Firefox certificate store. If only a filename is specified, Firefox searches for the file in the following locations:

        - Windows
        - %USERPROFILE%\AppData\Local\Mozilla\Certificates
        - %USERPROFILE%\AppData\Roaming\Mozilla\Certificates
        - macOS
        - /Library/Application Support/Mozilla/Certificates
        - ~/Library/Application Support/Mozilla/Certificates
        - Linux
        - /usr/lib/mozilla/certificates
        - /usr/lib64/mozilla/certificates
        - ~/.mozilla/certificates

        Starting with Firefox 65, Firefox 60.5 ESR, a fully qualified path can be used, including UNC paths. You should use the native path style for your operating system. We do not support using %USERPROFILE% or other environment variables on Windows.

        If you are specifying the path in the policies.json file on Windows, you need to escape your backslashes (`\\`) which means that for UNC paths, you need to escape both (`\\\\`). If you use group policy, you only need one backslash.

        Certificates are installed using the trust string `CT,CT,`.

        Binary (DER) and ASCII (PEM) certificates are both supported.

        **Compatibility:** Firefox 64, Firefox ESR 64
        **CCK2 Equivalent:** `certs.ca`
        **Preferences Affected:** N/A
      '';
      Deprecated = false;
      Children = [ ];
      Compatibility = [
        "Firefox 64"
        "Firefox ESR 64"
      ];
      "CCK2-Equivalent" = [ "certs.ca" ];
      "Preferences-Affected" = [ ];
      Example = ''
        {
          "policies": {
            "Certificates": {
              "Install": [
                "cert1.der",
                "/home/username/cert2.pem"
              ]
            }
          }
        }
      '';
    };
  };
  Containers = {
    Description = ''
      Set policies related to [containers](https://addons.mozilla.org/firefox/addon/multi-account-containers/).

      Currently you can set the initial set of containers.

      For each container, you can specify the name, icon, and color.

      | Name | Description |
      | --- | --- |
      | `name`| Name of container
      | `icon` | Can be `fingerprint`, `briefcase`, `dollar`, `cart`, `vacation`, `gift`, `food`, `fruit`, `pet`, `tree`, `chill`, `circle`, `fence`
      | `color` | Can be `blue`, `turquoise`, `green`, `yellow`, `orange`, `red`, `pink`, `purple`, `toolbar`

      **Compatibility:** Firefox 113
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 113" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "Containers": {
            "Default": [
              {
                "name": "My container",
                "icon": "pet",
                "color": "turquoise"
              }
            ]
          }
        }
      }
    '';
  };
  ContentAnalysis = {
    Description = ''
      Configure Firefox to use an agent for Data Loss Prevention (DLP) that is compatible with the [Google Chrome Content Analysis Connector Agent SDK](https://github.com/chromium/content_analysis_sdk).

      `AgentName` is the name of the DLP agent. This is used in dialogs and notifications about DLP operations. The default is "A DLP Agent".

      `AgentTimeout` is the timeout in number of seconds after a DLP request is sent to the agent. After this timeout, the request will be denied unless `TimeoutResult` is set to 1 or 2. The default is 300.

      `AllowUrlRegexList` is a space-separated list of regular expressions that indicates URLs for which DLP operations will always be allowed without consulting the agent. The default is "^about:(?!blank&#124;srcdoc).*", meaning that any pages that start with "about:" will be exempt from DLP except for "about:blank" and "about:srcdoc", as these can be controlled by web content.

      `BypassForSameTabOperations` indicates whether Firefox will automatically allow DLP requests whose data comes from the same tab and frame - for example, if data is copied to the clipboard and then pasted on the same page. The default is false.

      `ClientSignature` indicates the required signature of the DLP agent connected to the pipe. If this is a non-empty string and the DLP agent does not have a signature with a Subject Name that exactly matches this value, Firefox will not connect to the pipe. The default is the empty string.

      `DefaultResult` indicates the desired behavior for DLP requests if there is a problem connecting to the DLP agent. The default is 0.

      | Value | Description
      | --- | --- |
      | 0 | Deny the request (default)
      | 1 | Warn the user and allow them to choose whether to allow or deny
      | 2 | Allow the request

      `DenyUrlRegexList` is a space-separated list of regular expressions that indicates URLs for which DLP operations will always be denied without consulting the agent. The default is the empty string.

      `Enabled` indicates whether Firefox should use DLP. Note that if this value is true and no DLP agent is running, all DLP requests will be denied unless `DefaultResult` is set to 1 or 2.

      `InterceptionPoints` controls settings for specific interception points.

      * The `Clipboard` entry controls clipboard operations for files and text.
      * `Enabled` indicates whether clipboard operations should use DLP. The default is true.
      * `PlainTextOnly` indicates whether to only analyze the text/plain format on the clipboard. If this
      value is false, all formats will be analyzed, which some DLP agents may not expect. Regardless of
      this value, files will be analyzed as usual. The default is true.
      * The `Download` entry controls download operations. (Added in Firefox 142, Firefox ESR 140.2)
      * `Enabled` indicates whether download operations should use DLP. The default is false.
      * The `DragAndDrop` entry controls drag and drop operations for files and text.
      * `Enabled` indicates whether drag and drop operations should use DLP. The default is true.
      * `PlainTextOnly` indicates whether to only analyze the text/plain format in what is being dropped.
      If this value is false, all formats will be analyzed, which some DLP agents may not expect.
      Regardless of this value, files will be analyzed as usual. The default is true.
      * The `FileUpload` entry controls file upload operations for files chosen from the file picker.
      * `Enabled` indicates whether file upload operations should use DLP. The default is true.
      * The `Print` entry controls print operation.
      * `Enabled` indicates whether print operations should use DLP. The default is true.

      `IsPerUser` indicates whether the pipe the DLP agent has created is per-user or per-system. The default is true, meaning per-user.

      `PipePathName` is the name of the pipe the DLP agent has created and Firefox will connect to. The default is "path_user".

      `ShowBlockedResult` indicates whether Firefox should show a notification when a DLP request is denied. The default is true.

      `TimeoutResult` indicates the desired behavior for DLP requests if the DLP agent does not respond to a request in less than `AgentTimeout` seconds. The default is 0.

      | Value | Description
      | --- | --- |
      | 0 | Deny the request (default)
      | 1 | Warn the user and allow them to choose whether to allow or deny
      | 2 | Allow the request


      **Compatibility:** Firefox 137
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.contentanalysis.agent_name`, `browser.contentanalysis.agent_timeout`, `browser.contentanalysis.allow_url_regex_list`, `browser.contentanalysis.bypass_for_same_tab_operations`, `browser.contentanalysis.client_signature`, `browser.contentanalysis.default_result`, `browser.contentanalysis.deny_url_regex_list`, `browser.contentanalysis.enabled`, `browser.contentanalysis.interception_point.clipboard.enabled`, `browser.contentanalysis.interception_point.clipboard.plain_text_only`, `browser.contentanalysis.interception_point.download.enabled`, `browser.contentanalysis.interception_point.drag_and_drop.enabled`, `browser.contentanalysis.interception_point.drag_and_drop.plain_text_only`, `browser.contentanalysis.interception_point.file_upload.enabled`, `browser.contentanalysis.interception_point.print.enabled`, `browser.contentanalysis.is_per_user`, `browser.contentanalysis.pipe_path_name`, `browser.contentanalysis.show_blocked_result`, `browser.contentanalysis.timeout_result`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 137" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.contentanalysis.agent_name"
      "browser.contentanalysis.agent_timeout"
      "browser.contentanalysis.allow_url_regex_list"
      "browser.contentanalysis.bypass_for_same_tab_operations"
      "browser.contentanalysis.client_signature"
      "browser.contentanalysis.default_result"
      "browser.contentanalysis.deny_url_regex_list"
      "browser.contentanalysis.enabled"
      "browser.contentanalysis.interception_point.clipboard.enabled"
      "browser.contentanalysis.interception_point.clipboard.plain_text_only"
      "browser.contentanalysis.interception_point.download.enabled"
      "browser.contentanalysis.interception_point.drag_and_drop.enabled"
      "browser.contentanalysis.interception_point.drag_and_drop.plain_text_only"
      "browser.contentanalysis.interception_point.file_upload.enabled"
      "browser.contentanalysis.interception_point.print.enabled"
      "browser.contentanalysis.is_per_user"
      "browser.contentanalysis.pipe_path_name"
      "browser.contentanalysis.show_blocked_result"
      "browser.contentanalysis.timeout_result"
    ];
    Example = ''
      {
        "policies": {
          "ContentAnalysis": {
            "AgentName": "My DLP Product",
            "AgentTimeout": 60,
            "AllowUrlRegexList": "https://example\.com/.* https://subdomain\.example\.com/.*",
            "BypassForSameTabOperations": true | false,
            "ClientSignature": "My DLP Company",
            "DefaultResult": 0 | 1 | 2,
            "DenyUrlRegexList": "https://example\.com/.* https://subdomain\.example\.com/.*",
            "Enabled": true | false,
            "InterceptionPoints": {
              "Clipboard": {
                "Enabled": true | false,
                "PlainTextOnly": true | false
              },
              "Download": {
                "Enabled": false | true,

              },
              "DragAndDrop": {
                "Enabled": true | false,
                "PlainTextOnly": true | false
              },
              "FileUpload": {
                "Enabled": true | false
              },
              "Print": {
                "Enabled": true | false
              }
            },
            "IsPerUser": true | false,
            "PipePathName": "pipe_custom_name",
            "ShowBlockedResult": true | false,
            "TimeoutResult": 0 | 1 | 2,

          }
        }
      }
    '';
  };
  Cookies = {
    Description = ''
      Configure cookie preferences.

      `Allow` is a list of origins (not domains) where cookies are always allowed. You must include http or https.

      `AllowSession` is a list of origins (not domains) where cookies are only allowed for the current session. You must include http or https.

      `Block` is a list of origins (not domains) where cookies are always blocked. You must include http or https.

      `Behavior` sets the default behavior for cookies based on the values below.

      `BehaviorPrivateBrowsing` sets the default behavior for cookies in private browsing based on the values below.

      | Value | Description
      | --- | --- |
      | accept | Accept all cookies
      | reject-foreign | Reject third party cookies
      | reject | Reject all cookies
      | limit-foreign | Reject third party cookies for sites you haven't visited
      | reject-tracker | Reject cookies for known trackers (default)
      | reject-tracker-and-partition-foreign | Reject cookies for known trackers and partition third-party cookies (Total Cookie Protection) (default for private browsing)

      `Locked` prevents the user from changing cookie preferences.

      `Default` determines whether cookies are accepted at all. (*Deprecated*. Use `Behavior` instead)

      `AcceptThirdParty` determines how third-party cookies are handled. (*Deprecated*. Use `Behavior` instead)

      `RejectTracker` only rejects cookies for trackers. (*Deprecated*. Use `Behavior` instead)

      `ExpireAtSessionEnd` determines when cookies expire. (*Deprecated*. Use [`SanitizeOnShutdown`](#sanitizeonshutdown-selective) instead)

      **Compatibility:** Firefox 60, Firefox ESR 60 (RejectTracker added in Firefox 63, AllowSession added in Firefox 79/78.1, Behavior added in Firefox 95/91.4)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.cookie.cookieBehavior`, `network.cookie.cookieBehavior.pbmode`, `network.cookie.lifetimePolicy`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60 (RejectTracker added in Firefox 63"
      "AllowSession added in Firefox 79/78.1"
      "Behavior added in Firefox 95/91.4)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "network.cookie.cookieBehavior"
      "network.cookie.cookieBehavior.pbmode"
      "network.cookie.lifetimePolicy"
    ];
    Example = ''
      {
        "policies": {
          "Cookies": {
            "Allow": [
              "http://example.org/"
            ],
            "AllowSession": [
              "http://example.edu/"
            ],
            "Block": [
              "http://example.edu/"
            ],
            "Locked": true | false,
            "Behavior": "accept" | "reject-foreign" | "reject" | "limit-foreign" | "reject-tracker" | "reject-tracker-and-partition-foreign",
            "BehaviorPrivateBrowsing": "accept" | "reject-foreign" | "reject" | "limit-foreign" | "reject-tracker" | "reject-tracker-and-partition-foreign",

          }
        }
      }
    '';
  };
  DefaultDownloadDirectory = {
    Description = ''
      Set the default download directory.

      You can use \''${home} for the native home directory.

      **Compatibility:** Firefox 68, Firefox ESR 68
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.download.dir`, `browser.download.folderList`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68"
      "Firefox ESR 68"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.download.dir"
      "browser.download.folderList"
    ];
    Example = ''
      {
        "policies": {
          "DefaultDownloadDirectory": "\''${home}/Downloads"
        }
      }
    '';
  };
  DisableAppUpdate = {
    Description = ''
      Turn off application updates within Firefox.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableFirefoxUpdates`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableFirefoxUpdates" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableAppUpdate": true | false
        }
      }
    '';
  };
  DisableBuiltinPDFViewer = {
    Description = ''
      Disable the built in PDF viewer. PDF files are downloaded and sent externally.

      Note: As of Firefox 140, this policy no longer completely disables PDF.js; it changes the handler to send PDF files to the operating system. Embedded PDF files are shown in the browser. If you need to completely disable PDF.js, you can use the [`PDFjs`](#pdfjs) policy.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disablePDFjs`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disablePDFjs" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableBuiltinPDFViewer": true | false
        }
      }
    '';
  };
  DisabledCiphers = {
    Description = ''
      Disable specific cryptographic ciphers, listed below.

      ```
      TLS_DHE_RSA_WITH_AES_128_CBC_SHA
      TLS_DHE_RSA_WITH_AES_256_CBC_SHA
      TLS_RSA_WITH_AES_128_CBC_SHA
      TLS_RSA_WITH_AES_256_CBC_SHA
      TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
      TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
      TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
      TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
      TLS_RSA_WITH_3DES_EDE_CBC_SHA
      TLS_RSA_WITH_AES_128_GCM_SHA256 (Firefox 78)
      TLS_RSA_WITH_AES_256_GCM_SHA384 (Firefox 78)
      TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256 (Firefox 97 and Firefox ESR 91.6)
      TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (Firefox 97 and Firefox ESR 91.6)
      TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 (Firefox 97 and Firefox ESR 91.6)
      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Firefox 97 and Firefox ESR 91.6)
      TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA (Firefox 97 and Firefox ESR 91.6)
      TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA (Firefox 97 and Firefox ESR 91.6)
      TLS_CHACHA20_POLY1305_SHA256 (Firefox 138, Firefox ESR 128.10)
      TLS_AES_128_GCM_SHA256 (Firefox 138, Firefox ESR 128.10)
      TLS_AES_256_GCM_SHA384 (Firefox 138, Firefox ESR 128.10)
      ```

      **Preferences Affected:** `security.ssl3.ecdhe_rsa_aes_128_gcm_sha256`, `security.ssl3.ecdhe_ecdsa_aes_128_gcm_sha256`, `security.ssl3.ecdhe_ecdsa_chacha20_poly1305_sha256`, `security.ssl3.ecdhe_rsa_chacha20_poly1305_sha256`, `security.ssl3.ecdhe_ecdsa_aes_256_gcm_sha384`, `security.ssl3.ecdhe_rsa_aes_256_gcm_sha384`, `security.ssl3.ecdhe_rsa_aes_128_sha`, `security.ssl3.ecdhe_ecdsa_aes_128_sha`, `security.ssl3.ecdhe_rsa_aes_256_sha`, `security.ssl3.ecdhe_ecdsa_aes_256_sha`, `security.ssl3.dhe_rsa_aes_128_sha`, `security.ssl3.dhe_rsa_aes_256_sha`, `security.ssl3.rsa_aes_128_gcm_sha256`, `security.ssl3.rsa_aes_256_gcm_sha384`, `security.ssl3.rsa_aes_128_sha`, `security.ssl3.rsa_aes_256_sha`, `security.ssl3.deprecated.rsa_des_ede3_sha`, `security.tls13.chacha20_poly1305_sha256`, `security.tls13.aes_128_gcm_sha256`, `security.tls13.aes_256_gcm_sha384`

      ---
      **Note:**

      This policy was updated in Firefox 78 to allow enabling ciphers as well. Setting the value to true disables the cipher, setting the value to false enables the cipher. Previously setting the value to true or false disabled the cipher.

      ---
      **Compatibility:** Firefox 76, Firefox ESR 68.8
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 76"
      "Firefox ESR 68.8"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "security.ssl3.ecdhe_rsa_aes_128_gcm_sha256"
      "security.ssl3.ecdhe_ecdsa_aes_128_gcm_sha256"
      "security.ssl3.ecdhe_ecdsa_chacha20_poly1305_sha256"
      "security.ssl3.ecdhe_rsa_chacha20_poly1305_sha256"
      "security.ssl3.ecdhe_ecdsa_aes_256_gcm_sha384"
      "security.ssl3.ecdhe_rsa_aes_256_gcm_sha384"
      "security.ssl3.ecdhe_rsa_aes_128_sha"
      "security.ssl3.ecdhe_ecdsa_aes_128_sha"
      "security.ssl3.ecdhe_rsa_aes_256_sha"
      "security.ssl3.ecdhe_ecdsa_aes_256_sha"
      "security.ssl3.dhe_rsa_aes_128_sha"
      "security.ssl3.dhe_rsa_aes_256_sha"
      "security.ssl3.rsa_aes_128_gcm_sha256"
      "security.ssl3.rsa_aes_256_gcm_sha384"
      "security.ssl3.rsa_aes_128_sha"
      "security.ssl3.rsa_aes_256_sha"
      "security.ssl3.deprecated.rsa_des_ede3_sha"
      "security.tls13.chacha20_poly1305_sha256"
      "security.tls13.aes_128_gcm_sha256"
      "security.tls13.aes_256_gcm_sha384"
    ];
    Example = ''
      {
        "policies": {
          "DisabledCiphers": {
            "CIPHER_NAME": true | false,

          }
        }
      }
    '';
  };
  DisableDefaultBrowserAgent = {
    Description = ''
      Prevent the default browser agent from taking any actions. Only applicable to Windows; other platforms don\u2019t have the agent.

      The browser agent is a Windows-only scheduled task which runs in the background to collect and submit data about the browser that the user has set as their OS default. More information is available [here](https://firefox-source-docs.mozilla.org/toolkit/mozapps/defaultagent/default-browser-agent/index.html).

      **Compatibility:** Firefox 75, Firefox ESR 68.7 (Windows only)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 75"
      "Firefox ESR 68.7 (Windows only)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableDefaultBrowserAgent": true | false
        }
      }
    '';
  };
  DisableDeveloperTools = {
    Description = ''
      Remove access to all developer tools.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `removeDeveloperTools`
      **Preferences Affected:** `devtools.policy.disabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "removeDeveloperTools" ];
    "Preferences-Affected" = [ "devtools.policy.disabled" ];
    Example = ''
      {
        "policies": {
          "DisableDeveloperTools": true | false
        }
      }
    '';
  };
  DisableFeedbackCommands = {
    Description = ''
      Disable the menus for reporting sites (Submit Feedback, Report Deceptive Site).

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableFeedbackCommands": true | false
        }
      }
    '';
  };
  DisableEncryptedClientHello = {
    Description = ''
      Disable the TLS Feature for Encrypted Client Hello. Note that TLS Client Hellos will still contain an ECH extension, but this extension will not be used by Firefox during the TLS handshake.

      **Compatibility:** Firefox 127, Firefox ESR 128
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.dns.echconfig.enabled`, `network.dns.http3_echconfig.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 127"
      "Firefox ESR 128"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "network.dns.echconfig.enabled"
      "network.dns.http3_echconfig.enabled"
    ];
    Example = ''
      {
        "policies": {
          "DisableEncryptedClientHello": true | false
        }
      }
    '';
  };
  DisableFirefoxAccounts = {
    Description = ''
      Disable Firefox Accounts integration (Sync).

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableSync`
      **Preferences Affected:** `identity.fxaccounts.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableSync" ];
    "Preferences-Affected" = [ "identity.fxaccounts.enabled" ];
    Example = ''
      {
        "policies": {
          "DisableFirefoxAccounts": true | false
        }
      }
    '';
  };
  DisableFirefoxScreenshots = {
    Description = ''
      Remove access to Firefox Screenshots.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `extensions.screenshots.disabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "extensions.screenshots.disabled" ];
    Example = ''
      {
        "policies": {
          "DisableFirefoxScreenshots": true | false
        }
      }
    '';
  };
  DisableFirefoxStudies = {
    Description = ''
      Disable Firefox studies (Shield).

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons`, `browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features"
    ];
    Example = ''
      {
        "policies": {
          "DisableFirefoxStudies": true | false
        }
      }
    '';
  };
  DisableForgetButton = {
    Description = ''
      Disable the "Forget" button.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableForget`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableForget" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableForgetButton": true | false
        }
      }
    '';
  };
  DisableFormHistory = {
    Description = ''
      Turn off saving information on web forms and the search bar.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableFormFill`
      **Preferences Affected:** `browser.formfill.enable`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableFormFill" ];
    "Preferences-Affected" = [ "browser.formfill.enable" ];
    Example = ''
      {
        "policies": {
          "DisableFormHistory": true | false
        }
      }
    '';
  };
  DisableMasterPasswordCreation = {
    Description = ''
      Remove the master password functionality.

      If this value is true, it works the same as setting [`PrimaryPassword`](#primarypassword) to false and removes the primary password functionality.

      If both `DisableMasterPasswordCreation` and `PrimaryPassword` are used, `DisableMasterPasswordCreation` takes precedent.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `noMasterPassword`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "noMasterPassword" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableMasterPasswordCreation": true | false
        }
      }
    '';
  };
  DisablePasswordReveal = {
    Description = ''
      Do not allow passwords to be shown in saved logins

      **Compatibility:** Firefox 71, Firefox ESR 68.3
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 71"
      "Firefox ESR 68.3"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisablePasswordReveal": true | false
        }
      }
    '';
  };
  DisablePocket = {
    Description = ''
      Remove Pocket in the Firefox UI. It does not remove it from the new tab page.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disablePocket`
      **Preferences Affected:** `extensions.pocket.enabled`
    '';
    Deprecated = true;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disablePocket" ];
    "Preferences-Affected" = [ "extensions.pocket.enabled" ];
    Example = ''
      {
        "policies": {
          "DisablePocket": true | false
        }
      }
    '';
  };
  DisablePrivateBrowsing = {
    Description = ''
      Remove access to private browsing.

      This policy is superseded by [`PrivateBrowsingModeAvailability`](#privatebrowsingmodeavailability)

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disablePrivateBrowsing`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disablePrivateBrowsing" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisablePrivateBrowsing": true | false
        }
      }
    '';
  };
  DisableProfileImport = {
    Description = ''
      Remove the ability to import data from other browers.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableProfileImport": true | false
        }
      }
    '';
  };
  DisableProfileRefresh = {
    Description = ''
      Disable the Refresh Firefox button on about:support and support.mozilla.org, as well as the prompt that displays offering to refresh Firefox when you haven't used it in a while.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableResetFirefox`
      **Preferences Affected:** `browser.disableResetPrompt`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableResetFirefox" ];
    "Preferences-Affected" = [ "browser.disableResetPrompt" ];
    Example = ''
      {
        "policies": {
          "DisableProfileRefresh": true | false
        }
      }
    '';
  };
  DisableRemoteImprovements = {
    Description = ''
      Prevent Firefox from applying performance, stability, and feature changes between updates.

      For more information, see [Manage remote improvements settings in Firefox](https://support.mozilla.org/en-US/kb/remote-improvements).

      Note: This policy is not correctly reflected in preferences. This will be fixed soon.

      **Compatibility:** Firefox 148
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 148" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableRemoteImprovements": true | false
        }
      }
    '';
  };
  DisableSafeMode = {
    Description = ''
      Disable safe mode within the browser.

      On Windows, this disables safe mode via the command line as well.

      **Compatibility:** Firefox 60, Firefox ESR 60 (Windows, macOS)
      **CCK2 Equivalent:** `disableSafeMode`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60 (Windows"
      "macOS)"
    ];
    "CCK2-Equivalent" = [ "disableSafeMode" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableSafeMode": true | false
        }
      }
    '';
  };
  DisableSecurityBypass = {
    Description = ''
      Prevent the user from bypassing security in certain cases.

      `InvalidCertificate` prevents adding an exception when an invalid certificate is shown.

      `SafeBrowsing` prevents selecting "ignore the risk" and visiting a harmful site anyway.

      These policies only affect what happens when an error is shown, they do not affect any settings in preferences.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `security.certerror.hideAddException`, `browser.safebrowsing.allowOverride`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "security.certerror.hideAddException"
      "browser.safebrowsing.allowOverride"
    ];
    Example = ''
      {
        "policies": {
          "DisableSecurityBypass": {
            "InvalidCertificate": true | false,
            "SafeBrowsing": true | false
          }
        }
      }
    '';
  };
  DisableSetDesktopBackground = {
    Description = ''
      Remove the "Set As Desktop Background..." menuitem when right clicking on an image.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `removeSetDesktopBackground`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "removeSetDesktopBackground" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableSetDesktopBackground": true | false
        }
      }
    '';
  };
  DisableSystemAddonUpdate = {
    Description = ''
      Prevent system add-ons from being installed or updated.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisableSystemAddonUpdate": true | false
        }
      }
    '';
  };
  DisableTelemetry = {
    Description = ''
      Prevent the upload of telemetry data.

      As of Firefox 83 and Firefox ESR 78.5, local storage of telemetry data is disabled as well.

      Mozilla recommends that you do not disable telemetry. Information collected through telemetry helps us build a better product for businesses like yours.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `disableTelemetry`
      **Preferences Affected:** `datareporting.healthreport.uploadEnabled`, `datareporting.policy.dataSubmissionEnabled`, `toolkit.telemetry.archive.enabled`, `datareporting.usage.uploadEnabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "disableTelemetry" ];
    "Preferences-Affected" = [
      "datareporting.healthreport.uploadEnabled"
      "datareporting.policy.dataSubmissionEnabled"
      "toolkit.telemetry.archive.enabled"
      "datareporting.usage.uploadEnabled"
    ];
    Example = ''
      {
        "policies": {
          "DisableTelemetry": true | false
        }
      }
    '';
  };
  DisableThirdPartyModuleBlocking = {
    Description = ''
      Do not allow blocking third-party modules from the `about:third-party` page.

      This policy only works on Windows through GPO (not policies.json).

      **Compatibility:** Firefox 110 (Windows only, GPO only)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 110 (Windows only"
      "GPO only)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
  };
  DisplayBookmarksToolbar = {
    Description = ''
      Set the initial state of the bookmarks toolbar. A user can still change how it is displayed.

      `always` means the bookmarks toolbar is always shown.

      `never` means the bookmarks toolbar is not shown.

      `newtab` means the bookmarks toolbar is only shown on the new tab page.

      **Compatibility:** Firefox 109, Firefox ESR 102.7
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 109"
      "Firefox ESR 102.7"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisplayBookmarksToolbar": "always" | "never" | "newtab"
        }
      }
    '';
  };
  DisplayMenuBar = {
    Description = ''
      Set the state of the menubar.

      `always` means the menubar is shown and cannot be hidden.

      `never` means the menubar is hidden and cannot be shown.

      `default-on` means the menubar is on by default but can be hidden.

      `default-off` means the menubar is off by default but can be shown.

      **Compatibility:** Firefox 73, Firefox ESR 68.5 (Windows, some Linux)
      **CCK2 Equivalent:** `displayMenuBar`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 73"
      "Firefox ESR 68.5 (Windows"
      "some Linux)"
    ];
    "CCK2-Equivalent" = [ "displayMenuBar" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "DisplayMenuBar": "always",
          "never",
          "default-on",
          "default-off"
        }
      }
    '';
  };
  DNSOverHTTPS = {
    Description = ''
      Configure DNS over HTTPS.

      `Enabled` determines whether DNS over HTTPS is enabled

      `ProviderURL` is a URL to another provider.

      `Locked` prevents the user from changing DNS over HTTPS preferences.

      `ExcludedDomains` excludes domains from DNS over HTTPS.

      `Fallback` determines whether or not Firefox will use your default DNS resolver if there is a problem with the secure DNS provider.

      **Compatibility:** Firefox 63, Firefox ESR 68 (ExcludedDomains added in 75/68.7) (Fallback added in 124)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.trr.mode`, `network.trr.uri`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 63"
      "Firefox ESR 68 (ExcludedDomains added in 75/68.7) (Fallback added in 124)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "network.trr.mode"
      "network.trr.uri"
    ];
    Example = ''
      {
        "policies": {
          "DNSOverHTTPS": {
            "Enabled": true | false,
            "ProviderURL": "URL_TO_ALTERNATE_PROVIDER",
            "Locked": true | false,
            "ExcludedDomains": [
              "example.com"
            ],
            "Fallback": true | false,

          }
        }
      }
    '';
  };
  DontCheckDefaultBrowser = {
    Description = ''
      Don't check if Firefox is the default browser at startup.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `dontCheckDefaultBrowser`
      **Preferences Affected:** `browser.shell.checkDefaultBrowser`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "dontCheckDefaultBrowser" ];
    "Preferences-Affected" = [ "browser.shell.checkDefaultBrowser" ];
    Example = ''
      {
        "policies": {
          "DontCheckDefaultBrowser": true | false
        }
      }
    '';
  };
  DownloadDirectory = {
    Description = ''
      Set and lock the download directory.

      You can use \''${home} for the native home directory.

      **Compatibility:** Firefox 68, Firefox ESR 68
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.download.dir`, `browser.download.folderList`, `browser.download.useDownloadDir`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68"
      "Firefox ESR 68"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.download.dir"
      "browser.download.folderList"
      "browser.download.useDownloadDir"
    ];
    Example = ''
      {
        "policies": {
          "DownloadDirectory": "\''${home}/Downloads"
        }
    '';
  };
  EnableTrackingProtection = {
    Description = ''
      Configure tracking protection.

      If this policy is not configured, tracking protection is not enabled by default in the browser, but it is enabled by default in private browsing and the user can change it.

      If `Value` is set to false, tracking protection is disabled and locked in both the regular browser and private browsing.

      If `Value` is set to true, tracking protection is enabled by default in both the regular browser and private browsing.

      If `Locked` is set to true, users cannot change tracking protection values.

      If `Cryptomining` is set to true, cryptomining scripts on websites are blocked.

      If `Fingerprinting` is set to true, fingerprinting scripts on websites are blocked.

      If `EmailTracking` is set to true, hidden email tracking pixels and scripts on websites are blocked. (Firefox 112)

      If `SuspectedFingerprinting` is set to true, Firefox reduces the amount of information exposed to websites to protect against potential fingerprinting attempts. (Firefox 142, Firefox ESR 140.2)

      `Exceptions` are origins for which tracking protection is not enabled.

      `Category` can be either ```strict``` or ```standard```. If category is set, it overrides all other settings except `Exceptions`, `BaselineExceptions` and `ConvenienceExceptions`, and the user cannot change the category. (Firefox 142, Firefox ESR 140.2)

      IF `BaselineExceptions` is true, Firefox will automatically apply exceptions required to avoid major website breakage. (Firefox 145)

      If `ConvenienceExceptions`is true, Firefox will apply exceptions automatically that are only required to fix minor issues and make convenience features available. (Firefox 145)

      Note: Users can change `BaselineExceptions` and `ConvenienceExceptions` even when `Category` is set to ```strict``` unless `Locked` is set to true. If `Locked` is set to true, the defaults are used unless a different value is specified in policy for `BaselineExceptions` and `ConvenienceExceptions`.

      **Compatibility:** Firefox 60, Firefox ESR 60 (Cryptomining and Fingerprinting added in 70/68.2, Exceptions added in 73/68.5. Category added in Firefox 142/140.2. BaselineExceptions and ConvenienceExceptions added in Firefox 145)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `privacy.trackingprotection.enabled`, `privacy.trackingprotection.pbmode.enabled`, `privacy.trackingprotection.cryptomining.enabled`, `privacy.trackingprotection.fingerprinting.enabled`, `privacy.fingerprintingProtection`, `privacy.trackingprotection.emailtracking.enabled`, `privacy.trackingprotection.emailtracking.pbmode.enabled`, `privacy.trackingprotection.allow_list.baseline.enabled`, `privacy.trackingprotection.allow_list.convenience.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60 (Cryptomining and Fingerprinting added in 70/68.2"
      "Exceptions added in 73/68.5. Category added in Firefox 142/140.2. BaselineExceptions and ConvenienceExceptions added in Firefox 145)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "privacy.trackingprotection.enabled"
      "privacy.trackingprotection.pbmode.enabled"
      "privacy.trackingprotection.cryptomining.enabled"
      "privacy.trackingprotection.fingerprinting.enabled"
      "privacy.fingerprintingProtection"
      "privacy.trackingprotection.emailtracking.enabled"
      "privacy.trackingprotection.emailtracking.pbmode.enabled"
      "privacy.trackingprotection.allow_list.baseline.enabled"
      "privacy.trackingprotection.allow_list.convenience.enabled"
    ];
    Example = ''
      {
        "policies": {
          "EnableTrackingProtection": {
            "Value": true | false,
            "Locked": true | false,
            "Cryptomining": true | false,
            "Fingerprinting": true | false,
            "EmailTracking": true | false,
            "SuspectedFingerprinting": true | false,
            "Category": "strict" | "standard",
            "Exceptions": [
              "https://example.com"
            ],
            "BaselineExceptions": true | false,
            "ConvenienceExceptions": true | false
          }
        }
      }
    '';
  };
  EncryptedMediaExtensions = {
    Description = ''
      Enable or disable Encrypted Media Extensions and optionally lock it.

      If `Enabled` is set to false, encrypted media extensions (like Widevine) are not downloaded by Firefox unless the user consents to installing them.

      If `Locked` is set to true and `Enabled` is set to false, Firefox will not download encrypted media extensions (like Widevine) or ask the user to install them.

      **Compatibility:** Firefox 77, Firefox ESR 68.9
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `media.eme.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 77"
      "Firefox ESR 68.9"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "media.eme.enabled" ];
    Example = ''
      {
        "policies": {
          "EncryptedMediaExtensions": {
            "Enabled": true | false,
            "Locked": true | false
          }
        }
      }
    '';
  };
  EnterprisePoliciesEnabled = {
    Description = ''
      Enable policy support on macOS.

      **Compatibility:** Firefox 63, Firefox ESR 60.3 (macOS only)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 63"
      "Firefox ESR 60.3 (macOS only)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
  };
  ExemptDomainFileTypePairsFromFileTypeDownloadWarnings = {
    Description = ''
      Disable warnings based on file extension for specific file types on domains.

      This policy is based on the [Chrome policy](https://chromeenterprise.google/policies/#ExemptDomainFileTypePairsFromFileTypeDownloadWarnings) of the same name.

      Important: The documentation for the policy for both Edge and Chrome is incorrect. The ```domains``` value must be a domain, not a URL pattern. Also, we do not support using ```*``` to mean all domains.

      **Compatibility:** Firefox 102
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 102" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "ExemptDomainFileTypePairsFromFileTypeDownloadWarnings": [
            {
              "file_extension": "jnlp",
              "domains": [
                "example.com"
              ]
            }
          ]
        }
      }
    '';
  };
  Extensions = {
    Description = ''
      Control the installation, uninstallation and locking of extensions.

      Note: The **[`ExtensionSettings`](#extensionsettings)** policy was added in Firefox 69. It provides additional functionality and is closer in compatibility to Chrome and Edge. It does not support native paths, though, so you'll have to use file:/// URLs. I'd recommend trying it before using this policy. Any future improvements will happen in that policy.

      We will not, however, be removing this policy.

      `Install` is a list of URLs or native paths for extensions to be installed.

      `Uninstall` is a list of extension IDs that should be uninstalled if found.

      `Locked` is a list of extension IDs that the user cannot disable or uninstall.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `addons`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "addons" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "Extensions": {
            "Install": [
              "https://addons.mozilla.org/firefox/downloads/somefile.xpi",
              "//path/to/xpi"
            ],
            "Uninstall": [
              "bad_addon_id@mozilla.org"
            ],
            "Locked": [
              "addon_id@mozilla.org"
            ]
          }
        }
      }
    '';
  };
  ExtensionSettings = {
    Description = ''
      Manage all aspects of extensions. This policy is based heavily on the [Chrome policy](https://dev.chromium.org/administrators/policy-list-3/extension-settings-full) of the same name.

      This policy maps an extension ID to its configuration. With an extension ID, the configuration will be applied to the specified extension only. A default configuration can be set for the special ID `"*"`, which will apply to all extensions that don't have a custom configuration set in this policy.

      To obtain an extension ID, install the extension and go to **about:support**. You will see the ID in the Extensions section. I've also created an extension that makes it easy to find the ID of extensions on AMO. You can download it [here](https://github.com/mkaply/queryamoid/releases/tag/v0.1).

      **Note:**
      If the extension ID is a UUID (for example `{12345678-1234-1234-1234-1234567890ab}`), you must include the curly braces around the ID.

      The configuration for each extension is another dictionary that can contain the fields documented below.

      | Name | Description |
      | --- | --- |
      | `installation_mode` | Maps to a string indicating the installation mode for the extension. The valid strings are `allowed`, `blocked`, `force_installed`, and `normal_installed`. |
      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`allowed` | Allows the extension to be installed by the user. This is the default behavior. There is no need for an `install_url`; it will automatically be allowed based on the ID. |
      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`blocked` | Blocks installation of the extension and removes it from the device if already installed. If used in the default (`"*"`) configuration, it blocks all extensions that do not have an explicit configuration with a different `installation_mode`. |
      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`force_installed` | Automatically installs the extension and prevents it from being removed by the user. This option is not valid for the default configuration and requires an `install_url`. |
      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`normal_installed` | Automatically installs the extension but allows it to be disabled by the user. This option is not valid for the default configuration and requires an `install_url`. |
      |`install_url` | The URL from which Firefox can download a `force_installed` or `normal_installed` extension. Firefox automatically installs, updates, or re-installs the extension when the XPI file\u2019s internal [`version`](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/version) changes.<ul><li>If installing from `addons.mozilla.org`, use `https://addons.mozilla.org/firefox/downloads/latest/ADDON_ID/latest.xpi` and substitute **ADDON_ID** with the extension\u2019s ID (for example, `uBlock0@raymondhill.net` or `{446900e4-71c2-419f-a6a7-df9c091e268b}`). Using the AMO ID ensures Firefox always downloads the latest version that matches the user\u2019s platform.</li><li>If installing from the local file system, use a [`file:///` URL](https://en.wikipedia.org/wiki/File_URI_scheme). Firefox will update or re-install the extension whenever the XPI file at that path changes. You can also manually trigger an update by changing the file name or path.</li><li>Language packs are available from `https://releases.mozilla.org/pub/firefox/releases/VERSION/PLATFORM/xpi/LANGUAGE.xpi` (for example, `https://releases.mozilla.org/pub/firefox/releases/111.0.1/win64/xpi/en-US.xpi`). These URLs can be used as `install_url` values for managing language pack installation.</li></ul>
      | `install_sources` | A list of sources from which installing extensions is allowed using URL match patterns. **This is unnecessary if you are only allowing the installation of certain extensions by ID.** Each item in this list is an extension-style match pattern. Users will be able to easily install items from any URL that matches an item in this list. Both the location of the `.xpi` file and the page where the download is started (the referrer) must be allowed by these patterns. This setting can be used only for the default configuration. |
      | `allowed_types` | Restricts which types of add-ons can be installed. Accepts a list of one or more of: `"extension"`, `"theme"`, `"dictionary"`, `"locale"`, `"sitepermission"`. <br><br>**Note:** This setting only applies when installation is otherwise allowed. If `"installation_mode": "blocked"` is set (either for a specific ID or for `"*"`), extensions remain blocked regardless of `allowed_types`. This setting can be used only for the default configuration. |
      | `blocked_install_message` | Maps to a string specifying the error message to display to users if they're blocked from installing an extension. This setting allows you to append text to the generic error message displayed when an extension is blocked. This could be used to direct users to your help desk, explain why a particular extension is blocked, or something similar. This setting can be used only for the default configuration. |
      | `restricted_domains` | An array of domains on which content scripts can't be run. This setting can be used only for the default configuration. |
      | `updates_disabled` | (Firefox 89, Firefox ESR 78.11) Boolean that indicates whether or not to disable automatic updates for an individual extension. |
      | `default_area` | (Firefox 113) String that indicates where to place the extension icon by default. Possible values are `navbar` and `menupanel`. |
      | `temporarily_allow_weak_signatures` | (Firefox 127) A boolean that indicates whether to allow installing extensions signed using deprecated signature algorithms. |
      | `private_browsing` | (Firefox 136, Firefox ESR 128.8) A boolean that indicates whether or not this extension should be enabled in private browsing. |
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "ExtensionSettings": {
            "*": {
              "blocked_install_message": "Custom error message.",
              "install_sources": [
                "https://yourwebsite.com/*"
              ],
              "installation_mode": "blocked"
            },
            "uBlock0@raymondhill.net": {
              "installation_mode": "force_installed",
              "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
            },
            "adguardadblocker@adguard.com": {
              "installation_mode": "force_installed",
              "install_url": "https://addons.mozilla.org/firefox/downloads/latest/adguardadblocker@adguard.com/latest.xpi"
            },
            "https-everywhere@eff.org": {
              "installation_mode": "allowed",
              "updates_disabled": false
            }
          }
        }
      }
    '';
  };
  ExtensionUpdate = {
    Description = ''
      Control extension updates.

      **Compatibility:** Firefox 67, Firefox ESR 60.7
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `extensions.update.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 67"
      "Firefox ESR 60.7"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "extensions.update.enabled" ];
    Example = ''
      {
        "policies": {
          "ExtensionUpdate": true | false
        }
      }
    '';
  };
  FirefoxHome = {
    Description = ''
      Customize the Firefox Home page.

      **Compatibility:** Firefox 68, Firefox ESR 68 (SponsoredTopSites and SponsoredPocket were added in Firefox 95, Firefox ESR 91.4, Snippets was deprecated in Firefox 122, Stories and SponsoredStories were added in Firefox 141 to replace Pocket and SponsoredPocket.)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.newtabpage.activity-stream.showSearch`, `browser.newtabpage.activity-stream.feeds.topsites`, `browser.newtabpage.activity-stream.feeds.section.highlights`, `browser.newtabpage.activity-stream.feeds.section.topstories`, `browser.newtabpage.activity-stream.feeds.snippets`, `browser.newtabpage.activity-stream.showSponsoredTopSites`, `browser.newtabpage.activity-stream.showSponsored`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68"
      "Firefox ESR 68 (SponsoredTopSites and SponsoredPocket were added in Firefox 95"
      "Firefox ESR 91.4"
      "Snippets was deprecated in Firefox 122"
      "Stories and SponsoredStories were added in Firefox 141 to replace Pocket and SponsoredPocket.)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.newtabpage.activity-stream.showSearch"
      "browser.newtabpage.activity-stream.feeds.topsites"
      "browser.newtabpage.activity-stream.feeds.section.highlights"
      "browser.newtabpage.activity-stream.feeds.section.topstories"
      "browser.newtabpage.activity-stream.feeds.snippets"
      "browser.newtabpage.activity-stream.showSponsoredTopSites"
      "browser.newtabpage.activity-stream.showSponsored"
    ];
    Example = ''
      {
        "policies": {
          "FirefoxHome": {
            "Search": true | false,
            "TopSites": true | false,
            "SponsoredTopSites": true | false,
            "Highlights": true | false,
            "Pocket": true | false,
            "Stories": true | false,
            "SponsoredPocket": true | false,
            "SponsoredStories": true | false,
            "Snippets": true | false,
            "Locked": true | false
          }
        }
      }
    '';
  };
  FirefoxSuggest = {
    Description = ''
      Customize Firefox Suggest (US only).

      As of Firefox 146, `WebSuggestions` turns off Suggest completely.

      **Compatibility:** Firefox 118, Firefox ESR 115.3.
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.urlbar.suggest.quicksuggest.all`, `browser.urlbar.suggest.quicksuggest.sponsored`, `browser.urlbar.quicksuggest.dataCollection.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 118"
      "Firefox ESR 115.3."
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.urlbar.suggest.quicksuggest.all"
      "browser.urlbar.suggest.quicksuggest.sponsored"
      "browser.urlbar.quicksuggest.dataCollection.enabled"
    ];
    Example = ''
      {
        "policies": {
          "FirefoxSuggest": {
            "WebSuggestions": true | false,
            "SponsoredSuggestions": true | false,
            "ImproveSuggest": true | false,
            "Locked": true | false
          }
        }
      }
    '';
  };
  GenerativeAI = {
    Description = ''
      Configure generative AI features.

      `Enabled` Controls whether generative AI features are enabled by default. If false, all generative AI features are disabled by default. Individual generative AI policies can override this setting.

      `Chatbot` Controls access to AI chatbots in the sidebar. If false, AI chatbots are not available in the sidebar.

      `LinkPreviews` (Firefox 144+) Controls whether AI is used to generate link previews. If false, AI is not used to generate link previews.

      `TabGroups` (Firefox 144+) Controls whether AI is used to suggest names and tabs for tab groups. If false, AI is not used to suggest names or tabs for tab groups.

      `Locked` Prevents the user from changing generative AI preferences.

      **Compatibility:** Firefox 144, Firefox ESR 140.4
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.ml.chat.enabled`, `browser.ml.chat.page`, `browser.ml.linkPreview.optin`, `browser.tabs.groups.smart.userEnabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 144"
      "Firefox ESR 140.4"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.ml.chat.enabled"
      "browser.ml.chat.page"
      "browser.ml.linkPreview.optin"
      "browser.tabs.groups.smart.userEnabled"
    ];
    Example = ''
      {
        "policies": {
          "GenerativeAI": {
            "Enabled": true | false,
            "Chatbot": true | false,
            "LinkPreviews": true | false,
            "TabGroups": true | false,
            "Locked": true | false
          }
        }
      }
    '';
  };
  GoToIntranetSiteForSingleWordEntryInAddressBar = {
    Description = ''
      Whether to always go through the DNS server before sending a single word search string to a search engine.

      If the site exists, it will navigate to the website. If the intranet responds with a 404, the page will show a 404. If the intranet does not respond, the browser will attempt a search.

      The second result in the URL bar will be a search result to allow users to conduct a web search exactly as it was entered.

      If instead you would like to enable the ability to have your domain appear as a valid URL and to disallow the browser from ever searching that term using the first result that matches it, add the pref `browser.fixup.domainwhitelist.YOUR_DOMAIN` (where `YOUR_DOMAIN` is the name of the domain you'd like to add), and set the pref to `true`. The URL bar will then suggest `YOUR_DOMAIN` when the user fully types `YOUR_DOMAIN`. If the user attempts to load that domain and it fails to load, it will show an "Unable to connect" error page.

      You can also whitelist a domain suffix that is not part of the [Public Suffix List](https://publicsuffix.org/) by adding the pref `browser.fixup.domainsuffixwhitelist.YOUR_DOMAIN_SUFFIX` with a value of `true`.

      Additionally, if you want users to see a "Did you mean to go to 'YOUR_DOMAIN'" prompt below the URL bar if they land on a search results page instead of an intranet domain that provides a response, set the pref `browser.urlbar.dnsResolveSingleWordsAfterSearch` to `1`. Enabling this will cause the browser to commit a DNS check after every single word search. If the browser receives a response from the intranet, a prompt will ask the user if they'd like to instead navigate to `YOUR_DOMAIN`. If the user presses the **yes** button, `browser.fixup.domainwhitelist.YOUR_DOMAIN` will be set to `true`.

      **Compatibility:** Firefox 104, Firefox ESR 102.2
      **CCK2 Equivalent:** `N/A`
      **Preferences Affected:** `browser.fixup.dns_first_for_single_words`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 104"
      "Firefox ESR 102.2"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "browser.fixup.dns_first_for_single_words" ];
    Example = ''
      {
        "policies": {
          "GoToIntranetSiteForSingleWordEntryInAddressBar": true | false
        }
      }
    '';
  };
  Handlers = {
    Description = ''
      Configure default application handlers. This policy is based on the internal format of `handlers.json`.

      You can configure handlers based on a mime type (`mimeTypes`), a file's extension (`extensions`), or a protocol (`schemes`).

      Within each handler type, you specify the given mimeType/extension/scheme as a key and use the following subkeys to describe how it is handled.

      | Name | Description |
      | --- | --- |
      | `action`| Can be either `saveToDisk`, `useHelperApp`, `useSystemDefault`.
      | `ask` | If `true`, the user is asked if what they want to do with the file. If `false`, the action is taken without user intervention.
      | `handlers` | An array of handlers with the first one being the default. If you don't want to have a default handler, use an empty object for the first handler. Choose between path or uriTemplate.
      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`name` | The display name of the handler (might not be used).
      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`path`| The native path to the executable to be used.
      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`uriTemplate`| A url to a web based application handler. The URL must be https and contain a %s to be used for substitution.

      **Compatibility:** Firefox 78, Firefox ESR 78
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 78"
      "Firefox ESR 78"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "Handlers": {
            "mimeTypes": {
              "application/msword": {
                "action": "useSystemDefault",
                "ask": false
              }
            },
            "schemes": {
              "mailto": {
                "action": "useHelperApp",
                "ask": true | false,
                "handlers": [
                  {
                    "name": "Gmail",
                    "uriTemplate": "https://mail.google.com/mail/?extsrc=mailto&url=%s"
                  }
                ]
              }
            },
            "extensions": {
              "pdf": {
                "action": "useHelperApp",
                "ask": true | false,
                "handlers": [
                  {
                    "name": "Adobe Acrobat",
                    "path": "/usr/bin/acroread"
                  }
                ]
              }
            }
          }
        }
      }
    '';
  };
  HardwareAcceleration = {
    Description = ''
      Control hardware acceleration.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `layers.acceleration.disabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "layers.acceleration.disabled" ];
    Example = ''
      {
        "policies": {
          "HardwareAcceleration": true | false
        }
      }
    '';
  };
  Homepage = {
    Description = ''
      Configure the default homepage and how Firefox starts.

      `URL` is the default homepage.

      `Locked` prevents the user from changing homepage preferences.

      `Additional` allows for more than one homepage.

      `StartPage` is how Firefox starts.

      | Value             | Description
      |-------------------|-----------------------------------------------------------------------------
      | `none`            | Start with a blank page (no homepage, no previous session).
      | `homepage`        | Start with the homepage in `URL` policy.
      | `previous-session`| Restore the previous session (all tabs and windows reopen).
      | `homepage-locked` | Always force the homepage at startup, users cannot choose session restore. (Firefox 78)

      **Compatibility:** Firefox 60, Firefox ESR 60 (StartPage was added in Firefox 60, Firefox ESR 60.4, homepage-locked added in Firefox 78)
      **CCK2 Equivalent:** `homePage`,`lockHomePage`
      **Preferences Affected:** `browser.startup.homepage`, `browser.startup.page`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60 (StartPage was added in Firefox 60"
      "Firefox ESR 60.4"
      "homepage-locked added in Firefox 78)"
    ];
    "CCK2-Equivalent" = [
      "homePage"
      "lockHomePage"
    ];
    "Preferences-Affected" = [
      "browser.startup.homepage"
      "browser.startup.page"
    ];
    Example = ''
      {
        "policies": {
          "Homepage": {
            "URL": "http://example.com/",
            "Locked": true | false,
            "Additional": [
              "http://example.org/",
              "http://example.edu/"
            ],
            "StartPage": "none" | "homepage" | "previous-session" | "homepage-locked"
          }
        }
      }
    '';
  };
  HttpAllowlist = {
    Description = ''
      Configure sites that will not be upgraded to HTTPS.

      The sites are specified as a list of origins.

      **Compatibility:** Firefox 127
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 127" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "HttpAllowlist": [
            "http://example.org",
            "http://example.edu"
          ]
        }
      }
    '';
  };
  HttpsOnlyMode = {
    Description = ''
      Configure HTTPS-Only Mode.

      | Value | Description
      | --- | --- |
      | allowed | HTTPS-Only Mode is off by default, but the user can turn it on.
      | disallowed | HTTPS-Only Mode is off and the user can't turn it on.
      | enabled | HTTPS-Only Mode is on by default, but the user can turn it off.
      | force_enabled | HTTPS-Only Mode is on and the user can't turn it off.

      **Compatibility:** Firefox 127
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `dom.security.https_only_mode`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 127" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "dom.security.https_only_mode" ];
    Example = ''
      {
        "policies": {
          "HttpsOnlyMode": "allowed" | "disallowed" | "enabled" | "force_enabled"
        }
      }
    '';
  };
  InstallAddonsPermission = {
    Description = ''
      Configure the default extension install policy as well as origins for extension installs are allowed. This policy does not override turning off all extension installs.

      `Allow` is a list of origins where extension installs are allowed.

      `Default` determines whether or not extension installs are allowed by default.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `permissions.install`
      **Preferences Affected:** `xpinstall.enabled`, `browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons`, `browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "permissions.install" ];
    "Preferences-Affected" = [
      "xpinstall.enabled"
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features"
    ];
    Example = ''
      {
        "policies": {
          "InstallAddonsPermission": {
            "Allow": [
              "http://example.org/",
              "http://example.edu/"
            ],
            "Default": true | false
          }
        }
      }
    '';
  };
  IPProtectionAvailable = {
    Description = ''
      Prevent the built-in VPN from being available to users.

      **Compatibility:** Firefox 149.0.2
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.ipProtection.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 149.0.2" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "browser.ipProtection.enabled" ];
    Example = ''
      {
        "policies": {
          "IPProtectionAvailable": true | false
        }
    '';
  };
  LegacyProfiles = {
    Description = ''
      Disable the feature enforcing a separate profile for each installation.

      If this policy set to true, Firefox will not try to create different profiles for installations of Firefox in different directories. This is the equivalent of the MOZ_LEGACY_PROFILES environment variable.

      If this policy set to false, Firefox will create a new profile for each unique installation of Firefox.

      This policy only work on Windows via GPO (not policies.json).

      **Compatibility:** Firefox 70, Firefox ESR 68.2 (Windows only, GPO only)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 70"
      "Firefox ESR 68.2 (Windows only"
      "GPO only)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
  };
  LegacySameSiteCookieBehaviorEnabled = {
    Description = ''
      Enable default legacy SameSite cookie behavior setting.

      If this policy is set to true, it reverts all cookies to legacy SameSite behavior which means that cookies that don't explicitly specify a ```SameSite``` attribute are treated as if they were ```SameSite=None```.

      **Compatibility:** Firefox 96
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.cookie.sameSite.laxByDefault`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 96" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "network.cookie.sameSite.laxByDefault" ];
    Example = ''
      {
        "policies": {
          "LegacySameSiteCookieBehaviorEnabled": true | false
        }
    '';
  };
  LegacySameSiteCookieBehaviorEnabledForDomainList = {
    Description = ''
      Revert to legacy SameSite behavior for cookies on specified sites.

      If this policy is set to true, cookies set for domains in this list will revert to legacy SameSite behavior which means that cookies that don't explicitly specify a ```SameSite``` attribute are treated as if they were ```SameSite=None```.

      **Compatibility:** Firefox 96
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.cookie.sameSite.laxByDefault.disabledHosts`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 96" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "network.cookie.sameSite.laxByDefault.disabledHosts" ];
    Example = ''
      {
        "policies": {
          "LegacySameSiteCookieBehaviorEnabledForDomainList": [
            "example.org",
            "example.edu"
          ]
        }
      }
    '';
  };
  LocalFileLinks = {
    Description = ''
      Enable linking to local files by origin.

      **Compatibility:** Firefox 68, Firefox ESR 68
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `capability.policy.localfilelinks.*`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68"
      "Firefox ESR 68"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "capability.policy.localfilelinks.*" ];
    Example = ''
      {
        "policies": {
          "LocalFileLinks": [
            "http://example.org/",
            "http://example.edu/"
          ]
        }
      }
    '';
  };
  ManagedBookmarks = {
    Description = ''
      Configures a list of bookmarks managed by an administrator that cannot be changed by the user.

      The bookmarks are only added as a button on the personal toolbar. They are not in the bookmarks folder.

      The syntax of this policy is exactly the same as the [Chrome ManagedBookmarks policy](https://cloud.google.com/docs/chrome-enterprise/policies/?policy=ManagedBookmarks). The schema is:
      ```
      {
      "items": {
      "id": "BookmarkType",
      "properties": {
      "children": {
      "items": {
      "\''$ref": "BookmarkType"
      },
      "type": "array"
      },
      "name": {
      "type": "string"
      },
      "toplevel_name": {
      "type": "string"
      },
      "url": {
      "type": "string"
      }
      },
      "type": "object"
      },
      "type": "array"
      }
      ```
      **Compatibility:** Firefox 83, Firefox ESR 78.5
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 83"
      "Firefox ESR 78.5"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "ManagedBookmarks": [
            {
              "toplevel_name": "My managed bookmarks folder"
            },
            {
              "url": "example.com",
              "name": "Example"
            },
            {
              "name": "Mozilla links",
              "children": [
                {
                  "url": "https://mozilla.org",
                  "name": "Mozilla.org"
                },
                {
                  "url": "https://support.mozilla.org/",
                  "name": "SUMO"
                }
              ]
            }
          ]
        }
      }
    '';
  };
  ManualAppUpdateOnly = {
    Description = ''
      Switch to manual updates only.

      If this policy is enabled:
      1. The user will never be prompted to install updates
      2. Firefox will not check for updates in the background, though it will check automatically when an update UI is displayed (such as the one in the About dialog). This check will be used to show "Update to version X" in the UI, but will not automatically download the update or prompt the user to update in any other way.
      3. The update UI will work as expected, unlike when using DisableAppUpdate.

      This policy is primarily intended for advanced end users, not for enterprises, but it is available via GPO.

      **Compatibility:** Firefox 87
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 87" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "ManualAppUpdateOnly": true | false
        }
      }
    '';
  };
  MicrosoftEntraSSO = {
    Description = ''
      Allow single sign-on for Microsoft Entra accounts on macOS.

      If this policy is set to true, Firefox will use credentials stored in the Company Portal to sign in to Microsoft Entra accounts.

      **Compatibility:** Firefox 132.0.1, Firefox ESR 128.5
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.http.microsoft-entra-sso.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 132.0.1"
      "Firefox ESR 128.5"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "network.http.microsoft-entra-sso.enabled" ];
    Example = ''
      {
        "policies": {
          "MicrosoftEntraSSO": true | false
        }
      }
    '';
  };
  NetworkPrediction = {
    Description = ''
      Enable or disable network prediction (DNS prefetching).

      **Compatibility:** Firefox 67, Firefox ESR 60.7
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.dns.disablePrefetch`, `network.dns.disablePrefetchFromHTTPS`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 67"
      "Firefox ESR 60.7"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "network.dns.disablePrefetch"
      "network.dns.disablePrefetchFromHTTPS"
    ];
    Example = ''
      {
        "policies": {
          "NetworkPrediction": true | false
        }
    '';
  };
  NewTabPage = {
    Description = ''
      Enable or disable the New Tab page.

      **Compatibility:** Firefox 68, Firefox ESR 68
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.newtabpage.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68"
      "Firefox ESR 68"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "browser.newtabpage.enabled" ];
    Example = ''
      {
        "policies": {
          "NewTabPage": true | false
        }
    '';
  };
  NoDefaultBookmarks = {
    Description = ''
      Disable the creation of default bookmarks.

      This policy is only effective if the user profile has not been created yet.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `removeDefaultBookmarks`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "removeDefaultBookmarks" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "NoDefaultBookmarks": true | false
        }
      }
    '';
  };
  OfferToSaveLogins = {
    Description = ''
      Control whether or not Firefox offers to save passwords.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `dontRememberPasswords`
      **Preferences Affected:** `signon.rememberSignons`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "dontRememberPasswords" ];
    "Preferences-Affected" = [ "signon.rememberSignons" ];
    Example = ''
      {
        "policies": {
          "OfferToSaveLogins": true | false
        }
      }
    '';
  };
  OfferToSaveLoginsDefault = {
    Description = ''
      Sets the default value of signon.rememberSignons without locking it.

      **Compatibility:** Firefox 70, Firefox ESR 60.2
      **CCK2 Equivalent:** `dontRememberPasswords`
      **Preferences Affected:** `signon.rememberSignons`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 70"
      "Firefox ESR 60.2"
    ];
    "CCK2-Equivalent" = [ "dontRememberPasswords" ];
    "Preferences-Affected" = [ "signon.rememberSignons" ];
    Example = ''
      {
        "policies": {
          "OfferToSaveLoginsDefault": true | false
        }
      }
    '';
  };
  OverrideFirstRunPage = {
    Description = ''
      Override the first run page. If the value is an empty string (""), the first run page is not displayed.

      Starting with Firefox 83, Firefox ESR 78.5, you can also specify multiple URLS separated by a vertical bar (|).

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `welcomePage`,`noWelcomePage`
      **Preferences Affected:** `startup.homepage_welcome_url`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [
      "welcomePage"
      "noWelcomePage"
    ];
    "Preferences-Affected" = [ "startup.homepage_welcome_url" ];
    Example = ''
      {
        "policies": {
          "OverrideFirstRunPage": "http://example.org"
        }
      }
    '';
  };
  OverridePostUpdatePage = {
    Description = ''
      Override the upgrade page. If the value is an empty string (""), no extra pages are displayed when Firefox is upgraded.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `upgradePage`,`noUpgradePage`
      **Preferences Affected:** `startup.homepage_override_url`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [
      "upgradePage"
      "noUpgradePage"
    ];
    "Preferences-Affected" = [ "startup.homepage_override_url" ];
    Example = ''
      {
        "policies": {
          "OverridePostUpdatePage": "http://example.org"
        }
      }
    '';
  };
  PasswordManagerEnabled = {
    Description = ''
      Remove access to the password manager via preferences and blocks about:logins on Firefox 70.

      **Compatibility:** Firefox 70, Firefox ESR 60.2
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `pref.privacy.disable_button.view_passwords`, `signon.rememberSignons`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 70"
      "Firefox ESR 60.2"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "pref.privacy.disable_button.view_passwords"
      "signon.rememberSignons"
    ];
    Example = ''
      {
        "policies": {
          "PasswordManagerEnabled": true | false
        }
      }
    '';
  };
  PasswordManagerExceptions = {
    Description = ''
      Prevent Firefox from saving passwords for specific sites.

      The sites are specified as a list of origins.

      **Compatibility:** Firefox 101
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 101" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "PasswordManagerExceptions": [
            "https://example.org",
            "https://example.edu"
          ]
        }
      }
    '';
  };
  PDFjs = {
    Description = ''
      Disable or configure PDF.js, the built-in PDF viewer.

      If `Enabled` is set to false, the built-in PDF viewer is disabled.

      If `EnablePermissions` is set to true, the built-in PDF viewer will honor document permissions like preventing the copying of text.

      Note: DisableBuiltinPDFViewer has not been deprecated. You can either continue to use it, or switch to using PDFjs->Enabled to disable the built-in PDF viewer. This new permission was added because we needed a place for PDFjs->EnabledPermissions.

      **Compatibility:** Firefox 77, Firefox ESR 68.9
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `pdfjs.disabled`, `pdfjs.enablePermissions`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 77"
      "Firefox ESR 68.9"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "pdfjs.disabled"
      "pdfjs.enablePermissions"
    ];
    Example = ''
      {
        "policies": {
          "PDFjs": {
            "Enabled": true | false,
            "EnablePermissions": true | false
          }
        }
      }
    '';
  };
  Permissions = {
    Description = ''
      Set permissions associated with camera, microphone, location, notifications, autoplay, and virtual reality. Because these are origins, not domains, entries with unique ports must be specified separately. This explicitly means that it is not possible to add wildcards. See examples below.

      `Allow` is a list of origins where the feature is allowed.

      `Block` is a list of origins where the feature is not allowed.

      `BlockNewRequests` determines whether or not new requests can be made for the feature.

      `Locked` prevents the user from changing preferences for the feature.

      `Default` specifies the default value for Autoplay. block-audio-video is not supported on Firefox ESR 68.

      **Compatibility:** Firefox 62, Firefox ESR 60.2 (Autoplay added in Firefox 74, Firefox ESR 68.6, Autoplay Default/Locked added in Firefox 76, Firefox ESR 68.8, VirtualReality added in Firefox 80, Firefox ESR 78.2, ScreenShare added in Firefox 142, Firefox ESR 140.2)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `permissions.default.camera`, `permissions.default.microphone`, `permissions.default.geo`, `permissions.default.desktop-notification`, `media.autoplay.default`, `permissions.default.xr`, `permissions.default.screen`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 62"
      "Firefox ESR 60.2 (Autoplay added in Firefox 74"
      "Firefox ESR 68.6"
      "Autoplay Default/Locked added in Firefox 76"
      "Firefox ESR 68.8"
      "VirtualReality added in Firefox 80"
      "Firefox ESR 78.2"
      "ScreenShare added in Firefox 142"
      "Firefox ESR 140.2)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "permissions.default.camera"
      "permissions.default.microphone"
      "permissions.default.geo"
      "permissions.default.desktop-notification"
      "media.autoplay.default"
      "permissions.default.xr"
      "permissions.default.screen"
    ];
    Example = ''
      {
        "policies": {
          "Permissions": {
            "Camera": {
              "Allow": [
                "https://example.org",
                "https://example.org:1234"
              ],
              "Block": [
                "https://example.edu"
              ],
              "BlockNewRequests": true | false,
              "Locked": true | false
            },
            "Microphone": {
              "Allow": [
                "https://example.org"
              ],
              "Block": [
                "https://example.edu"
              ],
              "BlockNewRequests": true | false,
              "Locked": true | false
            },
            "Location": {
              "Allow": [
                "https://example.org"
              ],
              "Block": [
                "https://example.edu"
              ],
              "BlockNewRequests": true | false,
              "Locked": true | false
            },
            "Notifications": {
              "Allow": [
                "https://example.org"
              ],
              "Block": [
                "https://example.edu"
              ],
              "BlockNewRequests": true | false,
              "Locked": true | false
            },
            "Autoplay": {
              "Allow": [
                "https://example.org"
              ],
              "Block": [
                "https://example.edu"
              ],
              "Default": "allow-audio-video" | "block-audio" | "block-audio-video",
              "Locked": true | false
            },
            "VirtualReality": {
              "Allow": [
                "https://example.org"
              ],
              "Block": [
                "https://example.edu"
              ],
              "BlockNewRequests": true | false,
              "Locked": true | false
            },
            "ScreenShare": {
              "Allow": [
                "https://example.org"
              ],
              "Block": [
                "https://example.edu"
              ],
              "BlockNewRequests": true | false,
              "Locked": true | false
            }
          }
        }
      }
    '';
  };
  PictureInPicture = {
    Description = ''
      Enable or disable Picture-in-Picture as well as prevent the user from enabling or disabling it (Locked).

      **Compatibility:** Firefox 78, Firefox ESR 78
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `media.videocontrols.picture-in-picture.video-toggle.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 78"
      "Firefox ESR 78"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "media.videocontrols.picture-in-picture.video-toggle.enabled" ];
    Example = ''
      {
        "policies": {
          "PictureInPicture": {
            "Enabled": true | false,
            "Locked": true | false
          }
        }
      }
    '';
  };
  PopupBlocking = {
    Description = ''
      Configure the default pop-up window policy as well as origins for which pop-up windows are allowed.

      `Allow` is a list of origins where popup-windows are allowed.

      `Default` determines whether or not pop-up windows are allowed by default.

      `Locked` prevents the user from changing pop-up preferences.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `permissions.popup`
      **Preferences Affected:** `dom.disable_open_during_load`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "permissions.popup" ];
    "Preferences-Affected" = [ "dom.disable_open_during_load" ];
    Example = ''
      {
        "policies": {
          "PopupBlocking": {
            "Allow": [
              "http://example.org/",
              "http://example.edu/"
            ],
            "Default": true | false,
            "Locked": true | false
          }
        }
      }
    '';
  };
  PostQuantumKeyAgreementEnabled = {
    Description = ''
      Enable post-quantum key agreement for TLS.

      **Compatibility:** Firefox 127
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `security.tls.enable_kyber`, `network.http.http3.enable_kyber` (Firefox 128)
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 127" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "security.tls.enable_kyber"
      "network.http.http3.enable_kyber"
    ];
    Example = ''
      {
        "policies": {
          "PostQuantumKeyAgreementEnabled": true | false
        }
      }
    '';
  };
  Preferences = {
    Description = ''
      Set and lock preferences.

      **NOTE** On Windows, in order to use this policy, you must clear all settings in the old **Preferences (Deprecated)** section in group policy.

      Previously you could only set and lock a subset of preferences. Starting with Firefox 81 and Firefox ESR 78.3 you can set many more preferences. You can also set default preferences, user preferences and you can clear preferences.

      **NOTE** There are too many preferences for us to provide documentation on them all. The source file [StaticPrefList.yaml](https://searchfox.org/mozilla-central/source/modules/libpref/init/StaticPrefList.yaml) contains information on many of them.

      Preferences that start with the following prefixes are supported:
      ```
      accessibility.
      alerts.* (Firefox 122, Firefox ESR 115.7)
      app.update.* (Firefox 86, Firefox ESR 78.8)
      browser.
      datareporting.policy.
      dom.
      extensions.
      general.autoScroll (Firefox 83, Firefox ESR 78.5)
      general.smoothScroll (Firefox 83, Firefox ESR 78.5)
      geo.
      gfx.
      identity.fxaccounts.toolbar (Firefox 133)
      intl.
      keyword.enabled (Firefox 95, Firefox ESR 91.4)
      layers.
      layout.
      mathml.disabled (Firefox 141, Firefox ESR 140.1)
      media.
      network.
      pdfjs. (Firefox 84, Firefox ESR 78.6)
      places.
      pref.
      print.
      privacy.baselineFingerprintingProtection, privacy.baselineFingerprintingProtection.* (Firefox 141, Firefox ESR 140.1)
      privacy.fingerprintingProtection, privacy.fingerprintingProtection.* (Firefox 141, Firefox ESR 140.1)
      privacy.globalprivacycontrol.enabled (Firefox 127, Firefox ESR 128.0)
      privacy.userContext.enabled (Firefox 126, Firefox ESR 115.11)
      privacy.userContext.ui.enabled (Firefox 126, Firefox ESR 115.11)
      signon. (Firefox 83, Firefox ESR 78.5)
      spellchecker. (Firefox 84, Firefox ESR 78.6)
      svg.context-properties.content.enabled (Firefox 141, Firefox ESR 140.1)
      svg.disabled (Firefox 141, Firefox ESR 140.1)
      toolkit.legacyUserProfileCustomizations.stylesheets (Firefox 95, Firefox ESR 91.4)
      ui.
      webgl.disabled (Firefox 141, Firefox ESR 140.1)
      webgl.force-enabled (Firefox 141, Firefox ESR 140.1)
      widget.
      xpinstall.enabled (Firefox 141, Firefox ESR 140.1)
      xpinstall.signatures.required (Firefox ESR 102.10, Firefox ESR only)
      xpinstall.whitelist.required (Firefox 118, Firefox ESR 115.3)
      ```
      as well as the following security preferences:

      | Preference | Type | Default
      | --- | --- | --- |
      | security.csp.reporting.enabled | bool | true
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to false, disables CSP reporting. (Firefox 141, Firefox ESR 140.1)
      | security.default_personal_cert | string | Ask Every Time
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to Select Automatically, Firefox automatically chooses the default personal certificate.
      | security.disable_button.openCertManager | string | N/A
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to true and locked, the View Certificates button in preferences is disabled. (Firefox 121, Firefox ESR 115.6)
      | security.disable_button.openDeviceManager | string | N/A
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to true and locked, the Security Devices button in preferences is disabled. (Firefox 121, Firefox ESR 115.6)
      | security.insecure_connection_text.enabled | bool | false
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to true, adds the words "Not Secure" for insecure sites.
      | security.insecure_connection_text.pbmode.enabled | bool | false
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to true, adds the words "Not Secure" for insecure sites in private browsing.
      | security.mixed_content.block_active_content | boolean | true
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to true, mixed active content (HTTP subresources such as scripts, fetch requests, etc. on a HTTPS page) will be blocked.
      | security.mixed_content.block_display_content | boolean | false
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to true, mixed passive/display content (HTTP subresources such as images, videos, etc. on a HTTPS page) will be blocked and ```security.mixed_content.upgrade_display_content``` will be ignored. (Firefox 127, Firefox ESR 128.0)
      | security.mixed_content.upgrade_display_content | boolean | true
      | &nbsp;&nbsp;&nbsp;&nbsp;If set to false, mixed passive/display content (HTTP subresources such as images, videos, etc. on a HTTPS page) will NOT be upgraded to HTTPS. (Firefox 127, Firefox ESR 128.0)
      | security.osclientcerts.autoload | boolean | false
      | &nbsp;&nbsp;&nbsp;&nbsp;If true, client certificates are loaded from the operating system certificate store.
      | security.OCSP.enabled | integer | 1
      | &nbsp;&nbsp;&nbsp;&nbsp;If 0, do not fetch OCSP. If 1, fetch OCSP for DV and EV certificates. If 2, fetch OCSP only for EV certificates.
      | security.OCSP.require | boolean | false
      | &nbsp;&nbsp;&nbsp;&nbsp; If true, if an OCSP request times out, the connection fails.
      | security.osclientcerts.assume_rsa_pss_support | boolean | true
      | &nbsp;&nbsp;&nbsp;&nbsp; If false, we don't assume an RSA key can do RSA-PSS. (Firefox 114, Firefox ESR 102.12)
      | security.pki.certificate_transparency.disable_for_hosts  | |
      | &nbsp;&nbsp;&nbsp;&nbsp; See [this page](https://searchfox.org/mozilla-central/rev/d1fbe983fb7720f0a4aca0e748817af11c1a374e/modules/libpref/init/StaticPrefList.yaml#16334) for more details.
      | security.pki.certificate_transparency.disable_for_spki_hashes | |
      | &nbsp;&nbsp;&nbsp;&nbsp; See [this page](https://searchfox.org/mozilla-central/rev/d1fbe983fb7720f0a4aca0e748817af11c1a374e/modules/libpref/init/StaticPrefList.yaml#16344) for more details.
      | security.pki.certificate_transparency.mode | integer | 0
      | &nbsp;&nbsp;&nbsp;&nbsp; Configures Certificate Transparency support mode (Firefox 133)
      | security.ssl.enable_ocsp_stapling | boolean | true
      | &nbsp;&nbsp;&nbsp;&nbsp; If false, OCSP stapling is not enabled.
      | security.ssl.errorReporting.enabled | boolean | true
      | &nbsp;&nbsp;&nbsp;&nbsp;If false, SSL errors cannot be sent to Mozilla.
      | security.ssl.require_safe_negotiation | boolean | false
      | &nbsp;&nbsp;&nbsp;&nbsp;If true, Firefox will only negotiate TLS connections with servers that indicate they support secure renegotiation. (Firefox 118, Firefox ESR 115.3)
      | security.tls.enable_0rtt_data | boolean | true
      | &nbsp;&nbsp;&nbsp;&nbsp;If false, TLS early data is turned off. (Firefox 93, Firefox 91.2, Firefox 78.15)
      | security.tls.hello_downgrade_check | boolean | true
      | &nbsp;&nbsp;&nbsp;&nbsp;If false, the TLS 1.3 downgrade check is disabled.
      | security.tls.version.enable-deprecated | boolean | false
      | &nbsp;&nbsp;&nbsp;&nbsp;If true, browser will accept TLS 1.0. and TLS 1.1. (Firefox 86, Firefox 78.8)
      | security.warn_submit_secure_to_insecure | boolean | true
      | &nbsp;&nbsp;&nbsp;&nbsp;If false, no warning is shown when submitting a form from https to http.
      | security.webauthn.always_allow_direct_attestation | boolean | false
      | &nbsp;&nbsp;&nbsp;&nbsp;If true, unnecessary (redundant) WebAuthn prompts are not shown.

      Using the preference as the key, set the `Value` to the corresponding preference value.

      `Status` can be "default", "locked", "user" or "clear"

      * `"default"`: Read/Write: Settings appear as default even if factory default differs.
      * `"locked"`: Read-Only: Settings appear as default even if factory default differs.
      * `"user"`: Read/Write: Settings appear as changed if it differs from factory default.
      * `"clear"`: Read/Write: `Value` has no effect. Resets to factory defaults on each startup.

      `"user"` preferences persist across invocations of Firefox. It is the equivalent of a user setting the preference. They are most useful when a preference is needed very early in startup so it can't be set as default by policy. An example of this is ```toolkit.legacyUserProfileCustomizations.stylesheets```.

      `"user"` preferences persist even if the policy is removed, so if you need to remove them, you should use the clear policy.

      You can also set the `Type` starting in Firefox 123 and Firefox ESR 115.8. It can be `number`, `boolean` or `string`. This is especially useful if you are seeing 0 or 1 values being converted to booleans when set as user preferences.

      See the examples below for more detail.

      IMPORTANT: Make sure you're only setting a particular preference using this mechanism and not some other way.

      Status
      **Compatibility:** Firefox 81, Firefox ESR 78.3
      **CCK2 Equivalent:** `preferences`
      **Preferences Affected:** Many
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 81"
      "Firefox ESR 78.3"
    ];
    "CCK2-Equivalent" = [ "preferences" ];
    "Preferences-Affected" = [ "Many" ];
    Example = ''
      {
        "policies": {
          "Preferences": {
            "accessibility.force_disabled": {
              "Value": 1,
              "Status": "default""Type": "number"
            },
            "browser.cache.disk.parent_directory": {
              "Value": "SOME_NATIVE_PATH",
              "Status": "user"
            },
            "browser.tabs.warnOnClose": {
              "Value": false,
              "Status": "locked"
            }
          }
        }
      }
    '';
  };
  PrimaryPassword = {
    Description = ''
      Require or prevent using a primary (formerly master) password.

      If this value is true, a primary password is required. If this value is false, it works the same as if [`DisableMasterPasswordCreation`](#disablemasterpasswordcreation) was true and removes the primary password functionality.

      If both DisableMasterPasswordCreation and PrimaryPassword are used, DisableMasterPasswordCreation takes precedent.

      **Compatibility:** Firefox 79, Firefox ESR 78.1
      **CCK2 Equivalent:** `noMasterPassword`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 79"
      "Firefox ESR 78.1"
    ];
    "CCK2-Equivalent" = [ "noMasterPassword" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "PrimaryPassword": true | false
        }
      }
    '';
  };
  PrintingEnabled = {
    Description = ''
      Enable or disable printing.

      **Compatibility:** Firefox 120, Firefox ESR 115.5
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `print.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 120"
      "Firefox ESR 115.5"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "print.enabled" ];
    Example = ''
      {
        "policies": {
          "PrintingEnabled": true | false
        }
      }
    '';
  };
  PrivateBrowsingModeAvailability = {
    Description = ''
      Set availability of private browsing mode.

      Possible values are `0` (Private Browsing mode is available), `1` (Private Browsing mode not available), and `2`(Private Browsing mode is forced).

      This policy supersedes [`DisablePrivateBrowsing`](#disableprivatebrowsing)

      Note: This policy missed Firefox ESR 128.2, but it will be in Firefox ESR 128.3.

      **Compatibility:** Firefox 130, Firefox ESR 128.3
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 130"
      "Firefox ESR 128.3"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "PrivateBrowsingModeAvailability": 0 | 1 | 2
        }
      }
    '';
  };
  PromptForDownloadLocation = {
    Description = ''
      Ask where to save each file before downloading.

      **Compatibility:** Firefox 68, Firefox ESR 68
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.download.useDownloadDir`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68"
      "Firefox ESR 68"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "browser.download.useDownloadDir" ];
    Example = ''
      {
        "policies": {
          "PromptForDownloadLocation": true | false
        }
      }
    '';
  };
  Proxy = {
    Description = ''
      Configure proxy settings. These settings correspond to the connection settings in Firefox preferences.
      To specify ports, append them to the hostnames with a colon (:).

      Unless you lock this policy, changes the user already has in place will take effect.

      `Mode` is the proxy method being used.

      `Locked` is whether or not proxy settings can be changed.

      `HTTPProxy` is the HTTP proxy server.

      `UseHTTPProxyForAllProtocols` is whether or not the HTTP proxy should be used for all other proxies.

      `SSLProxy` is the SSL proxy server.

      `FTPProxy` is the FTP proxy server.

      `SOCKSProxy` is the SOCKS proxy server

      `SOCKSVersion` is the SOCKS version (4 or 5)

      `Passthrough` is list of hostnames or IP addresses that will not be proxied. Use `<local>` to bypass proxying for all hostnames which do not contain periods.

      `AutoConfigURL` is a  URL for proxy configuration (only used if Mode is autoConfig).

      `AutoLogin` means do not prompt for authentication if password is saved.

      `UseProxyForDNS` to use proxy DNS when using SOCKS v5.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `networkProxy*`
      **Preferences Affected:** `network.proxy.type`, `network.proxy.autoconfig_url`, `network.proxy.socks_remote_dns`, `signon.autologin.proxy`, `network.proxy.socks_version`, `network.proxy.no_proxies_on`, `network.proxy.share_proxy_settings`, `network.proxy.http`, `network.proxy.http_port`, `network.proxy.ftp`, `network.proxy.ftp_port`, `network.proxy.ssl`, `network.proxy.ssl_port`, `network.proxy.socks`, `network.proxy.socks_port`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "networkProxy*" ];
    "Preferences-Affected" = [
      "network.proxy.type"
      "network.proxy.autoconfig_url"
      "network.proxy.socks_remote_dns"
      "signon.autologin.proxy"
      "network.proxy.socks_version"
      "network.proxy.no_proxies_on"
      "network.proxy.share_proxy_settings"
      "network.proxy.http"
      "network.proxy.http_port"
      "network.proxy.ftp"
      "network.proxy.ftp_port"
      "network.proxy.ssl"
      "network.proxy.ssl_port"
      "network.proxy.socks"
      "network.proxy.socks_port"
    ];
    Example = ''
      {
        "policies": {
          "Proxy": {
            "Mode": "none" | "system" | "manual" | "autoDetect" | "autoConfig",
            "Locked": true | false,
            "HTTPProxy": "hostname",
            "UseHTTPProxyForAllProtocols": true | false,
            "SSLProxy": "hostname",
            "FTPProxy": "hostname",
            "SOCKSProxy": "hostname",
            "SOCKSVersion": 4 | 5,
            "Passthrough": "<local>",
            "AutoConfigURL": "URL_TO_AUTOCONFIG",
            "AutoLogin": true | false,
            "UseProxyForDNS": true | false
          }
        }
      }
    '';
  };
  RequestedLocales = {
    Description = ''
      Set the list of requested locales for the application in order of preference. It will cause the corresponding language pack to become active.

      Note: For Firefox 68, this can now be a string so that you can specify an empty value.

      **Compatibility:** Firefox 64, Firefox ESR 60.4, Updated in Firefox 68, Firefox ESR 68
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 64"
      "Firefox ESR 60.4"
      "Updated in Firefox 68"
      "Firefox ESR 68"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "RequestedLocales": [
            "de",
            "en-US"
          ]
        }
      }or{
        "policies": {
          "RequestedLocales": "de,en-US"
        }
      }
    '';
  };
  "SanitizeOnShutdown (Selective)" = {
    Description = ''
      Clear data on shutdown.

      Note: Starting with Firefox 136, FormData and History have been separated again.

      `Cache`

      `Cookies`

      `Downloads` Download History (*Deprecated - part of History*)

      `FormData` Form History

      `History` Browsing History, Download History

      `Sessions` Active Logins

      `SiteSettings` Site Preferences

      `OfflineApps` Offline Website Data (*Deprecated - part of Cookies*)

      `Locked` prevents the user from changing these preferences.

      **Compatibility:** Firefox 68, Firefox ESR 68 (Locked added in 74/68.6, History update in Firefox 128)
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `privacy.sanitize.sanitizeOnShutdown`, `privacy.clearOnShutdown.cache`, `privacy.clearOnShutdown.cookies`, `privacy.clearOnShutdown.downloads`, `privacy.clearOnShutdown.formdata`, `privacy.clearOnShutdown.history`, `privacy.clearOnShutdown.sessions`, `privacy.clearOnShutdown.siteSettings`, `privacy.clearOnShutdown.offlineApps`, `privacy.clearOnShutdown_v2.historyFormDataAndDownloads` (Firefox 128), `privacy.clearOnShutdown_v2.cookiesAndStorage` (Firefox 128), `privacy.clearOnShutdown_v2.cache` (Firefox 128), `privacy.clearOnShutdown_v2.siteSettings` (Firefox 128), `privacy.clearOnShutdown_v2.formdata` (Firefox 128)
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68"
      "Firefox ESR 68 (Locked added in 74/68.6"
      "History update in Firefox 128)"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "privacy.sanitize.sanitizeOnShutdown"
      "privacy.clearOnShutdown.cache"
      "privacy.clearOnShutdown.cookies"
      "privacy.clearOnShutdown.downloads"
      "privacy.clearOnShutdown.formdata"
      "privacy.clearOnShutdown.history"
      "privacy.clearOnShutdown.sessions"
      "privacy.clearOnShutdown.siteSettings"
      "privacy.clearOnShutdown.offlineApps"
      "privacy.clearOnShutdown_v2.historyFormDataAndDownloads"
      "privacy.clearOnShutdown_v2.cookiesAndStorage"
      "privacy.clearOnShutdown_v2.cache"
      "privacy.clearOnShutdown_v2.siteSettings"
      "privacy.clearOnShutdown_v2.formdata"
    ];
    Example = ''
      {
        "policies": {
          "SanitizeOnShutdown": {
            "Cache": true | false,
            "Cookies": true | false,
            "FormData": true | false,
            "History": true | false,
            "Sessions": true | false,
            "SiteSettings": true | false,
            "Locked": true | false
          }
        }
      }
    '';
  };
  "SanitizeOnShutdown (All)" = {
    Description = ''
      Clear all data on shutdown, including Browsing & Download History, Cookies, Active Logins, Cache, Form History, Site Preferences and Offline Website Data.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `privacy.sanitize.sanitizeOnShutdown`, `privacy.clearOnShutdown.cache`, `privacy.clearOnShutdown.cookies`, `privacy.clearOnShutdown.downloads`, `privacy.clearOnShutdown.formdata`, `privacy.clearOnShutdown.history`, `privacy.clearOnShutdown.sessions`, `privacy.clearOnShutdown.siteSettings`, `privacy.clearOnShutdown.offlineApps`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "privacy.sanitize.sanitizeOnShutdown"
      "privacy.clearOnShutdown.cache"
      "privacy.clearOnShutdown.cookies"
      "privacy.clearOnShutdown.downloads"
      "privacy.clearOnShutdown.formdata"
      "privacy.clearOnShutdown.history"
      "privacy.clearOnShutdown.sessions"
      "privacy.clearOnShutdown.siteSettings"
      "privacy.clearOnShutdown.offlineApps"
    ];
    Example = ''
      {
        "policies": {
          "SanitizeOnShutdown": true | false
        }
      }
    '';
  };
  SearchBar = {
    Description = ''
      Set whether or not search bar is displayed.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** `showSearchBar`
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ "showSearchBar" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "SearchBar": "unified" | "separate"
        }
      }
    '';
  };
  SearchEngines = {
    Description = ''

    '';
    Deprecated = false;
    Children = [
      "Add"
      "Default"
      "PreventInstalls"
      "Remove"
    ];
    Add = {
      Description = ''
        Add new search engines. Although there are only five engines available in the ADMX template, there is no limit. To add more in the ADMX template, you can duplicate the XML.

        `Name` is the name of the search engine. (Required)

        `URLTemplate` is the search URL with {searchTerms} to substitute for the search term. (Required)

        `Method` is either GET or POST

        `IconURL` is a URL for the icon to use.

        `Alias` is a keyword to use for the engine.

        `Description` is a description of the search engine.

        `PostData` is the POST data as name value pairs separated by &.

        `SuggestURLTemplate` is a search suggestions URL with {searchTerms} to substitute for the search term.

        `Encoding` is the query charset for the engine. It defaults to UTF-8.

        **Compatibility:** Firefox 139, Firefox ESR 60 (POST support in Firefox ESR 68, Encoding support in Firefox 91)
        **CCK2 Equivalent:** `searchplugins`
        **Preferences Affected:** N/A
      '';
      Deprecated = false;
      Children = [ ];
      Compatibility = [
        "Firefox 139"
        "Firefox ESR 60 (POST support in Firefox ESR 68"
        "Encoding support in Firefox 91)"
      ];
      "CCK2-Equivalent" = [ "searchplugins" ];
      "Preferences-Affected" = [ ];
      Example = ''
        {
          "policies": {
            "SearchEngines": {
              "Add": [
                {
                  "Name": "Example1",
                  "URLTemplate": "https://www.example.org/q={searchTerms}",
                  "Method": "GET" | "POST",
                  "IconURL": "https://www.example.org/favicon.ico",
                  "Alias": "example",
                  "Description": "Description",
                  "PostData": "name=value&q={searchTerms}",
                  "SuggestURLTemplate": "https://www.example.org/suggestions/q={searchTerms}"
                }
              ]
            }
          }
        }
      '';
    };
    Default = {
      Description = ''
        Set the default search engine.

        **Compatibility:** Firefox 139, Firefox ESR 60
        **CCK2 Equivalent:** `defaultSearchEngine`
        **Preferences Affected:** N/A
      '';
      Deprecated = false;
      Children = [ ];
      Compatibility = [
        "Firefox 139"
        "Firefox ESR 60"
      ];
      "CCK2-Equivalent" = [ "defaultSearchEngine" ];
      "Preferences-Affected" = [ ];
      Example = ''
        {
          "policies": {
            "SearchEngines": {
              "Default": "NAME_OF_SEARCH_ENGINE"
            }
          }
        }
      '';
    };
    PreventInstalls = {
      Description = ''
        Prevent installing search engines from webpages.

        **Compatibility:** Firefox 139, Firefox ESR 60
        **CCK2 Equivalent:** `disableSearchEngineInstall`
        **Preferences Affected:** N/A
      '';
      Deprecated = false;
      Children = [ ];
      Compatibility = [
        "Firefox 139"
        "Firefox ESR 60"
      ];
      "CCK2-Equivalent" = [ "disableSearchEngineInstall" ];
      "Preferences-Affected" = [ ];
      Example = ''
        {
          "policies": {
            "SearchEngines": {
              "PreventInstalls": true | false
            }
          }
        }
      '';
    };
    Remove = {
      Description = ''
        Hide built-in search engines.

        **Compatibility:** Firefox 139, Firefox ESR 60.2
        **CCK2 Equivalent:** `removeDefaultSearchEngines` (removed all built-in engines)
        **Preferences Affected:** N/A
      '';
      Deprecated = false;
      Children = [ ];
      Compatibility = [
        "Firefox 139"
        "Firefox ESR 60.2"
      ];
      "CCK2-Equivalent" = [ "removeDefaultSearchEngines` (removed all built-in engines)" ];
      "Preferences-Affected" = [ ];
      Example = ''
        {
          "policies": {
            "SearchEngines": {
              "Remove": [
                "NAME_OF_SEARCH_ENGINE"
              ]
            }
          }
        }
      '';
    };
  };
  SearchSuggestEnabled = {
    Description = ''
      Enable search suggestions.

      **Compatibility:** Firefox 68, Firefox ESR 68
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.urlbar.suggest.searches`, `browser.search.suggest.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68"
      "Firefox ESR 68"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.urlbar.suggest.searches"
      "browser.search.suggest.enabled"
    ];
    Example = ''
      {
        "policies": {
          "SearchSuggestEnabled": true | false
        }
      }
    '';
  };
  SecurityDevices = {
    Description = ''
      Install PKCS #11 modules.

      **Compatibility:** Firefox 64, Firefox ESR 60.4
      **CCK2 Equivalent:** `certs.devices`
      **Preferences Affected:** N/A
    '';
    Deprecated = true;
    Children = [ ];
    Compatibility = [
      "Firefox 64"
      "Firefox ESR 60.4"
    ];
    "CCK2-Equivalent" = [ "certs.devices" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "SecurityDevices": {
            "NAME_OF_DEVICE": "PATH_TO_LIBRARY_FOR_DEVICE"
          }
        }
      }
    '';
  };
  ShowHomeButton = {
    Description = ''
      Show the home button on the toolbar.

      Future versions of Firefox will not show the home button by default.

      **Compatibility:** Firefox 88, Firefox ESR 78.10
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 88"
      "Firefox ESR 78.10"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "ShowHomeButton": true | false
        }
      }
    '';
  };
  SkipTermsOfUse = {
    Description = ''
      If true, don't display the Firefox [Terms of Use](https://www.mozilla.org/about/legal/terms/firefox/) and [Privacy Notice](https://www.mozilla.org/privacy/firefox/) upon startup. You represent that you accept and have the authority to accept the Terms of Use on behalf of all individuals to whom you provide access to this browser.

      **Compatibility:** Firefox 138, Firefox ESR 140
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 138"
      "Firefox ESR 140"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "SkipTermsOfUse": true | false
        }
      }
    '';
  };
  SSLVersionMax = {
    Description = ''
      Set and lock the maximum version of TLS. (Firefox defaults to a maximum of TLS 1.3.)

      **Compatibility:** Firefox 66, Firefox ESR 60.6
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `security.tls.version.max`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 66"
      "Firefox ESR 60.6"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "security.tls.version.max" ];
    Example = ''
      {
        "policies": {
          "SSLVersionMax": "tls1" | "tls1.1" | "tls1.2" | "tls1.3"
        }
      }
    '';
  };
  SSLVersionMin = {
    Description = ''
      Set and lock the minimum version of TLS. (Firefox defaults to a minimum of TLS 1.2.)

      **Compatibility:** Firefox 66, Firefox ESR 60.6
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `security.tls.version.min`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 66"
      "Firefox ESR 60.6"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "security.tls.version.min" ];
    Example = ''
      {
        "policies": {
          "SSLVersionMin": "tls1" | "tls1.1" | "tls1.2" | "tls1.3"
        }
      }
    '';
  };
  StartDownloadsInTempDirectory = {
    Description = ''
      Force downloads to start off in a local, temporary location rather than the default download directory.

      **Compatibility:** Firefox 102
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.download.start_downloads_in_tmp_dir`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 102" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "browser.download.start_downloads_in_tmp_dir" ];
    Example = ''
      {
        "policies": {
          "StartDownloadsInTempDirectory": true | false
        }
    '';
  };
  SupportMenu = {
    Description = ''
      Add a menuitem to the help menu for specifying support information.

      **Compatibility:** Firefox 68.0.1, Firefox ESR 68.0.1
      **CCK2 Equivalent:** helpMenu
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 68.0.1"
      "Firefox ESR 68.0.1"
    ];
    "CCK2-Equivalent" = [ "helpMenu" ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "SupportMenu": {
            "Title": "Support Menu",
            "URL": "http://example.com/support",
            "AccessKey": "S"
          }
        }
      }
    '';
  };
  TranslateEnabled = {
    Description = ''
      Enable or disable webpage translation.

      Note: Web page translation is done completely on the client, so there is no data or privacy risk.

      If you only want to disable the popup, you can set the pref `browser.translations.automaticallyPopup` to false using the [Preferences](#preferences) policy.

      **Compatibility:** Firefox 126
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.translations.enable`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 126" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "browser.translations.enable" ];
    Example = ''
      {
        "policies": {
          "TranslateEnabled": true | false
        }
      }
    '';
  };
  UserMessaging = {
    Description = ''
      Prevent Firefox from messaging the user in certain situations.

      `WhatsNew` Remove the "What's New" icon and menuitem. (*Deprecated*)

      `ExtensionRecommendations` If false, don't recommend extensions while the user is visiting web pages.

      `FeatureRecommendations` If false, don't recommend browser features.

      `UrlbarInterventions` If false, don't offer Firefox specific suggestions in the URL bar.

      `SkipOnboarding` If true, don't show onboarding messages on the new tab page.

      `MoreFromMozilla` If false, don't show the "More from Mozilla" section in Preferences. (Firefox 98)

      `FirefoxLabs` If false, don't show the "Firefox Labs" section in Preferences. (Firefox 130.0.1)

      `Locked` prevents the user from changing user messaging preferences.

      **Compatibility:** Firefox 75, Firefox ESR 68.7
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons`, `browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features`, `browser.aboutwelcome.enabled`, `browser.preferences.moreFromMozilla`, `browser.preferences.experimental`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 75"
      "Firefox ESR 68.7"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features"
      "browser.aboutwelcome.enabled"
      "browser.preferences.moreFromMozilla"
      "browser.preferences.experimental"
    ];
    Example = ''
      {
        "policies": {
          "UserMessaging": {
            "ExtensionRecommendations": true | false,
            "FeatureRecommendations": true | false,
            "UrlbarInterventions": true | false,
            "SkipOnboarding": true | false,
            "MoreFromMozilla": true | false,
            "FirefoxLabs": true | false,
            "Locked": true | false
          }
        }
      }
    '';
  };
  UseSystemPrintDialog = {
    Description = ''
      Use the system print dialog instead of the print preview window.

      **Compatibility:** Firefox 102
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `print.prefer_system_dialog`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 102" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "print.prefer_system_dialog" ];
    Example = ''
      {
        "policies": {
          "UseSystemPrintDialog": true | false
        }
      }
    '';
  };
  VisualSearchEnabled = {
    Description = ''
      Enable or disable visual search.

      **Compatibility:** Firefox 144
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `browser.search.visualSearch.featureGate`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 144" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "browser.search.visualSearch.featureGate" ];
    Example = ''
      {
        "policies": {
          "VisualSearchEnabled": true | false
        }
      }
    '';
  };
  WebsiteFilter = {
    Description = ''
      Block websites from being visited. The parameters take an array of Match Patterns, as documented in https://developer.mozilla.org/en-US/Add-ons/WebExtensions/Match_patterns.
      The arrays are limited to 1000 entries each.

      If you want to block all URLs, you can use `<all_urls>` or `*://*/*`. You can't have just a `*` on the right side.

      For specific protocols, use `https://*/*` or `http://*/*`.

      As of Firefox 83 and Firefox ESR 78.5, file URLs are supported.

      **Compatibility:** Firefox 60, Firefox ESR 60
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** N/A
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [
      "Firefox 60"
      "Firefox ESR 60"
    ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ ];
    Example = ''
      {
        "policies": {
          "WebsiteFilter": {
            "Block": [
              "<all_urls>"
            ],
            "Exceptions": [
              "http://example.org/*"
            ]
          }
        }
      }
    '';
  };
  WindowsSSO = {
    Description = ''
      Allow Windows single sign-on for Microsoft, work, and school accounts.

      If this policy is set to true, Firefox will use credentials stored in Windows to sign in to Microsoft, work, and school accounts.

      **Compatibility:** Firefox 91
      **CCK2 Equivalent:** N/A
      **Preferences Affected:** `network.http.windows-sso.enabled`
    '';
    Deprecated = false;
    Children = [ ];
    Compatibility = [ "Firefox 91" ];
    "CCK2-Equivalent" = [ ];
    "Preferences-Affected" = [ "network.http.windows-sso.enabled" ];
    Example = ''
      {
        "policies": {
          "WindowsSSO": true | false
        }
      }
    '';
  };
}
