{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  cmake,
  cosmic-randr,
  expat,
  fontconfig,
  freetype,
  just,
  libinput,
  pipewire,
  pkg-config,
  pulseaudio,
  udev,
  util-linux,
  xkeyboard_config,
  nix-update-script,
}:

let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override {
    includeSettings = false;
  };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "1.0.2-unstable-2026-01-17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "a679d056b9c05ee68193a8260a8ed3011a8d0e28";
    hash = "sha256-/Zzs2b51J0v9PavMr3MuNiFBprb7oJiSC+qDVvMTwEk=";
  };

  cargoHash = "sha256-XY1ovI73O2jJdx1a5pUk/n6TUazklq7PA+bgva3xslo=";

  nativeBuildInputs = [
    libcosmicAppHook'
    rustPlatform.bindgenHook
    cmake
    just
    pkg-config
    util-linux
  ];
  buildInputs = [
    expat
    fontconfig
    freetype
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
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ cosmic-randr ]})
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
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
