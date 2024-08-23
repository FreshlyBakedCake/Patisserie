{ config, lib, pkgs, ... }:
{
  options = {
    chimera.games.steam.enable = lib.mkEnableOption "Enable Steam";
  };

  config = {
    programs.steam = lib.mkIf config.chimera.games.steam.enable {
      enable = true;
      remotePlay.openFirewall = true;

      package = pkgs.steam.override
        {
          extraLibraries = pkgs: [ config.hardware.graphics.package ] ++ config.hardware.graphics.extraPackages;
        };
    };
    hardware.steam-hardware.enable = true;

    environment.systemPackages = [
      pkgs.steam-run
    ];
  };
}
