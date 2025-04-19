{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config }:

stdenv.mkDerivation rec {
  pname = "spacefm-thermitegod";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "thermitegod";
    repo = "spacefm";
    rev = "v${version}";
    sha256 = "sha256-L2WIDvrn1TfZicf6xnZdqgwx0OCvuHRD5h3henSh1jc=";
    fetchSubmodules = true; # Required for git submodules
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  mesonFlags = [ "--buildtype=release" ];

  meta = with lib; {
    description = "SpaceFM file manager";
    homepage = "https://github.com/thermitegod/spacefm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
