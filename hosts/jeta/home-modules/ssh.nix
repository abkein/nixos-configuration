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
  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/.ssh 0700 ${config.home.username} users - -"
  ];
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "confirm";
        Compression = "no";
        ConnectionAttempts = 4;
        ControlMaster = "no";
        ControlPath = "${config.home.homeDirectory}/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
        EnableSSHKeysign = "yes";
        HashKnownHosts = "no";
        LocalCommand = "${pkgs.libnotify}/bin/notify-send -a SSH 'New session' '%r@%n:%p\\nHostname: %h\\nAlias: %k'";
        PermitLocalCommand = "yes";
        ProxyCommand = "${keepassxc_ssh_prompt} %h %p";
        ServerAliveCountMax = 3;
        ServerAliveInterval = 3;
        StrictHostKeyChecking = "accept-new";
        UpdateHostKeys = "yes";
        UserKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
        VisualHostKey = "yes";
      };
      fisher = with ssh-creds.fisher; {
        header = "Host fisher ${host}";
        HostName = host;
        User = user;
        WarnWeakCrypto = "no-pq-kex";
      };
      yun = with ssh-creds.yun; {
        header = "Host yun ${host}";
        HostName = host;
        User = user;
      };
      yun6 = with ssh-creds.yun6; {
        header = "Host yun6 ${host}";
        HostName = host;
        User = user;
        AddressFamily = "inet6";
      };
      github = {
        header = "Host github github.com";
        HostName = "github.com";
        User = "git";
      };
    };
  };
}
