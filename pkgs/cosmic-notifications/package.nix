{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  which,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-notifications";
  version = "1.5.0-unstable-2026-07-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-notifications";
    rev = "7837e494961db34492ae6bf957a644c1fb508081";
    hash = "sha256-7TD28DqSqOm0HwLM1UZgvP3vOaM37RW2Sxb3xskUhOM=";
  };

  cargoHash = "sha256-32AoA17CO4noUzKhx+KDBpy5fWG4lvSBMK5aVJW8K9o=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    which
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-notifications"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-notifications";
    description = "Notifications for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-notifications";
  };
}
