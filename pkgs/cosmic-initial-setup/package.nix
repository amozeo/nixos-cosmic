{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  libinput,
  pkg-config,
  udev,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-initial-setup";
  version = "1.0.0-beta.3-unstable-2025-10-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-initial-setup";
    rev = "0080330b6dacafccebc3aac74f3fccaf20f87f67";
    hash = "sha256-sgtZioUvBDSqlBVWbqGc2iVpZKF0fn/Mr1qo1qlzdlA=";
  };

  cargoHash = "sha256-orwK9gcFXK4/+sfwRubcz0PP6YAFqsENRHnlSLttLxM=";

  buildFeatures = [ "nixos" ];

  auditable = false;

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];
  buildInputs = [
    openssl
    libinput
    udev
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    description = "COSMIC Initial Setup";
    homepage = "https://github.com/pop-os/cosmic-initial-setup";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-initial-setup";
    platforms = lib.platforms.linux;
  };
}
