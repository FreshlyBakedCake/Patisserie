{ config, lib, pkgs, ... }: {
  options = {
    chimera.xdg-open.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable xdg-open";
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.chimera.xdg-open.enable {
    xdg.portal.enable = true;
    xdg.portal.xdgOpenUsePortal = true;
    environment.systemPackages = [ pkgs.xdg-utils ];
  };
}
