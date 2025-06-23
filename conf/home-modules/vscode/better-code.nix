{ lib, config, pkgs, ... }@args:

# with lib;

let
  inherit (lib) mkOption types literalExpression mapAttrs mkMerge attrValues;
  cfg = config.better-code;
  jsontype = (pkgs.formats.json { }).type;
  deepMerge = (import ./deepMerge.nix).deepMerge;
  # Helper to declare a single workspace given its name and spec
  declare_workspace = import ./declare_workspace.nix config;
  mkExtList = import ./mkExtList.nix { pkgs=pkgs; lib=lib; };
  rebuildExtensions = spec: spec // { extensions = mkExtList spec.extensions; };
  #mkProfile = name: spec: rebuildExtensions (lib.recursiveUpdate cfg.general spec);
  mkProfile = name: spec: rebuildExtensions (deepMerge cfg.general spec);
  mkProfileW = name: spec: mkProfile name (lib.mkMerge [
    (if spec.profile == "" then {} else cfg.profiles.${spec.profile})
    spec
  ]);
  genProfileName = name: spec: "${name}-${builtins.hashString "sha256" (builtins.toJSON spec)}";
  wtypes = import ./wtypes.nix args;
in
{
  options = {
    better-code.enable = mkOption {
      type        = types.bool;
      default     = false;
      description = "Enable the automated VSCode configuration.";
    };

    better-code.code-package = mkOption {
      type        = types.package;
      default     = pkgs.vscode-fhs;
      description = "The VSCode package to use.";
      example     = pkgs.vscodium;
    };

    #better-code.general = mkOption {
    #  default     = {};
    #  description = "A set of VSCode profiles.";
    #  type = types.submodule {
    #    options = {
    #      userSettings = wtypes.userSettings;
    #      userTasks = wtypes.userTasks;
    #      keybindings = wtypes.keybindings;
    #      extensions = wtypes.extensions;
    #      languageSnippets = wtypes.languageSnippets;
    #      globalSnippets = wtypes.globalSnippets;
    #    };
    #  };
    #};

    better-code.general = {
      userSettings = wtypes.userSettings;
      userTasks = wtypes.userTasks;
      keybindings = wtypes.keybindings;
      extensions = wtypes.extensions;
      languageSnippets = wtypes.languageSnippets;
      globalSnippets = wtypes.globalSnippets;
    };

    better-code.profiles = mkOption {
      default     = {};
      description = "A set of VSCode profiles. Mutually exclusive to programs.vscode.mutableExtensionsDir";
      type = types.attrsOf (types.submodule {
        options = {
          userSettings = wtypes.userSettings;
          userTasks = wtypes.userTasks;
          keybindings = wtypes.keybindings;
          extensions = wtypes.extensions;
          languageSnippets = wtypes.languageSnippets;
          globalSnippets = wtypes.globalSnippets;

          enableUpdateCheck = mkOption {
            type = types.nullOr types.bool;
            default = null;
            description = ''
              Whether to enable update checks/notifications.
              Can only be set for the default profile, but
              it applies to all profiles.
            '';
          };

          enableExtensionUpdateCheck = mkOption {
            type = types.nullOr types.bool;
            default = null;
            description = ''
              Whether to enable update notifications for extensions.
              Can only be set for the default profile, but
              it applies to all profiles.
            '';
          };
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

          settings = wtypes.userSettings;
          extensions = wtypes.extensions;

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
    programs.vscode.enable = true;
    programs.vscode.package = cfg.code-package;
    programs.vscode.profiles =
      (builtins.mapAttrs mkProfile cfg.profiles);
      # //
      #(lib.mkMerge (lib.mapAttrsToList (name: spec:
      #if builtins.length spec.extensions == 0 then {} else {
      #  "${genProfileName name spec}" = mkProfileW name { extensions = spec.extensions; };
      #}) cfg.workspaces));

    # Build and merge all declared workspaces
    xdg =
    let
      workspaces = mapAttrs (_name: spec: declare_workspace _name spec) cfg.workspaces;
    in
    {
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
