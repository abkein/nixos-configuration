{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = false;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    enableVteIntegration = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"  # add conf
        "regexp"  # add conf
        "cursor"
        "root"
        "line"
      ];
    };

    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      append = true;
      extended = true;
      size = 9999999;
      save = 9999999;
      path = "${config.xdg.stateHome}/.zsh_history";
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "agnoster"; # blinks is also really nice
    };

    shellAliases =
      let
        flakeDir = "~/nixos-configuration";
      in
      {
        rb = "nh os switch ${flakeDir}"; # sudo nixos-rebuild switch --flake ${flakeDir}
        upd = "sudo nix flake update --flake ${flakeDir}";
        upg = "nh os switch -u ${flakeDir}"; # sudo nixos-rebuild switch --upgrade --flake ${flakeDir}

        dg = "sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system";
        cg = "sudo nix-collect-garbage -d";
        os = "sudo nix-store --optimise";
        destroy = "dg && cg && os";

        # _cat = "$(which cat)";
        cat = "bat";
        # _tree = "$(which tree)";
        tree = "eza --tree";
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        # _top = "$(which top)";
        top = "btop";

        refresh = "upd && upg && destroy";

        ish = "echo 'use nix' > .envrc && cp $XDG_CONFIG_HOME/defshell.nix shell.nix && chmod 644 shell.nix";
        init_python = "echo 'use nix' > .envrc && cp $XDG_CONFIG_HOME/python/pyshell.nix shell.nix && chmod 644 shell.nix && cp $XDG_CONFIG_HOME/python/defreqs.txt requirements.txt";
      };
  };
}
