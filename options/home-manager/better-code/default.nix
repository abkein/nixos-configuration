{
  lib,
  config,
  pkgs,
  ...
}@moduleArgs:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.better-code;
  wtypes = import ./wtypes.nix moduleArgs;
  # # Ensures generated profile name is unique across workspaces and the generated profile name is the same
  # # for a workspace, based on its hash
  generateProfileName4Workspace =
    workspaceName: workspaceSpec: "${workspaceSpec.profile}-${workspaceName}";

  run = {
    pre = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Commands to run before starting VSCode/flake.";
      example = lib.literalExpression ''
        [
          "echo 'VSCode is going to be started!'"
        ]
      '';
    };
    post = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Commands to run after VSCode/flake exited.";
      example = lib.literalExpression ''
        [
          "echo 'VSCode is exited!'"
        ]
      '';
    };
  };

  env = mkOption {
    type = types.attrsOf types.str;
    default = { };
    description = "Environment to export.";
    example = lib.literalExpression ''
      {
        http_proxy="http://127.0.0.1:1080";
        https_proxy="http://127.0.0.1:1080";
        no_proxy="localhost,127.0.0.0/8";
      }
    '';
  };

  mkFlakeOpt =
    isWorkspace:
    mkOption {
      default = {
        enable = false;
        producesWorkspace = false;
        run = {
          pre = [ ];
          post = [ ];
        };
        nix-args = [ ];
      }
      // (lib.optionalAttrs isWorkspace {
        flake = null;
        name = "default";
      });
      description = "Allows to launch code in nix development shell.";
      type = types.submodule {
        options = {
          inherit run env;
          enable = mkOption {
            type = types.bool;
            description = "Whether the environment is managed by a flake or unmanaged.";
            default = false;
            example = true;
          };

          producesWorkspace = mkOption {
            type = types.bool;
            description = ''
              Whether the environment is producing a `*.code-workspace` file.
              If so, the environment variable `$BETTER_CODE_VSCODE_WORKSPACE_FILE` must be exported, pointing to this file.
            '';
            default = false;
            example = true;
          };

          commands = mkOption {
            type = types.listOf (
              types.enum [
                "lock"
                "update"
                "prefetch"
                "prefetch-inputs"
              ]
            );
            description = "Whether to execute `nix flake $command` for each $command before starting.";
            default = [ ];
            example = lib.literalExpression ''
              [ "update" "prefetch" ]
            '';
          };

          nix-args = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "CLI arguments appended after `nix develop flake-uri[#name]` before `--command`.";
            example = lib.literalExpression ''
              [ "--override-input nixpkgs nixpkgs-unstable" ]
            '';
          };
        }
        // (lib.optionalAttrs isWorkspace {
          flake = mkOption {
            type = types.nullOr types.str;
            description = "flake-uri[#name] or `null` (uses the workspace folder).";
            default = null;
            example = "~/devShells#myShell";
          };
          name = mkOption {
            type = types.nullOr types.str;
            description = "Name of flake if the workspace folder is used as its uri. null means 'default'.";
            default = null;
            example = "myShell";
          };
        })
        // (lib.optionalAttrs (!isWorkspace) {
          flake = mkOption {
            type = types.str;
            description = "flake-uri[#name] or `null` (uses the workspace folder).";
            example = "~/devShells#myShell";
          };
        });
      };
    };
  mkIconOption =
    default:
    mkOption {
      type = types.str;
      description = "Icon name. Would be set to `Icon=` field in the generated .desktop file.";
      default = default;
      example = "vscodium";
    };
