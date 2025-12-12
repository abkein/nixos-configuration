{
  "python.locator" = "js";
  "editor.formatOnSave"= true;
  "editor.multiCursorModifier"= "ctrlCmd";
  "editor.formatOnPaste"= true;
  "editor.formatOnType"= true;
  "editor.fontLigatures"= true;
  "editor.unicodeHighlight.ambiguousCharacters"= false;
  "editor.renderWhitespace"= "all";
  # "editor.defaultFormatter"= "trunk.io";

  "window.titleBarStyle"= "custom";

  "explorer.confirmDragAndDrop"= false;
  "explorer.confirmDelete"= false;
  "explorer.confirmPasteNative"= false;

  "files.hotExit" = "onExitAndWindowClose";
  "files.autoSave"= "afterDelay";
  "files.trimTrailingWhitespace" = true;
  "files.associations"= {
    "*.gpi"= "gnuplot";
    "*.in"= "lmps";
  };
  "files.exclude"= {
    "**/.trunk/*actions/"= true;
    "**/.trunk/*logs/"= true;
    "**/.trunk/*notifications/"= true;
    "**/.trunk/*out/"= true;
    "**/.trunk/*plugins/"= true;
  };
  "files.watcherExclude"= {
    "**/.trunk/*actions/"= true;
    "**/.trunk/*logs/"= true;
    "**/.trunk/*notifications/"= true;
    "**/.trunk/*out/"= true;
    "**/.trunk/*plugins/"= true;
  };

  "diffEditor.codeLens"= true;
  "diffEditor.wordWrap"= "on";

  "notebook.lineNumbers"= "on";

  "security.workspace.trust.untrustedFiles"= "open";

  "git.autofetch"= true;
  "git.confirmSync"= false;
  "git.enableCommitSigning"= true;
  "git.ignoreRebaseWarning"= true;

  "workbench.layoutControl.enabled"= false;
  "workbench.editorAssociations"= {
    "*.pdf"= "latex-workshop-pdf-hook";
    "*.gz"= "default";
  };

  "terminal.integrated.sendKeybindingsToShell"= true;
  "terminal.integrated.enableMultiLinePasteWarning"= false;

  "debug.onTaskErrors"= "abort";

  "atomKeymap.promptV3Features"= true;
  "redhat.telemetry.enabled"= true;
  "githubPullRequests.createOnPublishBranch"= "never";
  "vscodeGoogleTranslate.preferredLanguage"= "Russian";
  "dart.previewFlutterUiGuides"= true;

  "licenser.author"= "Perevoshchikov Egor";
  "licenser.license"= "GPLv3";
  "licenser.disableAutoHeaderInsertion"= true;
  "licenser.disableAutoSave"= true;

  "scm.alwaysShowActions"= true;
  "scm.alwaysShowRepositories"= true;
  "scm.defaultViewMode"= "tree";

  "randomNameGen.DefaultCasing"= "PascalCase";
  "randomNameGen.WordCount"= 1;

  "lammps.AutoComplete.Setting"= "Extensive";
  "lammps.Hover.Detail"= "Complete";
  "lammps.tasks.binary"= "/home/kein/.local/bin/lmp";

  "author-header"= {
    "author"= "Egor Perevoshchikov";
    "contents"= [
      "Open type style"
    ];
    "auto-comment-type"= "#";
    "auto-space"= true;
    "auto-title"= true;
    "auto-date-type"= 3;
  };

  "latex-workshop.latex.recipes" = [
    {
      "name" = "lualatex->biber->lualatex";
      "tools" = [
        "lualatex"
        "biber"
        "lualatex"
      ];
    }
  ];
  "latex-workshop.latex.tools"= [
    {
      "name"= "latexmk";
      "command"= "latexmk";
      "args"= [
          "-shell-escape"
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
          "-pdf"
          "-outdir=%OUTDIR%"
          "%DOC%"
      ];
      "env"= {};
    }
    {
      "name"= "pdflatex";
      "command"= "pdflatex";
      "args"= [
        "--shell-escape" # if you want to have the shell-escape flag
        "-synctex=1"
        "-interaction=nonstopmode"
        "-file-line-error"
        "%DOC%.tex"
      ];
    }
  ];
  "latex-workshop.latex.outDir"= "";
  "latex-workshop.latex.clean.fileTypes"= [];
  "latex-workshop.latex.clean.subfolder.enabled"= true;
  "latex-workshop.latex.autoBuild.run"= "never";
  "latex-workshop.latex.autoClean.run"= "onSucceeded";
  "latex-workshop.formatting.latex" = "tex-fmt";

  "remote.SSH.configFile"= "/home/kein/.ssh/config";
  "remote.SSH.enableRemoteCommand"= true;

  "actionButtons"= {
    "defaultColor"= "#ff0034"; # Can also use string color names.
    "loadNpmCommands"= false; # Disables automatic generation of actions for npm commands.
    "reloadButton"= "♻️"; # Custom reload button text or icon (default ↻). null value enables automatic reload on configuration change
    "commands"= [
      {
        "cwd"= "\${workspaceFolder}";
        "name"= "SyncRepo";
        "color"= "white";
        "singleInstance"= true;
        "command"= "rsync -azP --exclude-from=\${workspaceFolder}/rsync.ex \${workspaceFolder} fisher=/scratch/perevoshchikyy/repos/\${workspaceFolderBasename}/../"; # This is executed in the terminal.
      }
      {
        "cwd"= "\${cwd}";
        "name"= "Plot gpi";
        "color"= "white";
        "singleInstance"= true;
        "command"= "/home/kein/execs/plt.py --file=\"\${file}\""; # This is executed in the terminal.
      }
      # {
      #     "name"= "Build Cargo";
      #     "color"= "green";
      #     "command"= "cargo build ${file}";
      # }
      # {
      #     "name"= "🪟 Split editor";
      #     "color"= "orange";
      #     "useVsCodeApi"= true;
      #     "command"= "workbench.action.splitEditor"
      # }
    ];
  };

  # "python.analysis.diagnosticSeverityOverrides"= {
  #     "reportUnboundVariable"= "none";
  #     "reportGeneralTypeIssues"= "none"
  # };
  "python.editor.formatOnType"= true;
  "python.editor.defaultFormatter"= "ms-python.black-formatter";
  "python.analysis.inlayHints.functionReturnTypes"= true;
  "python.analysis.inlayHints.pytestParameters"= true;
  "python.analysis.inlayHints.variableTypes"= true;
  "python.analysis.completeFunctionParens"= true;
  "python.analysis.typeCheckingMode"= "basic";
  "python.analysis.autoFormatStrings"= true;
  "python.analysis.diagnosticMode"= "workspace";
  "python.analysis.autoImportCompletions"= true;
  "python.analysis.downloadStubs"= true;
  "python.analysis.inlayHints.callArgumentNames"= true;
  "python.formatting.provider"= "none";
  "python.formatting.autopep8Args"= [
    "--max-line-length 999999"
  ];

  "[python]" = {
    "editor.defaultFormatter" = "ms-python.black-formatter";
  };

  "flake8.args" = [
    "--disable=E701"
    "--max-line-length=120"
  ];

  "black-formatter.args"= [
    "--line-length=120"
  ];

  "mypy-type-checker.args"= [
    "--disable-error-code=import-untyped"
  ];

  "jupyter.askForKernelRestart" = false;
  "jupyter.disableJupyterAutoStart" = true;
  "jupyter.widgetScriptSources"= [
    "jsdelivr.com"
    "unpkg.com"
  ];
  "jupyter.logging.level" = "trace";

  "insertDateString.format"= "DD-MM-YYYY hh=mm=ss";
  "insertDateString.formatDate"= "DD-MM-YYYY";

  "lpubsppop01.autoTimeStamp.lineLimit"= 10;
  "lpubsppop01.autoTimeStamp.momentFormat"= "DD-MM-YYYY HH=mm=ss";
  "lpubsppop01.autoTimeStamp.birthTimeStart"= "# Created= ]";

  "ltex.additionalRules.languageModel"= "ru";
  "ltex.additionalRules.motherTongue"= "ru-RU";
  "ltex.language"= "ru-RU";

  "todo-tree.general.tags"= [
    "BUG"
    "HACK"
    "FIXME"
    "TODO"
    "XXX"
    "[ ]"
    "[x]"
    "type= ignore"
  ];

  "cmake.configureOnOpen"= true;
  "cmake.configureOnEdit"= false;
  "cmake.configureSettings"= {};
  "cmake.generator"= "Unix Makefiles";
  "cmake.showOptionsMovedNotification"= false;
  "cmake.options.statusBarVisibility"= "compact";
  "cmake.pinnedCommands"= [
    "workbench.action.tasks.configureTaskRunner"
    "workbench.action.tasks.runTask"
  ];

  "C_Cpp.formatting"= "disabled";
  "C_Cpp.intelliSenseUpdateDelay"= 3000;
  "C_Cpp.experimentalFeatures"= "enabled";
  "C_Cpp.workspaceParsingPriority"= "high";
  "C_Cpp.autocompleteAddParentheses"= true;
  "C_Cpp.default.mergeConfigurations"= true;
  "C_Cpp.inlayHints.parameterNames.enabled"= true;
  "C_Cpp.inlayHints.referenceOperator.enabled"= true;
  "C_Cpp.inlayHints.autoDeclarationTypes.enabled"= true;
  "C_Cpp.inlayHints.autoDeclarationTypes.showOnLeft"= true;
  "C_Cpp.inlayHints.parameterNames.suppressWhenArgumentContainsName"= false;
  "C_Cpp.default.includePath"= [
    "/usr/local/include/"
    "\${default}"
    "/usr/include/"
  ];

  "[cpp]"= {
    "editor.defaultFormatter" = "ms-vscode.cpptools";
  };

  "c-cpp-flylint.debug"= true;
  "c-cpp-flylint.flexelint.enable"= false;
  "c-cpp-flylint.cppcheck.extraArgs"= [
    "--check-level=exhaustive"
    "--force"
  ];

  "deepl.formality"= "default";
  "deepl.tagHandling"= "off";
  "deepl.splitSentences"= "1";
  "deepl.translationMode"= "Replace";

  "sonarlint.rules"= {
    "cpp=S134"= {
      "level"= "off";
    };
    "cpp=S125"= {
      "level"= "off";
    };
    "python:S3776"= {
      "level"= "off";
    };
    "python:S116"= {
      "level"= "off";
    };
    "python:S108"= {
      "level"= "off";
    };
    "python:S1192"= {    # String literals should not be duplicated
      "level"= "off";
    };
    "python:S117"= {    # Local variable and function parameter names should comply with a naming convention
      "level"= "off";
    };
    "python:S5843"= {    # Regular expressions should not be too complicated
      "level"= "off";
    };
  };
  "sonarlint.connectedMode.connections.sonarcloud" =  [
    {
      "organizationKey" = "abkein";
      "connectionId" = "abkein";
      "region" = "EU";
    }
  ];
  # "sonarlint.pathToNodeExecutable" = "";

  "geminicodeassist.inlineSuggestions.enableAuto" = false;
  "geminicodeassist.project" =  "someimportantproject";

  "nixEnvSelector.suggestion" = true;
  "[nix]"."editor.tabSize" = 2;
}