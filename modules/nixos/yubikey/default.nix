{ config, lib, ... }: {
  options = {
    chimera.yubikey.enable = lib.mkEnableOption "Enable support for YuibKeys";
    chimera.yubikey.pam.enable = lib.mkEnableOption "Enable Login and sudo via YubiKey";
  };

  config = lib.mkIf config.chimera.yubikey.enable {
    services.pcscd.enable = true;
    security.pam.u2f.cue = true;
    security.pam.services = lib.mkIf config.chimera.yubikey.pam.enable {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
