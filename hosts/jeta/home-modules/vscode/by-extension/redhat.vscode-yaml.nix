{ ... }: {
  yaml = {
    completion = true;
    disableAdditionalProperties = false;
    disableDefaultProperties = false;
    format = {
      enable = false;
      bracketSpacing = true;
      printWidth = 120;
      proseWrap = "preserve";
      singleQuote = false;
      trailingComma = true;
    };
    hover = true;
    hoverAnchor = true;
    hoverSchemaSource = true;
    keyOrdering = false;
    schemaStore.enable = true;
    style = {
      flowMapping = "allow";
      flowSequence = "allow";
    };
    suggest.parentSkeletonSelectedFirst = false;
    validate = true;
    yamlVersion = "1.2";
  };
}
