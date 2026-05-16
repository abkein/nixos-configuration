{
  lib,
  pkgs,
  mylib,
  cfg,
  ...
}:
lib.mkMerge (
  lib.map mylib.flattenAttrsDot' [
    {
      editor = {
        formatOnSave = true;
        multiCursorModifier = "ctrlCmd";
        formatOnPaste = true;
        formatOnType = true;
        fontLigatures = false;
        autoIndentOnPaste = true;
        unicodeHighlight.ambiguousCharacters = false;
        renderWhitespace = "all";
        # defaultFormatter = "trunk.io";
      };

      chat = {
        disableAIFeatures = true;
        mcp.gallery.enabled = true;
      };
      chatgpt = {
        composerEnterBehavior = "cmdIfMultiline";
        followUpQueueMode = "steer";
        reviewDelivery = "detached";
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

      "terminal.integrated.sendKeybindingsToShell" = true;
      "terminal.integrated.enableMultiLinePasteWarning" = "never";

      window = {
        titleBarStyle = "custom";
        customTitleBarVisibility = "hidden";
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
        associations = builtins.toJSON {
          "*.gpi" = "gnuplot";
          "*.in" = "lmps";
        };
        exclude = builtins.toJSON {
          "**/.trunk/*actions/" = true;
          "**/.trunk/*logs/" = true;
          "**/.trunk/*notifications/" = true;
          "**/.trunk/*out/" = true;
          "**/.trunk/*plugins/" = true;
        };
        watcherExclude = builtins.toJSON {
          "**/.trunk/*actions/" = true;
          "**/.trunk/*logs/" = true;
          "**/.trunk/*notifications/" = true;
          "**/.trunk/*out/" = true;
          "**/.trunk/*plugins/" = true;
        };
      };

      "diffEditor.codeLens" = true;
      "diffEditor.wordWrap" = "on";

      "notebook.lineNumbers" = "on";

      "security.workspace.trust.untrustedFiles" = "open";

      "debug.onTaskErrors" = "abort";
      "extensions.ignoreRecommendations" = true;

      "direnv.watchForChanges" = false;

      git = {
        autofetch = true;
        confirmSync = false;
        enableCommitSigning = true;
        ignoreRebaseWarning = true;
      };

      workbench = {
        colorTheme = "Dark Modern";
        layoutControl.enabled = false;
        secondarySideBar.defaultVisibility = "hidden";
        # editorAssociations = builtins.toJSON {
        #   "*.pdf" = "pdf.preview";
        # };
      };

      "keyboard.dispatch" = "keyCode";
      "atomKeymap.promptV3Features" = true;
      "redhat.telemetry.enabled" = true;
      "githubPullRequests.createOnPublishBranch" = "never";
      "vscodeGoogleTranslate.preferredLanguage" = "Russian";
      "dart.previewFlutterUiGuides" = true;

      scm = {
        alwaysShowActions = true;
        alwaysShowRepositories = true;
        defaultViewMode = "tree";
      };

      "randomNameGen.DefaultCasing" = "PascalCase";
      "randomNameGen.WordCount" = 1;

      "lammps.AutoComplete.Setting" = "Extensive";
      "lammps.Hover.Detail" = "Complete";

      "remote.SSH.configFile" = "/home/kein/.ssh/config";
      "remote.SSH.enableRemoteCommand" = true;

      actionButtons = builtins.toJSON {
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

      "todo-tree.general.tags" = builtins.toJSON [
        "BUG"
        "HACK"
        "FIXME"
        "TODO"
        "XXX"
        "[ ]"
        "[x]"
        "type= ignore"
      ];

      # deepl = {
      #   formality = "default";
      #   tagHandling = "off";
      #   splitSentences = "1";
      #   translationMode = "Replace";
      # };

      sonarlint = {
        "connectedMode.connections.sonarcloud" = builtins.toJSON [
          {
            "organizationKey" = "abkein";
            "connectionId" = "abkein";
            "region" = "EU";
          }
        ];
        rules = builtins.toJSON {
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

      "[cpp]" = builtins.toJSON {
        "editor.tabSize" = 2;
      };
      "[nix]" = builtins.toJSON {
        "editor.tabSize" = 2;
      };

      nixEnvSelector = {
        # suggestion = false;
        # useFlakes = true;
      };

      nix = {
        enableLanguageServer = true;
        serverPath = "${pkgs.nil}/bin/nil"; # or "nixd"
        # LSP config can be passed via the ``nix.serverSettings.{lsp}`` as shown below.
        serverSettings = builtins.toJSON {
          # check https://github.com/oxalica/nil/blob/main/docs/configuration.md for all options available
          nil = {
            diagnostics = {
              # Ignored diagnostic kinds.
              # The kind identifier is a snake_cased_string usually shown together
              # with the diagnostic message.
              # Type: [string]
              # Example: ["unused_binding", "unused_with"]
              ignored = [
                # "unused_binding"
                # "unused_with"
              ];
              # Files to exclude from showing diagnostics. Useful for generated files.
              # It accepts an array of paths. Relative paths are joint to the workspace root.
              # Glob patterns are currently not supported.
              # Type: [string]
              # Example: ["Cargo.nix"]
              excludedFiles = [ ];
            };
            formatting = {
              # External formatter command (with arguments).
              # It should accepts file content in stdin and print the formatted code into stdout.
              # Type: [string] | null
              # Example: ["nixfmt"]
              command = [
                "${pkgs.nixfmt}/bin/nixfmt"
                "--strict"
                "--verify"
              ];
            };
            nix = {
              # The path to the `nix` binary.
              # Type: string
              # Example: "/run/current-system/sw/bin/nix"
              binary = "${pkgs.nix}/bin/nix";
              # The heap memory limit in MiB for `nix` evaluation.
              # Currently it only applies to flake evaluation when `autoEvalInputs` is
              # enabled, and only works for Linux. Other `nix` invocations may be also
              # applied in the future. `null` means no limit.
              # As a reference, `nix flake show --legacy nixpkgs` usually requires
              # about 2GiB memory.
              #
              # Type: number | null
              # Example: 1024
              maxMemoryMB = 3072;
              flake = {
                # Auto-archiving behavior which may use network.
                #
                # - null: Ask every time.
                # - true: Automatically run `nix flake archive` when necessary.
                # - false: Do not archive. Only load inputs that are already on disk.
                # Type: null | boolean
                # Example: true
                autoArchive = false;
                # Whether to auto-eval flake inputs.
                # The evaluation result is used to improve completion, but may cost
                # lots of time and/or memory.
                #
                # Type: boolean
                # Example: true
                autoEvalInputs = true;
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
          nixd = {
            "nixpkgs" = {
              # For flake.
              expr = "import (builtins.getFlake \"${cfg.flakepath}\").inputs.nixpkgs { }   ";

              # This expression will be interpreted as "nixpkgs" toplevel
              # Nixd provides package, lib completion/information from it.
              #
              # Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
              #                Package documentation, versions, are evaluated by-need.
              # expr = "import <nixpkgs> { }";
            };
            formatting = {
              # Which command you would like to do formatting
              command = [
                "${pkgs.nixfmt}/bin/nixfmt"
                "--strict"
                "--verify"
              ];
            };
            # Tell the language server your desired option set, for completion. This is lazily evaluated.
            # Map of eval information
            options = {
              # By default, this entriy will be read from `import <nixpkgs> { }`
              # You can write arbitary nix expression here, to produce valid "options" declaration result.
              #
              # *NOTE*: Replace "<name>" below with your actual configuration name.
              # If you're unsure what to use, you can verify with `nix repl` by evaluating
              # the expression directly.

              # By default, this entry will be read from `import <nixpkgs> { }`.
              # You can write arbitrary Nix expressions here, to produce valid "options" declaration result.
              # Tip: for flake-based configuration, utilize `builtins.getFlake`
              nixos = {
                expr = "(builtins.getFlake \"${cfg.flakepath}\").nixosConfigurations.jeta.options";
              };
              # Before configuring Home Manager options, consider your setup:
              # Which command do you use for home-manager switching?
              #
              #  A. home-manager switch --flake .#... (standalone Home Manager)
              #  B. nixos-rebuild switch --flake .#... (NixOS with integrated Home Manager)
              #
              # Configuration examples for both approaches are shown below.
              home-manager = {
                # A:
                # expr = "(builtins.getFlake \"${cfg.flakepath}\").homeConfigurations.jeta.options";
                # expr = "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.<name>.options";

                # B:
                expr = "(builtins.getFlake \"${cfg.flakepath}\").nixosConfigurations.jeta.options.home-manager.users.type.getSubOptions []";
              };
            };
            # Control the diagnostic system
            diagnostic = {
              suppress = [
                "sema-extra-with"
              ];
            };
          };

        };
      };
    }
    (import ./by-extension/tamasfe.even-better-toml.nix)
  ]
)
