{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  optype,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "scipy-stubs";
  version = "1.18.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipy";
    repo = "scipy-stubs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rWMmwNuf/tWogsT8ADn9D/adNgXrvqA8fzcF6wAQOSQ=";
  };

  # postPatch = ''
  #   substituteInPlace pyproject.toml \
  #     --replace-fail "uv_build>=0.9.25,<0.10.0" "uv_build"
  # '';

  build-system = [ uv-build ];

  dependencies = [ optype ];

  optional-dependencies = {
    scipy = [ scipy ];
  };

  nativeCheckInputs = [ scipy ];

  meta = {
    description = "Typing Stubs for SciPy";
    homepage = "https://github.com/scipy/scipy-stubs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jolars ];
  };
})
