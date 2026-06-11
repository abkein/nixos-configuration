{ pkgs, ... }:
# See dunst(5) for all configuration options
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";
        width = 300;
        height = "(0, 300)";
        origin = "top-right";
        offset = "(10, 50)";
        gap_size = 3;

        progress_bar = true;
        progress_bar_height = 20;
        progress_bar_frame_width = 5;
        progress_bar_min_width = 50;
        progress_bar_max_width = 300;

        frame_width = 3;
        # frame_color = "#aaaaaa";

        idle_threshold = 120;
        show_age_threshold = 10;
        show_indicators = true;

        format = "<b>%a: %s</b>\\n%b";
        markup = "full";
        ellipsize = "end";

        enable_recursive_icon_lookup = true;

        sticky_history = "yes";
        history_length = 20;

        dmenu = "${pkgs.fuzzel}/bin/fuzzel --dmenu -p 'dunst: '";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";

        mouse_left_click = "context";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_current";
      };

      experimental = {
        pause_on_mouse_over = true;
      };

      urgency_low = {
        timeout = 10;
        default_icon = "dialog-information";
      };

      urgency_normal = {
        timeout = 10;
        default_icon = "dialog-information";
      };

      urgency_critical = {
        timeout = 0;
        default_icon = "dialog-warning";
      };
    };
  };
}
