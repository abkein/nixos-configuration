{ lib, config, pkgs, ... }@args:

# with lib;

let
  inherit (lib) mkOption types literalExpression mapAttrs mkMerge attrValues;
  cfg = config.better-code;
  jsontype = (pkgs.formats.json { }).type;
  # Helper to declare a single workspace given its name and spec
  declare_workspace = import ./declare_workspace.nix config;
  wtypes = import ./wtypes.nix args;
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

    better-code.generalUserSettings = wtypes.userSettings;
    better-code.generalUserTasks = wtypes.userTasks;
    better-code.generalKeybindings = wtypes.keybindings;
    better-code.generalExtensions = wtypes.extensions;
    better-code.generalLanguageSnippets = wtypes.languageSnippets;
    better-code.generalGlobalSnippets = wtypes.globalSnippets;

    better-code.profiles = mkOption {
      default     = {};
      description = "A list of VSCode profiles. Mutually exclusive to programs.vscode.mutableExtensionsDir";
      type = types.attrsOf (types.submodule {
        options = {
          userSettings = wtypes.userSettings;
          userTasks = wtypes.userTasks;
          keybindings = wtypes.keybindings;
          extensions = wtypes.extensions;
          languageSnippets = wtypes.languageSnippets;
          globalSnippets = wtypes.globalSnippets;
        };
      });
    };

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
        };
      });
    };
  };

  config = lib.mkIf cfg.enable {
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
