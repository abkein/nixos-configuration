{ pkgs, mylib, ... }:
mylib.flattenAttrsDot' {
  workbench.editorAssociations = mylib.flattenAttrsDot'.literal {
    "*.pdf" = "latex-workshop-pdf-hook";
  };

  vscodeGoogleTranslate.preferredLanguage = "Russian";

  ltex = {
    additionalRules.languageModel = "/home/kein/repos/languagetool/";
    additionalRules.motherTongue = "ru-RU";
    language = "ru-RU";
    additionalRules.enablePickyRules = true;
    checkFrequency = "edit"; # manual, save
    completionEnabled = true;
    ltex-ls.path = "${pkgs.ltex-ls-plus}";
    ltex-ls-plus.path = "${pkgs.ltex-ls-plus}";
    statusBarItem = true;
  };

  latex-workshop = {
    formatting.latex = "latexindent";
    latex = {
      outDir = "";
      # fileTypes = [ ];
      clean.subfolder.enabled = true;
      autoBuild.run = "never";
      autoClean.run = "onSucceeded";
      recipe.default = "lastUsed";
      clean.method = "glob";

      recipes = [
        {
          name = "latexmk";
          tools = [ "latexmk" ];
        }
        {
          name = "latexmk (latexmkrc)";
          tools = [ "latexmk_rconly" ];
        }
        {
          name = "latexmk (lualatex)";
          tools = [ "lualatexmk" ];
        }
        {
          name = "latexmk (xelatex)";
          tools = [ "xelatexmk" ];
        }
        {
          name = "pdflatex";
          tools = [ "pdflatex" ];
        }
        {
          name = "pdflatex * 2";
          tools = [
            "pdflatex"
            "pdflatex"
          ];
        }
        {
          name = "pdflatex -> bibtex -> pdflatex * 2";
          tools = [
            "pdflatex"
            "bibtex"
            "pdflatex"
            "pdflatex"
          ];
        }
        {
          name = "Compile Rnw files";
          tools = [
            "rnw2tex"
            "latexmk"
          ];
        }
        {
          name = "Compile Jnw files";
          tools = [
            "jnw2tex"
            "latexmk"
          ];
        }
        {
          name = "Compile Pnw files";
          tools = [
            "pnw2tex"
            "latexmk"
          ];
        }
        {
          name = "tectonic";
          tools = [ "tectonic" ];
        }
        {
          name = "lualatex";
          tools = [ "lualatex" ];
        }
        {
          name = "lualatex * 2";
          tools = [
            "lualatex"
            "lualatex"
          ];
        }
        {
          name = "lualatex->biber->lualatex * 2";
          tools = [
            "lualatex"
            "biber"
            "lualatex"
            "lualatex"
          ];
        }
      ];

      tools = [
        {
          name = "lualatexmk";
          command =  "latexmk";
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-lualatex"
            "-halt-on-error"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          "env" = { };
        }
        {
          name = "xelatexmk";
          command =  "latexmk";
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-halt-on-error"
            "-xelatex"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          "env" = { };
        }
        {
          name = "latexmk_rconly";
          command =  "latexmk";
          args = [ "%DOC%" ];
          "env" = { };
        }
        {
          name = "bibtex";
          command =  "bibtex";
          args = [ "%DOCFILE%" ];
          "env" = { };
        }
        {
          name = "rnw2tex";
          command =  "Rscript";
          args = [
            "-e"
            "knitr::opts_knit$set(concordance = TRUE); knitr::knit('%DOCFILE_EXT%')"
          ];
          "env" = { };
        }
        {
          name = "jnw2tex";
          command =  "julia";
          args = [
            "-e"
            "using Weave; weave(\"%DOC_EXT%\", doctype=\"tex\")"
          ];
          "env" = { };
        }
        {
          name = "jnw2texminted";
          command =  "julia";
          args = [
            "-e"
            "using Weave; weave(\"%DOC_EXT%\", doctype=\"texminted\")"
          ];
          "env" = { };
        }
        {
          name = "pnw2tex";
          command =  "pweave";
          args = [
            "-f"
            "tex"
            "%DOC_EXT%"
          ];
          "env" = { };
        }
        {
          name = "pnw2texminted";
          command =  "pweave";
          args = [
            "-f"
            "texminted"
            "%DOC_EXT%"
          ];
          "env" = { };
        }
        {
          name = "tectonic";
          command =  "tectonic";
          args = [
            "--synctex"
            "--keep-logs"
            "--print"
            "%DOC%.tex"
          ];
          "env" = { };
        }
        {
          name = "lualatex";
          command =  "lualatex";
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-halt-on-error"
            "-pdf"
            "%DOC%"
          ];
        }
        {
          name = "biber";
          command =  "biber";
          args = [ "%DOCFILE%" ];
        }
        {
          name = "latexmk";
          command =  "latexmk";
          args = [
            "-shell-escape"
            "-synctex=1"
            "-interaction=nonstopmode"
            "-halt-on-error"
            "-file-line-error"
            "-pdf"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          "env" = { };
        }
        {
          name = "pdflatex";
          command =  "pdflatex";
          args = [
            "--shell-escape" # if you want to have the shell-escape flag
            "-synctex=1"
            "-interaction=nonstopmode"
            "-halt-on-error"
            "-file-line-error"
            "%DOC%.tex"
          ];
        }
      ];
    };
  };
}
