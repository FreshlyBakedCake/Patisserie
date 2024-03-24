{ config, lib, pkgs, ... }: {
  options.chimera.nextcloud.enable = lib.mkEnableOption "Enable Nextcloud Client";
  config = {
    services.nextcloud-client = lib.mkIf config.chimera.nextcloud.enable {
      enable = true;
      startInBackground = true;
    };
    home.packages = [ pkgs.nextcloud-client ];
  };
}
