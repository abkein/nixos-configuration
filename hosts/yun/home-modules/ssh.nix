{ config, ... }:
{
  programs.ssh = {
    enable = true;
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
      github = {
        HostName = "github.com";
        User = "git";
      };
    };
  };
}
