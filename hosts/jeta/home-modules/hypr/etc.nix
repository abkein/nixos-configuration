{ config, pkgs, ... }:
{
  stylix.targets.ghostty.enable = false;
  programs = {
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      installBatSyntax = true;
      settings = {
        # font-size = 10; # stylix
        term = "xterm";
        clipboard-trim-trailing-spaces = true;
      };
    };
    fuzzel = {
      enable = true;
      settings = {
        main = {
          show-actions = true;
          terminal = "${pkgs.ghostty}/bin/ghostty";
          keyboard-focus = "on-demand"; # exclusive
          auto-select = true;
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
