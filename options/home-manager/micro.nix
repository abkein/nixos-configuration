{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.micro;

  jsonFormat = pkgs.formats.json { };
in
{
  meta.maintainers = [ lib.hm.maintainers.mforster ];

  options = {
    programs.micro = {
      keybindings = lib.mkOption {
        inherit (jsonFormat) type;
        default = { };
        example = {
          "Ctrl-y" = "Undo";
          "Ctrl-z" = "Redo";
          "Alt-s" = "Save,Quit";
        };
        description = ''
          Configuration written to
          {file}`$XDG_CONFIG_HOME/micro/bindings.json`. See
          <https://github.com/zyedidia/micro/blob/master/runtime/help/keybindings.md>
          for supported values.
        '';
      };
      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          List of plugins to install.
          Full list of plugins can be found at
          <https://github.com/micro-editor/plugin-channel#plugins>
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "micro/bindings.json".source = jsonFormat.generate "micro-keybindings" cfg.keybindings;
    }
    // (lib.listToAttrs (
      map (
        plugin-pkg: lib.nameValuePair "micro/plug/${plugin-pkg.pname}" { source = plugin-pkg; }
      ) cfg.plugins
    ));

  };
}
