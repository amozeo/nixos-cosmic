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
  version = "1.0.0-alpha.7-unstable-2025-09-07";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "f826e1184eedf80235e35098515292f62a773674";
    hash = "sha256-hseWfOn4SvJ/gzKSYMQ9Museapg43kHYiqBqlaET6Pk=";
  };

  cargoHash = "sha256-qiQ4VV1ML2EpfxEdE/A8b6mhtnr5y1/Dr9BvtFu0zgg=";

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
