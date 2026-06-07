{ pkgs, ... }:
{
  stylix.targets.fuzzel = {
    # icons.enable = false;
    fonts.override = {
      sizes = {
        # applications = 14;
        # desktop = 14;
        popups = 14;
        # terminal = 14;
      };
    };
  };
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        placeholder = "Search applications...";
        message-mode = "wrap";
        match-counter = true;
        show-actions = true;
        terminal = "${pkgs.ghostty}/bin/ghostty -e {cmd}";
        width = 90;
        tabs = 4;
        line-height = 30;
        keyboard-focus = "on-demand"; # exclusive
      };

      dmenu = {
        mode = "index";
        exit-immediately-if-empty = true;
      };

      border = {
        radius = 20;
      };
    };
  };
}
