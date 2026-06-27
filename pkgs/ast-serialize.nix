{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  # setuptools,
  # setuptools-scm,
  maturin,
}:
buildPythonPackage (finalAttrs: {
  pname = "ast-serialize";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
   owner = "mypyc";
   repo = "ast_serialize";
   rev = "v${finalAttrs.version}";
   sha256 = "sha256-GmhbMraI16J6ePtn7lXAWaJ+9zDH1GdebKIAzm5w9ok=";
  };

  build-system = [
    maturin
    # setuptools
    # setuptools-scm
  ];

  # dependencies = [
  # ];

  pythonImportsCheck = [ "ast_serialize" ];

  meta = with lib; {
    description = "Python bindings for mypy AST serialization.";
    homepage = "https://github.com/mypyc/ast_serialize";
    license = licenses.mit;
    maintainers = with maintainers; [ abkein ];
    broken = false;
  };
})
