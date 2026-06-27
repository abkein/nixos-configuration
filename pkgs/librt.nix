{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  mypy-extensions,
  python,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "librt";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-y9z1EdrZRiDtT8cxz/Ex/f6B/RfjnAXdGf7tM+77HGg=";
  };

  # https://github.com/mypyc/librt/blob/v0.7.8/.github/workflows/buildwheels.yml#L90-L93
  postPatch = ''
    cp -rv lib-rt/* .
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    mypy-extensions
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} smoke_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "librt"
    "librt.internal"
  ];

  meta = with lib; {
    description = "Mypyc runtime library";
    homepage = "https://github.com/mypyc/librt";
    license = licenses.mit;
    maintainers = with maintainers; [ abkein ];
  };
})
