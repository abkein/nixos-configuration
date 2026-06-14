{ cfg, ... }: {
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
