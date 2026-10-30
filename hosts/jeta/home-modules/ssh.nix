{
  config,
  pkgs,
  lib,
  ...
}:
let
  ssh-creds = import ../shadow/ssh-creds.nix;
  keepassxc_ssh_prompt = pkgs.writeShellScript "keepassxc_ssh_prompt.sh" ''
    set -euo pipefail

    host=$1
    port=$2
    shift
    shift

    until ${config.programs.ssh.package}/bin/ssh-add -l &> /dev/null
    do
      echo "Waiting for agent. Please unlock the database."
      ${pkgs.libnotify}/bin/notify-send --app-name="KeepassXC_SSH_prompt" "SSH: No keys were found" "Waiting for KeePassXC database unlock"
      ${config.programs.keepassxc.package}/bin/keepassxc &> /dev/null
      sleep 1
    done

    ${pkgs.netcat}/bin/nc "$@" "$host" "$port"
  '';
  mkProxyCommand =
    args:
    lib.escapeShellArgs (
      [
        "${keepassxc_ssh_prompt}"
        "%h"
        "%p"
      ]
      ++ args
    );
  genericProxyCommand = mkProxyCommand [ ];
  mkAddress =
    {
      host,
      port ? null,
    }:
    host + (lib.optionalString (port != null) ":${toString port}");
  mkProxyCommandWProxy =
    {
      protocol ? null,
      host,
      port ? null,
    }:
    mkProxyCommand (
      (lib.optionals (protocol != null) [
        "-X"
        (toString protocol)
      ])
      ++ [
        "-x"
        (mkAddress { inherit host port; })
      ]
    );
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
        LocalCommand = lib.escapeShellArgs [
          "${pkgs.libnotify}/bin/notify-send"
          "-a"
          "SSH"
          "New session"
          "%r@%n:%p\\nHostname: %h\\nAlias: %k"
        ];
        #  "${pkgs.libnotify}/bin/notify-send -a SSH 'New session' '%r@%n:%p\\nHostname: %h\\nAlias: %k'";
        PermitLocalCommand = "yes";
        ProxyCommand = genericProxyCommand;
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
      freedesktop = {
        header = "Host freedesktop gitlab.freedesktop ssh.gitlab.freedesktop.org";
        HostName = "ssh.gitlab.freedesktop.org";
        User = "git";
        ProxyCommand = mkProxyCommandWProxy {
          protocol = 5;
          host = "127.0.0.1";
          port = 1080;
        };
      };
    };
  };
}
