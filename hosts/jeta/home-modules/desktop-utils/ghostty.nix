{ ... }: {
  stylix.targets.ghostty.enable = false;
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
    installBatSyntax = true;
    settings = {
      auto-update = "off";
      font-size = 10; # stylix
      palette-generate = true;
      # background-opacity = 0.8;
      background-blur = true;
      resize-overlay = "always";
      focus-follows-mouse = true;
      clipboard-paste-protection = true;

      selection-clear-on-typing = false;
      notify-on-command-finish = "unfocused";
      notify-on-command-finish-after = "20s";
      notify-on-command-finish-action = "bell,notify";
      bell-features = "audio,system,attention,title,border";
      link-previews = false;
      working-directory = "home";
      clipboard-trim-trailing-spaces = true;
      shell-integration-features = "cursor,title,ssh-env,ssh-terminfo";
      app-notifications = "no-clipboard-copy,config-reload";
      linux-cgroup = "always";
      keybind = "global:ctrl+q=toggle_quick_terminal";
      quick-terminal-size = "40%,60%";
      # term = "xterm";
    };
    systemd.enable = true;
  };
}
