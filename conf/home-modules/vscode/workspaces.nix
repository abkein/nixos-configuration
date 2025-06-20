{ lib, config, pkgs, ... }: {
  myModule = {
    enable = true;
    configuration = {
      configuration = {
        name = "configuration";
        folder = "${config.home.homeDirectory}/nixos-configuration";
        settings = { "nixEnvSelector.suggestion" = false; };
        preinit = false;
      };
      lmptest = {
        name = "lmptest";
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmptest";
        settings = {
          "nixEnvSelector.suggestion" = false;
          "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
        };
      };
      Quicknotebook = {
        name = "Quicknotebook";
        folder = "${config.xdg.dataHome}/quicknotebook";
        settings = {
          "nixEnvSelector.suggestion" = false;
          "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
        };
        # prerun = "${config.home.homeDirectory}/execs/quicknotebook_wrapper.sh";
        prerun = "kitty --app-id=\"kitty_info\" ${config.home.homeDirectory}/execs/quicknotebook.sh";
        preinit = false;
      };
      lmp = {
        name = "lmp";
        folder = "${config.home.homeDirectory}/Documents/nucleation/lmp";
        settings = {
          "licenser.license" = "MIT";
          "nixEnvSelector.suggestion" = false;
          "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
        };
      };
      magdiss = {
        name = "magdiss";
        folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/";
        settings = {
          "nixEnvSelector.suggestion" = false;
          "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
        };
      };
      magdiss-pres = {
        name = "magdiss-pres";
        folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/presentation/";
        settings = {
          "nixEnvSelector.suggestion" = false;
          "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
        };
      };
      LAMMPS = {
        name = "LAMMPS";
        folder = "${config.home.homeDirectory}/repos/mylammps";
        settings = {
          "nixEnvSelector.suggestion" = false;
          "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
        };
      };
    };
  };
}