{
  lib,
  stdenv,
  cargo,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  qt6,
  rustPlatform,
  rustc,
}:

stdenv.mkDerivation (self: {
  pname = "cutecosmic";
  version = "0.1-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "IgKh";
    repo = "cutecosmic";
    rev = "d11412095401b5c9904dacef00df52a4d350f655";
    hash = "sha256-K267bT8aQ9l7vPbhEUAlxrm/F+1d+xXutY4ABltj8Qg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (self) src;
    name = self.pname;
    sourceRoot = "${self.src.name}/bindings";
    hash = "sha256-WInS4yY43OlRzGLXYdXUlelzpm+sjBHiyfQNQ+IAM8M=";
  };

  cargoRoot = "bindings";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_CORROSION=${fetchFromGitHub {
      owner = "corrosion-rs";
      repo = "corrosion";
      rev = "v0.5.2";
      hash = "sha256-sO2U0llrDOWYYjnfoRZE+/ofg3kb+ajFmqvaweRvT7c=";
    }}"
  ];

  postPatch = ''
    substituteInPlace platformtheme/CMakeLists.txt \
      --replace-fail "\''${QT_INSTALL_PLUGINS}/platformthemes" \
      "${qt6.qtbase.qtPluginPrefix}/platformthemes"
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    homepage = "https://github.com/IgKh/cutecosmic";
    description = "Qt platform theme for COSMIC desktop environment";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
