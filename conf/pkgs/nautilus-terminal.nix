{ stdenv, fetchFromGitHub, python3Packages, pkg-config }:

python3Packages.buildPythonApplication rec {
  pname = "nautilus-terminal";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "flozz";
    repo = "nautilus-terminal";
    rev = "v${version}";
    # Use 'nix-prefetch-github flozz nautilus-terminal v4.1.0' to fill this sha256
    sha256 = "sha256-sOt43RPES+5gEC7XGVzeQyyolrsJnJfjMydhKRZ5qtM=";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = with python3Packages; [
    psutil
    nautilus-python
    dbus-python
  ];

  # No tests provided upstream
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Embed a terminal in each Nautilus tab/window";
    homepage = "https://github.com/flozz/nautilus-terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yourMaintainerHandle ];
    platforms = platforms.linux;
  };
}
