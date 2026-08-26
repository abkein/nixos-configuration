browserName:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };
  cfg = config.programs.${browserName};
  generatedOptions = import ./firefox-policy-options.nix { inherit lib jsonFormat; };
  generatedMeta = import ./firefox-policy-metadata.nix;
  removeNulls =
    value:
    if builtins.isAttrs value then
      lib.mapAttrs (_: removeNulls) (lib.filterAttrs (_: child: child != null) value)
    else if builtins.isList value then
      map removeNulls value
    else
      value;
  policies = cfg._policies;

  existenceWarnings = map (
    policyName:
    lib.optional (!(generatedOptions ? ${policyName})) "Firefox: Unknown policy `${policyName}`."
  ) (lib.attrNames policies);

  deprecationWarnings = map (
    policyName:
    lib.optional (policies ? ${policyName}) "Firefox: Policy `${policyName}` has been deprecated."
  ) generatedMeta.deprecated;

  checkPreferences =
    context: preferencyNames:
    map (
      preferenceName:
      lib.optionals (generatedMeta.preferences-affected ? ${preferenceName}) (
        map (
          policyName:
          lib.optional (policies ? ${policyName})
            "Firefox: Preference `${preferenceName}` defined in `${context}` conflicts with policy `${policyName}`"

        ) generatedMeta.preferences-affected.${preferenceName}
      )
    ) preferencyNames;

  definedPreferenceNames = lib.optionals (policies ? Preferences) (
    lib.attrNames policies.Preferences
  );
  preferencesConflictsWarnings = checkPreferences "policies.Preferences" definedPreferenceNames;

  settingsConflictsWarnings = map (
    profileName:
    lib.optionals (cfg.profiles.${profileName} ? settings) (
      checkPreferences "profiles.${profileName}.settings" (
        lib.attrNames cfg.profiles.${profileName}.settings
      )
    )
  ) (lib.attrNames cfg.profiles);

in
{
  options = {
    programs.${browserName}._policies = lib.mkOption {
      type = lib.types.submodule {
        options = generatedOptions;
        freeformType = jsonFormat.type;
      };
      default = { };
      apply = removeNulls;
    };
  };

  config = {
    warnings = lib.flatten (
      existenceWarnings
      ++ deprecationWarnings
      ++ preferencesConflictsWarnings
      ++ settingsConflictsWarnings
    );
    programs.${browserName}.policies = policies;
  };
}
