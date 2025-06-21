{ lib, config, pkgs, ... }: {
  better-code = {
    enable = true;
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