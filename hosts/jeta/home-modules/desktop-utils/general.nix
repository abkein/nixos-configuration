{ pkgs, ... }: {
  services = {
    cliphist = {
      enable = true;
      allowImages = true;
    };
  };

  home.packages = with pkgs; [
    wlr-randr
    ydotool
    wl-clipboard
    wev

    xdg-utils
    xdg-user-dirs
    xdg-launch
    xdg-terminal-exec
    xdg-ninja

    slurp
    grim
    grimblast
  ];

  programs = {
    swayimg = {
      enable = true;
      # settings = {}; # https://github.com/artemsen/swayimg/blob/master/extra/swayimgrc
    };
    wayprompt = {
      enable = true;
      # settings = {}; # `man 5 wayprompt`
    };
  };
}
