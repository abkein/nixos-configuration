{ lib, config, pkgs, ... }:
let
  needed_extensions = import ./needed_exts.nix;
in
{
  better-code = {
    enable = true;
    code-package = pkgs.vscode-fhs;

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

    terminal-emulator = pkgs.kitty;
    terminal-args = "--app-id=kitty_info";
    args = "--password-store=gnome-libsecret --ozone-platform=wayland";

    profiles = {
      default = {
        extensions = builtins.concatLists (builtins.attrValues needed_extensions);
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
      };
      nix = { };
      LaTeX = with needed_extensions; { extensions = LaTeX ++ python; };
      python = with needed_extensions; { extensions = python ++ py-dev ++ dev; };
      cpp = with needed_extensions; { extensions = cpp ++ dev; };
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
      ewald = {
        folder   = "${config.home.homeDirectory}/Documents/nucleation/Ewald";
        profile  = "python";
      };
      gpg-tests = {
        folder   = "${config.home.homeDirectory}/nixos-configuration/testing/gpg-python-yubikey";
        profile  = "python";
      };
      # magdiss = {
      #   folder  = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/";
      #   profile = "LaTeX";
      # };
      LAMMPS = {
        folder  = "${config.home.homeDirectory}/repos/mylammps";
        profile = "cpp";
      };
    };
  };
}