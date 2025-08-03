config: {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = let flakeDir = "~/nixos-configuration/conf"; in {
      rb = "nh os switch /home/kein/nixos-configuration/conf";  # sudo nixos-rebuild switch --flake ${flakeDir}
      upd = "sudo nix flake update --flake ${flakeDir}";
      upg = "nh os switch -u /home/kein/nixos-configuration/conf";  # sudo nixos-rebuild switch --upgrade --flake ${flakeDir}

      dg = "sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system";
      cg = "sudo nix-collect-garbage -d";
      os = "sudo nix-store --optimise";
      destroy = "dg && cg && os";

      _cat = "$(which cat)";
      cat = "bat";
      _tree = "$(which tree)";
      tree = "eza --tree";
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      _top = "$(which top)";
      top = "btop";

      refresh = "upd && upg && destroy";

      ish = "echo 'use nix' > .envrc && cp $XDG_CONFIG_HOME/defshell.nix shell.nix && chmod 644 shell.nix";
      init_python = "echo 'use nix' > .envrc && cp $XDG_CONFIG_HOME/python/pyshell.nix shell.nix && chmod 644 shell.nix && cp $XDG_CONFIG_HOME/python/defreqs.txt requirements.txt";
    };

    history = {
      size = 999999;
      path = "${config.xdg.stateHome}/zsh/history";
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
    };
    dotDir = ".config/zsh";

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "agnoster"; # blinks is also really nice
    };
}
