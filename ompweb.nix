{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  ...
}:
let
  notoSansMono = fetchurl {
    name = "NotoSansMono.ttf";
    url = "https://raw.githubusercontent.com/notofonts/notofonts.github.io/noto-monthly-release-2026.08.01/fonts/NotoSansMono/unhinted/variable-ttf/NotoSansMono%5Bwdth%2Cwght%5D.ttf";
    hash = "sha256-BLG//8WYEU+ZjGDzE/emTfbJEez+1Hok4n8Dsd80v2Y=";
  };

  sourceSerif = fetchurl {
    name = "SourceSerif4Variable-Roman.otf";
    url = "https://raw.githubusercontent.com/adobe-fonts/source-serif/4.005R/VAR/SourceSerif4Variable-Roman.otf";
    hash = "sha256-hntzxqlUpKZGFpBtF5+UVyp0h5Ch0CLr7v8H9W6gIho=";
  };

  notoSerifSC = fetchurl {
    name = "NotoSerifSC-VF.otf";
    url = "https://raw.githubusercontent.com/notofonts/noto-cjk/Serif2.003/Serif/Variable/OTF/Subset/NotoSerifSC-VF.otf";
    hash = "sha256-cbTT3tLZD/Q7t1pOSM2+Fw8LjVSG3In/h/KhcotW2mQ=";
  };

  jetBrainsMono = fetchurl {
    name = "JetBrainsMono.ttf";
    url = "https://raw.githubusercontent.com/JetBrains/JetBrainsMono/v2.304/fonts/variable/JetBrainsMono%5Bwght%5D.ttf";
    hash = "sha256-ZioZbVjxGDvy13QottUoP+P0UWGrAhvqQDa8mOXKwBY=";
  };

  geist = fetchurl {
    name = "Geist.ttf";
    url = "https://raw.githubusercontent.com/vercel/geist-font/v1.7.2/fonts/Geist/variable/Geist%5Bwght%5D.ttf";
    hash = "sha256-c4lOBEjK6QqStsL4cyt7uay3uUxBi/9Vna1KGOHellk=";
  };

in
buildNpmPackage (finalAttrs: {
  pname = "ompweb";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kahme247";
    repo = "ompweb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmn+YuIfiRf06M37hGYJcglv5T1t19Mtejno13/e+Kk=";
  };
  # Regenerate against the fetched source with: git diff -U1 -- app/layout.tsx
  # Keep font changes in separate hunks to avoid unrelated import churn.
  patches = [ ./ompweb-local-fonts.patch ];

  postPatch = ''
    mkdir -p app/fonts
    cp ${notoSansMono} app/fonts/NotoSansMono.ttf
    cp ${sourceSerif} app/fonts/SourceSerif4Variable-Roman.otf
    cp ${notoSerifSC} app/fonts/NotoSerifSC-VF.otf
    cp ${jetBrainsMono} app/fonts/JetBrainsMono.ttf
    cp ${geist} app/fonts/Geist.ttf
  '';

  npmDepsHash = "sha256-HxT+m6bI0I3t9sqsSgHun6oXve3WtIEmkFpCoBplrC4=";

  npmPackFlags = [ "--ignore-scripts" ];

  meta = {
    description = "Local web UI for the oh-my-pi (omp) coding agent";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ ];
  };
})
