{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  requests,
  urllib3,
  pysocks,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyalex";
  version = "0.18";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-tx324OEEEBeDpk7LK0GyTHUFnuRWOqWWZJlFQWi+5ec=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    requests
    urllib3
    pysocks
  ];

  pythonImportsCheck = [ "pyalex" ];

  # nativeCheckInputs = with python3Packages; [ pytest pytest-xdist ruff python-dotenv ];
  # checkPhase = ''
  #   pytest
  # '';

  meta = with lib; {
    description = "Python interface to the OpenAlex database";
    homepage = "https://github.com/J535D165/pyalex";
    license = licenses.mit;
    maintainers = with maintainers; [ abkein ];
    broken = false;
  };
})
