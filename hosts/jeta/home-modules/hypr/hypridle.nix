{ ... }: {
  services.hypridle = {
    enable = true;
    settings =
      let
        # FIXME: provide full path to binaries
        lock_cmd = "hyprctl switchxkblayout at-translated-set-2-keyboard 0 && (pidof hyprlock || hyprlock)";
        # suspend_condition = pkgs.writeShellScript "hypridle-suspend-condition.sh" ''
        #   if [[ $(cat /sys/class/power_supply/ACAD/online) == '1' && $(cat /sys/class/power_supply/ACAD/type) == 'Mains' ]]; then
        #     hyprctl notify 1 5000 0 'fontsize:35 Auto suspending is disabled due to connected power supply.'
        #     exit 1
        #   else
        #     exit 0
        #   fi
        # '';
        lower_bright = "brightnessctl --device='amdgpu_bl1' -s set 1";
        resume_bright = "brightnessctl --device='amdgpu_bl1' -r";
      in
      {
        general = {
          lock_cmd = lock_cmd;
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = ''
            hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
          '';
          inhibit_sleep = 3;
        };
        listener = [
          {
            timeout = 120; # 2m
            on-timeout = lower_bright;
            on-resume = resume_bright;
          }
          {
            timeout = 240; # 4m
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 300; # 5m
            on-timeout = ''
              hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
            '';
            on-resume = ''
              hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' && brightnessctl -r
            '';
          }
          {
            timeout = 3600; # 1h
            on-timeout = "systemctl suspend";
            # condition_cmd = "${suspend_condition}";
            # condition_retry = 600;
          }
        ];
      };
  };
}
