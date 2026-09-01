{ pkgs, ... }: {
  projectRootFile = "flake.nix";

  settings = {
    walk = "git"; # 'auto', 'git', 'jujutsu' or 'filesystem'
    verbose = 1;
    excludes = [
      "*.patch"
      "*.diff"
      "*.aml"
      ".gitattributes"
      ".gitignore"
    ];
  };

  programs = {
    nixfmt = {
      enable = true;
      strict = true;
    };

    jsonfmt.enable = true;

    nixf-diagnose = {
      enable = true;
      variableLookup = true;
      ignore = [ ];
    };
  };

  settings.formatter = {
    nixfmt.options = [ "--verify" ];

    nixf-diagnose = {
      # Ensure nixfmt cleans up after nixf-diagnose.
      priority = -1;
      excludes = [ ];
    };

    editorconfig-checker = {
      command = "${pkgs.lib.getExe pkgs.editorconfig-checker}";
      options = [ ];
      includes = [ "*" ];
      excludes = [ ];
      priority = 1;
    };
  };

}
