{ config, lib, ... }: {
  options = {
    chimera.notifications.mako.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to use mako to handle notifications";
      default = config.chimera.hyprland.enable;
      example = false;
    };
  };

  config = lib.mkIf config.chimera.notifications.mako.enable {
    services.mako.enable = true;
  };
}
