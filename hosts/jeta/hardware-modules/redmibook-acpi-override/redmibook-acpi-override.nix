{
  lib,
  stdenvNoCC,
  requireFile,
  acpica-tools,
  cpio,
  filename ? "dsdt.aml",
  hash ? "sha256-ujKDPKm/6H/atjqDXxbkTcIQbmua3ABxhdNZSfzqWag=",
  source ? null,
}:
let
  defaultSource = requireFile {
    name = filename;
    hashMode = "flat";
    inherit hash;
    message = ''
      This expression requires that ${filename} is already in the Nix store.
      Add your original DSDT AML table with:
        nix store add-path --mode flat --hash-algo sha256 --name ${lib.escapeShellArg filename} /path/to/dsdt.aml

      Its flat SHA-256 hash must match the configured hash (${hash}). Check it with:
        nix hash file --type sha256 --sri /path/to/dsdt.aml
      The legacy equivalent is nix-hash --flat --type sha256 --sri /path/to/dsdt.aml.

      You could obtain one by running
        cat /sys/firmware/acpi/tables/DSDT > dsdt.aml
    '';
  };
in
stdenvNoCC.mkDerivation {
  name = "redmibook-acpi-override.cpio";
  version = "2";

  src = lib.defaultTo defaultSource source;

  nativeBuildInputs = [
    acpica-tools
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir source
    cd source
    cp "$src" dsdt.aml
    iasl -d dsdt.aml
    rm dsdt.aml

    runHook postUnpack
  '';

  patches = [
    ./svrp-only.patch
    ./s3-sleep.patch
    ./azal-device.patch
  ];

  patchFlags = [ "-p0" ];

  postPatch = ''
    # Linux requires a newer OEM revision to upgrade the firmware table.
    # Do this once, after all patches, so patches need no revision hunk.
    definitionBlock=$(sed -n '/^DefinitionBlock (/p' dsdt.dsl)
    oemRevision=$(sed -nE 's/^DefinitionBlock \(.*,[[:space:]]*(0x[[:xdigit:]]{8})\)$/\1/p' <<< "$definitionBlock")
    if [[ -z "$oemRevision" ]] || (( oemRevision == 0xFFFFFFFF )); then
      echo "Cannot increment DSDT OEM revision: $oemRevision" >&2
      exit 1
    fi
    printf -v nextOemRevision '0x%08X' "$((oemRevision + 1))"
    substituteInPlace dsdt.dsl --replace-fail \
      "$definitionBlock" \
      "''${definitionBlock%,*}, $nextOemRevision)"
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    iasl -sa dsdt.dsl
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dsdt.aml kernel/firmware/acpi/dsdt.aml
    # The early ACPI override must be an uncompressed newc archive.
    find kernel -print0 | sort -z | cpio --null --create --format=newc --reproducible --owner=0:0 > "$out"

    runHook postInstall
  '';

  dontFixup = true;
}
