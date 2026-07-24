{
  lib,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  nix-update-script,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-monitor";
  version = "1.4.0-unstable-2026-07-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-monitor";
    rev = "4b3b177092348c88eedf46f41567df59753fa38a";
    hash = "sha256-EIxdQo80yAjb2rgEsbTPiLuPcyRoJCPe6uDqPeaSCHQ=";
  };

  cargoHash = "sha256-VAVvkBLB45NntP/YahrCzuaRjKw8h2pZd/T5+7fsH6U=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-monitor"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-monitor";
    description = "COSMIC System Monitor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-monitor";
  };
}
