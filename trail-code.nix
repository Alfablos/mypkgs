{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "trail-code";
  version = "ead585b2707055f47f1e97d9b0d4209af5285805";

  src = fetchFromGitHub {
    owner = "trailhq";
    repo = "Trail-Code";
    # tag = "v${finalAttrs.version}";
    rev = "ead585b2707055f47f1e97d9b0d4209af5285805";
    hash = "sha256-NP89PdtlYLwhRag3OALGmhV4C33wI8d3bszMZxZOTJc=";
  };

  npmDepsHash = "sha256-PrmiOlkFqlm5ztUkk/u0kGgAsjlh43mXXnPab/+f6HI=";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail \
        '"tree-sitter-swift@0.7.1": true' \
        '"tree-sitter-swift@0.7.1": true,
        "tree-sitter-cli@0.23.2": false' \
      --replace-fail \
        '"graft": "dist/bin/graft.js"' \
        '"graft": "dist/bin/graft.js",
        "trail": "dist/bin/trail.js"'
  '';

  npmPackFlags = [ "--ignore-scripts" ];

  meta = {
    description = "Turbocharge Claude Code, Cursor, Codex, Gemini & every coding agent: faster, cheaper, with contextual understanding specific to your codebase.";
    license = lib.licenses.mit;
    mainProgram = "trail";
    # maintainers = with lib.maintainers; [ ];
  };
})
