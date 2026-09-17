{
  callPackage,
  stdenvNoCC,
}:
let
  desktop = callPackage ./desktop.nix { };
in
stdenvNoCC.mkDerivation {
  pname = "open-knowledge-cli";
  inherit (desktop) version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    ln -s ${desktop}/opt/OpenKnowledge/resources/cli/bin/ok.sh "$out/bin/ok"
    ln -s ok "$out/bin/open-knowledge"

    runHook postInstall
  '';

  meta = desktop.meta // {
    description = "Local-first, agent-friendly Markdown knowledge base CLI";
    mainProgram = "ok";
  };
}
