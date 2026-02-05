{ config, pkgs, ... }:
let
  needed_extensions = import ./needed_exts.nix pkgs;
in
{
  better-code = {
    enable = true;
    code-package = pkgs.vscode-fhs;
    desktopEntries.enable = true;

    general = {
      userSettings = import ./generalUserSettings.nix;
      globalSnippets = import ./generalGlobalSnippets.nix;
      languageSnippets = import ./generalLangSnippets.nix;
      extensions = needed_extensions.global;
    };

    terminal-emulator = pkgs.kitty;
    terminal-args = "--app-id=kitty_info";
    args = "--password-store=gnome-libsecret --ozone-platform=wayland --enable-proposed-api";
    envstr = "http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081 no_proxy=localhost,127.0.0.0/8";

    profiles = {
      default = {
        extensions = builtins.concatLists (builtins.attrValues needed_extensions);
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
      };
      nix = { };
      LaTeX = with needed_extensions; {
        extensions = LaTeX ++ python;
        userSettings = import ./latexSettings.nix;
      };
      python = with needed_extensions; {
        extensions = python ++ dev ++ [ "tomoki1207.pdf" ];
        userSettings = import ./pythonSettings.nix;
      };
      cpp = with needed_extensions; {
        extensions = cpp ++ dev;
        userSettings = import ./cppSettings.nix;
      };
      ts = with needed_extensions; {
        extensions = ts ++ dev;
      };
      remote = with needed_extensions; {
        extensions = remote ++ dev;
      };
    };

    workspaces = {
      configuration = {
        folder = "${config.home.homeDirectory}/nixos-configuration";
        profile = "nix";
      };
      lmptest = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmptest";
        profile = "python";
      };
      Quicknotebook = {
        folder = "${config.xdg.dataHome}/quicknotebook";
        prerun = [
          "kitty --app-id=\"kitty_info\" ${config.home.homeDirectory}/execs/quicknotebook.sh"
        ];
        profile = "python";
      };
      lmp = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmp";
        profile = "python";
      };
      indexlib = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmp/indexlib";
        workspaceFile = {
          enable = true;
          settings = {
            "licenser.license" = "MIT";
            "sonarlint.connectedMode.project" = {
              "connectionId" = "abkein";
              "projectKey" = "abkein_indexlib";
            };
          };
        };
        profile = "python";
        extensions = needed_extensions.sonar;
      };
      pysbatch = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmp/pysbatch-ng";
        workspaceFile = {
          enable = true;
          settings = {
            "licenser.license" = "MIT";
            "sonarlint.connectedMode.project" = {
              "connectionId" = "abkein";
              "projectKey" = "abkein_pysbatch";
            };
          };
        };
        profile = "python";
        extensions = needed_extensions.sonar;
      };
      LMPResume = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmp/LMPResume";
        workspaceFile = {
          enable = true;
          settings = {
            "licenser.license" = "MIT";
            "sonarlint.connectedMode.project" = {
              "connectionId" = "abkein";
              "projectKey" = "abkein_LMPResume";
            };
          };
        };
        profile = "python";
        extensions = needed_extensions.sonar;
      };
      ewald = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/Ewald";
        profile = "python";
      };
      yap = {
        folder = "${config.home.homeDirectory}/repos/yap";
        profile = "python";
      };
      gpg-tests = {
        folder = "${config.home.homeDirectory}/repos/gpg-python-yubikey";
        profile = "python";
      };
      onlykey-python = {
        folder = "${config.home.homeDirectory}/repos/onlykey-python";
        profile = "python";
      };
      # onlykey-solo = {
      #   folder   = "${config.home.homeDirectory}/repos/onlykey-solo";
      #   profile  = "python";
      # };
      monography = {
        folder = "${config.home.homeDirectory}/Documents/aspa/monography";
        profile = "python";
      };
      solo-python = {
        folder = "${config.home.homeDirectory}/repos/solo-python";
        profile = "python";
      };
      locp-article = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/LOCP";
        profile = "LaTeX";
      };
      cf = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/CF";
        profile = "LaTeX";
      };
      referat = {
        folder = "${config.home.homeDirectory}/Documents/aspa/Referat/";
        profile = "LaTeX";
      };
      aspa-plan = {
        folder = "${config.home.homeDirectory}/Documents/aspa/plan";
        profile = "LaTeX";
      };
      # magdiss = {
      #   folder  = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/";
      #   profile = "LaTeX";
      # };
      LAMMPS = {
        folder = "${config.home.homeDirectory}/repos/mylammps";
        profile = "cpp";
        nix = {
          method = "flake";
          launchInside = true;
          producesWorkspace = true;
        };
      };
      cfproc = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/python/cfproc";
        profile = "python";
        nix = {
          method = "flake";
          launchInside = true;
          producesWorkspace = true;
        };
      };
      vscode-clang-tidy = {
        folder = "${config.home.homeDirectory}/repos/vscode-clang-tidy";
        profile = "ts";
        nix = {
          method = "flake";
          launchInside = true;
          producesWorkspace = true;
        };
      };
    };
  };
}
