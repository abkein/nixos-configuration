{ mylib, ... }:
{
  evenBetterToml = {
    # Even Better TOML
    # The maximum amount of keys in a dotted key to display during completion, 0 effectively disables key completions.
    completion.maxKeys = 5;
    formatter = {
      # Align consecutive comments after entries and items vertically. This applies to comments that are after entries or array items
      alignComments = true;
      # Align entries vertically. Entries that have table headers, comments, or blank lines between them are not aligned.
      alignEntries = true;
      # The maximum amount of consecutive blank lines allowed.
      allowedBlankLines = 5;
      # Automatically collapse arrays if they fit in one line.
      arrayAutoCollapse = false;
      # Automatically expand arrays to multiple lines.
      arrayAutoExpand = true;
      # Put trailing commas for multiline arrays.
      arrayTrailingComma = true;
      # Target maximum column width after which arrays are expanded into new lines.
      columnWidth = 80;
      # Omit whitespace padding inside single-line arrays.
      compactArrays = false;
      # Omit whitespace around `=`.
      compactEntries = false;
      # Omit whitespace padding inside inline tables.
      compactInlineTables = false;
      # Use CRLF line endings.
      crlf = false;
      # Indent entries under tables.
      indentEntries = true;
      # Indentation to use, should be tabs or spaces but technically could be anything.
      # indentString = null;
      # Indent subtables if they come in order.
      indentTables = true;
      # Expand values inside in line tables.
      inlineTableExpand = true;
      # Alphabetically reorder array values that are not separated by blank lines.
      reorderArrays = false;
      # Alphabetically reorder inline tables.
      reorderInlineTables = false;
      # Alphabetically reorder keys that are not separated by blank lines.
      reorderKeys = false;
      # Add trailing newline to the source.
      trailingNewline = true;
    };
    # Array of Taplo rules in JSON format, see [Configuration File - Rules](https:#taplo.tamasfe.dev/configuration/file.html#rules). The rules given here are appended to existing rules from config files, if any. There is no conversion done, all object keys must be snake_case, including formatting rules.
    rules = [ ];
    # Additional document and schema associations.
    schema = {
      #  The key must be a regular expression, this pattern is used to associate schemas with absolute document URIs. Overlapping patterns result in undefined behaviour and either matching schema can be used.
      #
      #  The value must be an absolute URI to the JSON schema, for supported values and more information [read here](https://taplo.tamasfe.dev/configuration#visual-studio-code).
      # associations = mylib.literal { };
      # The amount of seconds after which cached catalogs and schemas expire and will be attempted to be fetched again.
      # cache.diskExpiration = 1800;
      # The amount of seconds after which schemas will be invalidated from memory.
      # **NOTE**: setting too low values will cause performance issues and validation of some schemas will fail.
      # cache.memoryExpiration = 300;
      # A list of URLs to schema catalogs where schemas and associations can be fetched from
      # catalogs = [
      #   "https://www.schemastore.org/api/json/catalog.json"
      # ];
      # Enable completion and validation based on JSON schemas.
      enabled = true;
      # Whether to show clickable links for keys in the editor.
      links = false;
    };
    # Enable semantic tokens for inline table and array keys.
    semanticTokens = false;
    # Whether to enable semantic tokens for tables and arrays.
    syntax.semanticTokens = true;
    taplo = {
      # Use the bundled taplo language server. If set to `false`, the `taplo` executable must be found in PATH or must be set in `taplo.path`.
      bundled = true;
      # Whether to enable the usage of a Taplo configuration file.
      configFile.enabled = true;
      # An absolute, or workspace relative path to the Taplo configuration file.
      # configFile.path = null;
      # Environment variables for Taplo.
      environment = mylib.literal { };
      # Additional arguments for Taplo. Has no effect for the bundled LSP.
      extraArgs = [ ];
      # An absolute path to the `taplo` executable. `taplo.bundled` needs to be set to `false` for this to have any effect.
      # path = null;
    };
  };
}
