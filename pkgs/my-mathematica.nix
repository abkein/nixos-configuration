{ pkgs }:
pkgs.mathematica.override {
  versionInfo = {
    version = "15.0.1";
    lang = "en";
    language = "English";
    hash = "sha256-VzK8CuOhk4sOO5CL4z3rfpY5631F2RN6c0Dh8cExeeg=";
    installer = "Wolfram_15.0.1.sh";
  };
  source = /home/kein/Projects/Mathematica/Wolfram_15.0.1.sh;
}
