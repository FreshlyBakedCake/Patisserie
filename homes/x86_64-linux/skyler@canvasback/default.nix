{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,

  # Additional metadata is provided by Snowfall Lib.
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

  # All other arguments come from the home home.
  config,
  ...
}:
{
  home.packages = [ pkgs.home-manager ];
  chimera.minion.enable = true;

  home.shellAliases.home-manager = "${pkgs.home-manager}/bin/home-manager --flake ${config.chimera.shell.rebuildFlakePath}#skyler@canvasback";

  programs.kitty.settings.shell = "${pkgs.bashInteractive}/bin/bash --login"; # nasty hack to make environment variables load on gnome
}
