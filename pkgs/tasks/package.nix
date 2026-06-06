{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  libsecret,
  openssl,
  sqlite,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "tasks";
  version = "0.2.4-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "tasks";
    rev = "91c49ca8b7777815216433bf9d58bd449e23f842";
    hash = "sha256-jwyPLoaaF33Gu9oKrT4YQ76KBuwbvGqGaUE6Wz3Vap8=";
  };

  cargoHash = "sha256-96uk8tQgvDbgZTC0ypzWRmWNToCUGnVefPyhI69nxxs=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    libsecret
    openssl
    sqlite
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/tasks"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/tasks";
    description = "Simple task management application for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "tasks";
  };
}