in
{
  options = {
    better-code = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the automated VSCode configuration.";
      };

      variant = mkOption {
        type = types.str;
        default = "vscode";
        description = ''
          Variant of VSCode, according to Home Manager's (`programs.''${variant}`).
          Currently only `vscode` or `vscodium`, but you can set any*.

          *Note that the option `programs.''${variant}` should exist and be compatible with Home Manager's `programs.vscode`.
        '';
      };

      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = "The VSCode package to use.";
        example = pkgs.vscodium;
      };

      mutableExtensionsDir = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Whether extensions can be installed or updated manually or by Visual Studio Code.";
      };

      enableUpdateCheck = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Whether to enable update checks/notifications.
          Can only be set for the default profile, but
          applies to all profiles.
        '';
      };

      enableExtensionUpdateCheck = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Whether to enable update notifications for extensions.
          Can only be set for the default profile, but
          applies to all profiles.
        '';
      };

      nix4vscodeAlways = mkOption {
        type = types.bool;
        default = false;
        description = ''
          By default extensions present in nixpkgs will be fetched from nixpkgs,
          extensions not present in nixpkgs will be fetched using pkgs.nix4vscode.forVscode.
          Enabling it will force to get all the extensions using pkgs.nix4vscode.forVscode.
        '';
        example = true;
      };

      desktopEntries = mkOption {
        default = {
          enable = false;
          workspaceSelectorIcon = cfg.variant;
          profileSelectorIcon = cfg.variant;
        };
        description = ''
          Configuration of generation of desktop entries for workspaces and profiles.
          Note that your application launcher should display actions, otherwise it's useless.
        '';
        type = types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              description = "Whether to enable creation of desktop entries.";
              default = false;
              example = true;
            };

            workspaceSelectorIcon = mkIconOption cfg.variant;

            profileSelectorIcon = mkIconOption cfg.variant;
          };
        };
      };

      terminal = {
        package = mkOption {
          type = types.package;
          default = pkgs.xterm;
          description = "Preferred terminal emulator app for `preinit` and `prerun`.";
          example = "pkgs.kitty";
        };

        args = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Additional CLI arguments provided to teminal emulator instance. Commands are added last.";
          example = lib.literalExpression ''
            [ "--app-id=vscode-launch-status" ]
          '';
        };
      };

      args = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Additional CLI arguments provided to every VSCode instance.";
        example = lib.literalExpression ''
          [
            "--password-store=gnome-libsecret"
            "--ozone-platform=wayland"
          ]
        '';
      };

      general = {
        inherit env run;
        inherit (wtypes)
          userSettings
          userTasks
          keybindings
          extensions
          languageSnippets
          globalSnippets
          enableMcpIntegration
          userMcp
          ;
      };

      profiles = mkOption {
        default = { };
        description = "A set of VSCode profiles. Mutually exclusive to programs.vscode.mutableExtensionsDir";
        type = types.attrsOf (
          types.submodule {
            options = {
              inherit env run;
              flake = mkFlakeOpt false;
              icon = mkIconOption cfg.desktopEntries.profileSelectorIcon;
              inherit (wtypes)
                userSettings
                userTasks
                keybindings
                extensions
                languageSnippets
                globalSnippets
                enableMcpIntegration
                userMcp
                ;
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
              inherit env run;
              flake = mkFlakeOpt true;
              extensions = wtypes.extensions;

              folder = mkOption {
                type = types.path;
                description = "Absolute path to the workspace folder.";
                example = "/home/user/Projects/MyApp";
              };

              profile = mkOption {
                type = types.str;
                description = "Profile used for this workspace. Written to workspace setting \"workbench.profile\".";
                default = "default";
                # example = "default";
              };

              workspaceFile = mkOption {
                default = {
                  enable = false;
                  folders = [ ];
                  addDefaultDir = true;
                  settings = { };
                };
                description = "Creates `.code-workspace` file. See https://code.visualstudio.com/docs/editing/workspaces/multi-root-workspaces";
                type = types.submodule {
                  options = {
                    enable = mkOption {
                      type = types.bool;
                      description = "Whether to create `.code-workspace` file.";
                      default = false;
                      example = true;
                    };

                    settings = wtypes.userSettings;
                    icon = mkIconOption cfg.desktopEntries.workspaceSelectorIcon;

                    folders = mkOption {
                      description = ''
                        Folders to add into workspace.

                        Note the folder specified in `better-code.workspaces.<name>.folder` is added automatically
                        with the name of workspace. To disable this behavior set `addDefaultDir = false`.
                      '';
                      default = [ ];
                      example = lib.literalExpression ''
                        [
                          {
                            name = "My cool project";
                            path = "/home/user/my-cool-project";
                          }
                        ]
                      '';
                      type = types.listOf (
                        types.submodule {
                          options = {
                            name = mkOption {
                              type = types.nullOr types.str;
                              description = "Name of the folder added.";
                              default = null;
                              example = "My cool project";
                            };
                            path = mkOption {
                              type = types.path;
                              description = "Path to the folder added.";
                              example = "/home/user/Documents/my-cool-project";
                            };
                          };
                        }
                      );
                    };

                    addDefaultDir = mkOption {
                      type = types.bool;
                      default = true;
                      example = false;
                      description = "Whether to add the folder specified in `better-code.workspaces.<name>.folder` into workspace folders.";
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
            };
          }
        );
      };
    };
  };

  config = mkIf cfg.enable (
    let
      extractAttrFromList =
        attr: list:
        lib.flatten (builtins.map (attrs: lib.optional (builtins.hasAttr attr attrs) attrs.${attr}) list);
      mergeAssertWarn = list: {
        assertions = lib.flatten (extractAttrFromList "assertions" list);
        warnings = lib.flatten (extractAttrFromList "warnings" list);
      };
      mergeAssertWarn' = func: attrs: mergeAssertWarn (lib.mapAttrsToList func attrs);
      workspaceAssertWarn =
        workspaceName: workspaceSpec:
        let
          msgStart = "Better-code: workspace ${workspaceName}: ";
        in
        with workspaceSpec;
        {
          assertions = [
            {
              assertion = workspaceFile.addDefaultDir || (workspaceFile.folders != [ ]);
              message =
                msgStart
                + "`workspaceFile`: either enable `addDefaultDir` or specify `folders`. Otherwise the workspace will be empty!";
            }
          ];
          warnings = [
            (lib.optional (flake.enable && (flake.flake != null) && (flake.name != null)) ''
              ${msgStart}`flake`: both `flake` and `name` are specified — only `flake` is used.
              Option `name` is used only if `flake=null`.
              If you wanted to specify flake name for that in `flake`, specify it there as `flake=flake-uri#name`.
            '')
          ];
        };
      profileAssertWarn =
        profileName: profileSpec: with profileSpec; {
          assertions = [
            {
              assertion = (!flake.enable) || (flake.flake != null); # if flake.enable then (flake.flake != null) else true;
              message = "Better-code: profiles: '${profileName}.flake': if flake is enabled for a profile, it must specify flake-uri.";
            }
          ];
        };
    in
    lib.mkMerge [
      (mkIf (cfg.workspaces != { }) (mergeAssertWarn' workspaceAssertWarn cfg.workspaces))
      (mkIf (cfg.profiles != { }) (mergeAssertWarn' profileAssertWarn cfg.profiles))
      { programs.${cfg.variant}.enable = true; }
      (mkIf (cfg.package != null) { programs.${cfg.variant}.package = cfg.package; })
      (mkIf (cfg.mutableExtensionsDir != null) {
        programs.${cfg.variant}.mutableExtensionsDir = cfg.mutableExtensionsDir;
      })
      (
        let
          deepMerge = (import ./deepMerge.nix).deepMerge;
          mkExtList = import ./mkExtList.nix moduleArgs cfg.nix4vscodeAlways;
          attrsToMerge = [
            "userSettings"
            "userTasks"
            "keybindings"
            "languageSnippets"
            "globalSnippets"
            "enableMcpIntegration"
            "userMcp"
          ];
          mkProfile =
            let
              general = cfg.general;
            in
            profileName: profileSpec:
            (builtins.listToAttrs (
              builtins.map (attrName: {
                name = attrName;
                value = deepMerge general.${attrName} profileSpec.${attrName};
              }) attrsToMerge
            ))
            // {
              extensions = mkExtList (general.extensions ++ profileSpec.extensions);
            }
            // (lib.optionalAttrs ((profileName == "default") && (cfg.enableUpdateCheck != null)) {
              enableUpdateCheck = cfg.enableUpdateCheck;
            })
            // (lib.optionalAttrs ((profileName == "default") && (cfg.enableExtensionUpdateCheck != null)) {
              enableExtensionUpdateCheck = cfg.enableExtensionUpdateCheck;
            });
          # Merge extension list specified for workspace with base profile's
          mkProfile4Workspace =
            workspaceName: workspaceSpec:
            let
              baseProfileSpec = cfg.profiles.${workspaceSpec.profile};
              profileSpec = baseProfileSpec // {
                extensions = baseProfileSpec.extensions ++ workspaceSpec.extensions;
              };
              profileName = "${workspaceSpec.profile}-${workspaceName}";
            in
            mkProfile profileName profileSpec;
          workspacesWithExtensions = lib.filterAttrs (
            _: workspaceSpec: (workspaceSpec.extensions != [ ])
          ) cfg.workspaces;
          # Merge profiles with profiles, generated for workspaces with requested extensions
          finalProfiles =
            (builtins.mapAttrs mkProfile cfg.profiles)
            // (lib.mapAttrs' (workspaceName: workspaceSpec: {
              name = generateProfileName4Workspace workspaceName workspaceSpec;
              value = mkProfile4Workspace workspaceName workspaceSpec;
            }) workspacesWithExtensions);
        in
        mkIf (finalProfiles != { }) { programs.${cfg.variant}.profiles = finalProfiles; }
      )
      (
        let
          mkWorkspaceConfigFile =
            workspaceName: workspaceSpec: with workspaceSpec.workspaceFile; {
              enable = enable;
              executable = false;
              force = true;
              text = builtins.toJSON {
                folders =
                  folders
                  ++ (lib.optionals addDefaultDir [
                    {
                      name = workspaceName;
                      path = workspaceSpec.folder;
                    }
                  ]);
                settings = settings;
              };
              target = "vscode_workspaces/${workspaceName}.code-workspace";
            };
          mkWorkspaceEnvrcFile = workspaceName: workspaceSpec: {
            name = "${workspaceName}-envrc";
            value = {
              enable = workspaceSpec.envrc != null;
              executable = false;
              force = true;
              target = "${workspaceSpec.folder}/.envrc";
              text = workspaceSpec.envrc;
            };
          };
          finalConfigFiles =
            lib.mapAttrs mkWorkspaceConfigFile (
              lib.filterAttrs (_: workspaceSpec: workspaceSpec.workspaceFile.enable) cfg.workspaces
            )
            // lib.mapAttrs' mkWorkspaceEnvrcFile (
              lib.filterAttrs (_: workspaceSpec: workspaceSpec.envrc != null) cfg.workspaces
            );
        in
        mkIf (finalConfigFiles != { }) {
          # VSCode workspace and .envrc files
          xdg.configFile = finalConfigFiles;
        }
      )
      (mkIf cfg.desktopEntries.enable (
        let
          mkCommand = command-args: lib.concatStringsSep " " (lib.flatten command-args);
          genEnvList = env: lib.mapAttrsToList (name: value: "export ${name}=\"${value}\"") env;

          mkActionExec =
            isWorkspace: name: spec:
            let
              profileName =
                if (!isWorkspace) then
                  name
                else if (spec.extensions == [ ]) then
                  spec.profile
                else
                  (generateProfileName4Workspace name spec);
              mkCodeCMD =
                workspaceName:
                mkCommand [
                  (lib.getExe config.programs.${cfg.variant}.package)
                  "--profile"
                  profileName
                  cfg.args
                  (lib.optional (workspaceName != null) workspaceName)
                ];
              flakeSpec = spec.flake;
              mkScript =
                scriptName: commandList:
                pkgs.writeShellScript scriptName (
                  builtins.concatStringsSep "\n" ([ "set -euo pipefail" ] ++ (lib.flatten commandList))
                );
              scriptNamePrefix =
                let
                  kind = if isWorkspace then "workspace" else "profile";
                in
                "better-code-${kind}-starter-${name}-";
              mkLauncher =
                {
                  launcherName,
                  inFlake ? false,
                  commandList,
                }:
                let
                  profileSpec = cfg.profiles.${spec.profile};
                  mergedEnv =
                    cfg.general.env
                    // (lib.optionalAttrs isWorkspace profileSpec.env)
                    // spec.env
                    // (lib.optionalAttrs inFlake flakeSpec.env);
                  mkRunSeq =
                    which:
                    cfg.general.run.${which}
                    ++ (lib.optionals isWorkspace profileSpec.run.${which})
                    ++ spec.run.${which}
                    ++ (lib.optionals inFlake flakeSpec.run.${which});
                in
                mkScript (scriptNamePrefix + launcherName) (
                  (genEnvList mergedEnv) ++ (mkRunSeq "pre") ++ commandList ++ (mkRunSeq "post")
                );

              nix-command =
                command: args:
                let
                  resolvedFlake =
                    if (flakeSpec.flake != null) then
                      flakeSpec.flake
                    else if isWorkspace then
                      (spec.folder + "#" + (if (flakeSpec.name != null) then flakeSpec.name else "default"))
                    else
                      null;
                in
                mkCommand [
                  "nix"
                  command
                  resolvedFlake
                  flakeSpec.nix-args
                  args
                ];

              terminal-exec =
                command:
                mkCommand [
                  (lib.getExe cfg.terminal.package)
                  cfg.terminal.args
                  command
                ];

              workspace =
                if flakeSpec.producesWorkspace then
                  "$BETTER_CODE_VSCODE_WORKSPACE_FILE"
                else if isWorkspace then
                  (if spec.workspaceFile.enable then config.xdg.configFile.${name}.target else spec.folder)
                else
                  null;

              innerExec = mkLauncher {
                launcherName = "inner";
                inFlake = true;
                commandList = [ (mkCodeCMD workspace) ];
              };

              flake-exec =
                command:
                nix-command "develop" [
                  "--command"
                  command
                ];

              nix-flake-command = command: nix-command [ "flake" command ] [ ];
              flake-commands = mkScript (scriptNamePrefix + "flake-init") [
                (builtins.map nix-flake-command flakeSpec.commands)
                (flake-exec "exit")
              ];

              innerCmds = [
                (terminal-exec flake-commands)
                (flake-exec innerExec)
              ];

            in
            mkLauncher {
              launcherName = "outer";
              inFlake = false;
              commandList = if flakeSpec.enable then innerCmds else [ (mkCodeCMD workspace) ];
            };
          mkAction = isWorkspace: name: spec: {
            name = if isWorkspace then "Workspace: ${name}" else "Profile: ${name}";
            icon = spec.icon;
            exec = mkActionExec isWorkspace name spec;
          };
          finalWorkspaceActions = lib.mapAttrs (mkAction true) cfg.workspaces;
          finalProfileActions = lib.mapAttrs (mkAction false) cfg.profiles;
          finalDesktopEntries = lib.mkMerge [
            (mkIf (finalWorkspaceActions != { }) {
              CodeWorkspaceSelector = {
                name = "Workspace Selector";
                genericName = "VSCode Workspace Selector";
                exec = "${pkgs.libnotify}/bin/notify-send --app-icon=${cfg.desktopEntries.workspaceSelectorIcon} 'Code workspace selector does nothing itself, select an action'";
                icon = cfg.desktopEntries.workspaceSelectorIcon;
                type = "Application";
                categories = [
                  "Development"
                  "IDE"
                  "TextTools"
                ];
                actions = finalWorkspaceActions;
              };
            })
            (mkIf (finalProfileActions != { }) {
              CodeProfileSelector = {
                name = "Profile Selector";
                genericName = "VSCode Profile Selector";
                exec = "${pkgs.libnotify}/bin/notify-send --app-icon=${cfg.desktopEntries.profileSelectorIcon} 'VSCodeProfileSelector does nothing itself, select an action";
                icon = cfg.desktopEntries.profileSelectorIcon;
                type = "Application";
                categories = [
                  "Development"
                  "IDE"
                  "TextTools"
                ];
                actions = finalProfileActions;
              };
            })
          ];
        in
        mkIf (finalDesktopEntries != { }) { xdg.desktopEntries = finalDesktopEntries; }
      ))
    ]
  );
}
