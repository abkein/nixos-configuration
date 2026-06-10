{ pkgs, cfg, ... }:
{
  users.users.${cfg.username} = {
    home = cfg.userhome;
    uid = cfg.uid;
    isNormalUser = true;
    description = "Ab Kein";
    createHome = true;
    extraGroups = [
      "wheel"
      "input"
    ];
    # packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
}
