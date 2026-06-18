{ config, pkgs, ... }: {
  programs = {
    eza.enable = true;
    bat.enable = true;
    btop.enable = true;
    htop.enable = true;
    ripgrep.enable = true;
    ripgrep-all.enable = true;
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
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
    bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historyFile = "${config.xdg.stateHome}/bash/history";
      historySize = 999999;
      historyControl = [
        "ignoredups"
        "ignorespace"
      ];
    };
    zsh = {
      enable = true;
      autocd = false;
      enableVteIntegration = true;
      enableCompletion = true;
      dotDir = "${config.xdg.configHome}/zsh";
      history = {
        append = true;
        extended = true;
        size = 9999999;
        save = 9999999;
        path = "${config.xdg.stateHome}/.zsh_history";
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreAllDups = true;
        saveNoDups = true;

        share = false;
      };
      autosuggestion = {
        enable = true;
        highlight = "fg=magenta";
        strategy = [
          "history"
          "completion"
        ];
      };
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "regexp"
          "cursor"
          "root"
          "line"
        ];
        styles = {
          alias = "fg=green,underline";
          builtin = "fg=blue";
          function = "fg=blue,underline";
          comment = "none";
        };
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          # "git"
          # "sudo"
          # "thefuck" # binary needs to be installed
          "extract"
          "universalarchive"
          "command-not-found"
          "gh"
          "ipfs"
        ];
        theme = "agnoster";
      };
    };
  };
}
