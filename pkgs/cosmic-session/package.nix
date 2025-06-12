{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bash,
  dbus,
  just,
  stdenv,
  xdg-desktop-portal-cosmic,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-session";
  version = "1.0.0-alpha.7-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    rev = "f187e8d767e80954515fe4989be75217286cb26a";
    hash = "sha256-vozm4vcXV3RB9Pk6om1UNCfGh80vIVJvSwbzwGDQw3Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-68budhhbt8wPY7sfDqwIs4MWB/NBXsswK6HbC2AnHqE=";

  postPatch = ''
    substituteInPlace data/start-cosmic \
      --replace-fail /usr/bin/cosmic-session "''${!outputBin}/bin/cosmic-session" \
      --replace-fail /usr/bin/dbus-run-session '${lib.getExe' dbus "dbus-run-session"}' \
      --replace-fail 'dbus-update-activation-environment --systemd' '${lib.getExe' dbus "dbus-update-activation-environment"} --systemd ${
        lib.concatStringsSep " " [
          "PATH"
          "XDG_SESSION_CLASS"
          "XDG_CONFIG_DIRS"
          "XDG_DATA_DIRS"
          "XDG_SESSION_DESKTOP"
          "XDG_DESKTOP_PORTAL_DIR"
          "XMODIFIERS"
          "XCURSOR_SIZE"
          "XCURSOR_THEME"
          "GDK_PIXBUF_MODULE_FILE"
          "GIO_EXTRA_MODULES"
          "GTK_IM_MODULE"
          "QT_PLUGIN_PATH"
          "QT_QPA_PLATFORMTHEME"
          "QT_STYLE_OVERRIDE"
          "QT_IM_MODULE"
          "NIXOS_OZONE_WL"
        ]
      }'
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

  env.XDP_COSMIC = lib.getExe xdg-desktop-portal-cosmic;
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
