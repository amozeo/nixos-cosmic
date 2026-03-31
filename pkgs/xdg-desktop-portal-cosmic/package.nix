{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  util-linux,
  libgbm ? null,
  mesa,
  pipewire,
  pkg-config,
  gst_all_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.8-unstable-2026-03-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "9fb7d2fe56d40529a8e48b3f8895145030fcc022";
    hash = "sha256-RX5WEeSa01NyjMBr3ZFyBm4kCm40eWRQTmZ8zkGv9Z4=";
  };

  cargoHash = "sha256-VvtfI1HQZWuputhAQXP94zMusFHwOwit78QHzlHlJRw=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
    util-linux
  ];
  buildInputs = [
    (if libgbm != null then libgbm else mesa)
    pipewire
  ];
  checkInputs = [ gst_all_1.gstreamer ];

  env.VERGEN_GIT_SHA = src.rev;

  dontCargoInstall = true;

  makeFlags = [
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
    "prefix=${placeholder "out"}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = lib.platforms.linux;
  };
}
