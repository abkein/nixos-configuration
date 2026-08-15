{
  lib,
  buildPythonPackage,
  fetchPypi,
  # fetchFromGitHub,
  uv-build,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "numpy-typing-compat";
  # version = "20260602";
  version = "20260602.2.5";
  pyproject = true;

  # src = fetchFromGitHub {
  #   owner = "jorenham";
  #   repo = finalAttrs.pname;
  #   rev = "v${finalAttrs.version}";
  #   hash = "sha256-LBF8AjbrXqs+cVjDO9iNA9SM+MJ1162CD3JFmW4Of2A=";
  # };
  src = fetchPypi {
    pname = "numpy_typing_compat";
    inherit (finalAttrs) version;
    hash = "sha256-GIWmeOmiRWSDntXRcRwAMXNft95/C17YjVUOXUWo1Pk=";
  };

  # postPatch = ''
  #   substituteInPlace pyproject.toml --replace-fail "uv_build>=0.9,<0.10" "uv_build>=0.9,<=0.10"
  # '';

  build-system = [ uv-build ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "numpy_typing_compat" ];

  meta = {
    description = "Static typing compatibility layer for older versions of NumPy";
    homepage = "https://github.com/jorenham/numpy-typing-compat";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tm-drtina ];
  };
})
