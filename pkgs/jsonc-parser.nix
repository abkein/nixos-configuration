{pkgs, python3Packages} :
  python3Packages.buildPythonPackage rec {
    pname = "jsonc-parser";
    version = "1.1.5";
    format = "pyproject";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-cSbRdyWwQTzUCvQpfZ9kEsQYGmITXkxBzfj2qCxZNuY=";
    };

    nativeBuildInputs = with python3Packages; [
      setuptools
    ];

    pythonImportsCheck = [ "jsonc_parser" ];

    meta = with pkgs.lib; {
      description = "This package is a lightweight, zero-dependency module for parsing files with .jsonc extension. (a.k.a. JSON with comments)";
      homepage = "https://github.com/NickolaiBeloguzov/jsonc-parser";
      license = licenses.mit;
      maintainers = with maintainers; [ abkein ];
      broken = false;
    };
  }