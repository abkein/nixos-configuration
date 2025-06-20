{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.myModule;
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
{
  options = {
    myModule.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable myModule.";
    };

    myModule.configuration = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Name of VSCode workspace.";
            example = "Work";
          };

          folder = mkOption {
            type = types.str;
            description = "Workspace folder.";
            example = "/home/user/Documents/Work";
          };

          settings = mkOption {
            type = types.attrs;
            description = "VSCode settings.json";
            default = {};
          };

          prerun = mkOption {
            type = types.str;
            description = "Command to run before initialization.";
            default = "";
          };

          postrun = mkOption {
            type = types.str;
            description = "Command to run after initialization.";
            default = "";
          };

          preinit = mkOption {
            type = types.bool;
            description = "Whether to run nix-shell before calling VSCode.";
            default = true;
          };
        };
      });
      default = {};
      description = "Configuration entries for myModule.";
    };
  };

  config = mkIf cfg.enable {
    # Iterate over each configured entry and apply settings
    xdg = lib.foldl' (acc: spec: lib.mkMerge [acc (declare_workspace spec)]) {}
    lib.map (entryName: config.myModule.configuration.${entryName}) (builtins.attrNames cfg.configuration);
  };
}
