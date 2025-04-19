{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, cmake, gtk2, xxHash
, libbsd, udev }:

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

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    # libbsd
  ];

  buildInputs = [
    gtk2
    xxHash
    libbsd
    udev
  ];

  # After fetchPhase, before configurePhase, patch the meson.build:
  patchPhase = ''
    substituteInPlace meson.build \
      --replace "find_library('libbsd'" "find_library('bsd'"
  '';

  # env = {
  #   LIBBSD_CFLAGS = "-I${libbsd.dev}/include";
  #   LIBBSD_LIBS = "-L${libbsd}/lib -lbsd";
  # };
  # shellHook = ''
  #   export LIBRARY_PATH=${libbsd}/lib:$LIBRARY_PATH
  #   export LD_LIBRARY_PATH=${libbsd}/lib:$LD_LIBRARY_PATH
  # '';

  mesonFlags = [ "--buildtype=release" ];

  meta = with lib; {
    description = "SpaceFM file manager";
    homepage = "https://github.com/thermitegod/spacefm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
