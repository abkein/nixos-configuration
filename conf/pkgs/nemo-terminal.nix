{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, gettext
, gobjectIntrospection, glib, gtk3, vte, dconf, libxml2, libnotify }:

stdenv.mkDerivation rec {
  pname = "nemo-terminal";
  # you can pin this to a release tag (e.g. "master.mint20") or to a commit sha
  version = "master.mint20";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = version;
    # replace this with the actual hash you get from `nix-prefetch-url --unpack …`
    sha256 = "0xg4w8cxdrgcglkbhqv4nr82f0140dd37srhddvd0kxj8z1ylmf4";
  };

  nativeBuildInputs = [ meson ninja pkg-config gettext gobjectIntrospection ];

  buildInputs = [ glib gtk3 vte dconf libxml2 libnotify ];

  # Configure Meson to only build the nemo-terminal subdir and
  # install into Nemo’s extensions-4 folder. Adjust "extensions-4"
  # to match your Nemo version (e.g. extensions-5 for Nemo ≥5).
  buildPhase = ''
    meson setup \
      --prefix=${placeholder "out"} \
      --libdir=${placeholder "out"}/lib/nemo/extensions-4 \
      build nemo-terminal
    ninja -C build
  '';

  installPhase = ''
    ninja -C build install
  '';

  meta = with lib; {
    description = "Embedded terminal window for the Nemo file manager";
    homepage =
      "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-terminal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
