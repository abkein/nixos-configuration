{
  Shebang = {
    scope = "bash, python";
    prefix = "#!";
    body = [
      "#!/usr/bin/env $1"
      "\${2:# -*- coding: utf-8 -*-}"
    ];
    description = "Paste shebang";
  };
}
