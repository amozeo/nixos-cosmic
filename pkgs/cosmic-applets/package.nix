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
  version = "1.0.0-beta.7-unstable-2025-11-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "0c3fd9571a634868448a6ebb752b7e2ac3c7537c";
    hash = "sha256-4cQ3MFV2l75ZTMkc4lri48hPE21os6xygr3MDP7RSEA=";
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
