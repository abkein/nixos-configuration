{ pkgs, ... }:
{
  bashIde = {
    enableSourceErrorDiagnostics = true;
    shellcheckPath = "${pkgs.shellcheck}/bin/shellcheck";
    shellcheckArguments = "--enable=all --exclude=deprecate-which";
    shfmt = {
      languageDialect = "bash";
      path = "${pkgs.shfmt}/bin/shfmt";
    };
  };
}
