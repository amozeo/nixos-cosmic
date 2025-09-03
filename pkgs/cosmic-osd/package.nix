{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  pipewire,
  pkg-config,
  pulseaudio,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-osd";
  version = "1.0.0-alpha.7-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "d69a50eafa280ef0a60153100c86217c8b965384";
    hash = "sha256-bToVt7cc7rIlDMYPEjRKZyiIcx//qtSMksUyXQBWXwA=";
  };

  cargoHash = "sha256-090ifWvXb2Idd/LBybDTbmKx4QGYa4I0EDRs4yKbI4A=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    pipewire
    pulseaudio
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
