{ config, pkgs, ... }:
let
  ssh-creds = import ../shadow/ssh-creds.nix;
  keepassxc_ssh_prompt = pkgs.writeShellScript "keepassxc_ssh_prompt.sh" ''
    host=$1
    port=$2

    until ${config.programs.ssh.package}/bin/ssh-add -l &> /dev/null
    do
      echo "Waiting for agent. Please unlock the database."
      ${pkgs.libnotify}/bin/notify-send --app-name="KeepassXC_SSH_prompt" "SSH: No keys were found" "Waiting for KeePassXC database unlock"
      ${config.programs.keepassxc.package}/bin/keepassxc &> /dev/null
      sleep 1
    done

    ${pkgs.netcat}/bin/nc "$host" "$port"
  '';
in
{
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    extraConfig = "WarnWeakCrypto = no-pq-kex";
    enableDefaultConfig = false;
    settings = {
      "*" = {
        # ForwardAgent = false;
        AddKeysToAgent = "confirm";
        Compression = false;
        ConnectionAttempts = 4;
        # EnableSSHKeysign = "yes";
        ServerAliveInterval = 3;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
        ControlMaster = "ask";
        ControlPath = "${config.home.homeDirectory}/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
      fisher = with ssh-creds.fisher; {
        HostName = host;
        User = user;
        Port = 22;
        ProxyCommand = "${keepassxc_ssh_prompt} %h %p";
      };
      yun = with ssh-creds.yun; {
        HostName = host;
        User = user;
        Port = 22;
        ProxyCommand = "${keepassxc_ssh_prompt} %h %p";
      };
      github = {
        HostName = "github.com";
        User = "git";
        # identitiesOnly = true;
        # identityFile = "/home/kein/nixos-configuration/secrets/keys/github_yubikey.pub";
      };
    };
  };
}
