#TODO: change shebangs with direct path to a system's bash executable

let
  generic = {
    enable = true;
    executable = true;
    force = true;
  };
in
{
  quicknotebook = generic // {
    target = "./execs/quicknotebook.sh";
    text = ''
      #!/usr/bin/env bash

      echo "Setting up environment..."
      if [[ ! -e $XDG_DATA_HOME/quicknotebook ]]; then
        mkdir $XDG_DATA_HOME/quicknotebook
      fi
      cd $XDG_DATA_HOME/quicknotebook
      echo "    Cleaning..."
      rm -rf *
      echo "    Writing..."
      echo 'use nix' > .envrc
      cp $XDG_CONFIG_HOME/python/pyshell.nix shell.nix
      cp $XDG_CONFIG_HOME/python/defreqs.txt requirements.txt
      cp $XDG_CONFIG_HOME/python/simple.ipynb quick.ipynb
      chmod 644 shell.nix
      chmod 644 requirements.txt
      chmod 644 quick.ipynb

      echo "Setting up nix-shell..."
      nix-shell ./shell.nix --command "exit"
    '';
  };
  keepassxc_ssh_prompt = generic // {
    target = "./execs/keepassxc_ssh_prompt";
    text = ''
      #!/usr/bin/env bash

      host=$1
      port=$2

      until ssh-add -l &> /dev/null
      do
        echo "Waiting for agent. Please unlock the database."
        hyprctl notify 2 3000 0 "fontsize:35 Waiting for KeePassXC database unlock"
        keepassxc &> /dev/null
        sleep 1
      done

      # host=$(cat "$hostfile" | tr -d '\n')

      nc "$host" "$port"
    '';
    # ''
    #   #!/usr/bin/env bash

    #   host=$1
    #   port=$2

    #   until ssh-add -l &> /dev/null
    #   do
    #     echo "Waiting for agent. Please unlock the database."
    #     hyprctl notify 2 3000 0 "fontsize:35 Waiting for KeePassXC database unlock"
    #     keepassxc &> /dev/null
    #     sleep 1
    #   done

    #   nc "$host" "$port"
    # ''
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
}
