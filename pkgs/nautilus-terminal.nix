{ stdenv, lib, fetchFromGitHub, nautilus-python, python3Packages, pkg-config
, glib }:

python3Packages.buildPythonApplication rec {
  pname = "nautilus-terminal";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "flozz";
    repo = "nautilus-terminal";
    rev = "v${version}";
    sha256 = "sha256-sOt43RPES+5gEC7XGVzeQyyolrsJnJfjMydhKRZ5qtM=";
  };

  nativeBuildInputs = [ pkg-config glib ];

  propagatedBuildInputs =
    [ python3Packages.psutil python3Packages.dbus-python nautilus-python ];

  # upstream has no tests
  doCheck = false;

  # After installation, compile schemas and expose the Nautilus extension
  postInstall = ''
    # Compile GSettings schemas
    mkdir -p $out/share/glib-2.0/schemas
    cp -r nautilus_terminal/schemas/* $out/share/glib-2.0/schemas/
    glib-compile-schemas $out/share/glib-2.0/schemas

    # Install the Nautilus-Python extension loader
    mkdir -p $out/lib/nautilus-python/extensions
    cp $src/nautilus_terminal/nautilus_terminal_extension.py \
      $out/lib/nautilus-python/extensions/nautilus_terminal_extension.py
  '';

  meta = with lib; {
    description = "Embed a terminal in each Nautilus tab/window";
    homepage = "https://github.com/flozz/nautilus-terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yourMaintainerHandle ];
    platforms = platforms.linux;
  };
}
