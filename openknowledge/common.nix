{
  fetchFromGitHub,
  fetchurl,
  lib,
  stdenv,
}:
let
  version = "0.76.0";
  desktopAssets = {
    x86_64-linux = {
      name = "OpenKnowledge-amd64.deb";
      hash = "sha256-MApq+Z7LFxnu6NYvKkYtRHorfY/XUZIvhYhjy9/ePiw=";
    };
    aarch64-linux = {
      name = "OpenKnowledge-arm64.deb";
      hash = "sha256-z/YmhHaAmPLh0YSBBvz8t6/jOy6JtUCUS78s3++DJEQ=";
    };
  };
  desktopAsset =
    desktopAssets.${stdenv.hostPlatform.system}
      or (throw "OpenKnowledge Desktop does not support ${stdenv.hostPlatform.system}");
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "inkeep";
    repo = "open-knowledge";
    tag = "v${version}";
    hash = "sha256-ugzekZ7sWAcG1UPbEpgmiiMq5M/RBzt7kI2eWRdRiYk=";
  };

  desktopSrc = fetchurl {
    url = "https://github.com/inkeep/open-knowledge/releases/download/v${version}/${desktopAsset.name}";
    inherit (desktopAsset) hash;
  };

  meta = {
    homepage = "https://github.com/inkeep/open-knowledge";
    changelog = "https://github.com/inkeep/open-knowledge/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
  };
}
