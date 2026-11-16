{ pkgs, ... }: {
  tombi = {
    path = "${pkgs.tombi}/bin/tombi";
    args = [ "lsp" ];
    semanticTokens = {
      strings.enabled = false;
      comments.enabled = false;
    };
  };
}
