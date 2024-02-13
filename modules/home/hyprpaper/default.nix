{ config, lib, ... }:
{
  options.chimera = {
    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Wallpaper of your choosing";
    };
    hyprland.hyprpaper.splash = {
      enable = lib.mkEnableOption "Enable the hyprland splash text";
      offset = lib.mkOption {
        type = lib.types.float;
        description = "Set the splash offset";
        default = 2.0;
      };
    };
  };

  # TODO: wallpapers path[] -> gen wallpaper lines...
  config.xdg.configFile."hypr/hyprpaper.conf".source = lib.mkIf config.chimera.hyprland.enable (
    builtins.toFile "hyprpaper.conf" ''
      preload = ${config.chimera.wallpaper}

      wallpaper=,${config.chimera.wallpaper}

      splash = ${builtins.toString config.chimera.hyprland.hyprpaper.splash.enable}
      splash_offset = ${builtins.toString config.chimera.hyprland.hyprpaper.splash.offset}

      ipc = off
    ''
  );
}
