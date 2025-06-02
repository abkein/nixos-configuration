with import <nixpkgs> { };

let python = pkgs.python312;
in pkgs.mkShell {
  name = "lmptest1";
  venvDir = "./.venv"; # This is where the venv will be created

  buildInputs = [
    python
    python.pkgs.venvShellHook
    python.pkgs.ipykernel
    texliveFull

    pkg-config
    meson
    ninja
    gfortran14

    git-crypt
    stdenv.cc.cc
  ];

  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    echo "✅ Python venv created at $venvDir"
    python --version
    which python
    pip install --upgrade pip

    python -m pip install --prefix=.venv -r requirements.txt
    python -m bash_kernel.install --sys-prefix

  '';

  postShellHook = ''
    unset SOURCE_DATE_EPOCH
    echo "🐍 Python venv active in $VIRTUAL_ENV"
    python --version
    which python
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH";
  '';
}
