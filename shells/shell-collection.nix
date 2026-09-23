{
  lib,
  shell-tools,
  root-overlaidPythonPackages ? [ ],
}:
# TODO: Errorprone: Implement scoped ctx (attrs), not the heap it is
rec {
  emptyShell = shell-tools.makeShell { };
  # root,
  # repoName,
  baseShell = shell-tools.makeShell (
    finalContext:
    with finalContext;
    let
      workspaceFile = shellPkgs.writers.writeJSON "${repoName}.code-workspace" {
        folders = [
          {
            name = repoName;
            path = root;
          }
        ]
        ++ workspaceFolders;
        settings = vscodeSettings;
      };
    in
    {
      vscodeDir = "${root}/.vscode";
      workspaceFileLoc = "${vscodeDir}/${repoName}.code-workspace";
      workspaceFolders = [ ];

      envrcFile = "${root}/.envrc";
      createEnvrc = true;

      lineLength = 120;

      shellArgs.env.BETTER_CODE_VSCODE_WORKSPACE_FILE = workspaceFileLoc;

      shellHook = [
        "mkdir -p '${vscodeDir}'"
        "cd '${root}'"
        "cat '${workspaceFile}' > '${workspaceFileLoc}'"
      ]
      ++ (lib.optionals createEnvrc [
        ''
          envrc_hash_should=$(sha256sum '${envrcFile}' | awk '{print $1}')
          envrc_hash_is=$(echo 'use flake /home/kein/nixos-configuration#${repoName}' | sha256sum - | awk '{print $1}')
          if [[ $envrc_hash_should != $envrc_hash_is ]]; then
            echo 'use flake /home/kein/nixos-configuration#${repoName}' > '${envrcFile}'
          fi
        ''
      ]);
    }
  );

  # root,
  # repoName,
  # cmakeSourceDirectory ? root,
  # cppcheckSuppressions ? "",
  # clangTidyConfText ? "",
  mkCppShell = baseShell.extend (
    finalContext:
    with finalContext;
    let
      cppcheckSupprPlain = shellPkgs.writeText "${repoName}-cppcheck_suppressions" (
        lib.concatStringsSep "\n" cppcheckSuppressions
      );
      yamlformat = shellPkgs.formats.yaml { };
      clangTidyConfFile = yamlformat.generate "${repoName}-clang-tidy" clangTidyConf;
    in
    {
      stdenv = shellPkgs.clangStdenv;
      cpp-standard = "c++20";

      clang-tidy-bin = "${shellPkgs.clang-tools}/bin/clang-tidy";
      cppcheckBuildDir = vscodeDir + "/.cppcheck";
      cppcheckSupprPlainLoc = vscodeDir + "/cppcheck_suppressions";
      clangTidyConfLoc = root + "/.clang-tidy";

      cppcheckSuppressions = [ ];
      cmakeSourceDirectory = root;
      buildPath = root + "/build";
      clangTidyConf = {
        FormatStyle = "file";
        InheritParentConfig = false;
        HeaderFileExtensions = [
          "h"
          "hpp"
          "hxx"
        ];
        ImplementationFileExtensions = [
          "c"
          "cpp"
          "cxx"
        ];
        Checks = [
          "-*"
          "bugprone-*"
          "concurrency-*"
          "hicpp-*"
          "modernize-*"
          "performance-*"
          "readability-*"
          "llvm-*"
          "misc-*"
          "mpi-*"
          "openmp-*"
          "cppcoreguidelines-*"
          "-readability-magic-numbers"
          "-readability-function-cognitive-complexity"
          "-readability-identifier-length"
          "-readability-math-missing-parentheses"
          "-readability-avoid-const-params-in-decls"
          "-readability-isolate-declaration"
          "-readability-use-concise-preprocessor-directives"
          "-modernize-use-trailing-return-type"
          "-modernize-return-braced-init-list"
          "-hicpp-signed-bitwise"
          # hicpp-member-init is an alias for enabled cppcoreguidelines-pro-type-member-init
          # hicpp-special-member-functions is an alias for cppcoreguidelines-special-member-functions
          # "-cppcoreguidelines-non-private-member-variables-in-classes"
          "-llvm-header-guard"
          "-llvm-prefer-static-over-anonymous-namespace"
          "-bugprone-easily-swappable-parameters"
          "-cppcoreguidelines-avoid-magic-numbers"
        ];
      };

      shellArgs = {
        packages =
          [ ]
          ++ (with shellPkgs; [
            clang
            clang-tools
            cmake
            ninja

            flawfinder
            cppcheck
            cpplint
          ]);
      };

      vscodeSettings = {
        "cmake.sourceDirectory" = cmakeSourceDirectory;
        "cmake.buildDirectory" = "${buildPath}";

        "C_Cpp.default.cppStandard" = cpp-standard;
        "C_Cpp.codeAnalysis.clangTidy.path" = clang-tidy-bin;
        "C_Cpp.default.cStandard" = "c23";
        "C_Cpp.default.intelliSenseMode" = "linux-clang-x64";
        "C_Cpp.clang_format_path" = "${shellPkgs.clang}/bin/clang-format";

        "cpplint.cpplintPath" = "${shellPkgs.cpplint}/bin/cpplint";
        "cpplint.lineLength" = lineLength;
        "cpplint.verbose" = 0;

        "clangd.enable" = false;

        "c-cpp-flylint.standard" = [ cpp-standard ];
        "c-cpp-flylint.cppcheck.extraArgs" = [
          "--check-level=exhaustive"
          "--cppcheck-build-dir=${cppcheckBuildDir}"
          "--inline-suppr"
          "--suppressions-list=${cppcheckSupprPlainLoc}"
          "--enable=all"
        ];

        "c-cpp-linter.compiler.path" = "${shellPkgs.clang}/bin/clang++";
        "c-cpp-linter.cppCheck.path" = "${shellPkgs.cppcheck}/bin/cppcheck";
        "c-cpp-linter.cppCheck.additionalFlags" = [
          "--std=${cpp-standard}"
          "--platform=unix64"
          "--force"
          "--check-level=exhaustive"
          "--cppcheck-build-dir=${cppcheckBuildDir}"
          "--inline-suppr"
          "--suppressions-list=${cppcheckSupprPlainLoc}"
          "--enable=all"
          "--verbose"
        ];

        "clang-tidy.buildPath" = buildPath;
        "clang-tidy.executable" = clang-tidy-bin;
      };

      shellHook = [
        "mkdir -p '${cppcheckBuildDir}'"
        "cat '${cppcheckSupprPlain}' > '${cppcheckSupprPlainLoc}'"
        "cat '${clangTidyConfFile}' > '${clangTidyConfLoc}'"
      ];
    }
  );

  pythonPackageSets = {
    basic = (
      ps: with ps; [
        numpy
        pandas
        pandas-stubs
        scipy
        scipy-stubs
        requests
        types-requests
        pysocks
        matplotlib
      ]
    );
    interactive = (
      ps: with ps; [
        isort
        bash-kernel
        ipython
        ipykernel
        jupyter
        jupyterlab
        notebook
      ]
    );
    typeCheckers = (
      ps: with ps; [
        ast-serialize
        mypy
        ruff
      ]
    );
    matplotlibBackends = {
      cairo = (
        ps: with ps; [
          cairocffi
          pycairo
        ]
      );
      gtk4cairo = (ps: with ps; [ pygobject3 ]);
      qt5cairo = (
        ps: with ps; [
          pyqt5
          pyside2
        ]
      );
      wxcairo = (ps: with ps; [ wxpython ]);
      notebook = (
        ps: with ps; [
          ipympl
          ipywidgets
        ]
      );
    };
  };

  modules = {
    pythonBase = (
      finalContext:
      with finalContext;
      let
        ruffConfigFile = shellPkgs.writers.writeTOML "${repoName}-ruff.toml" ruffConfig;
        mypyConfigFile = shellPkgs.writeText "${repoName}-mypy.ini" (lib.generators.toINI { } mypyConfig);
        pyrightConfigFile = shellPkgs.writers.writeJSON "${repoName}-pyrightconfig.json" pyrightConfig;
        # (lib.generators.toJSON { } pyrightConfig);
        pythonVersion = shellPkgs.python3.version;
        pythonVerisionMajorMinor = lib.substring 0 4 pythonVersion;
        shortPyVersion = "py" + (lib.replaceString "." "" pythonVerisionMajorMinor);
      in
      {
        overlaidPythonPackages = root-overlaidPythonPackages;
        nixpkgs.overlays = [ (shell-tools.mkPythonOverlay overlaidPythonPackages) ];

        pythonPackages = [
          pythonPackageSets.basic
          pythonPackageSets.typeCheckers
        ];
        pythonClosure = shell-tools.mkPythonClosure shellPkgs pythonPackages;
        interpreterPath = "${pythonClosure}/bin/python";

        pyCacheDir = vscodeDir + "/pycache";
        pythonHistory = vscodeDir + "/python_history";
        ignorePatterns = [
          # "nix-wiring/"
        ];

        notifyWherePython = true;

        mypyCacheDir = vscodeDir + "/mypy_cache";
        dmypyStatusFileLoc = vscodeDir + "dmypy.status";
        mypyConfigFileLoc = root + "/mypy.ini";
        mypyConfig = {
          mypy = {
            exclude_gitignore = true;
            ignore_missing_imports = false;
            follow_imports = "normal";
            python_executable = interpreterPath;
            python_version = pythonVerisionMajorMinor;
            platform = "linux";
            implicit_optional = false;
            warn_redundant_casts = false;
            warn_unused_ignores = true;
            warn_no_return = true;
            warn_return_any = true;
            warn_unreachable = true;
            allow_untyped_globals = false;
            allow_redefinition = false;
            allow_redefinition_old = false;
            local_partial_types = true;
            extra_checks = true;
            implicit_reexport = false;
            strict_equality = true;
            strict_equality_for_none = true;
            strict_bytes = true;
            strict = true;
            incremental = true;
            cache_dir = mypyCacheDir;
            sqlite_cache = true;
            cache_fine_grained = true;
            native_parser = true;
          };
        };

        ruffCacheDir = vscodeDir + "/ruff_cache";
        ruffConfigFileLoc = root + "/ruff.toml";
        ruffConfig = {
          cache-dir = ruffCacheDir;
          target-version = shortPyVersion;
          line-length = lineLength;
          indent-width = 4;
          analyze = {
            detect-string-imports = true;
          };
          format = {
            quote-style = "double";
            indent-style = "space";
            line-ending = "lf";
            nested-string-quote-style = "alternating";
            docstring-code-format = true;
            skip-magic-trailing-comma = false;
          };
          # extend-exclude = ["*.md"];
          lint = {
            select = [
              "E"
              "F"
              "UP"
              "B"
              "SIM"
              "I"
            ];
            ignore = [
              "E402"
              "SIM102"
              "SIM118"
            ];
          };
        };

        pyright_mode = "strict";
        pyrightConfigFileLoc = root + "/pyrightconfig.json";
        pyrightConfig = {
          pythonVersion = pythonVerisionMajorMinor;
          pythonPlatform = "Linux";
          analyzeUnannotatedFunctions = true;
          strictListInference = true;
          strictDictionaryInference = true;
          strictSetInference = true;
          strictParameterNoneValue = true;
          disableBytesTypePromotions = true;
          typeCheckingMode = pyright_mode;
          enableReachabilityAnalysis = true;
        };

        vscodeSettings = {
          # "python.languageServer" = "Pylance";
          "python.pythonPath" = interpreterPath;
          "python.defaultInterpreterPath" = interpreterPath;
          "[python]" = {
            "editor.defaultFormatter" = "charliermarsh.ruff";
          };

          # "python.analysis.diagnosticsSource" = "Pyright";
          # "python.analysis.indexing" =  false;
          # "python.analysis.typeCheckingMode" = "strict";
          # "python.analysis.exclude" = ignorePatterns;

          "mypy-type-checker.interpreter" = [ interpreterPath ];
          "mypy-type-checker.path" = [ "${pythonClosure}/bin/mypy" ]; # disables mypy daemon
          "mypy-type-checker.reportingScope" = "workspace";
          "mypy-type-checker.importStrategy" = "fromEnvironment";
          "mypy-type-checker.ignorePatterns" = ignorePatterns;
          # "mypy-type-checker.args" = [
          #   "--cache-dir=${mypyCacheDir}" # maybe should be removed, since we have it in the env
          #   "--strict"
          # ];
          # "mypy-type-checker.preferDaemon" = false;
          # "mypy-type-checker.daemonStatusFile" = dmypyStatusFileLoc;

          "basedpyright.importStrategy" = "fromEnvironment";
          "basedpyright.analysis.inlayHints.callArgumentNamesMatching" = true;
          "basedpyright.analysis.diagnosticMode" = "workspace";
          "basedpyright.analysis.configFilePath" = pyrightConfigFileLoc;

          "ruff.importStrategy" = "fromEnvironment";
          "ruff.interpreter" = [ interpreterPath ];
          "ruff.lineLength" = lineLength;
          "ruff.path" = [ "${pythonClosure}/bin/ruff" ];
          "ruff.configuration" = ruffConfigFileLoc;
          "ruff.configurationPreference" = "filesystemFirst";
        };

        shellArgs = {
          buildInputs = [
            pythonClosure
            shellPkgs.pyright
            # shellPkgs.basedpyright
          ];
          env = {
            PYTHONPYCACHEPREFIX = pyCacheDir;
            PYTHON_HISTORY = pythonHistory;
            MYPY_CACHE_DIR = mypyCacheDir;
            # MYPY_NUM_WORKERS same as `num_workers`, but takes precedence
          };
        };

        shellHook = [
          "mkdir -p ${mypyCacheDir}"
          "mkdir -p ${ruffCacheDir}"
          "cat ${ruffConfigFile} > ${ruffConfigFileLoc}"
          "cat ${mypyConfigFile} > ${mypyConfigFileLoc}"
          "cat ${pyrightConfigFile} > ${pyrightConfigFileLoc}"
          ''
            echo '-----------------------'
            echo 'Python is available at:'
            echo '${pythonClosure}'
            echo '-----------------------'
          ''
        ]
        ++ (lib.optionals notifyWherePython [
          "${shellPkgs.libnotify}/bin/notify-send --app-name='${repoName}' 'Python is here:' '${pythonClosure}'"
        ]);
      }
    );
    pythonInteractive = (
      finalContext: with finalContext; {
        pythonPackages = [ pythonPackageSets.interactive ];

        iPythonDir = vscodeDir + "/ipython";
        jupyterConfigDir = vscodeDir + "/jupyter";

        shellArgs.env = {
          IPYTHONDIR = iPythonDir;
          JUPYTER_CONFIG_DIR = jupyterConfigDir;
        };

        shellHook = [
          "mkdir -p ${iPythonDir}"
          "mkdir -p ${jupyterConfigDir}"
        ];
      }
    );
  };

  mkPyShell = baseShell.extend modules.pythonBase;
  mkPyShellInteractive = mkPyShell.extend modules.pythonInteractive;
}
