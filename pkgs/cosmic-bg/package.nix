{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  dav1d,
  just,
  nasm,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-bg";
  version = "1.4.0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-bg";
    rev = "76e89e6aff4224e3a820cbe71c74ee91adb60d03";
    hash = "sha256-f/Lt5LSOklxUrsLiPm54VVND63IssEsFHWynY4TVeZ8=";
  };

  cargoHash = "sha256-wU9McdejpTFNJd2VTrMREzdW4WIw0p5GTuhynt/vVro=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    nasm
    pkg-config
  ];

  buildInputs = [
    dav1d
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-bg"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-bg";
    description = "Applies Background for the COSMIC Desktop Environment";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-bg";
  };
}
