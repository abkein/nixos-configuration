self: super: {
  spacefm = super.spaceFM.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "thermitegod";
      repo = "spacefm";
      rev = "4f7240b7d111851157dff9febed332376b0f2f10"; # tag 2.1.0
      sha256 = "sha256-L2WIDvrn1TfZicf6xnZdqgwx0OCvuHRD5h3henSh1jc=";
    };
    patches = [
      # fix compilation error due to missing include
      ./glibc-fix.patch

      # restrict GDK backends to only X11
      # ./x11-only.patch

      # gcc-14 build fix from:
      #   https://github.com/IgnorantGuru/spacefm/pull/816
      (fetchpatch {
        name = "gcc-14.patch";
        url =
          "https://github.com/IgnorantGuru/spacefm/commit/98efb1f43e6339b3ceddb9f65ee85e26790fefdf.patch";
        hash = "sha256-dau1AMnSBsp8iDrjoo0WTnFQ13vNZW2kM4qz0B/beDI=";
      })
    ];
  });
}
