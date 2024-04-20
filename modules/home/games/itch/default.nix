{ config, lib, pkgs, ... }: {
  options.chimera.games.itch.enable = lib.mkEnableOption "Enable Itch.io Client";

  config = {
    home.packages = lib.mkIf config.chimera.games.itch.enable
      (lib.warn "Installing the itch.io client is currently disabled as it's broken in upstream nixpkgs, skipping..." [ /* pkgs.itch */ ]);
  };
}
