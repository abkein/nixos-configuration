{
  "cmake.configureOnOpen" = true;
  "cmake.configureOnEdit" = false;
  "cmake.configureSettings" = {};
  "cmake.generator" = "Unix Makefiles";
  "cmake.showOptionsMovedNotification" = false;
  "cmake.options.statusBarVisibility" = "compact";
  "cmake.pinnedCommands" = [
    "workbench.action.tasks.configureTaskRunner"
    "workbench.action.tasks.runTask"
  ];

  "C_Cpp.formatting" = "disabled";
  "C_Cpp.intelliSenseUpdateDelay" = 3000;
  "C_Cpp.experimentalFeatures" = "enabled";
  "C_Cpp.workspaceParsingPriority" = "high";
  "C_Cpp.autocompleteAddParentheses" = true;
  "C_Cpp.default.mergeConfigurations" = true;
  "C_Cpp.inlayHints.parameterNames.enabled" = true;
  "C_Cpp.inlayHints.referenceOperator.enabled" = true;
  "C_Cpp.inlayHints.autoDeclarationTypes.enabled" = true;
  "C_Cpp.inlayHints.autoDeclarationTypes.showOnLeft" = true;
  "C_Cpp.inlayHints.parameterNames.suppressWhenArgumentContainsName" = false;
  "C_Cpp.default.includePath" = [
    "/usr/local/include/"
    "\${default}"
    "/usr/include/"
  ];

  "[cpp]" = {
    "editor.defaultFormatter" = "ms-vscode.cpptools";
  };

  "c-cpp-flylint.debug" = true;
  "c-cpp-flylint.run" = "onType";
  "c-cpp-flylint.standard" = [
    "c++20"
  ];
  "c-cpp-flylint.flexelint.enable" = false;
  "c-cpp-flylint.cppcheck.extraArgs" = [
    "--check-level=normal"
  ];
  "c-cpp-flylint.cppcheck.force" = true;
  "c-cpp-flylint.clang.extraArgs" = [
    "-Qunused-arguments"
  ];
}