{ lib, shell-tools }:
# TODO: Errorprone: Implement scoped ctx (attrs), not the heap it is
rec {
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
      clangTidyUnwrapped = "${llvm.clang-tools}/bin/clang-tidy";
      cppcheckSupprPlain = shellPkgs.writeText "${repoName}-cppcheck_suppressions" (
        lib.concatStringsSep "\n" cppcheckSuppressions
      );
      clangTidyConf = shellPkgs.writeText "${repoName}-clang-tidy_configuration" (
        lib.concatStringsSep "\n" clangTidyConfText
      );
    in
    {
      gccToolchain = shellPkgs.gcc.cc;
      mpi = shellPkgs.openmpi;
      llvm = shellPkgs.llvmPackages_latest;
      clangTidy = shellPkgs.writeShellScriptBin "clang-tidy-wrapped" ''
        exec ${clangTidyUnwrapped} \
          --extra-arg=--gcc-toolchain=${gccToolchain} \
          --extra-arg=-stdlib=libstdc++ \
          --extra-arg=-isystem${mpi}/include \
          --extra-arg=-Qunused-arguments \
          "$@"
      '';
      clangTidyArgs = [
        "--gcc-toolchain=${gccToolchain}"
        "-stdlib=libstdc++"
        "-isystem${mpi}/include"
        "-Qunused-arguments"
      ];
      clangTidyExtraArgs = map (arg: "--extra-arg=${arg}") clangTidyArgs;
      cppcheckBuildDir = vscodeDir + "/.cppcheck";
      cppcheckSupprPlainLoc = vscodeDir + "/cppcheck_suppressions";
      clangTidyConfLoc = vscodeDir + "/.clang-tidy";

      cppcheckSuppressions = [ ];
      clangTidyConfText = [ ];
      cmakeSourceDirectory = root;
      buildPath = root + "/build";

      shellArgs = {
        buildInputs = [
          mpi
          clangTidy
          llvm.clang
          llvm.clang-tools
        ]
        ++ (with shellPkgs; [
          cmake
          ninja
          pkg-config
          gcc
          gdb
          gfortran

          flawfinder
          cppcheck
          cpplint

        ]);
      };

      vscodeSettings = {
        "cmake.sourceDirectory" = cmakeSourceDirectory;
        "cmake.useCMakePresets" = "always";

        "C_Cpp.codeAnalysis.clangTidy.useBuildPath" = true;
        "C_Cpp.codeAnalysis.exclude" = {
          "**/build/" = true;
        };

        "cpplint.cpplintPath" = "${shellPkgs.cpplint}/bin/cpplint";
        "cpplint.lineLength" = lineLength;
        "cpplint.verbose" = 0;

        "c-cpp-linter.clangTidy.enabled" = false;
        "c-cpp-linter.clangTidy.path" = "${clangTidy}/bin/clang-tidy-wrapped";
        "c-cpp-linter.compiler.path" = "${llvm.clang}/bin/clang++";
        "c-cpp-linter.compiler.additionalFlags" = [ "-Qunused-arguments" ];
        "c-cpp-linter.cppCheck.path" = "${shellPkgs.cppcheck}/bin/cppcheck";
        "c-cpp-linter.cppCheck.additionalFlags" = [
          "--std=c++20"
          "--platform=unix64"
          "--check-level=exhaustive"
          "--force"
          "--cppcheck-build-dir=${cppcheckBuildDir}"
          "--inline-suppr"
          "--suppressions-list=${cppcheckSupprPlainLoc}"
        ];
        "c-cpp-linter.general.sourceFileExtensions" = [
          "c"
          "h"
          "cpp"
          "hpp"
        ];

        "clang-tidy.buildPath" = buildPath;
        "clang-tidy.lintOnSave" = false;
        "clang-tidy.executable" = clangTidy;
        "clang-tidy.configFile" = clangTidyConfLoc;
        "clang-tidy.compilerArgs" = clangTidyArgs;
        "clang-tidy.checks" = [
          "-*,bugprone-*,concurrency-*,hicpp-*,modernize-*,performance-*,readability-*,llvm-*,misc-*,mpi-*,openmp-*"
          "-readability-magic-numbers,-readability-function-cognitive-complexity,-readability-identifier-length"
          "-readability-math-missing-parentheses,-readability-avoid-const-params-in-decls,-readability-isolate-declaration"
          "-readability-use-concise-preprocessor-directives"
          "-modernize-use-trailing-return-type,-modernize-return-braced-init-list"
          "-hicpp-signed-bitwise"
          # hicpp-member-init is an alias for enabled cppcoreguidelines-pro-type-member-init
          # hicpp-special-member-functions is an alias for cppcoreguidelines-special-member-functions
          # "-cppcoreguidelines-non-private-member-variables-in-classes"
          "-llvm-header-guard"
          "-llvm-prefer-static-over-anonymous-namespace"
          "-bugprone-easily-swappable-parameters"
        ];
      };

      shellHook = [
        "mkdir -p '${cppcheckBuildDir}'"
        "cat '${cppcheckSupprPlain}' > '${cppcheckSupprPlainLoc}'"
        "cat '${clangTidyConf}' > '${clangTidyConfLoc}'"
      ];
    }
  );

  pythonPackageSets = {
    basic = (
      ps: with ps; [
        numpy
        pandas
        scipy
        requests
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
        overlaidPythonPackages = [ ];
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
            warn_redundant_casts = true;
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
          };
        };

        pyright_mode = "strict";
        pyrightConfigFileLoc = root + "/pyrightconfig.json";
        pyrightConfig = {
          pythonVersion = pythonVerisionMajorMinor;
          pythonPlatform = "Linux";
          strictListInference = true;
          strictDictionaryInference = true;
          strictSetInference = true;
          strictParameterNoneValue = true;
          disableBytesTypePromotions = true;
          typeCheckingMode = pyright_mode;
          enableReachabilityAnalysis = true;
          # reportUnreachable = true;
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
