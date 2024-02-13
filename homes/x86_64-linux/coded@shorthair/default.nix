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
  chimera = {
    hyprland = {
      enable = true;

      monitors = [
        "DP-1,1920x1080@165,0x0,1"
        "DP-2,1920x1080@165,1920x0,1"
        "HDMI-A-1,1920x1080@60,960x-1080,1"
      ];

      hyprpaper = {
        splash = {
          enable = true;
          offset = -0.6;
        };
      };
    };
    wallpaper = ./wallpaper.png;

    browser = {
      firefox = {
        enable = true;
        extraExtensions = [
          config.nur.repos.rycee.firefox-addons.simple-tab-groups
        ];
      };

      chromium = {
        enable = true;
        extensions = {
          bitwarden.enable = true;
          youtube = {
            sponsorBlock.enable = true;
            returnDislike.enable = true;
            deArrow.enable = true;
          };
          reactdevtools.enable = true;
          ublockOrigin.enable = true;
        };
        extraExtensions = [
          { id = "gmkiokemhjjdjmpnnjmnpkpfoenpnpne"; } #Lofi Girl
          { id = "bmnlcjabgnpnenekpadlanbbkooimhnj"; } #PayPal Honey
          { id = "kekjfbackdeiabghhcdklcdoekaanoel"; } #MAL Sync
        ];
      };
    };

    theme.catppuccin = {
      enable = true;
      style = "Macchiato";
      color = "Blue";
    };
  };
}
