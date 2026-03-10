{...}:{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
    uwsm = {
      enable = true;
      # waylandCompositors = {

      # };
    };
  };
}