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
  chimera.users.coded.enable = true;

  chimera.waybar.modules = {
    laptop.enable = true;
    temperature.hwmonPath = "/sys/class/hwmon/hwmon4/temp1_input";
  };

  chimera.niri = {
    enable = true;

    monitors = {
      "eDP-1" = {
        mode = {
          width = 2560;
          height = 1600;
          refresh = 165.;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
    };
  };

  programs.ssh = {
    enable = true;

    includes = [ "~/.ssh/config.d/*" ];

    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = [ "~/.ssh/OnTheGo5cResident" ];
      };
      "greylag.minion" = {
        identityFile = [ "~/.ssh/OnTheGo5cResident" ];
      };
      "shorthair" = {
        identityFile = [ "~/.ssh/OnTheGo5cResident" ];
      };
      "git.auxolotl.org" = {
        user = "forgejo";
        identityFile = [ "~/.ssh/OnTheGo5cResident" ];
      };
    };
  };

  chimera.theme.wallpaper = ./wallpaper.png;
}
