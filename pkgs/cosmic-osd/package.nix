{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  libinput,
  pipewire,
  pkg-config,
  pulseaudio,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-osd";
  version = "1.0.10-unstable-2026-04-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "b5d04caba837314fcb99879f8e9017844b42dd90";
    hash = "sha256-TniUR2CwqHkouQ1OPYi8z3jxDiXJoWYqUjheKtmggD8=";
  };

  cargoHash = "sha256-Q6nsaYlAZwSoANsrrdaIrNdnzaJiBRMUzZdbtHLupio=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    libinput
    pipewire
    pulseaudio
    udev
  ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-osd";
  };
}
