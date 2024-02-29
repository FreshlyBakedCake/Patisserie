{ inputs, pkgs, ... }:
{
  programs.eww = {
    enable = true;
    configDir = ./config;
  };

  /* bluetoothctl
     wpa_cli
     pamixer
     rfkill -> util-linux
     cat
     bash
     date
  */
  # wpa_cli disable_network

  # $RUN_wpa_cli
}
