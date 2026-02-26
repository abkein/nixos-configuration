{pkgs, python3Packages} :
  let
    ipython_8_37 = python3Packages.ipython.overridePythonAttrs (old: rec {
      version = "8.37.0";
      src = pkgs.fetchPypi {
        pname = "ipython";
        inherit version;
        sha256 = "sha256-yoFYQeGkGh5rc6CwjzA4r5siUlZNAfxAU1bTQDMBIhY=";
      };
    });
  in
  python3Packages.buildPythonPackage rec {
    pname = "crossrefapi";
    version = "1.7.0";
    format = "pyproject";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-WY8no8wb2NKXcN4oSwsTFcgg3h1wiUCElF1SZeb+La4=";
    };

    nativeBuildInputs = with python3Packages; [
      poetry-core
    ];

    propagatedBuildInputs = with python3Packages; [
      requests
      urllib3
      ipython_8_37
    ];

    pythonImportsCheck = [ "crossref" ];

    # nativeCheckInputs = with python3Packages; [ pytest ruff pkgs.pre-commit black ];
    # checkPhase = ''
    #   pytest
    # '';

    meta = with pkgs.lib; {
      description = "Library that implements the endpoints of the Crossref API";
      homepage = "https://github.com/fabiobatalha/crossrefapi";
      license = licenses.bsd2;
      maintainers = with maintainers; [ abkein ];
      broken = false;
    };
  }