{
  "keyboard.dispatch" = "keyCode";
  "editor.formatOnSave" = true;
  "editor.multiCursorModifier" = "ctrlCmd";
  "editor.formatOnPaste" = true;
  "editor.formatOnType" = true;
  "editor.fontLigatures" = true;
  "editor.unicodeHighlight.ambiguousCharacters" = false;
  "editor.renderWhitespace" = "all";
  # "editor.defaultFormatter" = "trunk.io";

  "window.titleBarStyle" = "custom";

  "explorer.confirmDragAndDrop" = false;
  "explorer.confirmDelete" = false;
  "explorer.confirmPasteNative" = false;

  "files.hotExit" = "onExitAndWindowClose";
  "files.autoSave" = "afterDelay";
  "files.trimTrailingWhitespace" = true;
  "files.associations" = {
    "*.gpi" = "gnuplot";
    "*.in" = "lmps";
  };
  "files.exclude" = {
    "**/.trunk/*actions/" = true;
    "**/.trunk/*logs/" = true;
    "**/.trunk/*notifications/" = true;
    "**/.trunk/*out/" = true;
    "**/.trunk/*plugins/" = true;
  };
  "files.watcherExclude" = {
    "**/.trunk/*actions/" = true;
    "**/.trunk/*logs/" = true;
    "**/.trunk/*notifications/" = true;
    "**/.trunk/*out/" = true;
    "**/.trunk/*plugins/" = true;
  };

  "diffEditor.codeLens" = true;
  "diffEditor.wordWrap" = "on";

  "notebook.lineNumbers" = "on";

  "security.workspace.trust.untrustedFiles" = "open";

  "git.autofetch" = true;
  "git.confirmSync" = false;
  "git.enableCommitSigning" = true;
  "git.ignoreRebaseWarning" = true;

  "workbench.layoutControl.enabled" = false;
  "workbench.editorAssociations" = {
    "*.pdf" = "latex-workshop-pdf-hook";
    "*.gz" = "default";
  };

  "terminal.integrated.sendKeybindingsToShell" = true;
  "terminal.integrated.enableMultiLinePasteWarning" = "never";

  "debug.onTaskErrors" = "abort";

  "atomKeymap.promptV3Features" = true;
  "redhat.telemetry.enabled" = true;
  "githubPullRequests.createOnPublishBranch" = "never";
  "vscodeGoogleTranslate.preferredLanguage" = "Russian";
  "dart.previewFlutterUiGuides" = true;

  "licenser.author" = "Perevoshchikov Egor";
  "licenser.license" = "GPLv3";
  "licenser.disableAutoHeaderInsertion" = true;
  "licenser.disableAutoSave" = true;

  "scm.alwaysShowActions" = true;
  "scm.alwaysShowRepositories" = true;
  "scm.defaultViewMode" = "tree";

  "randomNameGen.DefaultCasing" = "PascalCase";
  "randomNameGen.WordCount" = 1;

  "lammps.AutoComplete.Setting" = "Extensive";
  "lammps.Hover.Detail" = "Complete";
  "lammps.tasks.binary" = "/home/kein/.local/bin/lmp";

  "author-header" = {
    "author" = "Egor Perevoshchikov";
    "contents" = [
      "Open type style"
    ];
    "auto-comment-type" = "#";
    "auto-space" = true;
    "auto-title" = true;
    "auto-date-type" = 3;
  };

  "remote.SSH.configFile" = "/home/kein/.ssh/config";
  "remote.SSH.enableRemoteCommand" = true;

  "actionButtons" = {
    "defaultColor" = "#ff0034"; # Can also use string color names.
    "loadNpmCommands" = false; # Disables automatic generation of actions for npm commands.
    "reloadButton" = "♻️"; # Custom reload button text or icon (default ↻). null value enables automatic reload on configuration change
    "commands" = [
      {
        "cwd" = "\${workspaceFolder}";
        "name" = "SyncRepo";
        "color" = "white";
        "singleInstance" = true;
        "command" = "rsync -azP --exclude-from=\${workspaceFolder}/rsync.ex \${workspaceFolder} fisher=/scratch/perevoshchikyy/repos/\${workspaceFolderBasename}/../"; # This is executed in the terminal.
      }
      {
        "cwd" = "\${cwd}";
        "name" = "Plot gpi";
        "color" = "white";
        "singleInstance" = true;
        "command" = "/home/kein/execs/plt.py --file=\"\${file}\""; # This is executed in the terminal.
      }
      # {
      #     "name" = "Build Cargo";
      #     "color" = "green";
      #     "command" = "cargo build ${file}";
      # }
      # {
      #     "name" = "🪟 Split editor";
      #     "color" = "orange";
      #     "useVsCodeApi" = true;
      #     "command" = "workbench.action.splitEditor"
      # }
    ];
  };

  "insertDateString.format" = "DD-MM-YYYY hh=mm=ss";
  "insertDateString.formatDate" = "DD-MM-YYYY";

  "lpubsppop01.autoTimeStamp.lineLimit" = 10;
  "lpubsppop01.autoTimeStamp.momentFormat" = "DD-MM-YYYY HH=mm=ss";
  "lpubsppop01.autoTimeStamp.birthTimeStart" = "# Created= ]";

  "ltex.additionalRules.languageModel" = "ru";
  "ltex.additionalRules.motherTongue" = "ru-RU";
  "ltex.language" = "ru-RU";

  "todo-tree.general.tags" = [
    "BUG"
    "HACK"
    "FIXME"
    "TODO"
    "XXX"
    "[ ]"
    "[x]"
    "type= ignore"
  ];

  "deepl.formality" = "default";
  "deepl.tagHandling" = "off";
  "deepl.splitSentences" = "1";
  "deepl.translationMode" = "Replace";

  "sonarlint.rules" = {
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
    "python:S1192" = { # String literals should not be duplicated
      "level" = "off";
    };
    "python:S117" = { # Local variable and function parameter names should comply with a naming convention
      "level" = "off";
    };
    "python:S5843" = { # Regular expressions should not be too complicated
      "level" = "off";
    };
  };
  "sonarlint.connectedMode.connections.sonarcloud" = [
    {
      "organizationKey" = "abkein";
      "connectionId" = "abkein";
      "region" = "EU";
    }
  ];

  "geminicodeassist.inlineSuggestions.enableAuto" = false;
  "geminicodeassist.project" = "someimportantproject";

  "[nix].editor.tabSize" = 2;
  # "nixEnvSelector.suggestion" = false;
  # "nixEnvSelector.useFlakes" = true;
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = "nil"; # or "nixd"
  # LSP config can be passed via the ``nix.serverSettings.{lsp}`` as shown below.
  "nix.serverSettings" = {
    # check https://github.com/oxalica/nil/blob/main/docs/configuration.md for all options available
    "nil" = {
      # "diagnostics" = {
      #  "ignored" = ["unused_binding" "unused_with"];
      # };
      "formatting" = {
        "command" = [
          "nixfmt"
        ];
      };
    };
    # check https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
    "nixd" = {
      "formatting" = {
        "command" = [
          "nixfmt"
        ];
      };
      "options" = {
        # By default, this entry will be read from `import <nixpkgs> { }`.
        # You can write arbitrary Nix expressions here, to produce valid "options" declaration result.
        # Tip: for flake-based configuration, utilize `builtins.getFlake`
        "nixos" = {
          "expr" = "(builtins.getFlake \"/home/kein/nixos-configuration/conf\").nixosConfigurations.<name>.options";
        };
        "home-manager" = {
          "expr" = "(builtins.getFlake \"/home/kein/nixos-configuration/conf\").homeConfigurations.<name>.options";
        };
      };
    };
  };
}
