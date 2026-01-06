{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bash,
  dbus,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-session";
  version = "1.0.1-unstable-2026-01-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    rev = "ec64522110482f44987028135361a88bfdbe5a61";
    hash = "sha256-MIiR6k/me0QFZeeywlNS48ziM0l5Imm3kv0D4cdbQcY=";
  };

  cargoHash = "sha256-wFh9AYQRZB9qK0vCrhW9Zk61Yg+VY3VPAqJRD47NbK4=";

  postPatch = ''
    substituteInPlace data/start-cosmic \
      --replace-fail /usr/bin/cosmic-session "''${!outputBin}/bin/cosmic-session" \
      --replace-fail /usr/bin/dbus-run-session '${lib.getExe' dbus "dbus-run-session"}'
    substituteInPlace data/cosmic.desktop \
      --replace-fail /usr/bin/start-cosmic "''${!outputBin}/bin/start-cosmic"
  '';

  nativeBuildInputs = [ just ];
  buildInputs = [ bash ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
    "--set"
    "cosmic_dconf_profile"
    "${placeholder "out"}/etc/dconf/profile/cosmic"
  ];

  # use `orca` from PATH (instead of absolute path) if available
  env.ORCA = "orca";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
    providedSessions = [ "cosmic" ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-session";
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
  };
}
