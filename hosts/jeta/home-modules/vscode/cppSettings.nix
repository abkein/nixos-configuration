{ mylib, ... }:
mylib.flattenAttrsDot' {
  "[cpp]" = mylib.flattenAttrsDot'.literal { "editor.defaultFormatter" = "ms-vscode.cpptools"; };

  cmake = {
    configureOnOpen = false;
    configureOnEdit = false;
    automaticReconfigure = false;
    showOptionsMovedNotification = false;
    options.statusBarVisibility = "compact";
    showConfigureWithDebuggerNotification = false;
    removeStaleKitsOnScan = true;
  };

  C_Cpp = {
    default.configurationProvider = "ms-vscode.cmake-tools";
    intelliSenseUpdateDelay = 3000;
    experimentalFeatures = "enabled";
    workspaceParsingPriority = "high";
    autocompleteAddParentheses = true;
    exclusionPolicy = "checkFilesAndFolders";
    intelliSenseCachePath = "$XDG_CACHE_HOME/vscode-cpptools/";
    errorSquiggles = "enabled";
    loggingLevel = "Debug";
    clang_format_style = "file";
    formatting = "clangFormat";
    markdownInComments = "enabled";
    inlayHints = {
      parameterNames.enabled = true;
      referenceOperator.enabled = true;
      autoDeclarationTypes.enabled = true;
      autoDeclarationTypes.showOnLeft = true;
      parameterNames.suppressWhenArgumentContainsName = false;
    };
    codeAnalysis = {
      clangTidy.enabled = true;
      runAutomatically = true;
      clangTidy.useBuildPath = true;
      exclude = mylib.flattenAttrsDot'.literal { "**/build/" = true; };
    };
  };

  clangd = {
    enableCodeCompletion = false;
    enableHover = false;
    detectExtensionConflicts = false;
  };

  c-cpp-flylint = {
    debug = true;
    run = "onBuild";
    cppcheck = {
      enable = true;
      force = true;
      verbose = true;
      platform = "unix64";
    };
    clang = {
      enable = true;
      pedantic = true;
      extraArgs = [ "-Qunused-arguments" ];
    };
    flexelint.enable = false;
    lizard.enable = false;
  };

  c-cpp-linter = {
    clangTidy.enabled = false;
    compiler.additionalFlags = [ "-Qunused-arguments" ];
    general = {
      runOnOpen = false;
      runOnSave = false;
      showInformationDialog = true;
      showOutputFromLinters = true;
      sourceFileExtensions = [
        "c"
        "h"
        "cpp"
        "hpp"
        "cxx"
        "hxx"
      ];
    };
  };

  clang-tidy.lintOnSave = false;
}
