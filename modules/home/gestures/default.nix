{ lib, config, ... }: {
  options.minion.touchpadGestures.enable = lib.mkEnableOption "Enable touchpad gestures";

  config = lib.mkIf config.minion.touchpadGestures.enable {
    services.fusuma.enable = true;

    systemd.user.startServices = "sd-switch";

    systemd.user.services.fusuma.Unit.X-Restart-Triggers = [ config.xdg.configFile."fusuma/config.yaml".source ];
  };
}