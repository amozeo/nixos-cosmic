{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  stdenv,
  glib,
  just,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-files";
  version = "1.0.0-beta.1.1-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    rev = "c7ee1c9ae13d7df72b01a41f311a3893ab1ea5ff";
    hash = "sha256-1yG5x8V7+WDaQhCosmiU/uaHq8FkcZYUC/P3was5eUo=";
  };

  cargoHash = "sha256-EnP7B4NHl5HVcbAe+nGYqyEc5yS38rARyO/Cji+I2MQ=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    rustPlatform.bindgenHook
  ];
  buildInputs = [ glib ];

  # TODO: uncomment and remove phases below if these packages can ever be built at the same time
  # NOTE: this causes issues with the desktop instance linking to a window tab when cosmic-files is opened, see <https://github.com/lilyinstarlight/nixos-cosmic/issues/591>
  #cargoBuildFlags = [
  #  "--package"
  #  "cosmic-files"
  #  "--package"
  #  "cosmic-files-applet"
  #];
  # cargoTestFlags = [
  #  "--package"
  #  "cosmic-files"
  #  "--package"
  #  "cosmic-files-applet"
  # ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
    "--set"
    "applet-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files-applet"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  # TODO: remove next two phases if these packages can ever be built at the same time
  buildPhase = ''
    baseCargoBuildFlags="$cargoBuildFlags"
    cargoBuildFlags="$baseCargoBuildFlags --package cosmic-files"
    runHook cargoBuildHook
    cargoBuildFlags="$baseCargoBuildFlags --package cosmic-files-applet"
    runHook cargoBuildHook
  '';

  checkPhase = ''
    baseCargoTestFlags="$cargoTestFlags"
    # operation tests require io_uring and fail in nix-sandbox
    cargoTestFlags="$baseCargoTestFlags --package cosmic-files"
    runHook cargoCheckHook
    cargoTestFlags="$baseCargoTestFlags --package cosmic-files-applet"
    runHook cargoCheckHook
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-files";
  };
}
