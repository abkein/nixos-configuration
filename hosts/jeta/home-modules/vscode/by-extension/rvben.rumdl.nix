{ pkgs, ... }:
let
  rumdl = pkgs.symlinkJoin {
    name = "rumdl-wrapped";
    paths = [ pkgs.rumdl ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rumdl \
        --prefix PATH : ${
          pkgs.lib.makeBinPath (
            with pkgs;
            [
              shellcheck
              shfmt
              nixfmt
              yamllint
              ruff
              jq
              clang-tools
              tombi
            ]
          )
        }
    '';
    allowSubstitutes = false;
    meta.mainProgram = "rumdl";
  };
in
{
  rumdl = {
    fixOnSave = true;
    linkCompletions.enable = true;
    linkNavigation.enable = true;
    lint.run = "onType";
    server.path = "${rumdl}/bin/rumdl";
  };
}
