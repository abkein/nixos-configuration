{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # dependencies
  pyyaml,
  pygobject3,

  # tests
  pytestCheckHook,

  # build-system
  poetry-core
}:
buildPythonPackage (finalAttrs: {
  pname = "TLPUI";
  version = "1.10.1";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "d4nj1";
    repo = finalAttrs.pname;
    rev = "tlpui-${finalAttrs.version}";
    hash = "sha256-9lSE5t38GuoT+SqIqrH87zjKSjNgKiu3NfDdKflgUxw=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pygobject3
    pyyaml
  ];

  # postPatch = ''
  #   substituteInPlace pyproject.toml \
  #     --replace-fail 'ipython = "^8.28.0"' 'ipython = "^9.0.0"' \
  #     --replace-fail 'ipython = "^8.20.0"' 'ipython = "^9.0.0"'
  # '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = false;

  # These tests require network access
  disabledTests = [
    "test_integration.py"
    "test_restful.py"
  ];

  pythonImportsCheck = [ "tlp-ui" ];

  meta = with lib; {
    description = "GTK UI for tlp";
    homepage = "https://github.com/d4nj1/TLPUI";
    license = licenses.gpl2;
    mainProgram = "tlpui";
    maintainers = with maintainers; [ abkein ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
