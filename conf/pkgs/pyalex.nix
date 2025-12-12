{pkgs, python3Packages} :
  python3Packages.buildPythonPackage rec {
    pname = "pyalex";
    version = "0.18";
    format = "pyproject";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-tx324OEEEBeDpk7LK0GyTHUFnuRWOqWWZJlFQWi+5ec=";
    };

    nativeBuildInputs = with python3Packages; [
      setuptools
      setuptools-scm
    ];

    propagatedBuildInputs = with python3Packages; [
      requests
      urllib3
      pysocks
    ];

    pythonImportsCheck = [ "pyalex" ];

    # nativeCheckInputs = with python3Packages; [ pytest pytest-xdist ruff python-dotenv ];
    # checkPhase = ''
    #   pytest
    # '';

    meta = with pkgs.lib; {
      description = "Python interface to the OpenAlex database";
      homepage = "https://github.com/J535D165/pyalex";
      license = licenses.mit;
      maintainers = with maintainers; [ abkein ];
      broken = false;
    };
  }