{ config, lib, ... }: {
  options = {
    chimera.yubikey.enable = lib.mkEnableOption "Enable support for YuibKeys";
    chimera.yubikey.pam.enable = lib.mkEnableOption "Enable Login and sudo via YubiKey";
    chimera.yubikey.pam.key = lib.mkOption {
      type = lib.types.str;
      example = "<username>:<KeyHandle1>,<UserKey1>,<CoseType1>,<Options1>:<KeyHandle2>,<UserKey2>,<CoseType2>,<Options2>:...";
      description = "A string following the example";
    };
  };

  config = lib.mkIf (config.chimera.yubikey.pam.enable && config.chimera.yubikey.enable) {
    home.file.".config/Yubico/u2f_keys" = {
      target = ".config/Yubico/u2f_keys";
      enable = true;
      text = config.chimera.yubikey.pam.key;
    };
  };
}
