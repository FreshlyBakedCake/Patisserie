{ config, lib, ... }: {
  options = {
    chimera.yubikey.enable = lib.mkEnableOption "Enable support for YuibKeys";
  };

  config = lib.mkIf config.chimera.yubikey.enable {
    services.pcscd.enable = true;
  };
}
