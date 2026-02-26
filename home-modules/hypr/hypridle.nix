{
  enable = true;
  settings =
  let
    # BUG: no brightnessctl installed
    # BUG: provide full path to binaries
    lock_cmd =
      "pidof hyprlock || hyprlock && hyprctl switchxkblayout at-translated-set-2-keyboard 0 && sleep 1 && grim /home/kein/Pictures/sc.png";
    suspend_cmd = "systemctl suspend || loginctl suspend";
    lower_bright = "brightnessctl --device='amdgpu_bl1' -s set 1";
    resume_bright = "brightnessctl --device='amdgpu_bl1' -r";
  in {
    general = {
      lock_cmd = lock_cmd;
      before_sleep_cmd = lock_cmd;
    };
    listener = [
      {
        timeout = 30;
        on-timeout = lower_bright;
        on-resume = resume_bright;
      }
      {
        timeout = 120;
        on-timeout = lock_cmd;
      }
      {
        timeout = 180;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 1800;
        on-timeout = suspend_cmd;
      }
    ];
  };
}
