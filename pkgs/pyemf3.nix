{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyemf3";
  version = "3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeremysanders";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-rIofdyT9XsWPViBbcNyLXxLBFMUeKxLE95axo8Ydvn8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pyemf3" ];

  meta = with lib; {
    description = "Pure Python Enhanced Metafile Library";
    homepage = "https://github.com/jeremysanders/pyemf3/";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abkein ];
  };
})
