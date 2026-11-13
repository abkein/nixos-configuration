{
  config,
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
mylib.flattenAttrsDot' (
  {
    redhat.telemetry.enabled = false;
    telemetry = {
      telemetryLevel = "off"; # default profile
      enableTelemetry = false; # default profile
      feedback.enabled = false;
    };
    update = {
      # default profile
      channel = "none";
      mode = "none";
      showReleaseNotes = false;
      showPostInstallInfo = false;
    };
    extensions = {
      autoCheckUpdates = false; # default profile
      autoUpdate = "off"; # default profile
      ignoreRecommendations = true;
    };
    chat = {
      defaultToCopilotHarness = false;
      editor = {
        localAgent.enabled = true;
        preferCopilotHarness = false;
      };
      # disableAIFeatures = true;
      # fontFamily = seriffont;
      # fontSize = fontsize;
      # editor = {
      #   fontFamily = monofont;
      #   fontSize = fontsize;
      # };
      agentHost = {
        enabled = true;
        agentOrchestrationLimits = "on";
        byokModels.enabled = false;
        claudeAgent.enabled = false;
        codexAgent.enabled = true;
        agentDebugLog.enabled = true;
        computerUse.enabled = true;
        experimental = {
          autoAttachPullRequests = true;
          markdownPlanRichLinks = true;
          mcpToolRouting = true;
          systemProxy.enabled = true;
        };
      };
      agentMerge = {
        enabled = true;
        addressReviews = true;
        fixCI = true;
        replyAttribution = true;
        resolveConflicts = true;
      };
      artifactIntegrations.enabled = true;
      artifactTools.enabled = true;
      canvases.enabled = true;
      experimental.workspaceSnapshot = true;
      stickyScroll.enabled = true;
      agent = {
        enabled = true;
        networkFilter = false;
        codeBlockProgress = true;
        collapseCompletedResponses = false;
      };
      agentSessionProjection.enabled = true;
      agentSessions.showExternal = "last30Days";
      # agentsHandoffTip.mode = "default";
      agentsWindowBanner = {
        enabled = true;
        developerMode = true;
        revealCurrentSession = true;
      };
      artifacts.enabled = true;
      autopilot.advanced.enabled = true;
      autoReply = false;
      btwTip.enabled = true;
      checkpoints = {
        enabled = true;
        showFileChanges = true;
      };
      closedPromoNotification = "copilotIconPopup";
      contextUsage.enabled = true;
      customizations = {
        locationsMigration.enabled = true;
        marketplace.enabled = true;
        mcpServerMigration.enabled = true;
        migration.enabled = true;
        promptMigration.enabled = true;
        structuredPreview.enabled = true;
        userDataMigration.enabled = true;
      };
      experimental = {
        sessionStateIndicator.enabled = true;
        stickyScroll.enabled = true;
      };
      experimentalModePermissionsPicker = true;
      extensionTools.enabled = true;
      extensionUnification.enabled = true;
      math.enabled = true;
      mcp = {
        access = "all";
        apps.enabled = true;
        gallery.enabled = true;
      };
      microsoftAuthentication.enabled = "never";
      plugins.enabled = true;
      progressBorder.enabled = true;
      requestQueuing.defaultAction = "steer";
      restoreLastPanelSession = false;
      tips.enabled = true;
      viewProgressBadge.enabled = true;
      viewSessions.enabled = true;
    };

    sessions = {
      chat.unifiedWorkspacePicker.enabled = true;
      chatTimeline.display = "gutter";
    };

    workbench = {
      colorTheme = "Dark Modern"; # stylix
      preferredDarkColorTheme = "Dark Modern";
      reduceMotion = "off";
      # editorAssociations = mylib.flattenAttrsDot'.literal {
      #   "*.pdf" = "pdf.preview";
      # };
      layoutControl.enabled = false;
      secondarySideBar.defaultVisibility = "hidden";
      editor = {
        markdownDefaultEditorInAgentsWindow = true;
        enablePreview = false;
        useModal = "off";
        wrapTabs = true;
      };
      settings.alwaysShowAdvancedSettings = true;
      commandPalette.experimental.suggestCommands = true;
      experimental = {
        modernUI = true;
        # fontFamily = monofont;
        # fontSize = fontsize;
      };
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

    editor = {
      formatOnSave = true;
      multiCursorModifier = "ctrlCmd";
      formatOnPaste = true;
      formatOnType = true;
      autoIndentOnPaste = true;
      guides.bracketPairs = true;
      renderLineHighlight = "all";
      renderRichScreenReaderContent = true;
      semanticHighlighting.enabled = true;
      smoothScrolling = true;
      stablePeek = true;
      tabCompletion = "on";
      tabSize = 2;
      wordWrap = "on";
      quickSuggestions = {
        comments = "on";
        strings = "on";
        other = "on";
      };
      # wrapOnEscapedLineFeeds = true;
      # aiStats.enabled = true;
      # experimentalGpuAcceleration = "on";
      find.autoFindInSelection = "multiline";
      inlineSuggest.showToolbar = "always";
      inlineSuggest.experimental.showOnSuggestConflict = "always";
      unicodeHighlight.ambiguousCharacters = false;
      renderWhitespace = "all";
      # defaultFormatter = "trunk.io";
      fontFamily = monofont;
      fontSize = fontsize;
      fontLigatures = true;
      inlineSuggest.fontFamily = monofont;
      codeLensFontFamily = monofont;
    };

    chatgpt = {
      composerEnterBehavior = "cmdIfMultiline";
      followUpQueueMode = "steer";
      reviewDelivery = "detached";
      cliExecutable = "${ipkgs.codex}/bin/codex";
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
      # defaul profile
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
      autoGuessEncoding = true;
      hotExit = "onExitAndWindowClose"; # default profile
      autoSave = "afterDelay";
      trimTrailingWhitespace = true;
      associations = mylib.flattenAttrsDot'.literal {
        "*.gpi" = "gnuplot";
        "*.in" = "lmps";
        ".clang-tidy" = "yaml";
        ".clang-format" = "yaml";
      };
      # exclude = mylib.flattenAttrsDot'.literal {
      #   "**/.trunk/*actions/" = true;
      #   "**/.trunk/*logs/" = true;
      #   "**/.trunk/*notifications/" = true;
      #   "**/.trunk/*out/" = true;
      #   "**/.trunk/*plugins/" = true;
      # };
      # watcherExclude = mylib.flattenAttrsDot'.literal {
      #   "**/.trunk/*actions/" = true;
      #   "**/.trunk/*logs/" = true;
      #   "**/.trunk/*notifications/" = true;
      #   "**/.trunk/*out/" = true;
      #   "**/.trunk/*plugins/" = true;
      # };
    };

    diffEditor = {
      codeLens = true;
      wordWrap = "on";
      ignoreTrimWhitespace = false;
      experimental = {
        showMoves = true;
        useTrueInlineView = true;
      };
    };

    notebook = {
      lineNumbers = "on";
      # markup.fontFamily = seriffont;
    };

    markdown = {
      editor.quickSuggestion = true;
      occurrencesHighlight.enabled = true;
      updateLinksOnFileMove.enabled = "prompt";
      validate.enabled = true;
      preview = {
        fontFamily = seriffont;
        fontSize = fontsize + 2;
        doubleClickToSwitchToEditor = true;
        frontMatter = "table";
      };
      math = {
        enabled = true;
        # A collection of custom macros. Each macro is a key-value pair where the key is a new command name and the value is the expansion of the macro.
        # macros = {};
      };
    };

    screencastMode.fontSize = 48;
    keyboard.dispatch = "keyCode";
    dart.previewFlutterUiGuides = true;

    security.workspace.trust = {
      untrustedFiles = "open";
      startupPrompt = "once";
    };

    githubPullRequests = {
      createOnPublishBranch = "never";
      commentExpandState = "collapseAll";
    };

    debug = {
      onTaskErrors = "abort";
      # console = {
      #   fontFamily = monofont;
      #   fontSize = fontsize;
      # };
    };

    direnv = {
      watchForChanges = false;
      restart.automatic = true;
    };

    git = {
      allowForcePush = true;
      allowNoVerifyCommit = true;
      blame.editorDecoration.enabled = true;
      autofetch = false;
      detectWorktrees = true;
      fetchOnPull = true;
      enableCommitSigning = true;
      mergeEditor = true;
      pullBeforeCheckout = true;
      confirmSync = false;
    };

    scm = {
      alwaysShowActions = true;
      alwaysShowRepositories = true;
      defaultViewMode = "tree";
      # inputFontSize = fontsize;
    };

    lammps = {
      AutoComplete.Setting = "Extensive";
      Hover.Detail = "Complete";
    };

    remote.SSH = {
      configFile = "${config.home.homeDirectory}/.ssh/config";
      enableRemoteCommand = true;
    };

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

    todo-tree = {
      ripgrep.ripgrep = "${pkgs.ripgrep}/bin/rg";
      general.tags = [
        "BUG"
        "FIXME"
        "TODO"
        "type= ignore"
      ];
    };

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

    "[nix]" = mylib.flattenAttrsDot'.literal { "editor.tabSize" = 2; };
    "[markdown]" = mylib.flattenAttrsDot'.literal {
      "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
    };

    # nixEnvSelector = {
    #   suggestion = false;
    #   useFlakes = true;
    # };

    nix = {
      enableLanguageServer = true;
      serverPath = "${pkgs.nixd}/bin/nixd"; # or "nil"
      # formatterPath = "${pkgs.nixfmt}/bin/nixfmt --strict --verify";  # VSCode says it should be a enum value. Nevertheless, it's not used if `enableLanguageServer = true`
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
  // (
    let
      entries = lib.readDir ./by-extension;

      files = lib.filter (name: entries.${name} == "regular" && lib.hasSuffix ".nix" name) (
        lib.attrNames entries
      );

      importFile = file: import (./by-extension + "/${file}") args;
    in
    lib.foldl' (acc: file: acc // (importFile file)) { } files
  )
)
