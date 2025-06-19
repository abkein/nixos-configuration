{ config, lib, pkgs, options, ... }:
let
  declare_workspace = { name, folder, settings, prerun ? "", postrun ? "", preinit ? true }: rec {
    configFile.${name} = {
      enable = true;
      executable = false;
      force = true;
      target = "vscode_workspaces/${name}.code-workspace";
      text = builtins.toJSON {
        folders = [{ path = folder; }];
        settings = settings;
      };
    };
    desktopEntries."CodeWSpaceSelector".actions.${name} =
    let
      init_cmd = "nix-shell ${folder}/shell.nix --command \"exit\"";
      init_wrap_cmd = "kitty --app-id=\"kitty_info\" ${init_cmd}";
      prefix = if (prerun == "") then (if preinit then "${init_wrap_cmd} &&" else "") else "${prerun} && ";
      postfix = if (postrun == "") then "" else " && ${postrun}";
      codecmd = "${pkgs.vscode-fhs}/bin/code --password-store=gnome-libsecret --ozone-platform=wayland ${config.xdg.configHome}/${configFile.${name}.target}";
      cmd = "${prefix}${codecmd}${postfix}";
    in
    {
      name = "${name}";
      exec = "bash -c \"${cmd}\"";
    };
  };
in
[
  mkMerge (builtins.attrValues (lib.foldl' (acc: spec: acc // mkConfFile spec)
  {}
  [
    { name = "proj1"; folder = "/path/to/p1"; settings = { /*…*/ }; }
    { name = "proj2"; folder = "/path/to/p2"; settings = { /*…*/ }; }
    { name = "proj3"; folder = "/path/to/p3"; settings = { /*…*/ }; }
  ]))
  (declare_workspace {
    name = "configuration";
    folder = "${config.home.homeDirectory}/nixos-configuration";
    settings = { "nixEnvSelector.suggestion" = false; };
    preinit = false;
  })
  (declare_workspace {
    name = "lmptest";
    folder = "${config.home.homeDirectory}/Documents/nucleation/lmptest";
    settings = {
      "nixEnvSelector.suggestion" = false;
      "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
    };
  })
  (declare_workspace {
    name = "Quicknotebook";
    folder = "${config.xdg.dataHome}/quicknotebook";
    settings = {
      "nixEnvSelector.suggestion" = false;
      "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
    };
    # prerun = "${config.home.homeDirectory}/execs/quicknotebook_wrapper.sh";
    prerun = "kitty --app-id=\"kitty_info\" ${config.home.homeDirectory}/execs/quicknotebook.sh";
    preinit = false;
  })
  (declare_workspace {
    name = "lmp";
    folder = "${config.home.homeDirectory}/Documents/nucleation/lmp";
    settings = {
      "licenser.license" = "MIT";
      "nixEnvSelector.suggestion" = false;
      "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
    };
  })
  (declare_workspace {
    name = "magdiss";
    folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/";
    settings = {
      "nixEnvSelector.suggestion" = false;
      "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
    };
  })
  (declare_workspace {
    name = "magdiss-pres";
    folder = "${config.home.homeDirectory}/Documents/nucleation/LaTeX/magdiss/presentation/";
    settings = {
      "nixEnvSelector.suggestion" = false;
      "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
    };
  })
  (declare_workspace {
    name = "LAMMPS";
    folder = "${config.home.homeDirectory}/repos/mylammps";
    settings = {
      "nixEnvSelector.suggestion" = false;
      "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
    };
  })
]
