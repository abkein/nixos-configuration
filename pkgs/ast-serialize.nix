{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  # setuptools,
  # setuptools-scm,
  maturin,

  # dependencies
  # pandas,
  # numpy,
  # matplotlib,
}:
buildPythonPackage (finalAttrs: {
  pname = "ast-serialize";
  version = "0.5.0";
  pyproject = true;

  #src = pkgs.fetchPypi {
  #  inherit pname version;
  #  sha256 = "sha256-KbffpWRjrpxQR/13ocg9hX2oDIuqAwst4/tAuZfY7DQ=";
  #};

  src = fetchFromGitHub {
   owner = "mypyc/";
   repo = "ast_serialize";
   rev = "v${finalAttrs.version}";
   sha256 = "sha256-GmhbMraI16J6ePtn7lXAWaJ+9zDH1GdebKIAzm5w9ok=";
  };

  # src = fetchzip {
  #   url = "https://files.pythonhosted.org/packages/78/32/ea84ead948ef9f5de29600343184f7e5ef1caaf9a53fa3cb7231b8be486a/lammps_logfile-1.1.3.tar.gz";
  #   hash = "sha256-HWHLaUXphPniFri3mJyV91ag9JZ7Khl8RBzbncL1ScA=";
  # };

  build-system = [
    maturin
    # setuptools
    # setuptools-scm
  ];

  # dependencies = [
  #   pandas
  #   numpy
  #   matplotlib
  # ];

  # nativeCheckInputs = with python3Packages; [ pytest pytest-xdist ruff python-dotenv ];
  # checkPhase = ''
  #   pytest
  # '';

  pythonImportsCheck = [ "ast_serialize" ];

  meta = with lib; {
    description = "Python bindings for mypy AST serialization.";
    homepage = "https://github.com/mypyc/ast_serialize";
    license = licenses.mit;
    maintainers = with maintainers; [ abkein ];
    # mainProgram = "lammps_logplotter";
    broken = false;
  };
})
