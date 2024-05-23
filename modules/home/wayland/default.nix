{
  lib,
  config,
  ...
}: {
  options.chimera = {
    wayland.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable generic options which are useful for all wayland compositors";
      default = false;
      internal = true;
    };
    input.mouse.scrolling.natural = lib.mkEnableOption "Enable natural scrolling";
    input.touchpad.scrolling.natural = lib.mkOption {
      type = lib.types.bool;
      description = "Enable natural scrolling";
      default = config.chimera.input.mouse.scrolling.natural;
    };
    input.keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        description = "Keyboard layouts, comma seperated";
        example = "us,de";
        default = "us";
      };
      variant = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Keyboard layout variants, comma seperated";
        example = "dvorak";
        default = null;
      };
    };

    input.keybinds.alternativeSearch.enable = lib.mkEnableOption "Use alt + space or SUPER + D to open search";

    nvidia.enable = lib.mkEnableOption "Enable NVIDIA support";
  };

  config = lib.mkIf config.chimera.wayland.enable {
    chimera.waybar.enable = lib.mkDefault true;
    chimera.notifications.mako.enable = true;
  };
}
