let
  showNotifications = "off";
in
{
  # "python.analysis.diagnosticSeverityOverrides" = {
  #     "reportUnboundVariable" = "none";
  #     "reportGeneralTypeIssues" = "none"
  # };
  "python.locator" = "js";
  "python.analysis.inlayHints.functionReturnTypes" = true;
  "python.analysis.inlayHints.pytestParameters" = true;
  "python.analysis.inlayHints.variableTypes" = true;
  "python.analysis.completeFunctionParens" = true;
  # "python.analysis.typeCheckingMode" = "basic";
  "python.analysis.autoFormatStrings" = true;
  "python.analysis.diagnosticMode" = "workspace";
  "python.analysis.autoImportCompletions" = true;
  "python.analysis.inlayHints.callArgumentNames" = "all";
  # "python.analysis.downloadStubs" = true; # Does not exists
  # "python.editor.formatOnType" = true; # Does not exists

  # "autopep8.showNotifications" = showNotifications;
  # "black-formatter.showNotifications" = showNotifications;
  # "flake8.showNotifications" = showNotifications;
  # "isort.showNotifications" = showNotifications;
  "mypy-type-checker.showNotifications" = showNotifications;

  "jupyter.askForKernelRestart" = false;
  "jupyter.disableJupyterAutoStart" = true;
  "jupyter.widgetScriptSources" = [
    "jsdelivr.com"
    "unpkg.com"
  ];
  # "jupyter.logging.level" = "info";
}
