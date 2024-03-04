{ config, lib, pkgs, ... }: {
  options.chimera.games.itch.enable = lib.mkEnableOption "Enable Itch.io Client";

  config = {
    home.packages = lib.mkIf config.chimera.games.itch.enable [ pkgs.itch ];
  };
}