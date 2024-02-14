{ config, lib, ... }:
{
  options.chimera.shell.starship.enable = lib.mkEnableOption "Enable to use starship prompt";

  config = lib.mkIf config.chimera.shell.starship.enable {
    programs.starship = {
      enable = true;
      settings = {
        format = "$all";
      };
    };
  };
}
