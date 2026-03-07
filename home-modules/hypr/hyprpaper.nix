{ cfg, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "${cfg.userhome}/Pictures/Wallpapers/rocket_copy.png";
        }
        {
          monitor = "DP-6";
          path = "${cfg.userhome}/Pictures/Wallpapers/sr-71-black-side_copy.jpg";
        }
        {
          monitor = "DP-9";
          path = "${cfg.userhome}/Pictures/Wallpapers/sr-71-red_copy.png";
        }
      ];
    };
  };
}
