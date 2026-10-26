{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  typing-extensions,
  numpy,
  numpy-typing-compat,
  beartype,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "optype";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorenham";
    repo = "optype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5o7z8gBsFcLEyTPicJdxAiBVS2lS7BqavNzFJ6ApZ7w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "uv_build>=0.12.22,<0.13" "uv_build>=0.12.4"
  '';

  doCheck = false;

  build-system = [ uv-build ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    numpy = [
      numpy
      numpy-typing-compat
    ];
  };

  pythonImportsCheck = [ "optype" ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    numpy-typing-compat
    beartype
  ];

  disabledTests = [ "test_any_timedelta64_array" ];

  meta = {
    description = "Opinionated typing package for precise type hints in Python";
    homepage = "https://github.com/jorenham/optype";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jolars ];
  };
})
