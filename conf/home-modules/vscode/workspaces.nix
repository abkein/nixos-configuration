{ lib, config, pkgs, ... }: {
  better-code = {
    enable = true;
    workspaces = {
      configuration = {
        folder = "${config.home.homeDirectory}/nixos-configuration";
        settings = { "nixEnvSelector.suggestion" = false; };
        hasShell = false;
      };
      lmptest = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmptest";
      };
      Quicknotebook = {
        folder = "${config.xdg.dataHome}/quicknotebook";
        prerun = "kitty --app-id=\"kitty_info\" ${config.home.homeDirectory}/execs/quicknotebook.sh";
      };
      lmp = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmp";
        settings = { "licenser.license" = "MIT"; };
      };
      magdiss = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/";
      };
      magdiss-pres = {
        folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/presentation/";
      };
      LAMMPS = {
        folder = "${config.home.homeDirectory}/repos/mylammps";
      };
    };
  };
}