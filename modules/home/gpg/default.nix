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
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
      enableZshIntegration = config.chimera.shell.zsh.enable;
      enableBashIntegration = config.chimera.shell.bash.enable;
    };
  };
}
