{ ... }: {
  stylix.targets.ghostty.enable = false;
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    settings = {
      auto-update = "off";
      font-size = 10; # stylix
      palette-generate = true;
      # background-opacity = 0.8;
      background-blur = true;
      resize-overlay = "always";

      notify-on-command-finish = "unfocused";
      notify-on-command-finish-after = "30s";
      notify-on-command-finish-action = "bell,notify";
      bell-features = "audio,system,attention,title,border";

      clipboard-paste-protection = true;
      clipboard-trim-trailing-spaces = true;
      selection-clear-on-typing = false;
      focus-follows-mouse = true;

      link-url = true;
      link-previews = true;

      working-directory = "home";
      window-inherit-working-directory = false;
      tab-inherit-working-directory = true;
      split-inherit-working-directory = true;

      shell-integration-features = "cursor,sudo,title,ssh-env"; # ,ssh-env,ssh-terminfo
      app-notifications = "no-clipboard-copy,config-reload";
      linux-cgroup = "always";
      keybind = "global:ctrl+q=toggle_quick_terminal";
      quick-terminal-size = "40%,60%";
      # term = "xterm";
    };
    systemd.enable = true;
  };
}
