{
  lib,
  buildNpmPackage,
  chromium,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "notion-scrapper";
  version = "0-unstable-2026-04-09";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gkosach";
    repo = "notion_scrapper";
    rev = "6057e56be1966de8dfdcd2112a4dddfb26316cf4";
    hash = "sha256-XNNkJwd87n2SzeoJ6CWdpmJp8JfYhxRdP3Jg6PJ0g80=";
  };

  npmDepsHash = "sha256-LfW+9RcMHeFaaPX7toPgawfdafIP91hQ3916JirTYtU=";

  nativeBuildInputs = [ makeWrapper ];

  # Use a Nix-packaged browser instead of Playwright's downloaded binaries.
  postPatch = ''
    substituteInPlace src/browser.ts \
      --replace-fail 'await chromium.launch({' 'await chromium.launch({ executablePath: "${lib.getExe chromium}",'
  '';

  # Upstream only defines an npm script, not a package.json bin entry.
  postInstall = ''
    makeWrapper ${lib.getExe nodejs} "$out/bin/notion-scrapper" \
      --add-flags "$out/lib/node_modules/notion_scrapper/dist/index.js"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Take your Notion content back. One command exports any public Notion site to local markdown for Obsidian, Logseq, or any markdown editor. No API key, no cloud, no lock-in";
    homepage = "https://github.com/gkosach/notion_scrapper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "notion-scrapper";
  };
})
