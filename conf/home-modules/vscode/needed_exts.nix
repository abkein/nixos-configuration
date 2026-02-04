{
  global = [
    # "arrterian.nix-env-selector"  # weird flakes support
    "jnoortheen.nix-ide"
    "mechatroner.rainbow-csv"
    "ms-vscode.atom-keybindings"
    "thmsrynr.vscode-namegen" # possibly delete
    "michaelcurrin.auto-commit-msg"
    "gruntfuggly.todo-tree"
    "mkhl.direnv"
    "openai.chatgpt"
    # "github.copilot"  # so annoying
    # "github.copilot-chat"
    # "Koda.koda"
    # "Continue.continue"
  ];

  LaTeX = [
    "funkyremi.vscode-google-translate"
    "james-yu.latex-workshop"
    "ms-ceintl.vscode-language-pack-ru"
    "valentjn.vscode-ltex"
    "yzhang.markdown-all-in-one"
    "mammothb.gnuplot"
    "trond-snekvik.simple-rst"
  ];

  python = [
    "ms-python.black-formatter"
    "ms-python.debugpy"
    "ms-python.flake8"
    "ms-python.isort"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.autopep8"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-cell-tags"
    "ms-toolsai.vscode-jupyter-slideshow"
    "ms-toolsai.vscode-jupyter-powertoys"
    "kevinrose.vsc-python-indent"
    "njpwerner.autodocstring"
    "ms-python.mypy-type-checker"
  ];

  flutter = [
    "alexisvt.flutter-snippets"
    "dart-code.dart-code"
    "dart-code.flutter"
  ];

  cpp = [
    "ms-vscode.makefile-tools"
    "ms-vscode.cmake-tools"
    "ms-vscode.cpptools"
    "ms-vscode.cpptools-extension-pack"
    "hars.cppsnippets"
    "jeff-hykin.better-cpp-syntax"
    "ms-vscode.cpptools-themes"
    "tomoki1207.pdf"
    "jbenden.c-cpp-flylint"
    "llvm-vs-code-extensions.vscode-clangd"
    # "mine.cpplint"
    "crugthew.c-cpp-linter"
    "cs128.cs128-clang-tidy"
  ];

  dev = [
    "ms-vscode.hexeditor"
    "github.vscode-pull-request-github"
    "github.vscode-github-actions"
    "github.remotehub"
    "ymotongpoo.licenser"
    "mads-hartmann.bash-ide-vscode"
    "redhat.vscode-xml"
    "tamasfe.even-better-toml"
    "thfriedrich.lammps"
  ];

  misc = [
    "coolbear.systemd-unit-file"
    "ombratteng.nftables"
    "william-voyek.vscode-nginx"
  ];

  remote = [
    "ms-vscode-remote.remote-containers"
    "ms-vscode-remote.remote-ssh"
    "ms-vscode-remote.remote-ssh-edit"
    # "ms-vscode-remote.vscode-remote-extensionpack"
    "ms-vscode.remote-explorer"
    "ms-vscode.remote-repositories"
    "ms-vscode.remote-server"
  ];

  sonar = [
    "sonarsource.sonarlint-vscode" # requires jre
  ];

  ts = [
    "dbaeumer.vscode-eslint"
  ];

  # "seunlanlege.action-buttons"
  # "trunk.io"
  # "google.geminicodeassist"
  # "googlecloudtools.cloudcode"

  # "gruntfuggly.todo-tree"
  # "ms-python.vscode-python-envs"

  # "redhat.java"
  # "vscjava.vscode-gradle"

  # "ms-vscode.js-debug"
  # "ms-vscode.js-debug-companion"
  # "ms-vscode.vscode-js-profile-table"
  # "ms-vscode.vscode-typescript-next"

  # "zhikui.vscode-openfoam"
}
