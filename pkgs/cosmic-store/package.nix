{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  flatpak,
  glib,
  just,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-store";
  version = "1.0.5-unstable-2026-02-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-store";
    rev = "91c53eba28c3d2f958135d9d972e05c53b3e8feb";
    hash = "sha256-0QcgFEyMlAK5QxZK9CmXBSJoFymmw4yru3VdK9TcXws=";
  };

  cargoHash = "sha256-0cn7/Mow9uAOAQZEUh7CZXNk9r4tvOeqjyCyJGtE2m4=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];
  buildInputs = [
    glib
    flatpak
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-store"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-store";
    description = "App Store for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-store";
  };
}
