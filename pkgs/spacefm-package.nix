{
  lib
  , stdenv
  , fetchFromGitHub
  , meson
  , ninja
  , pkg-config
  , cmake
  , udev
  , botan3
  , libsigcxx30
  , pugixml
  , gtkmm3
  , gtkmm4
  , xfce
}:

stdenv.mkDerivation rec {
  pname = "spacefm-thermitegod";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "thermitegod";
    repo = "spacefm";
    rev = "40a7cc54e5429bd911a0dd134682962f6b03f2a6";
    sha256 = "sha256-pB+ox15dI9mcQWM/9WFmlYMOnSD9g3x9rCcXgw+aOls=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];

  buildInputs = [
    udev
    botan3
    libsigcxx30
    pugixml
    gtkmm3
    gtkmm4
    xfce.exo
    xfce.libxfce4util
  ];

  patchPhase = ''
    substituteInPlace meson.build \
      --replace "find_library('libbsd'" "find_library('bsd'"
    substituteInPlace meson.build \
      --replace "find_library('libudev'" "find_library('udev'"
    substituteInPlace meson.build \
      --replace "find_library('libffmpegthumbnailer'" "find_library('ffmpegthumbnailer'"
    substituteInPlace meson.build \
      --replace "find_library('libm'" "find_library('m'"
  '';

  NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types -Wno-int-conversion";

  mesonFlags = [
    "--buildtype=release"
    "--prefix=${placeholder "out"}"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    description = "SpaceFM file manager";
    homepage = "https://github.com/thermitegod/spacefm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

