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
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "cbf4fa1e28ad807b60ad3555d250f0611a6a59fc";
    hash = "sha256-19Bp1EeMq1C1JP3xMfiFVDF8rqYJX4I2CzayJpqGxFM=";
  };

  cargoHash = "sha256-p0dg5RNXkzbi+/RB5k+jr34RNOp+Irahj0BiFUddfnk=";

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
