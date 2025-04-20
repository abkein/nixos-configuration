{
  lib
  , stdenv
  , fetchFromGitHub
  , meson
  , ninja
  , pkg-config
  , cmake
  # , gtk2
  # , xxHash
  # , libbsd
  , udev
  # , ffmpegthumbnailer
  , botan3
  , libsigcxx30
  , pugixml
  , gtkmm3
  , gtkmm4
# , desktop-file-utils
# , shared-mime-info
# , wrapGAppsHook3
# , jmtpfs
# , lsof
# , udisks2
}:

stdenv.mkDerivation rec {
  pname = "spacefm-thermitegod";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "thermitegod";
    repo = "spacefm";
    rev = "40a7cc54e5429bd911a0dd134682962f6b03f2a6";
    sha256 = "sha256-pB+ox15dI9mcQWM/9WFmlYMOnSD9g3x9rCcXgw+aOls=";
    fetchSubmodules = true; # Required for git submodules
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];

  buildInputs = [
    # gtk2
    # xxHash
    # libbsd
    udev
    # ffmpegthumbnailer
    botan3
    libsigcxx30
    pugixml
    gtkmm3
    gtkmm4

    # desktop-file-utils
    # shared-mime-info
    # wrapGAppsHook3
    # jmtpfs
    # lsof
    # udisks2
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

  # env = {
  #   LIBBSD_CFLAGS = "-I${libbsd.dev}/include";
  #   LIBBSD_LIBS = "-L${libbsd}/lib -lbsd";
  # };
  # shellHook = ''
  #   export LIBRARY_PATH=${libbsd}/lib:$LIBRARY_PATH
  #   export LD_LIBRARY_PATH=${libbsd}/lib:$LD_LIBRARY_PATH
  # '';
  NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types -Wno-int-conversion";

  postInstall = ''
    rm -f $out/etc/spacefm/spacefm.conf
    ln -s /etc/spacefm/spacefm.conf $out/etc/spacefm/spacefm.conf
  '';


  mesonFlags = [
    "--buildtype=release"
    "--prefix=${placeholder "out"}"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  # installPhase = ''
  #   ninja -C _build install
  # '';

  meta = with lib; {
    description = "SpaceFM file manager";
    homepage = "https://github.com/thermitegod/spacefm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

