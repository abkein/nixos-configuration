{
  lib,
  config,
  pkgs,
  ...
}@args:

let
  codeIcon = "vscode";
  inherit (lib)
    mkOption
    types
    mkMerge
    attrValues
    mapAttrsToList
    ;
  cfg = config.better-code;
  deepMerge = (import ./deepMerge.nix).deepMerge;
  # Ensures generated profile name is unique across workspaces and the generated profile name is the same
  # for a workspace, based on its hash
  generateProfileName4Workspace =
    name: spec: "${name}-${builtins.hashString "sha256" (builtins.toJSON spec)}";
  # Generate command to launch VSCode prepending environment string (env variables like http_proxy=http://127.0.0.1:1080
  # and others that go before executable), specifying profile and other user-specified arguments
  basic_code_CMD =
    profile: disable_envstr:
    let
      envstr =
        if (cfg.envstr != "" && !disable_envstr) then
          "${builtins.replaceStrings [ "$" ] [ "\\$" ] cfg.envstr} "
        else
          "";
    in
    "${envstr}${lib.getExe cfg.code-package} --profile ${profile} ${cfg.args}";
  # Helper to declare a single workspace given its name and specification
  declare_workspace =
    name: spec:
    let
      nixSpec =
        if spec.nix == null then
          {
            method = null;
            flakeOutput = null;
            launchInside = false;
            producesWorkspace = false;
          }
        else
          spec.nix;
    in
    rec {
      # Generate a .code-workspace file, but enable only if needed
      configFile."${name}" = {
        enable = spec.workspaceFile.enable;
        executable = false;
        force = true;
        target = "vscode_workspaces/${name}.code-workspace";
        text = builtins.toJSON {
          folders = [ { path = spec.folder; } ];
          settings =
            (
              if spec.workspaceFile.addNixEnvSelect then
                (
                  if nixSpec.method == "shell" then
                    {
                      "nixEnvSelector.suggestion" = false;
                      "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
                    }
                  else if nixSpec.method == "flake" then
                    {
                      "nixEnvSelector.suggestion" = false;
                      "nixEnvSelector.nixFile" = "\${workspaceFolder}/flake.nix";
                    }
                  else
                    { }
                )
              else
                { }
            )
            // spec.workspaceFile.settings;
        };
      };

      # Add action to open the workspace
      desktopEntries.CodeWorkspaceSelector.actions."${name}" =
        let
          # Helper to run specified command inside the user-specified environment (inside nix-shell or nix develop).
          # If the environment wasn't specified (nixSpec.method is null) then it isn't used
          environmentLaunchCommand =
            command:
            if nixSpec.method == "shell" then
              "nix-shell ${spec.folder}/shell.nix --command '${command}'"
            else if nixSpec.method == "flake" then
              "nix develop ${spec.folder}${
                if nixSpec.flakeOutput != null then "#${nixSpec.flakeOutput}" else ""
              } --command bash -c '${command}'"
            else
              "";
          # Execute command 'exit' inside the environment launched inside the terminal emulator.
          # I think it's useful so if the environment needs to be set-up, e.g. nix needs to download
          # packages. If so in the terminal emulator the user will see the progress (and errors if the are)
          # and at the end VSCode will be launched immediately. Otherwise the output from nixisn't visible
          # which leads to a frustration (is it stuck or something?) and in the case of errors (e.g. nix
          # couldn't download smth or the env file contains errors) there's no way to know it.
          preinitWrap = "${lib.getExe cfg.terminal-emulator} ${cfg.terminal-args} ${environmentLaunchCommand "exit"}";
          # Commands to be launched before launching VSCode
          prefix = builtins.concatStringsSep " && " (
            spec.prerun
            ++ [ "echo ' '" ]
            ++ (if (spec.preinit && (nixSpec.method != null)) then [ preinitWrap ] else [ ])
          );
          # Commands to be launched after VSCode is closed
          postfix = builtins.concatStringsSep " && " (spec.postrun ++ [ "echo ' '" ]);
          # Determine the profile name. If there are extensions specified for current workspace,
          # a new profile will be generated using the base profile. Now we need just its name
          # which is ensured to be similar to the name of the actually generated profile.
          profile =
            if spec.profile == "" then
              "default"
            else if (builtins.length spec.extensions == 0) then
              spec.profile
            else
              (generateProfileName4Workspace name spec);
          # Determine the workspace. If the user's environment generates its own workspace file and
          # VSCode is intended to be launched inside this environment, then workspace file should be
          # specified inside $BETTER_CODE_VSCODE_WORKSPACE_FILE environment variable. If the leading
          # is false, but this module generates the workspace file, then use it. Otherwuise just
          # the target folder.
          workspace =
            if (nixSpec.method != null && nixSpec.launchInside && nixSpec.producesWorkspace) then
              "\\\\$BETTER_CODE_VSCODE_WORKSPACE_FILE"
            else if spec.workspaceFile.enable then
              "${config.xdg.configHome}/${configFile.${name}.target}"
            else
              "${spec.folder}";
          codeCmd = "${basic_code_CMD profile spec.disable_envstr} ${workspace}";
          # If needed wrap the command to launch VSCode to be launched inside the environment
          codeCmdWrapped =
            if (nixSpec.method != null && nixSpec.launchInside) then
              environmentLaunchCommand codeCmd
            else
              codeCmd;
        in
        {
          name = name;
          exec = "bash -c \"${prefix} && ${codeCmdWrapped} && ${postfix}\"";
        };
    }
    // (
      if spec.envrc != null then
        {
          configFile."${name}-envrc" = {
            enable = true;
            executable = false;
            force = true;
            target = "${spec.folder}/.envrc";
            text = spec.envrc;
          };
        }
      else
        { }
    );
  # Performs automatic search for an extension in pkgs.vscode-extensions
  # and uses pkgs.nix4vscode.forVscode if not found and produces derivation list
  mkExtList = import ./mkExtList.nix {
    pkgs = pkgs;
    lib = lib;
  };
  # Replace extension names with actual derivations
  rebuildExtensions = spec: spec // { extensions = mkExtList spec.extensions; };
  # Merges profile specification with general one to produce actual profile
  # Also filter out `disable_envstr` attr from specification, because we're
  # using programs.vscode.profile like specification, wich does not contains it
  mkProfile =
    name: spec:
    rebuildExtensions (deepMerge cfg.general (builtins.removeAttrs spec [ "disable_envstr" ]));
  # Merge extension list specified for workspace with base profile's
  mkProfile4Workspace =
    name: spec:
    mkProfile name (
      deepMerge (if spec.profile == "" then cfg.profiles.default else cfg.profiles."${spec.profile}") {
        extensions = spec.extensions;
      }
    );
  wtypes = import ./wtypes.nix args;
