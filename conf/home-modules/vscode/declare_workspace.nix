# Helper to declare a single workspace given its name and spec
config: name: spec: rec {
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

  desktopEntries."CodeWorkspaceSelector".actions."${name}" =
  let
    initCmd     = "nix-shell ${spec.folder}/shell.nix --command \"exit\"";
    initWrap    = "kitty --app-id=kitty_info ${initCmd}";
    prefix      = if spec.prerun != "" then "${spec.prerun} && "
                  else if (spec.preinit && spec.hasShell) then "${initWrap} && " else "";
    postfix     = if spec.postrun != "" then " && ${spec.postrun}" else "";
    profileCmd  = if spec.profile == "" then "" else "--profile ${spec.profile}";
    codeCmd     = "${config.better-code.code-package}/bin/code --password-store=gnome-libsecret --ozone-platform=wayland ${config.xdg.configHome}/${configFile.${name}.target}";
    fullCommand = "${prefix}${codeCmd}${postfix}";
  in {
    name = name;
    exec = "bash -c \"${fullCommand}\"";
  };
}
