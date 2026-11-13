{ ... }: {
  markdown.extension = {
    bold.indicator = "**";
    italic.indicator = "_";
    completion.enabled = true;
    # katex.macros = { };
    list.indentationSize = "inherit";
    math.enabled = false;
    preview.autoShowPreviewToSide = false;
    showActionButtons = true;
    syntax.plainTheme = true; # ???
    tableFormatter = {
      enabled = false;
      # delimiterRowNoPadding = false;
      # normalizeIndentation = false;
    };
    theming.decoration = {
      renderCodeSpan = true;
      renderHardLineBreak = true; # exp
      renderLink = false; # exp
      renderParagraph = true; # exp
      renderStrikethrough = true;
      renderTrailingSpace = true; # false
    };
    toc = {
      levels = "1..6";
      orderedList = true;
      slugifyMode = "github";
      unorderedList.marker = "-";
      updateOnSave = true;
    };
  };
}
