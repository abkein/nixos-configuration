{ pkgs, ... }:
let
  showNotifications = "off";
in
{
  # "python.analysis.diagnosticSeverityOverrides" = {
  #     "reportUnboundVariable" = "none";
  #     "reportGeneralTypeIssues" = "none"
  # };
  # "python.analysis.indexing" =  false;
  "python.locator" = "js";

  "python.terminal.activateEnvironment" = false;
  "python.terminal.shellIntegration.enabled" = false;

  "python.analysis.autoFormatStrings" = true;
  "python.analysis.languageServerMode" = "full";
  "python.analysis.diagnosticMode" = "workspace";
  "python.analysis.autoImportCompletions" = true;
  "python.analysis.completeFunctionParens" = true;
  "python.analysis.generateWithTypeAnnotation" = true;

  "python.analysis.inlayHints.callArgumentNames" = "all";
  "python.analysis.inlayHints.variableTypes" = true;
  "python.analysis.inlayHints.pytestParameters" = true;
  "python.analysis.inlayHints.functionReturnTypes" = true;

  "python.analysis.typeEvaluation.disableBytesTypePromotions" = true;
  "python.analysis.typeEvaluation.enableReachabilityAnalysis" = true;
  "python.analysis.typeEvaluation.strictDictionaryInference" = true;
  "python.analysis.typeEvaluation.strictListInference" = true;
  "python.analysis.typeEvaluation.strictParameterNoneValue" = true;
  "python.analysis.typeEvaluation.strictSetInference" = true;
  "python.analysis.nodeExecutable" = "${pkgs.nodejs}/bin/node";

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
