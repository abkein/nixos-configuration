{
  # "python.analysis.diagnosticSeverityOverrides" = {
  #     "reportUnboundVariable" = "none";
  #     "reportGeneralTypeIssues" = "none"
  # };
  "python.locator" = "js";
  "python.editor.formatOnType" = true;
  "python.editor.defaultFormatter" = "ms-python.black-formatter";
  "python.analysis.inlayHints.functionReturnTypes" = true;
  "python.analysis.inlayHints.pytestParameters" = true;
  "python.analysis.inlayHints.variableTypes" = true;
  "python.analysis.completeFunctionParens" = true;
  "python.analysis.typeCheckingMode" = "basic";
  "python.analysis.autoFormatStrings" = true;
  "python.analysis.diagnosticMode" = "workspace";
  "python.analysis.autoImportCompletions" = true;
  "python.analysis.downloadStubs" = true;
  "python.analysis.inlayHints.callArgumentNames" = true;
  "python.formatting.provider" = "none";
  "python.formatting.autopep8Args" = [
    "--max-line-length 999999"
  ];

  "[python]" = {
    "editor.defaultFormatter" = "ms-python.black-formatter";
  };

  "flake8.args" = [
    "--disable=E701"
    "--max-line-length=120"
  ];

  "black-formatter.args" = [
    "--line-length=120"
  ];

  "mypy-type-checker.args" = [
    "--disable-error-code=import-untyped"
  ];

  "jupyter.askForKernelRestart" = false;
  "jupyter.disableJupyterAutoStart" = true;
  "jupyter.widgetScriptSources" = [
    "jsdelivr.com"
    "unpkg.com"
  ];
  "jupyter.logging.level" = "trace";
}