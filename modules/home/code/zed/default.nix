{ config, lib, pkgs, ... }:
{
  options.chimera.code.zed = {
    enable = lib.mkEnableOption "Enable Zed Editor";
  };

  config = lib.mkIf config.chimera.code.zed.enable {
    home.packages = [
      pkgs.zed-editor
    ];
  };
}
