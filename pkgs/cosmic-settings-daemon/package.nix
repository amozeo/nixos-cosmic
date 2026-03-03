{
  lib,
  fetchFromGitHub,
  rustPlatform,
  geoclue2-with-demo-agent,
  libinput,
  libxkbcommon,
  openssl,
  pkg-config,
  pulseaudio,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-settings-daemon";
  version = "1.0.8-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "e37160f14d1e7ee428f973cd2848b4e95f83dfe1";
    hash = "sha256-rI9HFfIDb/FiW6JjNQdnkOS4jF4H1R51SIl56UZKvP8=";
  };

  cargoHash = "sha256-srGV9ddIuxGYvNWmTPcXUDCYmDNOfYG31UwtdVPGsyE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    libxkbcommon
    openssl
    pulseaudio
    udev
  ];

  env.GEOCLUE_AGENT = "${lib.getLib geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";

  postInstall = ''
    mkdir -p $out/share/{polkit-1/rules.d,cosmic/com.system76.CosmicSettings.Shortcuts/v1}
    cp data/polkit-1/rules.d/*.rules $out/share/polkit-1/rules.d/
    cp data/system_actions.ron $out/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/system_actions
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings daemon for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-settings-daemon";
  };
}
