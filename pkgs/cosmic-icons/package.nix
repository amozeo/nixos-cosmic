{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  just,
  pop-icon-theme,
  hicolor-icon-theme,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-icons";
  version = "1.2.0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-icons";
    rev = "b78b059636ed967ad7c6f120709c7d29b2bafac1";
    hash = "sha256-QUTAYIQ6qAhjZK/9BZjJzTViECLUwO/MyaOqiRb1Ans=";
  };

  nativeBuildInputs = [ just ];

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  propagatedBuildInputs = [
    pop-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    description = "System76 COSMIC icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = lib.licenses.cc-by-sa-40;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.all;
  };
}
