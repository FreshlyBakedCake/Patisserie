{ config, lib, ... }: {
  options = {
    chimera.yubikey.enable = lib.mkEnableOption "Enable support for YuibKeys";
  };
}
