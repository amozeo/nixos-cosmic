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

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-tweaks";
  version = "0.2.0-unstable-2025-09-27";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "tweaks";
    rev = "4ce0650fba453cb89f0cb113349de262bab25ed1";
    hash = "sha256-zbNvUnIzVZ3v+ThGOLGm0FU/+EPa6h/q/IhkUmo32Aw=";
  };

  cargoHash = "sha256-Zl7c/3q5J+9y1vRJdR77NJ6y62bV1bxaVMuiyxDbLX4=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-tweaks"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/tweaks";
    description = "Tweaking tool for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-tweaks";
  };
}
