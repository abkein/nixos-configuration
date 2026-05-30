self: super: {
  spacefm = super.spaceFM.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "thermitegod";
      repo = "spacefm";
      rev = "v2.1.0";
      sha256 = "sha256-L2WIDvrn1TfZicf6xnZdqgwx0OCvuHRD5h3henSh1jc=";
    };
    patches = [];
    # patches = [
    #   # fix compilation error due to missing include
    #   ./confs/glibc-fix.patch
    #   # (super.fetchpatch {
    #   #   url =
    #   #     "https://raw.githubusercontent.com/NixOS/nixpkgs/${super.lib.version}/pkgs/applications/file-managers/spacefm/glibc-fix.patch";
    #   #   sha256 = "1s2q6qpz8sqwq9vqasx8l5pz6vdfmiw8qg63rffw3r9wgdj0mh3y";
    #   # })

    #   # restrict GDK backends to only X11
    #   # ./x11-only.patch

    #   # gcc-14 build fix from:
    #   #   https://github.com/IgnorantGuru/spacefm/pull/816
    #   (super.fetchpatch {
    #     name = "gcc-14.patch";
    #     url =
    #       "https://github.com/IgnorantGuru/spacefm/commit/98efb1f43e6339b3ceddb9f65ee85e26790fefdf.patch";
    #     hash = "sha256-dau1AMnSBsp8iDrjoo0WTnFQ13vNZW2kM4qz0B/beDI=";
    #   })
    # ];
  });
}
