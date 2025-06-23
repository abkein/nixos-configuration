{ lib, config, pkgs, ... }:
let
  needed_extensions = import ./needed_exts.nix;
in
{
  better-code = {
    enable = true;

    general = {
      userSettings = import ./generalUserSettings.nix;
      globalSnippets = import ./generalGlobalSnippets.nix;
      languageSnippets = import ./generalLangSnippets.nix;
      extensions = [
        "arrterian.nix-env-selector"
        "jnoortheen.nix-ide"
        "mechatroner.rainbow-csv"
        "ms-vscode.atom-keybindings"
        "thmsrynr.vscode-namegen" # possibly delete
      ];
    };

    profiles = {
      default = {
        extensions = builtins.concatLists (builtins.attrValues needed_extensions);
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
      };
      nix = { };
      LaTeX = with needed_extensions; { extensions = LaTeX ++ python; };
      python = with needed_extensions; { extensions = python ++ py-dev ++ dev ++ sonar; };
      cpp = with needed_extensions; { extensions = cpp ++ dev ++ sonar; };
      remote = with needed_extensions; { extensions = remote ++ dev; };
    };

    workspaces = {
      configuration = {
        folder   = "${config.home.homeDirectory}/nixos-configuration";
        settings = { "nixEnvSelector.suggestion" = false; };
        hasShell = false;
        profile  = "nix";
      };
      lmptest = {
        folder  = "${config.home.homeDirectory}/Documents/nucleation/lmptest";
        profile = "python";
      };
      Quicknotebook = {
        folder  = "${config.xdg.dataHome}/quicknotebook";
        prerun  = "kitty --app-id=\"kitty_info\" ${config.home.homeDirectory}/execs/quicknotebook.sh";
        profile = "python";
      };
      lmp = {
        folder   = "${config.home.homeDirectory}/Documents/nucleation/lmp";
        settings = { "licenser.license" = "MIT"; };
        profile  = "python";
      };
      magdiss = {
        folder  = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/";
        profile = "LaTeX";
      };
      LAMMPS = {
        folder  = "${config.home.homeDirectory}/repos/mylammps";
        profile = "cpp";
      };
    };
  };
}