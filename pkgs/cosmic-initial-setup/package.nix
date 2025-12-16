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
  version = "1.0.0-unstable-2025-12-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-initial-setup";
    rev = "6147d304d4d94907a55f30c0725243a36b21c2e0";
    hash = "sha256-jwDj9dvLPnV4T3ftbYwstws02OAOl3tIA8MisKDsBd0=";
  };

  cargoHash = "sha256-fLLpxs3smfBz90MRNlUGzKzmTX/i01jh85b8wqyr9Tg=";

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
