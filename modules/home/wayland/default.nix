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
    input.touchpad.scrolling.factor = lib.mkOption {
      type = lib.types.float;
      description = "Scrolling factor";
      default = 1;
    };
    input.touchpad.tapToClick = lib.mkOption {
      type = lib.types.bool;
      description = "Enable tap to click";
      default = true;
    };
    input.mouse.sensitivity = lib.mkOption {
      type = lib.types.float;
      description = "Mouse sensitivity";
      default = 1;
    };
    input.keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        description = "Keyboard layouts, comma seperated";
        example = "us,de";
        default = "us";
      };
      variant = lib.mkOption {
        type = lib.types.str;
        description = "Keyboard layout variants, comma seperated";
        example = "dvorak";
        default = "";
      };
      appleMagic = lib.mkEnableOption "Emulate PC keys on Apple Magic Keyboard";
    };

    input.keybinds.alternativeSearch.enable = lib.mkEnableOption "Use alt + space or SUPER + D to open search";

    nvidia.enable = lib.mkEnableOption "Enable NVIDIA support";
  };

  config = lib.mkIf config.chimera.wayland.enable {
    chimera.waybar.enable = lib.mkDefault true;
    chimera.notifications.mako.enable = true;
  };
}
