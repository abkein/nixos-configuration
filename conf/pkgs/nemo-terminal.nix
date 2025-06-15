{ lib, python3Packages, fetchFromGitHub, vte, gtk3, nemo-python, dconf
, pkg-config, gettext, gobject-introspection }:

python3Packages.buildPythonPackage rec {
  pname = "nemo-terminal";
  version = "master.mint20";

  # Fetch the whole nemo-extensions repo, then we'll only unpack the nemo-terminal subdir
  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = version;
    # replace this with the real sha256 from `nix-prefetch-git`:
    sha256 = "0xg4w8cxdrgcglkbhqv4nr82f0140dd37srhddvd0kxj8z1ylmf4";
  };

  # Only unpack the nemo-terminal subdirectory
  unpackPhase = ''
    mkdir -p $name
    cp -r ${src}/nemo-terminal/* $name
  '';

  # buildPythonPackage will pick up setup.py automatically
  propagatedBuildInputs = [ vte gtk3 nemo-python dconf gettext ];

  nativeBuildInputs = [ pkg-config gobject-introspection ];

  # After the normal Python install, we need to compile the GSettings schema
  postInstall = ''
    # install() has already put the .gschema.xml into $out/share/glib-2.0/schemas
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "Embedded terminal window for the Nemo file manager";
    homepage =
      "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-terminal";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
