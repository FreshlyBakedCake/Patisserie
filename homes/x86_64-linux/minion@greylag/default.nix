{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,

  # Additional metadata is provided by Snowfall Lib.
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

  # All other arguments come from the home home.
  config,
  ...
}:
{
  chimera.minion.enable = true;
  home.packages = [
    pkgs.wl-clipboard
  ];

  chimera.waybar = {
    modules.temperature.hwmonPath = "/sys/class/hwmon/hwmon4/temp1_input";
    modules.laptop.enable = true;
  };

  chimera.touchpad.enable = true;

  chimera.hyprland.enable = false;
  chimera.niri.enable = true;
  chimera.niri.monitors = {
    "eDP-1" = {
      position = {
        x = 0;
        y = 0;
      };
    };
    "DP-5" = {
      position = {
        x = 2256;
        y = -1956;
      };
      transform.rotation = 90;
    };
    "DP-7" = {
      position = {
        x = 336;
        y = -1080;
      };
    };
  };

  chimera.theme.wallpaper = ./wallpaper.png;

  chimera.games = {
    minecraft.enable = true;
    itch.enable = true;
  };
}
