{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (self: {
  pname = "cosmic-ext-applet-clipboard-manager";
  version = "0.1.0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = "9e0309b19eac7eb9124318f72d0cc2c0b3617d71";
    hash = "sha256-VsUQNdXSU6QMYz7NSIOuFI4ecVUza1t7SydaIdhfYhA=";
  };

  cargoHash = "sha256-0CziruLYJrku1FO7tBSJRNtS5JyhjDWxTEcOwUVYmSk=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-clipboard-manager"
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR="$TMP"
  '';
  
  postPatch = ''
    substituteInPlace justfile \
      --replace-fail "\`git rev-parse --short HEAD\`" "'${lib.substring 0 8 self.src.rev}'"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/clipboard-manager";
    description = "Clipboard manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-clipboard-manager";
  };
})
