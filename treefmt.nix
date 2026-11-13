{ pkgs, ... }:
let
  llvm = pkgs.llvmPackages_22;
in
{
  projectRootFile = "flake.nix";

  settings = {
    walk = "git"; # 'auto', 'git', 'jujutsu' or 'filesystem'
    verbose = 1;
    enableDefaultExcludes = true;
    excludes = [
      "*.diff"
      "*.aml"
      "**/shadow/*"
    ];
  };

  programs =
    let
      clang-tools = llvm.clang-tools;
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
      nixfmt = {
        enable = true;
        strict = true;
        indent = 2;
      };

      jq = {
        enable = true;
        indentWidth = 2;
      };

      clang-format = {
        enable = true;
        package = clang-tools;
        includes = [
          "*.cxx"
          "*.cpp"
          "*.hpp"
          "*.h"
        ];
      };

      dos2unix.enable = true;

      rumdl-check = {
        enable = true;
        package = rumdl;
        includes = [
          "*.md"
          "*.mdx"
        ];
      };

      yamllint = {
        enable = true;
        includes = [
          "*.yaml"
          "*.yml"
          ".clang-format"
          ".clang-tidy"
        ];
        excludes = [ "resources/themes/*" ];
      };

      nixf-diagnose = {
        enable = true;
        variableLookup = true;
        # Ensure nixfmt cleans up after nixf-diagnose.
        priority = -1;
      };

      shfmt = {
        enable = true;
        indent_size = 2;
        simplify = true;
      };

      shellcheck = {
        enable = true;
        external-sources = true;
        extra-checks = [ "all" ];
      };
    };

  settings.formatter = {
    nixfmt.options = [ "--verify" ];

    yamllint.options = [ "--strict" ];

    rumdl-check.options = [
      "--quiet"
      "--color"
      "always"
      "--config"
      ".rumdl.toml"
    ];

    tombi-fmt = {
      command = "${pkgs.tombi}/bin/tombi";
      options = [
        "format"
        "--diagnostics-format"
        "pretty"
      ];
      includes = [ "*.toml" ];
    };

    tombi-lint = {
      command = "${pkgs.tombi}/bin/tombi";
      options = [
        "lint"
        "--diagnostics-format"
        "pretty"
      ];
      includes = [ "*.toml" ];
    };

    editorconfig-checker = {
      command = "${pkgs.editorconfig-checker}/bin/editorconfig-checker";
      options = [ "-fix" ];
      includes = [ "*" ];
      priority = 1;
    };
  };
}
