{
  alsa-lib,
  at-spi2-atk,
  autoPatchelfHook,
  bash,
  cairo,
  callPackage,
  coreutils,
  cups,
  dbus,
  dpkg,
  expat,
  git,
  glib,
  gtk3,
  lib,
  libGL,
  libgbm,
  libgcc,
  libnotify,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  makeBinaryWrapper,
  nspr,
  nss,
  pango,
  pulseaudio,
  stdenv,
  systemd,
  xdg-utils,
}:
let
  common = callPackage ./common.nix { };
  runtimeLibraries = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libGL
    libgbm
    libgcc
    libnotify
    libsecret
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
    pulseaudio
    systemd
  ];
in
stdenv.mkDerivation {
  pname = "open-knowledge-desktop";
  inherit (common) version;
  src = common.desktopSrc;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = runtimeLibraries;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt" "$out/share"
    mv opt/OpenKnowledge "$out/opt/OpenKnowledge"
    cp -r usr/share/applications usr/share/doc usr/share/icons "$out/share/"

    substituteInPlace "$out/share/applications/openknowledge.desktop" \
      --replace-fail "/opt/OpenKnowledge/openknowledge" "openknowledge"

    makeBinaryWrapper "$out/opt/OpenKnowledge/openknowledge" "$out/bin/openknowledge" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibraries} \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          git
          xdg-utils
        ]
      }

    runHook postInstall
  '';

  meta = common.meta // {
    description = "AI-native Markdown IDE and LLM wiki";
    mainProgram = "openknowledge";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
