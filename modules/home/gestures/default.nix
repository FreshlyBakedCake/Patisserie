{ lib, config, ... }:
{
  options.chimera.input.touchpad.enable = lib.mkEnableOption "Enable touchpad gestures";


  config = lib.mkIf (config.chimera.input.touchpad.enable && config.chimera.hyprland.enable) {
    services.fusuma.enable = true;

    systemd.user.startServices = "sd-switch";

    systemd.user.services.fusuma.Unit.X-Restart-Triggers = [
      config.xdg.configFile."fusuma/config.yml".source
    ];
  };
}
