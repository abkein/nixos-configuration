{ pkgs, ... }:
{
  stylix.targets.fuzzel.fonts.override = {
    sizes = {
      # applications = 14;
      # desktop = 14;
      popups = 14;
      # terminal = 14;
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
}
