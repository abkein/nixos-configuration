{ mylib, ... }:
let
  showNotifications = "off";
in
mylib.flattenAttrsDot' {
  "[python]" = mylib.flattenAttrsDot'.literal {
    "editor.codeActionsOnSave" = {
      "source.organizeImports" = "explicit";
    };
  };

  python = {
    locator = "js";

    terminal = {
      activateEnvironment = false;
      shellIntegration.enabled = false;
    };

    analysis = {
      # nodeExecutable = "${pkgs.nodejs}/bin/node";
      autoFormatStrings = true;
      languageServerMode = "full";
      diagnosticMode = "workspace";
      autoImportCompletions = true;
      completeFunctionParens = true;
      generateWithTypeAnnotation = true;
      inlayHints = {
        callArgumentNames = "all";
        variableTypes = true;
        pytestParameters = true;
        functionReturnTypes = true;
      };
      typeEvaluation = {
        disableBytesTypePromotions = true;
        enableReachabilityAnalysis = true;
        strictDictionaryInference = true;
        strictListInference = true;
        strictParameterNoneValue = true;
        strictSetInference = true;
      };
    };
  };

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
