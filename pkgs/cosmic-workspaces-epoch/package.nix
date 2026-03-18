{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  libgbm ? null,
  libinput,
  mesa,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-workspaces-epoch";
  version = "1.0.8-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "2f1e5c77e3373a60ce8403051bc43012ae02d3fc";
    hash = "sha256-ecczLfUatPXJwbwBwSpZoEXGJBJf3qFjZBMvmh80DcU=";
  };

  cargoHash = "sha256-AKx97B7lfKb5yIRWh36QP4bxFgS+1gknR25IDhHKE38=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];
  buildInputs = [
    (if libgbm != null then libgbm else mesa)
    libinput
    udev
  ];

  postInstall = ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp data/*.desktop $out/share/applications/
    cp data/*.svg $out/share/icons/hicolor/scalable/apps/
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-workspaces";
  };
}
