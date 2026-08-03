{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applibrary";
  version = "1.5.0-unstable-2026-07-28";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    rev = "172acdae07aeb78a554813a566c0f8b942dcc831";
    hash = "sha256-MW/p9ufEofcKr350KDZLqXxpxgFrISSPgH6cFqT7TOI=";
  };

  cargoHash = "sha256-Lq1Gs1/dcIxfWM4jNIH2qGu94HCC+JKxFdUTb/MDHzg=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
