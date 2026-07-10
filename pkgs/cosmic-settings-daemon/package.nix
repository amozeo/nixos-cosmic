{
  lib,
  fetchFromGitHub,
  rustPlatform,
  geoclue2-with-demo-agent,
  libinput,
  libxkbcommon,
  openssl,
  pkg-config,
  pipewire,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-settings-daemon";
  version = "1.2.0-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "8c54bbbc10485c31e8717c21e119e19b87eeb3ea";
    hash = "sha256-hgvw7+/3olCitNgHVEJfB8q274Ya+FegUhTHJ74U2EY=";
  };

  cargoHash = "sha256-WuscaiN3Dg/BcCC7czIUPq6jALLu4RHvwHEqprK7ClE=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [
    libinput
    libxkbcommon
    openssl
    pipewire
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
