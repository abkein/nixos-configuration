let
  generic = {
    enable = true;
    executable = true;
    force = true;
  };
in
{
  open_vscode_workspaces = generic // {
    target = "./execs/open_vscode_workspaces";
    text = ''
      #!/usr/bin/env bash

      for file in $XDG_CONFIG_HOME/vscode_workspaces/*; do
        code --password-store=gnome-libsecret --ozone-platform=wayland $file
      done
    '';
  };
  keepassxc_ssh_prompt = generic // {
    target = "./execs/keepassxc_ssh_prompt";
    text = ''
      #!/usr/bin/env bash

      hostfile=$1
      port=$2

      until ssh-add -l &> /dev/null
      do
        echo "Waiting for agent. Please unlock the database."
        hyprctl notify 2 3000 0 "fontsize:35 Waiting for KeePassXC database unlock"
        keepassxc &> /dev/null
        sleep 1
      done

      host=$(cat "$hostfile" | tr -d '\n')

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
}
