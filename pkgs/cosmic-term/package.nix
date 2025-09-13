{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  fontconfig,
  freetype,
  just,
  libinput,
  pkg-config,
  rustPlatform,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-term";
  version = "1.0.0-alpha.7-unstable-2025-09-12";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "5fb5ce43cd4b70adc0b91c1ebb4362bba9bfa76d";
    hash = "sha256-soE8lNyb9O7igtUtgSwRmswfKLoKjamqyFVSnmAoiDw=";
  };

  cargoHash = "sha256-x8SCp5lYngAxAyKWE9w954IPjLTC7sko6wctnmhLHec=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    libinput
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-term"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-term";
  };
}
