{ lib, config, pkgs, ... }@args:

# with lib;

let
  codeCMD = "code";
  codeIcon = "vscode";
  inherit (lib) mkOption types literalExpression mapAttrs mkMerge attrValues attrNames mapAttrsToList;
  cfg = config.better-code;
  jsontype = (pkgs.formats.json { }).type;
  deepMerge = (import ./deepMerge.nix).deepMerge;
  mkDeepMerge = lst: lib.foldl' (acc: spec: deepMerge acc spec) {} lst;
  genProfileName = name: spec: "${name}-${builtins.hashString "sha256" (builtins.toJSON spec)}";
  basic_code_CMD = profile: disable_envstr:
  let
    envstr = if (cfg.envstr != "" && !disable_envstr) then "${builtins.replaceStrings ["$"] ["\\$"] cfg.envstr} " else "";
  in
  "${envstr}${lib.getExe cfg.code-package} --profile ${profile} ${cfg.args}";
  # Helper to declare a single workspace given its name and spec
  declare_workspace = name: spec: rec {
    configFile."${name}" =
    let
      envSet = if spec.hasShell then {
        "nixEnvSelector.suggestion" = false;
        "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
      } else {};
      settings = envSet // spec.settings;
    in
    {
      enable     = true;
      executable = false;
      force      = true;
      target     = "vscode_workspaces/${name}.code-workspace";
      text       = builtins.toJSON {
        folders = [{ path = spec.folder; }];
        settings = settings;
      };
    };

    desktopEntries.CodeWorkspaceSelector.actions."${name}" =
    let
      initCmd     = "nix-shell ${spec.folder}/shell.nix --command \"exit\"";
      initWrap    = "${lib.getExe cfg.terminal-emulator} ${cfg.terminal-args} ${initCmd}";
      prefix      = if spec.prerun != "" then "${spec.prerun} && "
                    else if (spec.preinit && spec.hasShell) then "${initWrap} && " else "";
      postfix     = if spec.postrun != "" then " && ${spec.postrun}" else "";
      profile     = if spec.profile == "" then "default" else (if builtins.length spec.extensions == 0 then spec.profile else (genProfileName name spec));
      codeCmd     = "${basic_code_CMD profile spec.disable_envstr} ${config.xdg.configHome}/${configFile.${name}.target}";
      fullCommand = "${prefix}${codeCmd}${postfix}";
    in {
      name = name;
      exec = "bash -c \"${fullCommand}\"";
    };
  };
  mkExtList = import ./mkExtList.nix { pkgs=pkgs; lib=lib; };
  rebuildExtensions = spec: spec // { extensions = mkExtList spec.extensions; };
  #mkProfile = name: spec: rebuildExtensions (lib.recursiveUpdate cfg.general spec);
  mkProfile = name: spec: rebuildExtensions (deepMerge cfg.general spec);
  mkProfileW = profileName: name: spec: mkProfile name (deepMerge
    (if profileName == "" then {} else cfg.profiles.${profileName})
    spec
  );
  wtypes = import ./wtypes.nix args;
in
{
  options = {
    better-code = {
      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = "Enable the automated VSCode configuration.";
      };

      code-package = mkOption {
        type        = types.package;
        default     = pkgs.vscode-fhs;
        description = "The VSCode package to use.";
        example     = pkgs.vscodium;
      };

      terminal-emulator = mkOption {
        type        = types.package;
        default     = pkgs.xterm;
        description = "Preferred terminal emulator app for `preinit` and `prerun`.";
        example     = pkgs.kitty;
      };

      terminal-args = mkOption {
        type        = types.str;
        description = "Additional CLI arguments provided to teminal emulator instance";
        default     = "";
        example     = "--app-id=kitty_info";
      };

      args = mkOption {
        type        = types.str;
        description = "Additional CLI arguments provided to every VSCode instance";
        default     = "";
        example     = "--password-store=gnome-libsecret --ozone-platform=wayland";
      };

      envstr = mkOption {
        type        = types.str;
        description = "Environment string to place before every VSCode instance.";
        default     = "";
        example     = "http_proxy=socks5://127.0.0.1:1080 https_proxy=$http_proxy no_proxy=localhost,127.0.0.0/8";
      };

      general = {
        userSettings = wtypes.userSettings;
        userTasks = wtypes.userTasks;
        keybindings = wtypes.keybindings;
        extensions = wtypes.extensions;
        languageSnippets = wtypes.languageSnippets;
        globalSnippets = wtypes.globalSnippets;
      };

      profiles = mkOption {
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

            disable_envstr = mkOption {
              type        = types.bool;
              description = "Whether to disable `envstr` addition.";
              default     = false;
            };

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

      workspaces = mkOption {
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

            disable_envstr = mkOption {
              type        = types.bool;
              description = "Whether to disable `envstr` addition.";
              default     = false;
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
  };

  config = lib.mkIf cfg.enable {
    programs.vscode.enable = true;
    programs.vscode.package = cfg.code-package;
    programs.vscode.profiles = lib.mapAttrs (name: spec: builtins.removeAttrs spec ["disable_envstr"])
      ((builtins.mapAttrs mkProfile cfg.profiles)
      //
      (mkDeepMerge (lib.mapAttrsToList (name: spec:
      if builtins.length spec.extensions == 0 then {} else {
       "${genProfileName name spec}" = mkProfileW spec.profile name { extensions = spec.extensions; };
      }) cfg.workspaces)));

    # Build and merge all declared workspaces
    xdg =
    let
      workspaces = mapAttrs (_name: spec: declare_workspace _name spec) cfg.workspaces;
      declProfAction = profileName: profileSpec:
      let
        fullCommand = basic_code_CMD profileName profileSpec.disable_envstr;
      in
      {
        CodeProfileSelector.actions."${profileName}" = {
          name = profileName;
          exec = "bash -c \"${fullCommand}\"";
        };
      };
    in
    {
      # VSCode workspace files
      configFile = mkMerge (map (w: w.configFile) (attrValues workspaces));

      # Desktop entry for selector and per-workspace actions
      desktopEntries = mkMerge (
        [ {
            CodeWorkspaceSelector = {
              name        = "Workspace Selector";
              genericName = "VSCode Workspace Selector";
              exec        = ''hyprctl notify 2 3000 0 "fontsize:35 VSCodeWorkspaceSelector does nothing itself, select an action"'';
              icon        = codeIcon;
              type        = "Application";
              categories  = [ "Development" "IDE" "TextTools" ];
              actions     = {};
            };
            CodeProfileSelector = {
              name        = "Profile Selector";
              genericName = "VSCode Profile Selector";
              exec        = ''hyprctl notify 2 3000 0 "fontsize:35 VSCodeProfileSelector does nothing itself, select an action"'';
              icon        = codeIcon;
              type        = "Application";
              categories  = [ "Development" "IDE" "TextTools" ];
              actions     = {};
            };
          }
        ] ++ map (w: w.desktopEntries) (attrValues workspaces) ++ mapAttrsToList declProfAction cfg.profiles
      );
    };
  };
}
