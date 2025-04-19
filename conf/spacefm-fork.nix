self: super: {
  spacefm = super.spacefm.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "thermitegod";
      repo = "spacefm";
      rev = "4f7240b7d111851157dff9febed332376b0f2f10"; # tag 2.1.0
      sha256 = "sha256-L2WIDvrn1TfZicf6xnZdqgwx0OCvuHRD5h3henSh1jc=";
    };
  });
}
