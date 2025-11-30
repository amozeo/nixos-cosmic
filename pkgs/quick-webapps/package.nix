{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  gtk3,
  glib,
  just,
  pkg-config,
  webkitgtk_4_1,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "quick-webapps";
  version = "2.0.1-unstable-2025-11-18";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "web-apps";
    rev = "73fcb5946d4bb50ec068950c14d7fd24846c35cb";
    hash = "sha256-v5WydORCw6SdOhMibn1F5UQZ0jOw5YzNBM2S71T5S84=";
  };

  cargoHash = "sha256-bwoG4KMB8JQHE+dc3X2OHDDmg1jWBfXMcR68bbCq/Ag=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    gtk3
    glib
    webkitgtk_4_1
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "base-dir"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/dev-heppen-webapps"
    "--set"
    "webview-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/dev-heppen-webapps-webview"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/web-apps";
    description = "Web app manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "quick-webapps";
  };
}
