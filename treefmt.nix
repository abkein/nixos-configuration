{ ... }:
{
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
}
