{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.code-workspace;

  # Helper to declare a single workspace given its name and spec
  declare_workspace = name: spec: rec {
    configFile."${name}" = {
      enable     = true;
      executable = false;
      force      = true;
      target     = "vscode_workspaces/${name}.code-workspace";
      text       = builtins.toJSON {
        folders  = [{ path = spec.folder; }];
        settings = spec.settings;
      };
    };

    desktopEntries."CodeWorkspaceSelector".actions."${name}" =
      let
        initCmd     = "nix-shell ${spec.folder}/shell.nix --command \"exit\"";
        initWrap    = "kitty --app-id=kitty_info ${initCmd}";
        prefix      = if spec.prerun != "" then "${spec.prerun} && "
                      else if spec.preinit then "${initWrap} && " else "";
        postfix     = if spec.postrun != "" then " && ${spec.postrun}" else "";
        codeCmd     = "${pkgs.vscode-fhs}/bin/code --password-store=gnome-libsecret --ozone-platform=wayland ${config.xdg.configHome}/${configFile.${name}.target}";
        fullCommand = "${prefix}${codeCmd}${postfix}";
      in {
        name = name;
        exec = "bash -c \"${fullCommand}\"";
      };
  };
in
{
  options = {
    code-workspace.enable = mkOption {
      type        = types.bool;
      default     = false;
      description = "Enable the automated VSCode workspace declarations.";
    };

    code-workspace.workspaces = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          folder = mkOption {
            type        = types.str;
            description = "Absolute path to the workspace folder.";
            example     = "/home/user/Projects/MyApp";
          };

          settings = mkOption {
            type        = types.attrs;
            description = "VSCode settings to embed in the workspace file.";
            default     = {};
          };

          prerun = mkOption {
            type        = types.str;
            description = "Command to run before opening VSCode.";
            default     = "";
          };

          postrun = mkOption {
            type        = types.str;
            description = "Command to run after opening VSCode.";
            default     = "";
          };

          preinit = mkOption {
            type        = types.bool;
            description = "Whether to run nix-shell before opening VSCode if prerun is empty.";
            default     = true;
          };
        };
      });
      default     = {};
      description = "Attribute-set of VSCode workspace specs, keyed by workspace name.";
    };
  };

  config = mkIf cfg.enable {
    # Build and merge all declared workspaces
    xdg = let
      workspaces = mapAttrs (_name: spec: declare_workspace _name spec) cfg.workspaces;
    in {
      # VSCode workspace files
      configFile = mkMerge (map (w: w.configFile) (attrValues workspaces));

      # Desktop entry for selector and per-workspace actions
      desktopEntries = mkMerge (
        [ {
            CodeWorkspaceSelector = {
              name        = "Space Selector";
              genericName = "Visual Studio Workspace Selector";
              exec        = ''
                hyprctl notify 2 3000 0 "fontsize:35 CodeWorkspaceSelector does nothing itself, select an action"'';
              icon        = "vscode";
              type        = "Application";
              categories  = [ "Development" "IDE" "TextTools" ];
              actions     = {};
            };
          }
        ] ++ map (w: w.desktopEntries) (attrValues workspaces)
      );
    };
  };
}
