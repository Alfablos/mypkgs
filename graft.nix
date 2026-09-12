{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "graft";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "trailhq";
    repo = "Graft";
    tag = finalAttrs.version;
    hash = "sha256-ylWiVycjkq8twq3PsEprVdJyUbZUDRQNH/a5JC0W98A=";
  };

  npmDepsHash = "sha256-HLU+L4pIWA/07Zh9pcVEQuhR1s3L+hzJ0LBGG2AX568=";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail \
        '"tree-sitter-swift@0.7.1": true' \
        '"tree-sitter-swift@0.7.1": true,
        "tree-sitter-cli@0.23.2": false'
  '';

  npmPackFlags = [ "--ignore-scripts" ];

  meta = {
    description = "Turbocharge Claude Code, Cursor, Codex, Gemini & every coding agent: faster, cheaper, with contextual understanding specific to your codebase.";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
