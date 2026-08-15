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
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorenham";
    repo = "optype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mtcGblOEyLfOmBwQCC+jX9wvpXiRJE/DNPfPMpcKEOI=";
  };

  # postPatch = ''
  #   substituteInPlace pyproject.toml \
  #     --replace-fail "uv_build>=0.9.16,<0.10.0" uv_build
  # '';

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
