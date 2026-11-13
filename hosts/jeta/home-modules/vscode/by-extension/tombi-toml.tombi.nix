{ pkgs, ... }: {
  tombi = {
    path = "${pkgs.tombi}/bin/tombi";
    args = [
      "lsp"
      "--no-cache"
    ];
    semanticTokens = {
      strings.enabled = false;
      comments.enabled = false;
    };
  };
}
