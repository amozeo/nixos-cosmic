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
  version = "0-unstable-2025-12-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "4bbbe6ad4346fddbb4b8dccef03f2b96d238c102";
    hash = "sha256-LsnoLpIw1QETB7SK2N4tOrH82MSiDT7WGufE6eCybTU=";
  };

  cargoHash = "sha256-4ofAtZN3FpYwNahinldALbdEJA5lDwa+CUsVIISnSTc=";

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
