{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  pciutils,
  stdenv,
  usbutils,
  util-linux,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "examine";
  version = "2.0.0-unstable-2026-07-10";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "examine";
    rev = "2eabd04d2286ea3474f3f4295128e4e9ce942a2c";
    hash = "sha256-jnjozBRgxD83ZUWwFLLaFMfpxxcALkWX/XkZ7q30XHU=";
  };

  cargoHash = "sha256-V+ClzaG7LnkOl84j5mVGJPTLVfaVqxaSH7ufmjXdwyM=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/examine"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        pciutils
        usbutils
        util-linux
      ]
    })
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/examine";
    description = "System information viewer for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "examine";
  };
}
