{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, gettext
, gobject-introspection, glib, gtk3, vte, dconf, libxml2, libnotify }:

stdenv.mkDerivation rec {
  pname = "nemo-terminal";
  version = "master.mint20";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = version;
    sha256 = "0xg4w8cxdrgcglkbhqv4nr82f0140dd37srhddvd0kxj8z1ylmf4";
  };

  nativeBuildInputs = [ meson ninja pkg-config gettext gobject-introspection ];

  buildInputs = [ glib gtk3 vte dconf libxml2 libnotify ];

  # Only run the phases we define below.
  # Skip Nix’s built-in configurePhase / buildPhase / installPhase.
  phases = [
    "unpackPhase"
    "patchPhase"
    "updateAutotoolsGnuConfigScriptsPhase"
    "buildPhase"
    "installPhase"
  ];

  buildPhase = ''
    # create an out‑of‑source build directory
    mkdir build
    meson setup \
      build \
      ${src}/nemo-terminal \
      --prefix=$out \
      --libdir=lib/nemo/extensions-4 \
      --buildtype=plain \
      -Dauto_features=enabled \
      -Dwrap_mode=nodownload
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
    platforms = platforms.linux;
  };
}
