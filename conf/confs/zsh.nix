config: {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = let flakeDir = "~/nixos-configuration/conf"; in {
      rb = "sudo nixos-rebuild switch --flake ${flakeDir}";
      upd = "nix flake update --flake ${flakeDir}";
      upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";

      dg = "sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system";
      cg = "sudo nix-collect-garbage -d";
      os = "sudo nix-store --optimise";
      destroy = "dg && cg && os";
    };

    history.size = 10000;
    # history.path = "${config.xdg.dataHome}/zsh/history";

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "agnoster"; # blinks is also really nice
    };
}
