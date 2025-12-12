{ lib, config, pkgs, ... }@args:
let
  inherit (lib) mkOption types literalExpression mapAttrs mkMerge attrValues attrNames;
  cfg = config.better-code;
in
{
  options = {
    globalVars = {
      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = "Enable the globalVars configuration.";
      };

      teminal-emulator = mkOption {
        type        = types.package;
        default     = pkgs.kitty;
        description = "Preferred terminal emulator app.";
        example     = pkgs.konsole;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode.enable = true;
  }
}