{
  lib,
  fetchFromGitHub,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-screenshot";
  version = "1.0.0-unstable-2025-12-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "d0e69f7ba1af1f0aec408146a548636d6ba5886a";
    hash = "sha256-NwFkmHj2F52rhnv/ltcSroE8052xKq+SWb+sVKe5DEQ=";
  };

  cargoHash = "sha256-O8fFeg1TkKCg+QbTnNjsH52xln4+ophh/BW/b4zQs9o=";

  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-screenshot"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}