in
{
  options = {
    better-code = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the automated VSCode configuration.";
      };

      code-package = mkOption {
        type = types.package;
        default = pkgs.vscode-fhs;
        description = "The VSCode package to use.";
        example = pkgs.vscodium;
      };

      terminal-emulator = mkOption {
        type = types.package;
        default = pkgs.xterm;
        description = "Preferred terminal emulator app for `preinit` and `prerun`.";
        example = pkgs.kitty;
      };

      terminal-args = mkOption {
        type = types.str;
        description = "Additional CLI arguments provided to teminal emulator instance";
        default = "";
        example = "--app-id=kitty_info";
      };

      args = mkOption {
        type = types.str;
        description = "Additional CLI arguments provided to every VSCode instance";
        default = "";
        example = "--password-store=gnome-libsecret --ozone-platform=wayland";
      };

      envstr = mkOption {
        type = types.str;
        description = "Environment string to place before every VSCode instance.";
        default = "";
        example = "http_proxy=http://127.0.0.1:1080 https_proxy=$http_proxy no_proxy=localhost,127.0.0.0/8";
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
        default = { };
        description = "A set of VSCode profiles. Mutually exclusive to programs.vscode.mutableExtensionsDir";
        type = types.attrsOf (
          types.submodule {
            options = {
              userSettings = wtypes.userSettings;
              userTasks = wtypes.userTasks;
              keybindings = wtypes.keybindings;
              extensions = wtypes.extensions;
              languageSnippets = wtypes.languageSnippets;
              globalSnippets = wtypes.globalSnippets;

              disable_envstr = mkOption {
                type = types.bool;
                description = "Whether to disable `envstr` addition.";
                default = false;
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
          }
        );
      };

      workspaces = mkOption {
        default = { };
        description = "Attribute-set of VSCode workspace specs, keyed by workspace name.";
        type = types.attrsOf (
          types.submodule {
            options = {
              folder = mkOption {
                type = types.str;
                description = "Absolute path to the workspace folder.";
                example = "/home/user/Projects/MyApp";
              };

              extensions = wtypes.extensions;

              prerun = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Command to run before opening VSCode.";
                example = lib.literalExpression ''
                  [
                    "echo 'VSCode is going to be opened!'"
                  ]
                '';
              };

              postrun = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Command to run after VSCode is closed.";
                example = lib.literalExpression ''
                  [
                    "echo 'VSCode is closed!'"
                  ]
                '';
              };

              disable_envstr = mkOption {
                type = types.bool;
                description = "Whether to disable `envstr` addition.";
                default = false;
              };

              preinit = mkOption {
                type = types.bool;
                description = "Whether to run nix-shell before opening VSCode if prerun is empty.";
                default = true;
              };

              profile = mkOption {
                type = types.str;
                description = "Profile used for this workspace. Written to workspace setting \"workbench.profile\". Nothing written if empty.";
                default = "";
                example = "default";
              };

              workspaceFile = mkOption {
                default = {
                  enable = false;
                  settings = { };
                  addNixEnvSelect = false;
                };
                description = "Attribute-set of VSCode workspace specs, keyed by workspace name.";
                type = types.submodule {
                  options = {
                    enable = mkOption {
                      type = types.bool;
                      description = "Whether to create `.code-workspace` file.";
                      default = false;
                      example = true;
                    };

                    settings = wtypes.userSettings;

                    addNixEnvSelect = mkOption {
                      type = types.bool;
                      description = "Whether to add settings for Nix Environment Selector extension.";
                      default = false;
                      example = true;
                    };
                  };
                };
              };

              envrc = mkOption {
                type = types.nullOr types.str;
                description = "Contents of the `.envrc` file in workspace folder. `null` if shouldn't be managed.";
                default = null;
                example = "use flake .";
              };

              nix = mkOption {
                default = {
                  method = null;
                  flakeOutput = null;
                  launchInside = false;
                  producesWorkspace = false;
                };
                description = "Attribute-set of VSCode workspace specs, keyed by workspace name.";
                type = types.nullOr (
                  types.submodule {
                    options = {
                      method = mkOption {
                        type = types.nullOr types.str;
                        description = "Whether the environment is managed by shell, flake or unmanaged. Possible respective values are `shell`, `flake`, `null` (default).";
                        default = null;
                        example = "shell";
                      };

                      flakeOutput = mkOption {
                        type = types.nullOr types.str;
                        description = "Name of the flake output (that goes after # in `nix develop /path/to/flake#OutputName`) or `null` (default, uses default output).";
                        default = null;
                        example = "compilers";
                      };

                      launchInside = mkOption {
                        type = types.bool;
                        description = "Whether to launch vscode from the inside of the environment.";
                        default = false;
                        example = true;
                      };

                      producesWorkspace = mkOption {
                        type = types.bool;
                        description = ''
                          Whether the environment is producing a `*.code-workspace` file.
                          If so, the environment variable `$BETTER_CODE_VSCODE_WORKSPACE_FILE` must be present, pointing to this file.
                          Makes sense only if `launchInside` option is true.
                        '';
                        default = false;
                        example = true;
                      };
                    };
                  }
                );
              };
            };
          }
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode.enable = true;
    programs.vscode.package = cfg.code-package;
    # Marge profiles with profiles, generated for workspaces with requested extensions
    programs.vscode.profiles =
      (builtins.mapAttrs mkProfile cfg.profiles)
      // (lib.mapAttrs' (name: spec: {
        name = generateProfileName4Workspace name spec;
        value = mkProfile4Workspace name spec;
      }) (lib.filterAttrs (_name: spec: (builtins.length spec.extensions != 0)) cfg.workspaces));

    # Build and merge all declared workspaces
    xdg =
      let
        workspaces = builtins.mapAttrs (_name: spec: declare_workspace _name spec) cfg.workspaces;
        declProfAction =
          profileName: profileSpec:
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
          [
            {
              CodeWorkspaceSelector = {
                name = "Workspace Selector";
                genericName = "VSCode Workspace Selector";
                exec = ''hyprctl notify 2 3000 0 "fontsize:35 VSCodeWorkspaceSelector does nothing itself, select an action"'';
                icon = codeIcon;
                type = "Application";
                categories = [
                  "Development"
                  "IDE"
                  "TextTools"
                ];
                actions = { };
              };
              CodeProfileSelector = {
                name = "Profile Selector";
                genericName = "VSCode Profile Selector";
                exec = ''hyprctl notify 2 3000 0 "fontsize:35 VSCodeProfileSelector does nothing itself, select an action"'';
                icon = codeIcon;
                type = "Application";
                categories = [
                  "Development"
                  "IDE"
                  "TextTools"
                ];
                actions = { };
              };
            }
          ]
          ++ map (w: w.desktopEntries) (attrValues workspaces)
          ++ mapAttrsToList declProfAction cfg.profiles
        );
      };
  };
}
