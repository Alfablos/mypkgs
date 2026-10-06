{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "graft";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "trailhq";
    repo = "Graft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fop4YQ0uCGEmrqW6Wm35q0dlmBZMzMcVbMJkruIhnEY=";
  };

  npmDepsHash = "sha256-7iC2xhQcWnMYU+XicC44UFwsDYgKC5ZUWHK6c6/ecVc=";

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
