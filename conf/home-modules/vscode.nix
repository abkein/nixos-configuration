{pkgs, lib} :
let
    plugins = (import ./vscode_exts.nix) { inherit pkgs lib; };
in
{
  enable = true;
  package = pkgs.vscode-fhs;
  profiles.default = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    extensions = with pkgs.vscode-extensions;[
    #   mkhl.direnv
      jnoortheen.nix-ide
      alefragnani.bookmarks
      alexisvt.flutter-snippets
      coolbear.systemd-unit-file
      dart-code.dart-code
      dart-code.flutter
      funkyremi.vscode-google-translate
      github.vscode-pull-request-github
      gruntfuggly.todo-tree
      hars.cppsnippets
      james-yu.latex-workshop
      mads-hartmann.bash-ide-vscode
      mechatroner.rainbow-csv
      ms-ceintl.vscode-language-pack-ru
      ms-python.black-formatter
      ms-python.debugpy
      ms-python.flake8
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode-remote.vscode-remote-extensionpack
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      ms-vscode.hexeditor
      ms-vscode.makefile-tools
      njpwerner.autodocstring
      redhat.java
      redhat.vscode-xml
      sonarsource.sonarlint-vscode  # requires jre
      tamasfe.even-better-toml
      twxs.cmake
      valentjn.vscode-ltex
      visualstudioexptteam.intellicode-api-usage-examples
      visualstudioexptteam.vscodeintellicode
      vscjava.vscode-gradle
      yzhang.markdown-all-in-one
      arrterian.nix-env-selector
    ] ++ [
    #   plugins.christian-kohler.npm-intellisense
    # #   plugins.ms-python.vscode-python-envs
    #   plugins.github.remotehub
    #   plugins.google.geminicodeassist
    # #   plugins.googlecloudtools.cloudcode
    #   plugins.jbenden.c-cpp-flylint
    #   plugins.jeff-hykin.better-cpp-syntax
    #   plugins.jsynowiec.vscode-insertdatestring
    #   plugins.kevinrose.vsc-python-indent
    #   plugins.lpubsppop01.vscode-auto-timestamp
    #   plugins.mammothb.gnuplot
    #   plugins.ms-python.autopep8
    #   plugins.ms-python.mypy-type-checker
    #   plugins.ms-toolsai.vscode-jupyter-powertoys
    #   plugins.ms-vscode.atom-keybindings
    #   plugins.ms-vscode.azure-repos
    #   plugins.ms-vscode.cpptools-themes
    #   plugins.ms-vscode.js-debug
    #   plugins.ms-vscode.js-debug-companion
    #   plugins.ms-vscode.remote-explorer
    #   plugins.ms-vscode.remote-repositories
    #   plugins.ms-vscode.remote-server
    #   plugins.ms-vscode.vscode-js-profile-table
    #   plugins.ms-vscode.vscode-typescript-next
    #   plugins.ombratteng.nftables
    #   plugins.seunlanlege.action-buttons
    #   plugins.thfriedrich.lammps
    #   plugins.thmsrynr.vscode-namegen
    #   plugins.trond-snekvik.simple-rst
    # #  plugins.trunk.io
    #   plugins.turaiiao.vscode-author-header
    #   plugins.william-voyek.vscode-nginx
    #   plugins.ymotongpoo.licenser
    #   plugins.zhikui.vscode-openfoam
    # ];
    # ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #   {
    #     name = "atom-keybindings";
    #     publisher = "ms-vscode";
    #     version = "3.3.0";
    #     sha256 = "vzOb/DUV44JMzcuQJgtDB6fOpTKzq298WSSxVKlYE4o=";
    #   }
    ] ++  pkgs.nix4vscode.forVscode  [
      "christian-kohler.npm-intellisense"
    #   "ms-python.vscode-python-envs"
      "github.remotehub"
    #   "google.geminicodeassist"
    #   "googlecloudtools.cloudcode"
      "jbenden.c-cpp-flylint"
      "jeff-hykin.better-cpp-syntax"
      "jsynowiec.vscode-insertdatestring"
      "kevinrose.vsc-python-indent"
      "lpubsppop01.vscode-auto-timestamp"
      "mammothb.gnuplot"
      "ms-python.autopep8"
      "ms-python.mypy-type-checker"
      "ms-toolsai.vscode-jupyter-powertoys"
      "ms-vscode.atom-keybindings"
      "ms-vscode.azure-repos"
      "ms-vscode.cpptools-themes"
      "ms-vscode.js-debug"
      "ms-vscode.js-debug-companion"
      "ms-vscode.remote-explorer"
      "ms-vscode.remote-repositories"
      "ms-vscode.remote-server"
      "ms-vscode.vscode-js-profile-table"
      "ms-vscode.vscode-typescript-next"
      "ombratteng.nftables"
      "seunlanlege.action-buttons"
      "thfriedrich.lammps"
      "thmsrynr.vscode-namegen"
      "trond-snekvik.simple-rst"
    #   "trunk.io"
      "turaiiao.vscode-author-header"
      "william-voyek.vscode-nginx"
      "ymotongpoo.licenser"
      "zhikui.vscode-openfoam"
    ];
    userSettings = {
      "editor.formatOnSave"= true;
      "editor.multiCursorModifier"= "ctrlCmd";
      "editor.formatOnPaste"= true;
      "editor.formatOnType"= true;
      "editor.fontLigatures"= true;
      "editor.unicodeHighlight.ambiguousCharacters"= false;
      "editor.renderWhitespace"= "all";
    #   "editor.defaultFormatter"= "trunk.io";

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
          "python:S1192"= {
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

      "geminicodeassist.inlineSuggestions.enableAuto" = false;
      "geminicodeassist.project" =  "someimportantproject";

      "nixEnvSelector.suggestion" = true;

    };
    globalSnippets = {
      Shebang = {
        scope = "bash, python";
        prefix = "#!";
        body = [
          "#!/usr/bin/env $1"
          "\${2:# -*- coding: utf-8 -*-}"
        ];
        description = "Paste shebang";
      };
    };
    languageSnippets = {
      python = {
        plot = {
          prefix = [ "plt.plot" ];
          body = [
            "fig = plt.figure()"
            "ax1 = fig.add_subplot(1,1,1)"
            "(line11,) = ax1.plot($1)"
            ""
            "# fig.savefig(\"\", bbox_inches=\"tight\", transparent=True)"
            "plt.show()"
          ];
          description = "Matplotlib extended plot";
        };
        scatter = {
          prefix = [ "plt.scatter" ];
          body = [
            "fig = plt.figure()"
            "ax1 = fig.add_subplot(1,1,1)"
            "line11 = ax1.scatter($1)"
            ""
            "# fig.savefig(\"\", bbox_inches=\"tight\", transparent=True)"
            "plt.show()"
          ];
          description = "Matplotlib extended plot, scatter";
        };
	      ignore_type = {
	      	prefix = "# t";
	      	body = [
	      		"# type: ignore"
	      	];
	      	description = "Inserts type ignore instruction";
	      };
        passifmain = {
          prefix = "if __";
          body = [
            "if __name__ == \"__main__\":"
            "    pass"
            ""
          ];
          description = "Pass if main";
        };
      };
      cpp = {
        print = {
          prefix = "std::c";
          body = [
            "std::cout << $1 << std::endl;"
          ];
          description = "Output to console";
        };
      };
      latex = {
        text = {
          prefix = "\\t";
          body = [
            "\\text{$1}"
          ];
          description = "\\text{}";
        };
        limit = {
          prefix = "\\lim";
          body = [
            "\\lim\\limits_{\\substack{\${1:a} \\to -\${2:\\infty} \${3:b} \\to \${4:\\infty}}}"
          ];
          description = "Double limits";
        };
        therm_deriv = {
          prefix = "\\lfp";
          body = [
            "\\left(\\frac{\\partial $1}{\\partial $2}\\right)_{$3}"
          ];
          description = "Thermodynamic derivative";
        };
      };
    };
  };
}
