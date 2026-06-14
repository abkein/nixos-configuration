{ pkgs, ... }: {
  projectRootFile = "flake.nix";

  settings = {
    walk = "git"; # 'auto', 'git', 'jujutsu' or 'filesystem'
    # fail-on-change = true;
    # formatters = ["go" "toml" "haskell"];
    verbose = 1;
  };

  programs = {
    nixfmt = {
      enable = true;
      strict = true;
    };
  };

  settings.formatter = {
    nixfmt = {
      options = [ "--verify" ];
    };
  };

  programs.nixf-diagnose = {
    enable = true;
    variableLookup = true;
    ignore = [
      # Rule names can currently be looked up here:
      # https://github.com/nix-community/nixd/blob/main/libnixf/src/Basic/diagnostic.py
      # Keep this rule, because we have `lib.or`.
      "or-identifier"
      # TODO: remove after outstanding prelude diagnostics issues are fixed:
      # https://github.com/nix-community/nixd/issues/761
      # https://github.com/nix-community/nixd/issues/762
      "sema-primop-removed-prefix"
      "sema-primop-overridden"
      "sema-constant-overridden"
      "sema-primop-unknown"
    ];
  };
  settings.formatter.nixf-diagnose = {
    # Ensure nixfmt cleans up after nixf-diagnose.
    priority = -1;
    excludes = [ ];
  };

  settings.formatter.editorconfig-checker = {
    command = "${pkgs.lib.getExe pkgs.editorconfig-checker}";
    options = [ ];
    # includes = [ "*.nix" "*.md" "*.toml" ];
    includes = [ "*" ];
    excludes = [
      "*.aml"
      "*.diff"
      "**/Makefile"
    ];
    priority = 1;
  };
}
