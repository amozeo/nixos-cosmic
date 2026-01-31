{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  fontconfig,
  gumbo,
  harfbuzz,
  jbig2dec,
  libjpeg,
  openjpeg,
  leptonica,
  tesseract,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-reader";
  version = "0-unstable-2026-01-31";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "4dec38f058da6f4443ea3a2032be79339d7c814e";
    hash = "sha256-LyBzcWJWOSe5TNS9trH7To2Te1aFPSsUGV9c/nfK0oA=";
  };

  cargoHash = "sha256-IT0gCE1chtmvu/sSjkQ3t1eIUq/ItfxygICe8HOBDHA=";

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    gumbo
    harfbuzz
    jbig2dec
    libjpeg
    openjpeg
    leptonica
    tesseract
  ];

  passthru.updateScript = nix-update-script {
    # TODO: uncomment when there are actual tagged releases
    #extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-reader";
    description = "PDF reader for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-reader";
  };
}
