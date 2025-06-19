{ config, name, folder, settings, prerun ? "", postrun ? "", preinit ? true }: rec {
  configFile.${name} = {
    enable = true;
    executable = false;
    force = true;
    target = "vscode_workspaces/${name}.code-workspace";
    text = builtins.toJSON {
      folders = [{ path = folder; }];
      settings = settings;
    };
  };
  desktopEntries."CodeWSpaceSelector".actions.${name} =
  let
    init_cmd = "nix-shell ${folder}/shell.nix --command \"exit\"";
    init_wrap_cmd = "kitty --app-id=\"kitty_info\" ${init_cmd}";
    prefix = if (prerun == "") then (if preinit then "${init_wrap_cmd} &&" else "") else "${prerun} && ";
    postfix = if (postrun == "") then "" else " && ${postrun}";
    codecmd = "${pkgs.vscode-fhs}/bin/code --password-store=gnome-libsecret --ozone-platform=wayland ${config.xdg.configHome}/${configFile.${name}.target}";
    cmd = "${prefix}${codecmd}${postfix}";
  in
  {
    name = "${name}";
    exec = "bash -c \"${cmd}\"";
  };
}
