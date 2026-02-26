{
  python = {
    plot = {
      prefix = [ "plt.plot" ];
      body = [
        "fig = plt.figure()"
        "ax1 = fig.add_subplot(1,1,1)"
        "(line11,) = ax1.plot($1)"
        ""
        "# fig.savefig(\"\", bbox_inches=\"tight\", transparent=True)"
        "plt.show()"
      ];
      description = "Matplotlib extended plot";
    };
    scatter = {
      prefix = [ "plt.scatter" ];
      body = [
        "fig = plt.figure()"
        "ax1 = fig.add_subplot(1,1,1)"
        "line11 = ax1.scatter($1)"
        ""
        "# fig.savefig(\"\", bbox_inches=\"tight\", transparent=True)"
        "plt.show()"
      ];
      description = "Matplotlib extended plot, scatter";
    };
    latex = {
      prefix = [ "plt.latex" ];
      body = [
        "plt.rcParams.update("
        "    {"
        "        \"text.usetex\": True,"
        "        \"font.family\": \"Computer Modern\","
        "        \"text.latex.preamble\": r\"\"\""
        "        \\usepackage[T2A]{fontenc}"
        "        \\usepackage[utf8]{inputenc}"
        "        \\usepackage[russian]{babel}"
        "    \"\"\","
        "    }"
        ")"
      ];
      description = "For quickly enabling latex rendering";
    };
    ignore_type = {
      prefix = "# t";
      body = [
        "# type: ignore"
      ];
      description = "Inserts type ignore instruction";
    };
    passifmain = {
      prefix = "if __";
      body = [
        "if __name__ == \"__main__\":"
        "    pass"
        ""
      ];
      description = "Pass if main";
    };
  };
  cpp = {
    print = {
      prefix = "std::c";
      body = [
        "std::cout << $1 << std::endl;"
      ];
      description = "Output to console";
    };
  };
  latex = {
    text = {
      prefix = "\\t";
      body = [
        "\\text{$1}"
      ];
      description = "\\text{}";
    };
    limit = {
      prefix = "\\lim";
      body = [
        "\\lim\\limits_{\\substack{\${1:a} \\to -\${2:\\infty} \${3:b} \\to \${4:\\infty}}}"
      ];
      description = "Double limits";
    };
    therm_deriv = {
      prefix = "\\lfp";
      body = [
        "\\left(\\frac{\\partial $1}{\\partial $2}\\right)_{$3}"
      ];
      description = "Thermodynamic derivative";
    };
  };
}
