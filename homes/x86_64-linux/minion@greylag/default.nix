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

  chimera.hyprland.enable = true;
  chimera.hyprland.hyprpaper.splash.enable = true;
  chimera.touchpad.enable = true;

  chimera.hyprland.monitors = [
    "eDP-1,preferred,0x0,1"
    "desc:Dell Inc. DELL P2715Q V7WP95AV914L,preferred,2256x-1956,1,transform,1"
    "desc:AOC 2460G5 0x00023C3F,preferred,336x-1080,1"
  ];

  chimera.theme.wallpaper = ./wallpaper.png;

  chimera.games = {
    minecraft.enable = true;
    itch.enable = true;
  };
}
