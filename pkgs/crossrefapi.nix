{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # dependencies
  requests,
  urllib3,
  ipython,

  # tests
  pytestCheckHook,

  # build-system
  poetry-core,
}:
buildPythonPackage (finalAttrs: {
  pname = "crossrefapi";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabiobatalha";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-yMw6EkeG59ub82yMoJ+o2/hZOAxF8vGLWStyiCE1k1o=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    urllib3
    ipython
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'ipython = "^8.28.0"' 'ipython = "^9.0.0"' \
      --replace-fail 'ipython = "^8.20.0"' 'ipython = "^9.0.0"'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  # These tests require network access
  disabledTests = [
    "test_integration.py"
    "test_restful.py"
  ];

  pythonImportsCheck = [ "crossref" ];

  meta = with lib; {
    description = "Library that implements the endpoints of the Crossref API";
    homepage = "https://github.com/fabiobatalha/crossrefapi";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abkein ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
