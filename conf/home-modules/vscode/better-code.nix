{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.better-code;

  # Helper to declare a single workspace given its name and spec
  declare_workspace = import ./declare_workspace.nix config;
in
{
  options = {
    better-code.enable = mkOption {
      type        = types.bool;
      default     = false;
      description = "Enable the automated VSCode configuration (enables VSCode as well).";
    };

    better-code.code-package = mkOption {
      type        = types.package;
      default     = pkgs.vscode-fhs;
      description = "The VSCode package to use.";
      example     = pkgs.vscodium;
    };

    # better-code.always_allowed_extensions = mkOption {
    #   type        = types.listOf types.str;
    #   description = "List of extensions always allowed regardless of better-code.workspaces.<name>.extension_management_policy option.";
    #   default     = [];
    #   example     = [ "jnoortheen.nix-ide" "ms-vscode.atom-keybindings" ];
    # };

    better-code.workspaces = mkOption {
      default     = {};
      description = "Attribute-set of VSCode workspace specs, keyed by workspace name.";
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

          profile = mkOption {
            type        = types.str;
            description = "Profile used for this workspace. Written to workspace setting \"workbench.profile\". Nothing written if empty.";
            default     = "";
            example     = "default";
          };

          hasShell = mkOption {
            type        = types.bool;
            description = "Wether workspace has shell.nix or not.";
            default     = true;
          };

          # extension_management_policy = mkOption {
          #   type        = types.enum [ "none" "blacklist" "whitelist" ];
          #   description = "Whether to include specified extensions in option better-code.workspaces.<name>.extensions as only allowed into \"extensions.allowed\" or as blacklisted. Or do nothing if \"none\" specified.";
          #   default     = "none";
          #   example     = "whitelist";
          # };

          # extensions = mkOption {
          #   type        = types.listOf types.str;
          #   description = "List of extensions to include into \"extensions.allowed\". See also better-code.workspaces.<name>.extension_management_policy option.";
          #   default     = [];
          #   example     = [ "mechatroner.rainbow-csv" "ms-python.python" ];
          # };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    programs.vscode.package = cfg.code-package;

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
