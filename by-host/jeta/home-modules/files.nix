#TODO: change shebangs with direct path to a system's bash executable
{ ...}:
let
  generic = {
    enable = true;
    executable = true;
    force = true;
  };
in
{
  home.file = {
    hyprlock-status = generic // {
      target = "./execs/hyprlock/status.sh";
      text = ''
        #!/usr/bin/env bash

        ############ Variables ############
        enable_battery=false
        battery_charging=false

        ####### Check availability ########
        for battery in /sys/class/power_supply/*BAT*; do
          if [[ -f "$battery/uevent" ]]; then
            enable_battery=true
            if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
              battery_charging=true
            fi
            break
          fi
        done

        ############# Output #############
        if [[ $enable_battery == true ]]; then
          if [[ $battery_charging == true ]]; then
            echo -n "(+) "
          fi
          echo -n "$(cat /sys/class/power_supply/*/capacity | head -1)"%
          if [[ $battery_charging == false ]]; then
            echo -n " remaining"
          fi
        fi

        echo \'\'
      '';
    };
    hyprlock-label = generic // {
      target = "./execs/hyprlock/label.sh";
      text = ''
        #!/usr/bin/env bash

        if [ "$1" -eq 0 ]; then
          echo ""
        else
          echo "There were failed attempts: $1"
          printf "\n"
          echo "Last fail reason: $2"
        fi
      '';
    };
    record-script = generic // {
      target = "./execs/record-script.sh";
      text = ''
        #!/usr/bin/env bash

        getdate() {
            date '+%Y-%m-%d_%H.%M.%S'
        }
        getaudiooutput() {
            pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2
        }
        getactivemonitor() {
            hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
        }

        mkdir -p "$(xdg-user-dir VIDEOS)"
        cd "$(xdg-user-dir VIDEOS)" || exit
        if pgrep wf-recorder > /dev/null; then
            notify-send "Recording Stopped" "Stopped" -a 'record-script.sh' &
            pkill wf-recorder &
        else
            notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'record-script.sh'
            if [[ "$1" == "--sound" ]]; then
                wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$(slurp)" --audio="$(getaudiooutput)" & disown
            elif [[ "$1" == "--fullscreen-sound" ]]; then
                wf-recorder -o $(getactivemonitor) --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --audio="$(getaudiooutput)" & disown
            elif [[ "$1" == "--fullscreen" ]]; then
                wf-recorder -o $(getactivemonitor) --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t & disown
            else
                wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$(slurp)" & disown
            fi
        fi
      '';
    };
  };
}
