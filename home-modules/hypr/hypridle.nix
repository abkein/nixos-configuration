{ ... }:
{
  services.hypridle = {
    enable = true;
    settings =
      let
        # FIXME: provide full path to binaries
        lock_cmd = "pidof hyprlock || hyprlock && hyprctl switchxkblayout at-translated-set-2-keyboard 0 && sleep 1 && grim /home/kein/Pictures/sc.png";
        suspend_cmd = ''if [[ $(cat /sys/class/power_supply/ACAD/online) == '1' && $(cat /sys/class/power_supply/ACAD/type) == 'Mains' ]]; then hyprctl notify 1 5000 0 'fontsize:35 Auto suspending is disabled due to connected power supply.'; else systemctl suspend || loginctl suspend; fi'';
        lower_bright = "brightnessctl --device='amdgpu_bl1' -s set 1";
        resume_bright = "brightnessctl --device='amdgpu_bl1' -r";
      in
      {
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
  };
}
