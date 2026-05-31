{ cfg, ... }:
{
  home = {
    username = cfg.username;
    homeDirectory = cfg.userhome;
    uid = cfg.uid;
    enableNixpkgsReleaseCheck = false;
    preferXdgDirectories = true;
    shell = {
      enableShellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
