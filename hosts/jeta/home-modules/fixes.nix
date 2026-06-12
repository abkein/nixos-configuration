{
  config,
  pkgs,
  cfg,
  ...
}:
{
  home = {
    # Wrong placement of icons
    packages =
      with pkgs;
      let
        vimixPkg = (pkgs.vimix-icon-theme.override { colorVariants = [ "standard" ]; });
      in
      [
        (runCommand "zoom-icon-fix" { } ''
          mkdir -p $out/share/icons/hicolor/256x256

          ln -s ${pkgs.zoom-us}/share/pixmaps \
            $out/share/icons/hicolor/256x256/apps
        '')
        (runCommand "gucharmap-icon-fix" { } ''
          mkdir -p $out/share/icons/hicolor/scalable/apps

          ln -s ${vimixPkg}/share/icons/Vimix/scalable/apps/accessories-character-map.svg \
            $out/share/icons/hicolor/scalable/apps/accessories-character-map.svg
        '')
        (runCommand "networkmanaerapplet-icon-fix" { } ''
          mkdir -p $out/share/icons/hicolor/scalable/apps

          ln -s ${vimixPkg}/share/icons/Vimix/scalable/preferences/preferences-system-network.svg \
            $out/share/icons/hicolor/scalable/apps/preferences-system-network.svg
        '')
      ];
    sessionVariables = {
      # "GLFW_IM_MODULE, ibus"
      # For apps to prevent spamming home directory with .trash
      SONARLINT_USER_HOME = "${config.xdg.dataHome}/sonarlint";
      DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      NPM_CONFIG_TMP = "${cfg.xdg.runtimeDir}/npm";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      ELECTRUMDIR = "${config.xdg.dataHome}/electrum";
      TEXMFCACHE = "${config.xdg.cacheHome}/texmf-var";
      TEXMFVAR = "${config.xdg.cacheHome}/texmf-var";
      TEXMFCONFIG = "${config.xdg.configHome}/texmf-config";
      TEXMFHOME = "${config.xdg.dataHome}/texmf";
    };
  };
}
