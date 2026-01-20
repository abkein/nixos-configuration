{ config, pkgs, ... }:
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
        "michaelcurrin.auto-commit-msg"
        "gruntfuggly.todo-tree"
        "mkhl.direnv"
        "openai.chatgpt"
        # "github.copilot"  # so annoying
        # "github.copilot-chat"
        # "Koda.koda"
        # "Continue.continue"
      ];
    };

    terminal-emulator = pkgs.kitty;
    terminal-args = "--app-id=kitty_info";
    # --proxy-server=\"socks5=127.0.0.1:1080\"
    args = "--password-store=gnome-libsecret --ozone-platform=wayland";
    envstr = "http_proxy=socks5://127.0.0.1:1080 https_proxy=socks5://127.0.0.1:1080 no_proxy=localhost,127.0.0.0/8";

    profiles = {
      default = {
        extensions = builtins.concatLists (builtins.attrValues needed_extensions);
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
      };
      nix = { };
      LaTeX = with needed_extensions; { extensions = LaTeX ++ python; };
      python = with needed_extensions; { extensions = python ++ py-dev ++ dev ++ ["tomoki1207.pdf"]; };
      cpp = with needed_extensions; { extensions = cpp ++ dev; };
      remote = with needed_extensions; { extensions = remote ++ dev; };
    };

    workspaces = {
      configuration = {
        folder   = "${config.home.homeDirectory}/nixos-configuration";
        settings = { "nixEnvSelector.suggestion" = false; };
        nix = null;
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
      indexlib = {
        folder   = "${config.home.homeDirectory}/Documents/nucleation/lmp/indexlib";
        settings = {
          "licenser.license" = "MIT";
          "sonarlint.connectedMode.project" = {
            "connectionId" = "abkein";
            "projectKey" = "abkein_indexlib";
          };
        };
        profile  = "python";
        extensions = needed_extensions.sonar;
      };
      pysbatch = {
        folder   = "${config.home.homeDirectory}/Documents/nucleation/lmp/pysbatch-ng";
        settings = {
          "licenser.license" = "MIT";
          "sonarlint.connectedMode.project" = {
            "connectionId" = "abkein";
            "projectKey" = "abkein_pysbatch";
          };
        };
        profile  = "python";
        extensions = needed_extensions.sonar;
      };
      LMPResume = {
        folder   = "${config.home.homeDirectory}/Documents/nucleation/lmp/LMPResume";
        settings = {
          "licenser.license" = "MIT";
          "sonarlint.connectedMode.project" = {
            "connectionId" = "abkein";
            "projectKey" = "abkein_LMPResume";
          };
        };
        profile  = "python";
        extensions = needed_extensions.sonar;
      };
      ewald = {
        folder   = "${config.home.homeDirectory}/Documents/nucleation/Ewald";
        profile  = "python";
      };
      yap = {
        folder   = "${config.home.homeDirectory}/repos/yap";
        profile  = "python";
      };
      gpg-tests = {
        folder   = "${config.home.homeDirectory}/repos/gpg-python-yubikey";
        profile  = "python";
      };
      onlykey-python = {
        folder   = "${config.home.homeDirectory}/repos/onlykey-python";
        profile  = "python";
      };
      # onlykey-solo = {
      #   folder   = "${config.home.homeDirectory}/repos/onlykey-solo";
      #   profile  = "python";
      # };
      monography = {
        folder   = "${config.home.homeDirectory}/Documents/aspa/monography";
        profile  = "python";
      };
      solo-python = {
        folder   = "${config.home.homeDirectory}/repos/solo-python";
        profile  = "python";
      };
      locp-article = {
        folder  = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/LOCP";
        profile = "LaTeX";
      };
      cf = {
        folder  = "${config.home.homeDirectory}/Documents/nucleation/CF";
        profile = "LaTeX";
      };
      referat = {
        folder  = "${config.home.homeDirectory}/Documents/aspa/Referat/";
        profile = "LaTeX";
      };
      aspa-plan = {
        folder  = "${config.home.homeDirectory}/Documents/aspa/plan";
        profile = "LaTeX";
      };
      # magdiss = {
      #   folder  = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/";
      #   profile = "LaTeX";
      # };
      LAMMPS = {
        folder  = "${config.home.homeDirectory}/repos/mylammps";
        profile = "cpp";
        nix = "flake";
      };
    };
  };
}
