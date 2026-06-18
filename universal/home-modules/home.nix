{
  config,
  pkgs,
  cfg,
  ...
}:
{
  home = {
    username = cfg.username;
    homeDirectory = cfg.userhome;
    uid = cfg.uid;
    enableNixpkgsReleaseCheck = false;
    preferXdgDirectories = true;
    shell = {
      enableShellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    shellAliases =
      let
        eza_args = "--git --icons=auto --color=auto --color-scale=all --color-scale-mode=gradient --time-style='+%H:%M %d.%m.%Y' --group";
      in
      {
        delete-generations = "sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system";
        system-cleaning = "delete-generations && nix store gc && nix store optimise";
        wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";

        _ls = "${pkgs.coreutils-full}/bin/ls";
        ls = "${config.programs.eza.package}/bin/eza ${eza_args}";
        _cat = "${pkgs.coreutils-full}/bin/cat";
        cat = "${config.programs.bat.package}/bin/bat";
        _tree = "${pkgs.tree}/bin/tree";
        tree = "${config.programs.eza.package}/bin/eza ${eza_args} --tree";
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        dud = "du -h -d 1 ";
        grep = "grep --color=auto";
        _top = "${pkgs.procps}/bin/top";
        top = "${config.programs.btop.package}/bin/btop";
      };
  };

  xdg = {
    enable = true;
    # defaults:
    # cacheHome = "~/.cache";  # $XDG_CACHE_HOME
    # configHome = "~/.config";  # $XDG_CONFIG_HOME
    # dataHome = "~/.local/share";  # $XDG_DATA_HOME
    # stateHome = "~/.local/state";  # $XDG_STATE_HOME
    # binHome = "~/.local/bin"; # $XDG_BIN_HOME
    localBinInPath = true;
  };
}
