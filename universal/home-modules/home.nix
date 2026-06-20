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
        dud = "du -h -d 1 ";

        _ls = "${pkgs.coreutils-full}/bin/ls";
        ls = "${config.programs.eza.package}/bin/eza ${eza_args}";

        _tree = "${pkgs.tree}/bin/tree";
        tree = "${config.programs.eza.package}/bin/eza ${eza_args} --tree";

        _cat = "${pkgs.coreutils-full}/bin/cat";
        cat = "${config.programs.bat.package}/bin/bat";

        _rm = "${pkgs.coreutils-full}/bin/rm";
        "rm -f" = "${pkgs.trash-cli}/bin/trash-put -i";
        "rm -rf" = "${pkgs.trash-cli}/bin/trash-put -ri";
        rm = "${pkgs.trash-cli}/bin/trash-put -i";

        _cp = "${pkgs.coreutils-full}/bin/cp";
        "cp -f" = "${pkgs.coreutils-full}/bin/cp --backup=numbered -i";
        "cp -rf" = "${pkgs.coreutils-full}/bin/cp --backup=numbered -ri";
        cp = "${pkgs.coreutils-full}/bin/cp --backup=numbered -i";

        _mv = "${pkgs.coreutils-full}/bin/mv";
        "mv -f" = "${pkgs.coreutils-full}/bin/mv --backup=numbered -i";
        "mv -rf" = "${pkgs.coreutils-full}/bin/mv --backup=numbered -ri";
        mv = "${pkgs.coreutils-full}/bin/mv --backup=numbered -i";

        _grep = "${pkgs.gnugrep}/bin/grep";
        grep = "grep --color=auto";

        _top = "${pkgs.procps}/bin/top";
        top = "${config.programs.btop.package}/bin/btop";
      };
    packages = with pkgs; [ trash-cli ];
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
