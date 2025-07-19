# args from flake
{
  cosmicOverlay,
  nixpkgsPath,
}:

# module args
{
  lib,
  modulesPath,
  ...
}:

let
  modules = basePath: lib.optionals (lib.versionOlder lib.trivial.version "25.11") [
    # cosmic modules in unstable nixpkgs depends on changes to geogclue that are not on stable
    (basePath + "/services/desktops/geoclue2.nix")

    (basePath + "/services/display-managers/cosmic-greeter.nix")
    (basePath + "/services/desktop-managers/cosmic.nix")
  ];
in
{
  imports = modules (nixpkgsPath + "/nixos/modules");

  disabledModules = modules modulesPath;

  nixpkgs.overlays = [ cosmicOverlay ];
}
