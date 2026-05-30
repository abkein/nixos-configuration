{
  cfg,
  ...
}:
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
          monitor = "desc:Acer Technologies SA240Y 0x0480DAE1";  # DP-6
          path = "${cfg.userhome}/Pictures/Wallpapers/sr-71-black-side_copy.jpg";
        }
        {
          monitor = "desc:Xiaomi Corporation Mi monitor 5323110031874";  # DP-9
          path = "${cfg.userhome}/Pictures/Wallpapers/sr-71-red_copy.png";
        }
      ];
    };
  };
}
