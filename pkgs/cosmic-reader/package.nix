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
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "0dde6aed2c51b16e48d2756ceeb0c92620442418";
    hash = "sha256-Is6SRWn7BbsT6GRsmPMDxQNzdGxSMXKM3hNVMV2NM7c=";
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
