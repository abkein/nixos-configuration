{ config, pkgs, ... }:
{
  imports = [
    ./networkmanager_dmenu.nix
    ./waybar.nix
    ./fuzzel.nix
    # ./wofi.nix
  ];

  services = {
    cliphist = {
      enable = true;
      allowImages = true;
    };
  };

  home.packages = with pkgs; [
    dmenu
    polkit_gnome # exclusively here
    wlr-randr
    ydotool
    wl-clipboard

    xdg-utils
    xdg-user-dirs
    xdg-launch
    xdg-terminal-exec
    xdg-ninja
  ];

  stylix.targets.ghostty.enable = false;
  programs = {
    swayimg = {
      enable = true;
      # settings = {}; # https://github.com/artemsen/swayimg/blob/master/extra/swayimgrc
    };
    wayprompt = {
      enable = true;
      # settings = {}; # `man 5 wayprompt`
    };
    ghostty = {
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
    swappy = {
      enable = true;
      settings.Default = {
        save_dir = config.xdg.userDirs.extraConfig.SCREENSHOTS;
        save_filename_format = "swappy-%Y%m%d-%H%M%S.png";
        show_panel = false;
        line_size = 5;
        text_size = 20;
        text_font = "sans-serif";
        paint_mode = "brush";
        early_exit = true;
        fill_shape = false;
        auto_save = true;
        custom_color = "rgba(193,125,17,1)";
      };
    };
  };
}
