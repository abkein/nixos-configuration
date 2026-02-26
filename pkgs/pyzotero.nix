{pkgs, python3Packages} :
  python3Packages.buildPythonPackage rec {
    pname = "pyzotero";
    version = "1.6.11";
    format = "pyproject";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-l3P6k4+IrTFX2BJblBjpvY8nIzldDR8DT3QaQ+BzV3Q=";
    };

    nativeBuildInputs = with python3Packages; [
      setuptools
      setuptools-scm
    ];

    propagatedBuildInputs = with python3Packages; [
      feedparser
      pytz
      bibtexparser
      httpx
      httpretty
      python-dateutil
      ipython
      pytest-asyncio
      pytest-cov
    ];

    pythonImportsCheck = [ "pyzotero" ];

    nativeCheckInputs = with python3Packages; [ pytest ];
    checkPhase = ''
      pytest
    '';

    meta = with pkgs.lib; {
      description = "Python wrapper for the Zotero API";
      homepage = "https://github.com/urschrei/pyzotero";
      # Well, it actually BOML 1.0.0, but it isn't present int lib/licenses.nix, so it's the closest one.
      license = licenses.asl20;
      maintainers = with maintainers; [ abkein ];
      broken = false;
    };
  }