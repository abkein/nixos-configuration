{ config, pkgs, ... }:
{
  imports = [
    ./networkmanager_dmenu.nix
    ./waybar.nix
    ./wofi.nix
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
      installBatSyntax = true;
      settings = {
        font-size = 10; # stylix
        term = "xterm";
        clipboard-trim-trailing-spaces = true;
      };
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
