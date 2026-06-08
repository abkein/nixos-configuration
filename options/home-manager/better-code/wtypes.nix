{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types literalExpression;
  jsonFormat = pkgs.formats.json { };
in
{
  userSettings = mkOption {
    type = types.json;
    default = { };
    example = literalExpression ''
      {
        "files.autoSave" = "off";
        "[nix]"."editor.tabSize" = 2;
      }
    '';
    description = ''
      Configuration written to Visual Studio Code's
      {file}`settings.json`.
      This can be a JSON object or a path to a custom JSON file.
    '';
  };

  userTasks = mkOption {
    type = types.json;
    default = { };
    example = literalExpression ''
      {
        version = "2.0.0";
        tasks = [
          {
            type = "shell";
            label = "Hello task";
            command = "hello";
          }
        ];
      }
    '';
    description = ''
      Configuration written to Visual Studio Code's
      {file}`tasks.json`.
      This can be a JSON object or a path to a custom JSON file.
    '';
  };

  keybindings = mkOption {
    default = [ ];
    description = ''
      Keybindings written to Visual Studio Code's
      {file}`keybindings.json`.
      This can be a JSON object or a path to a custom JSON file.
    '';
    type = types.listOf (
      types.submodule {
        options = {
          key = mkOption {
            type = types.str;
            example = "ctrl+c";
            description = "The key or key-combination to bind.";
          };

          command = mkOption {
            type = types.str;
            example = "editor.action.clipboardCopyAction";
            description = "The VS Code command to execute.";
          };

          when = mkOption {
            type = types.nullOr (types.str);
            default = null;
            example = "textInputFocus";
            description = "Optional context filter.";
          };

          # https://code.visualstudio.com/docs/getstarted/keybindings#_command-arguments
          args = mkOption {
            type = types.nullOr types.json;
            default = null;
            example = {
              direction = "up";
            };
            description = "Optional arguments for a command.";
          };
        };
      }
    );
    example = literalExpression ''
      [
        {
          key = "ctrl+c";
          command = "editor.action.clipboardCopyAction";
          when = "textInputFocus";
        }
      ]
    '';
  };

  extensions = mkOption {
    type = types.listOf (
      types.either types.str (
        types.either types.package (types.listOf (types.either types.str types.package))
      )
    );
    default = [ ];
    example = literalExpression ''
      [
        "bbenoist.nix"
        "arrterian.nix-env-selector"
        (pkgs.nix4vscode.forOpenVsx [ "foo.bar" "bar.baz" ])
      ]
    '';
    description = ''
      The extensions Visual Studio Code should be started with.
      String extension ids or raw derivations. Allows 1 level of nested lists.
    '';
  };

  languageSnippets = mkOption {
    type = types.json;
    default = { };
    example = {
      haskell = {
        fixme = {
          prefix = [ "fixme" ];
          body = [ "$LINE_COMMENT FIXME: $0" ];
          description = "Insert a FIXME remark";
        };
      };
    };
    description = "Defines user snippets for different languages.";
  };

  globalSnippets = mkOption {
    type = types.json;
    default = { };
    example = {
      fixme = {
        prefix = [ "fixme" ];
        body = [ "$LINE_COMMENT FIXME: $0" ];
        description = "Insert a FIXME remark";
      };
    };
    description = "Defines global user snippets.";
  };

  enableMcpIntegration = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether to integrate the MCP servers config from
      `programs.mcp.servers` into
      `profiles.<name>.userMcp`.

      Note: Settings defined in `programs.mcp.servers` are merged
      with `profiles.<name>.userMcp`, with profile
      settings taking precedence.
    '';
  };

  userMcp = mkOption {
    type = jsonFormat.type;
    default = { };
    example = lib.literalExpression ''
      {
        "servers": {
          "Github": {
            "url": "https://api.githubcopilot.com/mcp/"
          }
        }
      }
    '';
    description = "Configuration written to `mcp.json`.";
  };
}
