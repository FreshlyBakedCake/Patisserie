{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.chimera.gpg = {
    enable = lib.mkEnableOption "Enable gpg";
  };

  config = lib.mkIf config.chimera.gpg.enable {
    programs.gpg = {
      enable = true;

      scdaemonSettings = lib.mkIf config.chimera.yubikey.enable {
        reader-port = "Yubico Yubi";
        disable-ccid = true;
      };
    };

    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      enableZshIntegration = config.chimera.shell.zsh.enable;
      enableBashIntegration = config.chimera.shell.bash.enable;
    };
  };
}
