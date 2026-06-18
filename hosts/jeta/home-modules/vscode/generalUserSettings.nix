{
  lib,
  pkgs,
  mylib,
  cfg,
  ipkgs,
  ...
}@args:
let
  monofont = "'Noto Sans Mono', 'Symbols Nerd Font'";
  seriffont = "'Noto Sans Serif', 'Symbols Nerd Font'";
  fontsize = 14;
in
lib.mkMerge (
  lib.map mylib.flattenAttrsDot' [
    {
      "telemetry.telemetryLevel" = "off";

      editor = {
        formatOnSave = true;
        multiCursorModifier = "ctrlCmd";
        formatOnPaste = true;
        formatOnType = true;
        autoIndentOnPaste = true;
        unicodeHighlight.ambiguousCharacters = false;
        renderWhitespace = "all";
        # defaultFormatter = "trunk.io";
        fontFamily = monofont;
        fontSize = fontsize;
        fontLigatures = true;
        inlineSuggest.fontFamily = monofont;
        codeLensFontFamily = monofont;
        # minimap.sectionHeaderFontSize = 10.285714285714286; # ?????
      };

      chat = {
        disableAIFeatures = true;
        mcp.gallery.enabled = true;
        # fontFamily = seriffont;
        # editor = {
        #   fontFamily = monofont;
        #   fontSize = fontsize;
        # };
      };
      chatgpt = {
        composerEnterBehavior = "cmdIfMultiline";
        followUpQueueMode = "steer";
        reviewDelivery = "detached";
        cliExecutable = "${ipkgs.codex-cli}/bin/codex";
      };
      claudeCode = {
        disableLoginPrompt = true;
        preferredLocation = "sidebar";
        claudeProcessWrapper = "claude";
        useCtrlEnterToSend = true;
      };
      # geminicodeassist = {
      #   inlineSuggestions.enableAuto = false;
      #   project = "someimportantproject";
      # };

      terminal.integrated = {
        sendKeybindingsToShell = true;
        enableMultiLinePasteWarning = "never";
        fontLigatures.enabled = true;
      };

      window = {
        titleBarStyle = "custom";
        customTitleBarVisibility = "never";
        dialogStyle = "custom";
        menuBarVisibility = "hidden";
      };

      explorer = {
        confirmDragAndDrop = false;
        confirmDelete = false;
        confirmPasteNative = false;
      };

      files = {
        hotExit = "onExitAndWindowClose";
        autoSave = "afterDelay";
        trimTrailingWhitespace = true;
        associations = mylib.flattenAttrsDot'.literal {
          "*.gpi" = "gnuplot";
          "*.in" = "lmps";
        };
        exclude = mylib.flattenAttrsDot'.literal {
          "**/.trunk/*actions/" = true;
          "**/.trunk/*logs/" = true;
          "**/.trunk/*notifications/" = true;
          "**/.trunk/*out/" = true;
          "**/.trunk/*plugins/" = true;
        };
        watcherExclude = mylib.flattenAttrsDot'.literal {
          "**/.trunk/*actions/" = true;
          "**/.trunk/*logs/" = true;
          "**/.trunk/*notifications/" = true;
          "**/.trunk/*out/" = true;
          "**/.trunk/*plugins/" = true;
        };
      };

      diffEditor = {
        codeLens = true;
        wordWrap = "on";
        ignoreTrimWhitespace = false;
      };

      notebook = {
        lineNumbers = "on";
        # markup.fontFamily = seriffont;
      };

      markdown.preview = {
        fontFamily = seriffont;
        fontSize = fontsize;
      };

      screencastMode.fontSize = 48;

      "security.workspace.trust.untrustedFiles" = "open";

      debug = {
        onTaskErrors = "abort";
        # console = {
        #   fontFamily = monofont;
        #   fontSize = fontsize;
        # };
      };
      "extensions.ignoreRecommendations" = true;

      "direnv.watchForChanges" = false;

      git = {
        autofetch = true;
        confirmSync = false;
        enableCommitSigning = true;
        ignoreRebaseWarning = true;
      };

      workbench = {
        colorTheme = "Dark Modern"; # stylix
        layoutControl.enabled = false;
        secondarySideBar.defaultVisibility = "hidden";
        editor.enablePreview = false;
        # editorAssociations = mylib.flattenAttrsDot'.literal {
        #   "*.pdf" = "pdf.preview";
        # };
        # experimental = {
        #   fontFamily = monofont;
        #   fontSize = fontsize;
        # };
        # navigationControl.enabled = false;
        # activityBar.experimental = {
        #   fontFamily = monofont;
        #   fontSize = fontsize;
        # };
        # bottomPane.experimental = {
        #   fontFamily = monofont;
        #   fontSize = fontsize;
        # };
        # sideBar.experimental = {
        #   fontFamily = monofont;
        #   fontSize = fontsize;
        # };
        # tabs.experimental = {
        #   fontFamily = monofont;
        #   fontSize = fontsize;
        # };
      };

      "keyboard.dispatch" = "keyCode";
      "atomKeymap.promptV3Features" = true;
      "redhat.telemetry.enabled" = true;
      "githubPullRequests.createOnPublishBranch" = "never";
      "dart.previewFlutterUiGuides" = true;

      scm = {
        alwaysShowActions = true;
        alwaysShowRepositories = true;
        defaultViewMode = "tree";
        # inputFontSize = fontsize;
      };

      "randomNameGen.DefaultCasing" = "PascalCase";
      "randomNameGen.WordCount" = 1;

      "lammps.AutoComplete.Setting" = "Extensive";
      "lammps.Hover.Detail" = "Complete";

      "remote.SSH.configFile" = "/home/kein/.ssh/config";
      "remote.SSH.enableRemoteCommand" = true;

      actionButtons = mylib.flattenAttrsDot'.literal {
        defaultColor = "#ff0034"; # Can also use string color names.
        loadNpmCommands = false; # Disables automatic generation of actions for npm commands.
        reloadButton = "♻️"; # Custom reload button text or icon (default ↻). null value enables automatic reload on configuration change
        commands = [
          {
            cwd = "\${workspaceFolder}";
            name = "SyncRepo";
            color = "white";
            singleInstance = true;
            command = "rsync -azP --exclude-from=\${workspaceFolder}/rsync.ex \${workspaceFolder} fisher=/scratch/perevoshchikyy/repos/\${workspaceFolderBasename}/../"; # This is executed in the terminal.
          }
          {
            cwd = "\${cwd}";
            name = "Plot gpi";
            color = "white";
            singleInstance = true;
            command = "/home/kein/execs/plt.py --file=\"\${file}\""; # This is executed in the terminal.
          }
          # {
          #     name = "Build Cargo";
          #     color = "green";
          #     command = "cargo build ${file}";
          # }
          # {
          #     name = "🪟 Split editor";
          #     color = "orange";
          #     useVsCodeApi = true;
          #     command = "workbench.action.splitEditor"
          # }
        ];
      };

      "todo-tree.general.tags" = [
        "BUG"
        "FIXME"
        "TODO"
        "type= ignore"
      ];

      # deepl = {
      #   formality = "default";
      #   tagHandling = "off";
      #   splitSentences = "1";
      #   translationMode = "Replace";
      # };

      sonarlint = {
        "connectedMode.connections.sonarcloud" = [
          {
            organizationKey = "abkein";
            connectionId = "abkein";
            region = "EU";
          }
        ];
        rules = mylib.flattenAttrsDot'.literal {
          "cpp=S134" = {
            "level" = "off";
          };
          "cpp=S125" = {
            "level" = "off";
          };
          "python:S3776" = {
            "level" = "off";
          };
          "python:S116" = {
            "level" = "off";
          };
          "python:S108" = {
            "level" = "off";
          };
          "python:S1192" = {
            # String literals should not be duplicated
            "level" = "off";
          };
          "python:S117" = {
            # Local variable and function parameter names should comply with a naming convention
            "level" = "off";
          };
          "python:S5843" = {
            # Regular expressions should not be too complicated
            "level" = "off";
          };
        };
      };

      "[cpp]" = mylib.flattenAttrsDot'.literal { "editor.tabSize" = 2; };
      "[nix]" = mylib.flattenAttrsDot'.literal { "editor.tabSize" = 2; };

      # nixEnvSelector = {
      #   suggestion = false;
      #   useFlakes = true;
      # };

      nix = {
        enableLanguageServer = true;
        serverPath = "${pkgs.nixd}/bin/nixd"; # or "nil"
        formatterPath = "${pkgs.nixfmt}/bin/nixfmt --strict --verify";
        serverSettings = mylib.flattenAttrsDot'.literal {
          # check https://github.com/oxalica/nil/blob/main/docs/configuration.md for all options available
          nil = {
            diagnostics = {
              # ignored = [
              #   # "unused_binding"
              #   # "unused_with"
              # ];
              excludedFiles = [ ]; # Globs are not supported
            };
            formatting = {
              command = [
                "${pkgs.nixfmt}/bin/nixfmt"
                "--strict"
                "--verify"
              ];
            };
            nix = {
              binary = "${pkgs.nix}/bin/nix";
              maxMemoryMB = 3072;
              flake = {
                # Auto-archiving behavior which may use network.
                #
                # - null: Ask every time.
                # - true: Automatically run `nix flake archive` when necessary.
                # - false: Do not archive. Only load inputs that are already on disk.
                autoArchive = false;
                # Whether to auto-eval flake inputs.
                # The evaluation result is used to improve completion, but may cost
                # lots of time and/or memory.
                autoEvalInputs = false;
                # The input name of nixpkgs for NixOS options evaluation.
                #
                # The options hierarchy is used to improve completion, but may cost
                # lots of time and/or memory.
                # If this value is `null` or is not found in the workspace flake's
                # inputs, NixOS options are not evaluated.
                #
                # Type: null | string
                # Example: "nixos"
                nixpkgsInputName = "nixpkgs";
              };
            };
          };
          # check https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
          nixd =
            let
              flake = ''(builtins.getFlake "${cfg.flakepath}")'';
              host = "jeta";
              hostConfiguration = "${flake}.nixosConfigurations.${host}";
              hostOptions = "${hostConfiguration}.options";
            in
            {
              "nixpkgs" = {
                # expr = "import ${flake}.inputs.nixpkgs { }";
                expr = "${hostConfiguration}.pkgs";
              };
              formatting = {
                command = [
                  "${pkgs.nixfmt}/bin/nixfmt"
                  "--strict"
                  "--verify"
                ];
              };
              options = {
                nixos.expr = hostOptions;
                home-manager.expr = "${hostOptions}.home-manager.users.type.getSubOptions []";
              };
              # diagnostic = {
              #   suppress = [ "sema-extra-with" ];
              # };
            };

        };
      };
    }
    (import ./by-extension/tamasfe.even-better-toml.nix args)
  ]
)
