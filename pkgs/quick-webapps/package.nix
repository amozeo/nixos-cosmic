{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "quick-webapps";
  version = "2.0.1-unstable-2025-10-07";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "web-apps";
    rev = "0d1847a2523ecd77c3f4c8024d22e7223ad1104f";
    hash = "sha256-2k7cUTKg0im7qMXaPg0uLFnVf3iTtiUz6xJFcazonk0=";
  };

  cargoHash = "sha256-bwoG4KMB8JQHE+dc3X2OHDDmg1jWBfXMcR68bbCq/Ag=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/quick-webapps"
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
