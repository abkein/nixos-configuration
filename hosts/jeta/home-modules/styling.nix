{ config, ... }:
{
  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
  };

  qt.enable = true;

  home = {
    pointerCursor = {
      enable = true;
      dotIcons.enable = true;
      gtk = {
        enable = true;
        # size = config.home.pointerCursor.size;
      };
      hyprcursor = {
        enable = true;
        # size = config.home.pointerCursor.size;
      };
      # package = cursor.pkg; # stylix
      # name = cursor.theme; # stylix
      # size = cursor.size; # stylix
    };
  };
}
