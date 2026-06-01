{ config, pkgs, ... }:
{
  stylix.targets.ghostty.enable = false;
  stylix.targets.fuzzel.fonts.override = {
    sizes = {
      # applications = 14;
      # desktop = 14;
      popups = 14;
      # terminal = 14;
    };
  };
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
    fuzzel = {
      enable = true;
      settings = {
        main = {
          show-actions = true;
          terminal = "${pkgs.ghostty}/bin/ghostty -e {cmd}";
          keyboard-focus = "on-demand"; # exclusive
          auto-select = true;
          message-mode = "wrap";
          width = 90;
          line-height = 30;
          tabs = 4;
        };
        # stylix
        # colors = {
        #   background = "282a36fa";
        #   selection = "3d4474fa";
        #   border = "fffffffa";
        # };

        border = {
          radius = 20;
        };
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
