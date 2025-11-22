{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  dbus,
  just,
  libinput,
  pkg-config,
  pipewire,
  pulseaudio,
  stdenv,
  udev,
  util-linux,
  xkeyboard_config,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applets";
  version = "1.0.0-beta.7-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "3e4f68b3d07fb0a4519a47a3598c7c21de13ac2f";
    hash = "sha256-qbhpo9+67h2k+YDyDh8xd+b+CI+PeO5AAq0HGzyocaU=";
  };

  cargoHash = "sha256-XOA5yREoQHGxPI9PVYd2UsaHRCIfbb3Tkr1eovqIIow=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
    rustPlatform.bindgenHook
    util-linux
  ];
  buildInputs = [
    dbus
    libinput
    pipewire
    pulseaudio
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "target"
    "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set-default X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
  };
}
