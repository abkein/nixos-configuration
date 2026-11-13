{ pkgs, ... }: {
  shellcheck = {
    enable = true;
    disableVersionCheck = true;
    executablePath = "${pkgs.shellcheck}/bin/shellcheck";
    customArgs = [
      "--format=checkstyle"
      "--extended-analysis=true"
      "--check-sourced"
    ];
    run = "onSave";
    enableQuickFix = true;
    # markdownDiagnostics = true;
    runtime = "native";
    # useWorkspaceRootAsCwd = true;
    # maxConcurrentRuns = 5;
    # logLevel="info";
  };
}
