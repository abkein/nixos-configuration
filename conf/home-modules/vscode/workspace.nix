{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.code-workspace;

  # Helper to declare a single workspace given its name and spec
  declare_workspace = name: spec: rec {
    configFile."${name}" =
    # let
    #   allow = if spec.extension_management_policy == "whitelist" then true else false;
    #   allowed_exts = foldl' (acc: ext: acc // {"${ext}" = true;}) {} cfg.always_allowed_extensions;
    #   exts = allowed_exts // (foldl' (acc: ext: acc // {"${ext}" = allow;}) {} spec.extensions) // {"*" = !allow;};
    #   settings = if spec.extension_management_policy == "none" then spec.settings else (spec.settings // {"extensions.allowed" = exts;});
    # in
    {
      enable     = true;
      executable = false;
      force      = true;
      target     = "vscode_workspaces/${name}.code-workspace";
      text       = builtins.toJSON {
        folders  = [{ path = spec.folder; }];
        settings = settings;
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

    # code-workspace.always_allowed_extensions = mkOption {
    #   type        = types.listOf types.str;
    #   description = "List of extensions always allowed regardless of code-workspace.workspaces.<name>.extension_management_policy option.";
    #   default     = [];
    #   example     = [ "jnoortheen.nix-ide" "ms-vscode.atom-keybindings" ];
    # };

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
            example     = {
                            "nixEnvSelector.suggestion" = false;
                            "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
                          };
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

          # extension_management_policy = mkOption {
          #   type        = types.enum [ "none" "blacklist" "whitelist" ];
          #   description = "Whether to include specified extensions in option code-workspace.workspaces.<name>.extensions as only allowed into \"extensions.allowed\" or as blacklisted. Or do nothing if \"none\" specified.";
          #   default     = "none";
          #   example     = "whitelist";
          # };

          # extensions = mkOption {
          #   type        = types.listOf types.str;
          #   description = "List of extensions to include into \"extensions.allowed\". See also code-workspace.workspaces.<name>.extension_management_policy option.";
          #   default     = [];
          #   example     = [ "mechatroner.rainbow-csv" "ms-python.python" ];
          # };
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
