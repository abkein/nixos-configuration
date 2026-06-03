{ pkgs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = true;
    enableReleaseChecks = false;
    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };
    polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/katy.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/espresso.yaml";
    # VSCode dark modern
    # https://github.com/technosophos/vscode-base16
    # https://github.com/mk12/base16-modern-scheme
    base16Scheme = ./dark-modern.yaml;
    cursor = {
      # package = pkgs.vimix-cursors;
      # name = "Vimix-cursors";
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
    icons = {
      enable = true;
      # dark = "Adwaita";
      dark = "mint-x";
      light = null;
      # package = pkgs.adwaita-icon-theme;
      package = pkgs.mint-x-icons;
    };
    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 0.7;
      terminal = 1.0;
    };
    fonts =
      let
        # fts = {
        #   p = pkgs.dejavu_fonts;
        #   s = "DejaVu";
        # };
        fts = {
          p = pkgs.noto-fonts-lgc-plus;
          s = "Noto";
        };
      in
      {
        serif = {
          package = fts.p;
          name = "${fts.s} Serif";
        };
        sansSerif = {
          package = fts.p;
          name = "${fts.s} Sans";
        };
        monospace = {
          package = fts.p;
          name = "${fts.s} Sans Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 12;
          desktop = 10;
          popups = 10;
          terminal = 10;
        };
      };
  };
}
