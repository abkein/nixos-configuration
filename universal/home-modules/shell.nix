{
  config,
  pkgs,
  ...
}:
{
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

  programs = {
    ripgrep.enable = true;
    ripgrep-all.enable = true;
    bat.enable = true;
    btop.enable = true;
    htop = {
      enable = true;
      # settings = {};
    };
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;
      settings.user = {
        name = "abkein";
        email = "rickbatra0z@gmail.com";
      };
    };
    direnv = {
      enable = true;
      silent = false;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        bash_path = "${config.programs.bash.package}/bin/bash";
        disable_stdin = true;
        load_dotenv = true;
        strict_env = true;
      };
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      git = true;
      icons = "always";
    };
    bash = {
      enable = true;
      enableCompletion = true;
      # enableVteIntegration = true;
      historyFile = "${config.xdg.stateHome}/bash/history";
      historySize = 999999;
    };
    zsh = {
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
      # enableVteIntegration = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern" # add conf
          "regexp" # add conf
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

      shellAliases = {
        delete-generations = "sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system";
        system-cleaning = "delete-generations && nix store gc && nix store optimise";
        wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";

        _cat = "${pkgs.coreutils-full}/bin/coreutils --coreutils-prog=cat";
        cat = "bat"; # "${config.programs.bat.package}/bin/bat";
        _tree = "${pkgs.tree}/bin/tree";
        tree = "eza --tree"; # "${config.programs.eza.package}/bin/eza --tree";
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        _top = "${pkgs.procps}/bin/top";
        top = "btop"; # "${config.programs.btop.package}/bin/btop";
      };
    };
  };
}
