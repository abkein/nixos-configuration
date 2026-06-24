{
  lib,
  fetchzip,
  buildPythonPackage,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  pandas,
  numpy,
  matplotlib,
}:
buildPythonPackage (finalAttrs: {
  pname = "lammps_logfile";
  version = "1.1.13";
  pyproject = true;

  #src = pkgs.fetchPypi {
  #  inherit pname version;
  #  sha256 = "sha256-KbffpWRjrpxQR/13ocg9hX2oDIuqAwst4/tAuZfY7DQ=";
  #};

  #src = pkgs.fetchFromGitHub {
  #  owner = "henriasv";
  #  repo = "lammps-logfile";
  #  rev = "v${version}";
  #  sha256 = "sha256-PgM4BAJsq4rTaLtx+CRYXOsGEPPm1VZ17UtauoV5S7U=";
  #};

  src = fetchzip {
    url = "https://files.pythonhosted.org/packages/78/32/ea84ead948ef9f5de29600343184f7e5ef1caaf9a53fa3cb7231b8be486a/lammps_logfile-1.1.3.tar.gz";
    hash = "sha256-HWHLaUXphPniFri3mJyV91ag9JZ7Khl8RBzbncL1ScA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pandas
    numpy
    matplotlib
  ];

  # nativeCheckInputs = with python3Packages; [ pytest pytest-xdist ruff python-dotenv ];
  # checkPhase = ''
  #   pytest
  # '';

  pythonImportsCheck = [ "lammps_logfile" ];

  meta = with lib; {
    description = "Tool to read a logfile produced by LAMMPS into a python data structure.";
    homepage = "https://github.com/henriasv/lammps-logfile";
    license = licenses.gpl3;
    maintainers = with maintainers; [ abkein ];
    broken = false;
  };
})
