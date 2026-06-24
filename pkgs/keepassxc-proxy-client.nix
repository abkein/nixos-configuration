{
  fetchPypi,
  lib,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  pynacl,
}:
buildPythonPackage (finalAttrs: {
  pname = "keepassxc-proxy-client";
  version = "0.1.7";
  format = "pyproject";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-ZS8MAPOP2UfT7+UCrES4pZzI1MprYlYREPrYNagRB6A=";
  };

  build-system = [ setuptools ];

  dependencies = [ pynacl ];

  pythonImportsCheck = [ "keepassxc_proxy_client" ];

  meta = with lib; {
    description = "A CLI for keepassxc-proxy";
    homepage = "https://github.com/hargoniX/keepassxc-proxy-client";
    license = licenses.bsd0;
    maintainers = with maintainers; [ abkein ];
    broken = false;
  };
})
