{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "jsonc-parser";
  version = "1.1.5";
  pyproject = true;
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "NickolaiBeloguzov";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-yRsuVnaJOfkiGGXRvPi60Va/PJoagn5dYRfREUXV+uE=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "jsonc_parser" ];

  meta = with lib; {
    description = "A lightweight, native tool for parsing .jsonc files";
    homepage = "https://github.com/NickolaiBeloguzov/jsonc-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ abkein ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
