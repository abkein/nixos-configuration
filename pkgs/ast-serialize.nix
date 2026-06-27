{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  pytestCheckHook,
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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-h+BklNeoQaRVWczsE9sFXgvFrnHW5vjWOVaOvLghv0U=";
  };

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [ "ast_serialize" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python bindings for mypy AST serialization.";
    homepage = "https://github.com/mypyc/ast_serialize";
    license = licenses.mit;
    maintainers = with maintainers; [ abkein ];
    broken = false;
  };
})
