# Helper to declare a single workspace given its name and spec
config: name: spec: rec {
  configFile."${name}" =
  let
  #   allow = if spec.extension_management_policy == "whitelist" then true else false;
  #   allowed_exts = foldl' (acc: ext: acc // {"${ext}" = true;}) {} cfg.always_allowed_extensions;
  #   exts = allowed_exts // (foldl' (acc: ext: acc // {"${ext}" = allow;}) {} spec.extensions) // {"*" = !allow;};
    profSet = if spec.profile == "" then {} else { "workbench.profile" = spec.profile; };
    envSet = if spec.hasShell then {
      "nixEnvSelector.suggestion" = false;
      "nixEnvSelector.nixFile" = "\${workspaceFolder}/shell.nix";
    } else {};
    settings = profSet // envSet // spec.settings;
  in
  {
    enable     = true;
    executable = false;
    force      = true;
    target     = "vscode_workspaces/${name}.better-code";
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
                  else if (spec.preinit && spec.hasShell) then "${initWrap} && " else "";
    postfix     = if spec.postrun != "" then " && ${spec.postrun}" else "";
    codeCmd     = "${config.better-code.code-package}/bin/code --password-store=gnome-libsecret --ozone-platform=wayland ${config.xdg.configHome}/${configFile.${name}.target}";
    fullCommand = "${prefix}${codeCmd}${postfix}";
  in {
    name = name;
    exec = "bash -c \"${fullCommand}\"";
  };
}
