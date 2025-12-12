{pkgs, python3Packages} :
  python3Packages.buildPythonPackage rec {
    pname = "keepassxc-proxy-client";
    version = "0.1.7";
    format = "pyproject";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-ZS8MAPOP2UfT7+UCrES4pZzI1MprYlYREPrYNagRB6A=";
    };

    nativeBuildInputs = with python3Packages; [
      setuptools
    ];

    propagatedBuildInputs = with python3Packages; [ pynacl ];

    pythonImportsCheck = [ "keepassxc_proxy_client" ];

    meta = with pkgs.lib; {
      description = "A CLI for keepassxc-proxy";
      homepage = "https://github.com/hargoniX/keepassxc-proxy-client";
      license = licenses.bsd0;
      maintainers = with maintainers; [ abkein ];
      broken = false;
    };
  }